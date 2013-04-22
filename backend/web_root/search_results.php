<?php
include_once "../db_functions.php";
include_once "games.php";
include_once "search.php";

/**
* Search for a game in the database
* 
* @param $keyword The keyword being searched
*
* Return list of games matching, similar to list_games
*
*/

function search_for_key($keyword)
{   
    $db = open_db();
    $result = $db->query("SELECT * FROM games WHERE `game_name` LIKE \"%{$keyword}%\" UNION SELECT * FROM games WHERE `short_description` LIKE \"%{$keyword}%\" UNION SELECT * FROM games WHERE `long_description` LIKE \"%{$keyword}%\"");
/* UNION SELECT * FROM instructions WHERE `instruction` LIKE \"%{$keyword}%\" UNION SELECT * FROM supplies WHERE `supply` LIKE \"%{$keyword}%\"*/

    close_db();


    $list = array();
	foreach ($result as $items) {
        $list[] = $items;
	}/*
	foreach ($description_short as $item) {
        $list[] = $item;
	}*/

	return $list;
}

?>
