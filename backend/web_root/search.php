<?php
include_once "../db_functions.php";
include_once "games.php";
include_once "search_results.php";

/*
 * Performs a keyword search through games currently in the database.
 * 
 * @Param keyword: The keyword to be search specified by the user.
 */
function main() {
    $keyword = $_REQUEST["keyword"];

    $result = search_for_key($keyword);

    echo json_encode($result);

}

main();

?>
