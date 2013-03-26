<?php
include_once "../db_functions.php";
include_once "users.php";

$action = $_REQUEST["action"];

class chat_message
{
    public $id;
    public $username;
    public $message;
    public $timestamp;
}

if ($action == "send")
{
    // Post a message
    $uuid = $_REQUEST["uuid"];
    $user_info = get_login($uuid);
    if ($user_info == null) {
        die("{\n    \"error\": \"UUID NOT LOGGED IN\"\n}");
    }
} else if ($action == "get") {
    $room = $_REQUEST["room"];
    $db = open_db();
    $result = $db->query("SELECT chat.id,chat.message,UNIX_TIMESTAMP(chat.time),(SELECT username FROM users WHERE id=chat.userid LIMIT 1) FROM chat WHERE `room`=\"{$room}\";");
    $ret = array();
    foreach ($result as $row) {
        $current = new chat_message;
        $current->id = $row["id"];
        $current->username = $row["(SELECT username FROM users WHERE id=chat.userid LIMIT 1)"];
        $current->message = $row["message"];
        $current->timestamp = $row["UNIX_TIMESTAMP(chat.time)"];
        $ret[] = $current;
    }
    close_db();
    echo json_encode($ret);
}
?>