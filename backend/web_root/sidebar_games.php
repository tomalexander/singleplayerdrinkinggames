<?php
include "users.php";
include "games.php";

/*
 * Fetches the data for the games list in the sidebar.
 */
 
function main() {
    $result = get_sidebar_game_list();
    echo json_encode($result);
}

main();
?>
