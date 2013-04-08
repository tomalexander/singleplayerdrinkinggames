<?php
include "users.php";
include "games.php";

function main() {
    $result = get_sidebar_game_list();
    echo json_encode($result);
}

main();
?>
