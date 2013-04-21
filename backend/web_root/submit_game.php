<?php
include "games.php";
include "users.php";

/*
 * Submits a new game to the database, but returns an error
 * message if there already exsists a game with the same name.
 * 
 * @Param game_name The name of the game being created.
 * @Param submitter_id The ID of the user submitting the game.
 * @Param short_description A short description of the game.
 * @Param supplies The supplies required for the game.
 * @Param instructions The instructions for playing the game.
 */
function main() {
    $uuid = $_REQUEST["uuid"];
    $game_name = $_REQUEST["game_name"];
    $short_desc = $_REQUEST["short_description"];
    $long_desc = $_REQUEST["long_description"];
    $supplies = $_REQUEST["supplies"];
    $instructions = $_REQUEST["instructions"];
    
    // Check if the user is logged in and if it a valid uuid
    $user_info = get_login($uuid);
    if($user_info == null) {
        die("UUID NOT LOGGED IN");
    }
    $submitter_id = $user_info->id;
    

    if(!is_array($supplies)) {
        $supplies = array();
    }

    
    $game_id = create_game($game_name, $submitter_id, $short_desc, $long_desc, $supplies, $instructions);
    if ($game_id == -1) {
        die("GAME NAME ALREADY TAKEN");
    }
    die();
}

main();
?>
