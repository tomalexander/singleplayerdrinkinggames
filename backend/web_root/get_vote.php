<?php
include "games.php";
include "users.php";
/*
 * Returns what the current user voted for.
 * 
 * @param game_id The id of the game the user is voting for.
 * @param uuid The id of the user.
 */
function main() {
    $game_id = $_REQUEST["game_id"];
    $uuid = $_REQUEST["uuid"];
    
    $ret = Array();
    $ret["vote"] = 0;

    $user = get_login($uuid);
    if(!$user) {
        echo json_encode($ret); 
        die();
    }
    $voter_id = $user->id;
    if(!game_exists_id($game_id)) {
        echo json_encode($ret);
        die();
    }
    $ret["vote"] = get_vote($game_id,$voter_id);
    echo json_encode($ret);
    die();
}

main();
?>
