<?php
include "games.php";

/* 
 * Fetches the game info.
 */
function main() {
    $game_id = $_REQUEST["gameid"];
    $result = get_game($game_id);
    echo json_encode($result);
}

main();
?>
