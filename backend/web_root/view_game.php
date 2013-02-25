<?php
include "users.php";
include "games.php";

function main() {
    $game_id = $_REQUEST["game_id"];
    $result = get_game($game_id);
    echo json_encode($result);
}

main();
?>
