<?php
include "users.php";
include "games.php";

/*
 * Returns list of games from the games database.
 */

function main() {
    $result = get_game_list();
    echo json_encode($result);
}

main();
?>
