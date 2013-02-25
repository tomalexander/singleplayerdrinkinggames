<?php
include_once "../db_functions.php";

class game {
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
 * @return game_id = success, -1 = game_name already exists, -2 = mysql query failed, -3 = empty fields passed
 */
function create_game($game_name, $submitter_id, $short_desc, $long_desc, $supplies, $instructions) {
    $db = open_db();
    if (game_exists($game_name)) {
        close_db();
        return -1;
    }
    if((!isset($game_name) || $game_name == "") || (!isset($submitter_id)) || (!isset($short_desc) || $short_desc == "") || (!isset($long_desc) || $long_desc == "")) {
        close_db();
        return -3;
    }
    $game_name = htmlspecialchars($game_name);
    $short_desc = htmlspecialchars($short_desc);
    $long_desc = htmlspecialchars($long_desc);
    $insert = "INSERT INTO games (game_name, submitter_id, short_description, long_description) VALUES (:game_name, :submitter_id, :short_description, :long_description)";
    $stmt = $db->prepare($insert);
    $stmt->bindParam(":game_name", $game_name);
    $stmt->bindParam(":submitter_id", $submitter_id);
    $stmt->bindParam(":short_description", $short_desc);
    $stmt->bindParam(":long_description", $long_desc);
    if (! $stmt->execute()) {
        close_db();
        print_r($stmt->errorInfo());
        return -2; //statement failed to execute
    }

    $id = get_game_id($game_name);
    if(count($supplies > 0)) {
        // Now add the supplies to the supplies table and the instructions to the instructions table
        $insert = "INSERT INTO supplies (game_id, supply) VALUES (?,?)";
        // Add as many fields as we have supplies
        for($i = 1; $i < count($supplies); $i++) {
            $insert .= ", (?,?)";
        }
        // Generate array of supplies to insert
        $supp_arr = array();
        foreach($supplies as $supply) {
            $supp_arr_tmp = array($id, htmlspecialchars($supply));
            $supp_arr = array_merge($supp_arr, $supp_arr_tmp);
        }
        $stmt = $db->prepare($insert);
        if (! $stmt->execute($supp_arr)) {
            close_db();
            print_r($stmt->errorInfo());
            return -2; //statement failed to execute
        }
    }
    
    // Do the same for instructions
    if(count($instructions > 0)) {
        $insert = "INSERT INTO instructions (game_id, instruction) VALUES (?,?)";
        
        for($i = 1; $i < count($instructions); $i++) {
            $insert .= ", (?,?)";
        }
        
        $inst_arr = array();
        foreach($instructions as $instruction) {
            $inst_arr_tmp = array($id, htmlspecialchars($instruction));
            $inst_arr = array_merge($inst_arr, $inst_arr_tmp);
        }
        $stmt = $db->prepare($insert);
        if (! $stmt->execute($inst_arr)) {
            close_db();
            print_r($stmt->errorInfo());
            return -2; //statement failed to execute
        }
    }
    
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
function game_exists($game_name) {
    $db = open_db();
    $result = $db->query("SELECT * FROM games WHERE `game_name`=\"{$game_name}\"");
    close_db();
    if ($result->fetch()) {
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
function game_exists_id($game_id) {
    $db = open_db();
    $result = $db->query("SELECT * FROM games WHERE `game_id`=\"{$game_id}\"");
    close_db();
    if ($result->fetch()) {
        return true;
    } else {
        return false;
    }
}

/** 
 * Return an array of supplies for the corresponding game id
 * 
 * @param id The game ID
 * 
 * @return array of supplies for the given game or null if none exist
 */
function get_supplies($game_id) {
    $db = open_db();
    $ret = array();
    if(!game_exists($game_id)) {
        close_db();
        return $ret;
    }
    $result = $db->query("SELECT * FROM supplies WHERE `game_id`=\"{$game_id}\"");
    close_db();
    foreach($result as $row) {
        $ret[] = $row["supply"];
    }

    return $ret;
}

/** 
 * Return an array of instructions for the corresponding game id
 * 
 * @param id The game ID
 * 
 * @return array of instructions for the given game or an empty array if none exist
 */
function get_instructions($game_id) {
    $db = open_db();
    $ret = array();
    if(!game_exists($game_id)) {
        close_db();
        return $ret;
    }
    $result = $db->query("SELECT * FROM instructions WHERE `game_id`=\"{$game_id}\"");
    close_db();
    foreach($result as $row) {
        $ret[] = $row["instruction"];
    }

    return $ret;
}

/** 
 * Get the id for the game name
 * 
 * @param game_name The game to look up
 * 
 * @return the id or -1 if not found
 */
function get_game_id($game_name) {
    $db = open_db();
    $result = $db->query("SELECT * FROM games WHERE `game_name`=\"{$game_name}\"");
    close_db();
    foreach ($result as $row) {
        return intval($row["game_id"]);
    }
    return -1;
}

/** 
 * Return a game object for the corresponding id
 * 
 * @param id The game ID
 * 
 * @return a game object for the game or null if it does not exist
 */


function get_game($game_id) {
    $db = open_db();
    $ret = new game;
    if(!game_exists_id($game_id)) {
        close_db();
        return null;
    }
    $result = $db->query("SELECT * FROM games WHERE `game_id`=\"{$game_id}\"");
    foreach ($result as $row) {
        $ret->game_id = $row["game_id"];
        $ret->game_name = $row["game_name"];
        $ret->submitter_id = $row["submitter_id"];
        $user_result = $db->query("SELECT * FROM users WHERE `id`=\"{$ret->submitter_id}\"");
        //$ret->submitter_username = $user_result["id"];
        $ret->short_description = $row["short_description"];
        $ret->long_description = $row["long_description"];
        $ret->supplies = get_supplies($game_id);
        $ret->instructions = get_instructions($game_id);
        $ret->upvote_count = 0;
        $ret->downvote_count = 0;
        $ret->report_count = 0;
        $ret->view_count = 0;
    }
    close_db();
    return $ret;
}

/**
 * Return a list of game information
 *
 * @return list of valid game objects
 */

function get_game_list() {
    $db = open_db();
    $result = $db->query("SELECT * FROM games");
    $list = array();
    foreach ($result as $item) {
        $list[] = $item;
    }
    return $list;
}
?>
