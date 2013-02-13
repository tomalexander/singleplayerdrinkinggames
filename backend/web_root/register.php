<?php
include "users.php";

function main()
{
    $username = $_REQUEST["username"];
    $password = $_REQUEST["password"];
    $confirm_password = $_REQUEST["confirm_password"];
    $email = $_REQUEST["email"];

    if ($confirm_password != $password)
    {
        die("PASSWORDS DONT MATCH");
    }

    $uuid = create_user($username, $password, $email);
    if ($uuid == 1)
    {
        header("refresh:5;url=register.html");
        setcookie("login_uuid","", time()-3600);
        die("Username already taken");
    }
    header("Location: https://singleplayerdrinkinggames.com/");
    setcookie("login_uuid",$uuid, time()+3600*24*30); //Expires in 30 days
    die();
}

main();
?>