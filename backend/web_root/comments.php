<?php
include_once "../db_functions.php";
/**
 * Return a list of game information
 *
 * @return list of valid comment objects
 */
function get_game_list($test_game_id) {
    $db = open_db();
    $result = $db->query("SELECT * FROM comments WHERE game_id = " . $test_game_id);
    $list = array();
    foreach ($result as $item) {
        $list[] = $item;
    }
    return $list;
}

$test_game_id = $_REQUEST["gameid"];
echo json_encode(get_game_list($test_game_id));
?>
