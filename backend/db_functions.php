<?php
$global_db = null;
$db_connections = 0;

/** 
 * Open a mysql database connection using the new PDO extension
 * 
 * 
 * @return the database object
 */
function open_db()
{
    global $global_db, $db_connections;
    if ($db_connections > 0)
    {
        $db_connections += 1;
        return $global_db;
    }
    $global_db = new PDO("mysql:host=mysql.singleplayerdrinkinggames.com;dbname=singleplayerdb", "theenablers", "alcoholic");
    $db_connections += 1;
    return $global_db;
}

/** 
 * Close the mysql database connection if everyone is done using it
 * 
 * 
 */
function close_db()
{
    global $global_db, $db_connections;
    if ($db_connections > 0)
    {
        $db_connections -= 1;
    }
    if ($db_connections == 0)
    {
        $global_db = null; //Close the connection
    }
}
?>