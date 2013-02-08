<?php
include "../db_functions.php";

/** 
 * Create a user in the database
 * 
 * @param username The username for the new user
 * @param password The password for the new user
 * 
 * @return 0 = success, 1 = username already exists, 2 = mysql query failed
 */
function create_user($username, $password)
{
    $db = open_db();
    if (username_exists($username))
    {
        close_db();
        return 1;
    }
    $salt = substr(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), 0, 20);
    $hashed_salt = hash("sha256", $salt);
    $hashed_password = hash("sha256", $password);
    $combined_password = hash("sha256", $hashed_password . $hashed_salt);
    $insert = "INSERT INTO users (username, password, salt) VALUES (:username, :password, :salt)";
    $stmt = $db->prepare($insert);
    $stmt->bindParam(":username", $username);
    $stmt->bindParam(":password", $combined_password);
    $stmt->bindParam(":salt", $salt);
    if (! $stmt->execute())
    {
        close_db();
        print_r($stmt->errorInfo());
        return 2; //statement failed to execute
    }
    close_db();
    return 0;
}

/** 
 * Check to see if the username exists in the database
 * 
 * @param username The username to check
 * 
 * @return true if the user exists, false if it does not
 */
function username_exists($username)
{
    $db = open_db();
    $result = $db->query("SELECT * FROM users WHERE `username`=\"{$username}\"");
    close_db();
    if ($result->fetch())
    {
        return true;
    } else {
        return false;
    }
}
?>