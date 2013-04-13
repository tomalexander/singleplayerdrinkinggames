<?php
include "games.php";
include "users.php";

/*
 * Adds a vote to the designated game.
 * 
 * @param game_id The id of the game the user is voting for.
 * @param uuid The id of the user doing the voiting.
 * @param vote The kind of vote being made. +1 is an upvote, -1 is a downvote
 */

function main() {
    $game_id = $_REQUEST["game_id"];
    $uuid = $_REQUEST["uuid"];
    $vote = $_REQUEST["vote"];
    
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

    $ret["vote"] = vote($game_id,$voter_id,$vote);

    echo json_encode($ret);
    die();
}

main();
?>
