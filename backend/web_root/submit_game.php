<?php
include "users.php";
include "games.php";

function main() {
    $game_name = $_REQUEST["game_name"];
    $submitter_id = $_REQUEST["submitter_id"];
    $short_desc = $_REQUEST["short_description"];
    $long_desc = $_REQUEST["long_description"];
    $supplies = $_REQUEST["supplies"];
    $instructions = $_REQUEST["instructions"];
    
    if(!is_array($supplies)) {
        $supplies = array();
    }
    if(!is_array($instructions)) {
        $instructions = array();
    }

    $game_id = create_game($game_name, $submitter_id, $short_desc, $long_desc, $supplies, $instructions);
    if ($game_id == -1)
    {
        header("refresh:5;url=https://singleplayerdrinkinggames.com/");
        die("Game Name already taken");
    }
    header("Location: https://singleplayerdrinkinggames.com/");
    die();
}

main();
?>