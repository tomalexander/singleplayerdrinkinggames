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
    """Check login.php and get_login_details.php"""
    global account_uuid
    passfail = print_closure("login_check")
    print("Performing Account Login Check")

    failed_login = call_server("login.php", {"username": account_username, "password": "wrongpassword"})
    passfail("Incorrect Login", failed_login == "Log In Failed")

    successful_login = call_server("login.php", {"username": account_username, "password": account_password})
    passfail("Successful Login", len(successful_login) == 23)
    account_uuid = successful_login

    login_details = json.loads(call_server("get_login_details.php", {"uuid": account_uuid}))
    passfail("Get Login Details", "error" not in login_details and login_details["username"] == account_username)

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
    failed_map = json.loads(failed_login_message)
    success_map = json.loads(retrieve_message)
    
    passfail("Not logged in chat", failed_map["error"] == "UUID NOT LOGGED IN")
    passfail("Sent message successfully", submit_map["message"] == "Successfully sent message")
    passfail("Read message successfully", chat_contains_message(success_map, "Test Message"))
    passfail("Not logged in message did not get read", not chat_contains_message(success_map, "Invalid UUID Message"))

def games_count(data, name):
    """Counts the number of games that have the provided name"""
    ret = 0
    for game in data:
        if game["game_name"] == name:
            ret += 1
    return ret

def games_contains(data, name):
    """Check to see if the games list contains a game with the provided name"""
    return games_count(data, name) != 0

def games_check():
    """Check list_games.php and submit_game.php"""
    passfail = print_closure("games_check")
    print("Performing list and submit game check")

    original_games_list = json.loads(call_server("list_games.php"))
    
    new_game = get_uuid()
    success_game = call_server("submit_game.php", {"game_name": new_game, "submitter_id": 102, "short_description": "test short desc", "long_description": "test long desc", "supplies[]": "test", "instructions": "## Instructions"})

    new_games_list = json.loads(call_server("list_games.php"))
    passfail("Create a new game", games_contains(new_games_list, new_game) and not games_contains(original_games_list, new_game))

    fail_game = call_server("submit_game.php", {"game_name": new_game, "submitter_id": 102, "short_description": "test short desc", "long_description": "test long desc", "supplies[]": "test", "instructions": "## Instructions"})
    final_games_list = json.loads(call_server("list_games.php"))
    passfail("Block games with same name as previous game", games_count(final_games_list, new_game) == 1)

def vote_check():
    """Check get_vote.php and vote.php"""
    passfail = print_closure("vote_check")
    print("Performing the vote check")
    game_id = json.loads(call_server("list_games.php"))[0]["game_id"]
    
    not_logged_in = json.loads(call_server("get_vote.php", {"game_id": game_id, "uuid": "invaliduuid"}))
    passfail("Not logged in vote", not_logged_in["vote"] == 0)
    
    invalid_gameid = json.loads(call_server("get_vote.php", {"game_id": -10, "uuid": account_uuid}))
    passfail("Invalid Game ID", invalid_gameid["vote"] == 0)
    
    valid = json.loads(call_server("get_vote.php", {"game_id": game_id, "uuid": account_uuid}))
    passfail("Valid Get Vote", valid["vote"] == 0)

    call_server("vote.php", {"game_id": game_id, "uuid": account_uuid, "vote": 1})
    voted = json.loads(call_server("get_vote.php", {"game_id": game_id, "uuid": account_uuid}))
    passfail("Voted Get Vote", voted["vote"] == 1)

def view_game_check():
    """Checks view_game.php"""
    passfail = print_closure("view_game")
    print("Checking the view game function")
    game_id = json.loads(call_server("list_games.php"))[0]["game_id"]
    game = json.loads(call_server("view_game.php", {"gameid": game_id}))
    passfail("Get a game", game["game_id"] == game_id)

def sidebar_games_check():
    """Checks the sidebar games"""
    passfail = print_closure("sidebar_games")
    print("Checking the sidebar games function")
    games_list = json.loads(call_server("sidebar_games.php"))
    passfail("Get at most 5 games for sidebar", len(games_list) <= 5 and len(games_list) > 0)

def cleanup_automated_test():
    """Cleans up the database"""
    call_server("cleanup_automated_test.php")
    
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
    games_check()
    vote_check()
    view_game_check()
    sidebar_games_check()
    cleanup_automated_test()
    print()
    print("Passed Tests:", passed_tests);
    print("Failed Tests:", failed_tests);
    print("Total Tests:", passed_tests + failed_tests);

if __name__ == "__main__":
    main()
