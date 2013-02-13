<?php
include "users.php";
include "games.php";

function main()
{
    $game_name = $_REQUEST["game_name"];
    $submitter_id = 1;
    $short_desc = $_REQUEST["short_description"];
    $long_desc = $_REQUEST["long_description"];
    $supplies = array();
    $instructions = array();

    $game_id = create_game($game_name, $submitter_id, $short_desc, $long_desc, $supplies, $instructions);
    if ($game_id == -1)
    {
        die("Game Name already taken");
    }
    header("Location: https://singleplayerdrinkinggames.com/");
    die();
}

main();
?>