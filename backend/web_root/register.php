<?php
include "users.php";
/*
 * Registers a new user, and then sets a cookie that logs the user in.
 * 
 * @Param username: The name the user wants to create an account for.
 * @Param password: the password that goes with the new user's account.
 */
function main()
{
    $username = $_REQUEST["username"];
    $password = $_REQUEST["password"];
    $confirm_password = $_REQUEST["confirm_password"];
    $email = $_REQUEST["email"];

    if ($confirm_password != $password) {
        die("PASSWORDS DONT MATCH");
    }

    $uuid = create_user($username, $password, $email);
    if ($uuid == 1) {
        die("Username already taken");
    }
    die($uuid);
}

main();
?>
