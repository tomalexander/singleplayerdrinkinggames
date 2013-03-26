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

function cleanup_old_chats()
{
    $db = open_db();
    $db->exec("DELETE FROM `singleplayerdb`.`chat` WHERE `chat`.`time` < DATE_SUB(NOW(),INTERVAL '60' SECOND)");
    close_db();
}

if ($action == "send") {
    // Post a message
    $uuid = $_REQUEST["uuid"];
    $room = isset($_REQUEST["room"]) ? $_REQUEST["room"] : "main";
    $message = $_REQUEST["message"];
    $db = open_db();
    cleanup_old_chats();
    $user_info = get_login($uuid);
    if ($user_info == null) {
        die("{\n    \"error\": \"UUID NOT LOGGED IN\"\n}");
    }
    $insert = "INSERT INTO chat (userid, room, message) VALUES (:userid, :room, :message);";
    $stmt = $db->prepare($insert);
    $stmt->bindParam(":userid", $user_info->id);
    $stmt->bindParam(":room", $room);
    $stmt->bindParam(":message", $message);
    if (! $stmt->execute()) {
        close_db();
        die("{\n    \"error\": \"Failed to execute statement\"\n}");
    }
    close_db();
} else if ($action == "get") {
    //Retrieve messages
    $room = isset($_REQUEST["room"]) ? $_REQUEST["room"] : "main";
    $last_id = isset($_REQUEST["last_id"]) ? $_REQUEST["last_id"] : 0;
    $db = open_db();
    $result = $db->query("SELECT chat.id,chat.message,UNIX_TIMESTAMP(chat.time),(SELECT username FROM users WHERE id=chat.userid LIMIT 1) FROM chat WHERE `room`=\"{$room}\" AND `id`>{$last_id} ORDER BY chat.id ASC;");
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