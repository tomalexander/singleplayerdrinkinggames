<?php 
include_once "../db_functions.php";

$db = open_db();
$db->exec("DELETE FROM `votes` WHERE `voter_id` IN (SELECT id FROM users WHERE `email` = \"decoy@me.this\")");
$db->exec("DELETE FROM `chat` WHERE `userid` IN (SELECT id FROM users WHERE `email` = \"decoy@me.this\")");
$db->exec("DELETE FROM `supplies` WHERE `game_id` IN (SELECT `game_id` FROM `games` WHERE `submitter_id` IN (SELECT id FROM users WHERE `email` = \"decoy@me.this\"))");
$db->exec("DELETE FROM `active_logins` WHERE `userid` IN (SELECT id FROM users WHERE `email` = \"decoy@me.this\")");
$db->exec("DELETE FROM `users` WHERE `email` = \"decoy@me.this\"");
// Temporary functions till tate fixes submit game security
$db->exec("DELETE FROM `games` WHERE `submitter_id` = -1");
$db->exec("DELETE FROM `supplies` WHERE `game_id` IN (SELECT `game_id` FROM `games` WHERE `submitter_id` = -1)");
close_db();
?>