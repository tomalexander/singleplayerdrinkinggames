<?php
include "../db_functions.php";

class game
{
    public $game_id;
    public $game_name;
    public $submitter_id;
    public $submitter_username;
    public $short_description;
    
    public $long_description;
    public $supplies;
    public $instructions;
    
    public $upvote_count;
    public $downvote_count;
    public $report_count;
    public $view_count;
}

/** 
 * Create a game in the database
 * 
 * @param game_name The name of the new game
 * @param submitter_id The id of the submitting user
 * @param short_desc A short description of the game
 * @param long_desc A long description of the game
 * @param supplies Any necessary supplies as a comma separated list 
 * @param instructions Instructions for play as a comma separated list
 * 
 * @return game_id = success, 1 = game_name already exists, 2 = mysql query failed
 */
function create_game($game_name, $submitter_id, $short_desc, $long_desc, $supplies, $instructions)
{
    $db = open_db();
    if (game_exists($game_name))
    {
        close_db();
        return 1;
    }
    $game_name = htmlspecialchars($game_name);
    $short_desc = htmlspecialchars($short_desc);
    $long_desc = htmlspecialchars($long_desc);
    $supplies = htmlspecialchars($supplies);
    $instructions = htmlspecialchars($instructions);
    $insert = "INSERT INTO games (game_name, submitter_id, short_description, long_description, supplies, instructions) VALUES (:game_name, :submitter_id, :short_description, :long_description, :supplies, :instructions)";
    $stmt = $db->prepare($insert);
    $stmt->bindParam(":game_name", $game_name);
    $stmt->bindParam(":submitter_id", $submitter_id);
    $stmt->bindParam(":short_description", $short_desc);
    $stmt->bindParam(":long_description", $long_desc);
    $stmt->bindParam(":supplies", $supplies);
    $stmt->bindParam(":instructions", $instructions);
    if (! $stmt->execute())
    {
        close_db();
        print_r($stmt->errorInfo());
        return 2; //statement failed to execute
    }

    $id = get_game_id($game_name);
    close_db();
    return $id;
}

/** 
 * Check to see if the game_name exists in the database
 * 
 * @param game_name The game name to check
 * 
 * @return true if the game exists, false if it does not
 */
function game_exists($game_name)
{
    $db = open_db();
    $result = $db->query("SELECT * FROM games WHERE `game_name`=\"{$game_name}\"");
    close_db();
    if ($result->fetch())
    {
        return true;
    } else {
        return false;
    }
}

/** 
 * Check to see if the game_id exists in the database
 * 
 * @param game_id The game id to check
 * 
 * @return true if the game exists, false if it does not
 */
function game_exists_id($game_id)
{
    $db = open_db();
    $result = $db->query("SELECT * FROM games WHERE `id`=\"{$game_id}\"");
    close_db();
    if ($result->fetch())
    {
        return true;
    } else {
        return false;
    }
}


/** 
 * Get the id for the game name
 * 
 * @param game_name The game to look up
 * 
 * @return the id or -1 if not found
 */
function get_game_id($game_name)
{
    $db = open_db();
    $result = $db->query("SELECT * FROM gamess WHERE `game_name`=\"{$game_name}\"");
    close_db();
    foreach ($result as $row)
    {
        return intval($row["id"]);
    }
    return -1;
}

public $game_id;
    public $game_name;
    public $submitter_id;
    public $submitter_username;
    public $short_description;
    
    public $long_description;
    public $supplies;
    public $instructions;
    
    public $upvote_count;
    public $downvote_count;
    public $report_count;
    
/** 
 * Return a game object for the corresponding id
 * 
 * @param id The game ID
 * 
 * @return a game object for the game or null if it does not exist
 */
function get_game($game_id)
{
    $db = open_db();
    $ret = new game;
    if(!game_exists($game_id))
    {
        return null;
    }
    $result = $db->query("SELECT * FROM users WHERE `id`=\"{$game_id}\"");
    foreach ($result as $row)
    {
        $ret->game_id = $row["id"];
        $ret->game_name = $row["game_name"];
        $ret->submitter_id = $row["submitter_id"];
        $ret->submitter_username = "PLACEHOLDER";
        $ret->short_description = $ret["short_description"];
        $ret->long_description = $ret["long_description"];
        $ret->supplies = $ret["supplies"];
        $ret->instructions = $ret["instructions"];
        $ret->upvote_count = 0;
        $ret->downvote_count = 0;
        $ret->report_count = 0;
        $ret->view_count = 0;
    }
    close_db();
    return $ret;
}
?>