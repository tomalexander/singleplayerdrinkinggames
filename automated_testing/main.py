#!/usr/bin/python
#

import urllib.request
import urllib.parse
import json

passed_tests = 0
failed_tests = 0

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
    passfail = print_closure("register_check")
    print("Performing account registration test")

    not_matching = call_server("register.php", {"username": "01928374657483", "password": "firstpassword", "confirm_password": "secondpassword", "email": "email"})
    passfail("Mismatching Passwords", not_matching == "PASSWORDS DONT MATCH")
    
def main():
    """Perform the checks and print the stats"""
    python_sanity_check()
    register_check()
    print()
    print("Passed Tests:", passed_tests);
    print("Failed Tests:", failed_tests);
    print("Total Tests:", passed_tests + failed_tests);

if __name__ == "__main__":
    main()
