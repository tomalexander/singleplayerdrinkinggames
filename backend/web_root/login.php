<?php
include_once "users.php";

/*
 * Checks to see if user's attempt to log in is valid,
 * and then sets a cookie so that the user stays logged in.
 * 
 * @Param username: The name the user is trying to log in with.
 * @Param password: the password that the user is trying to log in with.
 */

function main()
{
    $username = $_REQUEST["username"];
    $password = $_REQUEST["password"];
    
    $uuid = login($username, $password);
    if ($uuid == null) {
        die("Log In Failed");
    }
    die($uuid);
}

main();
?>
