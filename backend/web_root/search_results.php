<?php
include_once "../db_functions.php";
include_once "games.php";
include_once "search.php";

/**
 * Query the database for the specified keyword
 * 
 * @param $keyword The keyword being searched
 *
 * Returns a list of games matching
 */

function search_for_key($keyword) {   
    $db = open_db();
    $result = $db->query("SELECT * FROM games WHERE `game_name` LIKE \"%{$keyword}%\" UNION SELECT * FROM games WHERE `short_description` LIKE \"%{$keyword}%\" UNION SELECT * FROM games WHERE `long_description` LIKE \"%{$keyword}%\" UNION SELECT * FROM games WHERE `instructions` LIKE \"%{$keyword}%\"");
/* UNION SELECT * FROM supplies WHERE `supply` LIKE \"%{$keyword}%\"*/

    close_db();


    $list = array();
	foreach ($result as $items) {
        $list[] = $items;
	}

	return $list;
}

?>
