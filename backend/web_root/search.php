<?php
include_once "../db_functions.php";
include_once "games.php";
include_once "search_results.php";

function main()
{
	$keyword = $_REQUEST["keyword"];

	$result = search_for_key($keyword);

	echo json_encode($result);

}

main();

?>
