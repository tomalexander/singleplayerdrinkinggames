#!/usr/bin/python
#

import urllib.request
import urllib.parse
import json
import uuid

passed_tests = 0
failed_tests = 0
account_uuid = ""
account_password = ""
account_username = ""

def get_uuid():
    return str(uuid.uuid4())

def call_server(address, data=None):
    if data is not None:
        response = urllib.request.urlopen("https://singleplayerdrinkinggames.com/" + address, urllib.parse.urlencode(data).encode("UTF-8"))
        return response.read().decode("UTF-8")
    else:
        response = urllib.request.urlopen("https://singleplayerdrinkinggames.com/" + address)
        return response.read().decode("UTF-8")

def print_closure(module):
    def ret(error_string, passed):
        global passed_tests, failed_tests
        if passed:
            print("PASS " + module + ":", error_string)
            passed_tests += 1
        else:
            print("FAIL " + module + ":", error_string)
            failed_tests += 1
    return ret

def python_sanity_check():
    """Check to make sure python behavior is as expected"""
    passfail = print_closure("python_sanity_check")
    print("Performing Python sanity check")

    passfail("Loading 'null' from json", json.loads("null") is None)
    passfail("Reading list from json", type(json.loads("[1, 2, 3]")) == list)
    passfail("Reading map from json", type(json.loads("{\"array\":[1,2,3],\"boolean\":true,\"null\":null,\"number\":123,\"object\":{\"a\":\"b\",\"c\":\"d\",\"e\":\"f\"},\"string\":\"Hello World\"}")) == dict)

def register_check():
    """Check register.php"""
    global account_uuid, account_username, account_password
    passfail = print_closure("register_check")
    print("Performing account registration test")

    not_matching = call_server("register.php", {"username": "01928374657483", "password": "firstpassword", "confirm_password": "secondpassword", "email": "email"})
    passfail("Mismatching Passwords", not_matching == "PASSWORDS DONT MATCH")

    new_username = get_uuid()
    new_password = get_uuid()
    email = "decoy@me.this"
    new_account_result = call_server("register.php", {"username": new_username, "password": new_password, "confirm_password": new_password, "email": email})
    passfail("Register a new account", len(new_account_result) == 23)
    account_uuid = new_account_result
    account_username = new_username
    account_password = new_password

    username_taken = call_server("register.php", {"username": new_username, "password": new_password, "confirm_password": new_password, "email": email})
    passfail("Username already taken", username_taken == "Username already taken")

def login_check():
    """Check login.php"""
    global account_uuid
    passfail = print_closure("login_check")
    print("Performing Account Login Check")

    failed_login = call_server("login.php", {"username": account_username, "password": "wrongpassword"})
    passfail("Incorrect Login", failed_login == "Log In Failed")

    successful_login = call_server("login.php", {"username": account_username, "password": account_password})
    passfail("Successful Login", len(successful_login) == 23)
    account_uuid = successful_login

def chat_contains_message(data, goal_message):
    for message in data:
        if message["message"] == goal_message:
            return True
    return False

def chat_check():
    """Check chat.php"""
    passfail = print_closure("chat_check")
    print("Performing Chat Check")
    
    room = get_uuid()
    submit_message = call_server("chat.php", {"action": "send", "uuid": account_uuid, "room": room, "message": "Test Message"})
    failed_login_message = call_server("chat.php", {"action": "send", "uuid": "invaliduuid", "room": room, "message": "Invalid UUID Message"})
    retrieve_message = call_server("chat.php", {"action": "get", "room": room})

    submit_map = json.loads(submit_message)
    failed_map = jsons.load(failed_login_message)
    success_map = json.load(retrieve_message)
    
    passfail("Not logged in chat", failed_map["error"] == "UUID NOT LOGGED IN")
    passfail("Sent message successfully", submit_map["message"] == "Successfully sent message")
    passfail("Read message successfully", chat_contains_message(success_map, "Test Message"))
    passfail("Not logged in message did not get read", not chat_contains_message(success_map, "Invalid UUID Message"))
    
def main():
    """Perform the checks and print the stats"""
    python_sanity_check()
    register_check()
    if (len(account_uuid) != 23):
        return # Can't continue without an account
    login_check()
    if (len(account_uuid) != 23):
        return # Can't continue without a successful login
    chat_check()
    print()
    print("Passed Tests:", passed_tests);
    print("Failed Tests:", failed_tests);
    print("Total Tests:", passed_tests + failed_tests);

if __name__ == "__main__":
    main()
