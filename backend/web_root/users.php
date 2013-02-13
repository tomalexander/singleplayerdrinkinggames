<?php
include "../db_functions.php";

class user
{
    public $id;
    public $username;
    public $email;
}

/** 
 * Create a user in the database
 * 
 * @param username The username for the new user
 * @param password The password for the new user
 * @param email The email for the new user
 * 
 * @return uuid = success, 1 = username already exists, 2 = mysql query failed
 */
function create_user($username, $password, $email)
{
    $db = open_db();
    if (username_exists($username))
    {
        close_db();
        return 1;
    }
    $salt = base64_encode(openssl_random_pseudo_bytes(32));
    $combined_password = hash("sha256", $password . $salt);
    $insert = "INSERT INTO users (username, password, salt, email) VALUES (:username, :password, :salt, :email)";
    $stmt = $db->prepare($insert);
    $stmt->bindParam(":username", $username);
    $stmt->bindParam(":password", $combined_password);
    $stmt->bindParam(":salt", $salt);
    $stmt->bindParam(":email", $email);
    if (! $stmt->execute())
    {
        close_db();
        print_r($stmt->errorInfo());
        return 2; //statement failed to execute
    }

    $id = get_user_id($username);
    $insert = "INSERT INTO active_logins (userid) VALUES (:userid)";
    $stmt = $db->prepare($insert);
    $stmt->bindParam(":userid", $id);
    if (! $stmt->execute())
    {
        close_db();
        print_r($stmt->errorInfo());
        return 2; //statement failed to execute
    }
    $uuid = login($username, $password);
    close_db();
    return $uuid;
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

/** 
 * Log the user in
 * 
 * @param username The username
 * @param password The password for the user, not hashed or salted 
 * 
 * @return the UUID for the user or null if the login fails
 */
function login($username, $password)
{
    $db = open_db();
    $result = $db->query("SELECT * FROM users WHERE `username`=\"{$username}\"");
    foreach ($result as $row)
    {
        $combined_password = hash("sha256", $password . $row["salt"]);
        if ($combined_password == $row["password"])
        {
            $uuid = uniqid("", true);
            $userid = get_user_id($username);
            $db->exec("UPDATE active_logins SET `uuid`=\"{$uuid}\" WHERE userid={$userid}");
            close_db();
            return $uuid;
        }
    }
    close_db();
    return null;
}

/** 
 * Get the userid for the username
 * 
 * @param username The user to look up
 * 
 * @return the userid or -1 if not found
 */
function get_user_id($username)
{
    $db = open_db();
    $result = $db->query("SELECT * FROM users WHERE `username`=\"{$username}\"");
    close_db();
    foreach ($result as $row)
    {
        return intval($row["id"]);
    }
    return -1;
}

/** 
 * Return a user object for the corresponding uuid
 * 
 * @param uuid The logged in UUID
 * 
 * @return a user object for the logged in user or null if they are not logged in
 */
function get_login($uuid)
{
    $db = open_db();
    $ret = new user;
    $result = $db->query("SELECT * FROM active_logins WHERE `uuid`=\"{$uuid}\"");
    $id = -1;
    foreach ($result as $row)
    {
        $id = $row["userid"];
    }
    if ($id == -1) // UUID not logged in
    {
        close_db();
        return null;
    }
    $result = $db->query("SELECT * FROM users WHERE `id`=\"{$id}\"");
    foreach ($result as $row)
    {
        $ret->id = $id;
        $ret->username = $row["username"];
        $ret->email = $row["email"];
    }
    close_db();
    return $ret;
}
?>