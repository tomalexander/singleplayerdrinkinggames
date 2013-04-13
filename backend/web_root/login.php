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
        header("refresh:5;url=https://singleplayerdrinkinggames.com/");
        setcookie("login_uuid","", time()-3600);
        die("Log In Failed");
    }
    header("Location: https://singleplayerdrinkinggames.com/");
    setcookie("login_uuid",$uuid, time()+3600*24*30); //Expires in 30 days
    die();
}

main();
?>
