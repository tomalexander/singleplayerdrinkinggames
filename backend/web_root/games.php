<?php
include_once "../db_functions.php";

class game {
    public $game_id;
    public $creation_time;
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
    $insert = "INSERT INTO games (game_name, submitter_id, short_description, long_description, instructions) VALUES (:game_name, :submitter_id, :short_description, :long_description, :instructions)";
    $stmt = $db->prepare($insert);
    $stmt->bindParam(":game_name", $game_name);
    $stmt->bindParam(":submitter_id", $submitter_id);
    $stmt->bindParam(":short_description", $short_desc);
    $stmt->bindParam(":long_description", $long_desc);
    $stmt->bindParam(":instructions", $instructions);
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
            $supp_arr_tmp = array($id, $supply);
            $supp_arr = array_merge($supp_arr, $supp_arr_tmp);
        }
        $stmt = $db->prepare($insert);
        if (! $stmt->execute($supp_arr)) {
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
    $query = "SELECT * FROM games WHERE 'game_name' = :game_name";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":game_name", $game_name);
    if(!$stmt->execute()) {
      close_db();
      print_r($stmt->errorinfo());
      return false;
    }
    $result = $stmt->fetchAll();
    close_db();
    if ($result) {
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
    $query = "SELECT * FROM games WHERE game_id = :game_id";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":game_id", $game_id);
    if(!$stmt->execute()) {
      close_db();
      print_r($stmt->errorinfo());
      return false;
    }
    $result = $stmt->fetchAll();
    close_db();
    if ($result) {
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
    if(!game_exists_id($game_id)) {
        close_db();
        return $ret;
    }
    $query = "SELECT * FROM supplies WHERE game_id = :game_id";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":game_id", $game_id);
    if(!$stmt->execute()) {
      close_db();
      print_r($stmt->errorinfo());
      return $ret;
    }
    $result = $stmt->fetchAll();
    close_db();
    foreach($result as $row) {
        $ret[] = htmlspecialchars($row["supply"]);
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
    $query = "SELECT * FROM games WHERE game_name = :game_name";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":game_name", $game_name);
    if(!$stmt->execute()) {
      close_db();
      print_r($stmt->errorinfo());
      return -1;
    }
    $result = $stmt->fetchAll();
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
    $query = "SELECT *,UNIX_TIMESTAMP(creation_time) FROM games WHERE game_id = :game_id";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":game_id", $game_id);
    if(!$stmt->execute()) {
      close_db();
      print_r($stmt->errorinfo());
      return -1;
    }
    $result = $stmt->fetchAll();
    foreach ($result as $row) {
        //echo "ROW: " . $row . "<br>";
        $ret->game_id = $row["game_id"];
        $ret->creation_time = $row["UNIX_TIMESTAMP(creation_time)"];
        $ret->game_name = htmlspecialchars($row["game_name"]);
        $ret->submitter_id = $row["submitter_id"];
        $user_result = $db->query("SELECT * FROM users WHERE `id`=\"{$ret->submitter_id}\"");
        foreach ($user_result as $user_row) {
            $ret->submitter_username = htmlspecialchars($user_row["username"]);
        }
        $ret->short_description = htmlspecialchars($row["short_description"]);
        $ret->long_description = htmlspecialchars($row["long_description"]);
        $ret->supplies = get_supplies($game_id);
        $ret->instructions = $row["instructions"];
        $query = "SELECT COUNT(*) FROM votes WHERE game_id = :game_id AND vote = 1";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":game_id", $ret->game_id);
        if(!$stmt->execute()) {
            $ret->upvote_count = 0;
        } else {
            foreach($stmt->fetchAll() as $s) {
                $ret->upvote_count = $s["COUNT(*)"];
            }
        }
        $query = "SELECT COUNT(*) FROM votes WHERE game_id = :game_id AND vote = -1";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":game_id", $ret->game_id);
        if(!$stmt->execute()) {
            $ret->downvote_count = 0;
        } else {
            foreach($stmt->fetchAll() as $s) {
                $ret->downvote_count = $s["COUNT(*)"];
            }
        }
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

/**
 * Return a list of game information to display on the homepage sidebar
 *
 * @return list of valid game objects
 */
function get_sidebar_game_list() {
    $db = open_db();
    $result = $db->query("SELECT * FROM games ORDER BY RAND() LIMIT 5");
    $list = array();
    foreach ($result as $item) {
        $list[] = $item;
    }
    return $list;
}

/** 
 * Adds or Changes a vote
 * 
 * @param game_id The game ID
 * @param voter_id The user voting
 * @param vote the vote to record
 */
function vote($game_id, $voter_id, $vote) {
    $db = open_db();
    $query = "";
    $ret = 0;
    // Check their previous vote if any
    $old_vote = get_vote($game_id, $voter_id);
    $remove = false;
    // Add if it is different from their old and an allowed value
    if(($vote == $old_vote) || ($vote != -1 && $vote != 1)) {
        // Else remove it from the table
        $query = "DELETE FROM votes WHERE game_id = :game_id AND voter_id = :voter_id";
        $remove = true;
    } else {
        $query = "UPDATE votes SET vote = :vote WHERE voter_id = :voter_id AND game_id = :game_id"; 
    }
    $stmt = $db->prepare($query);
    $stmt->bindParam(":game_id", $game_id);
    $stmt->bindParam(":voter_id", $voter_id);
    if(!$remove) {
        $stmt->bindParam(":vote", $vote);
    }
    if(!$stmt->execute()) {
        print_r($stmt->errorinfo());
        close_db();
        return intval($ret);
    }
    if($stmt->rowCount() > 0 || $remove) {
        close_db();
        $ret = ($remove) ? 0 : $vote;
        return intval($ret);
    }

    $query = "INSERT INTO votes (game_id, voter_id, vote) VALUES (:game_id, :voter_id, :vote)";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":game_id", $game_id);
    $stmt->bindParam(":voter_id", $voter_id);
    $stmt->bindParam(":vote", $vote);
    if(!$stmt->execute()) {
        print_r($stmt->errorinfo());
        close_db();
        return intval($ret);
    }
    $ret = $vote;
    close_db();
    return intval($ret);
}

/** 
 * Get a user's vote for a game
 * 
 * @param game_id The game ID
 * @param voter_id The user to search for
 *
 * @return vote the vote on record or 0 if none recorded / error
 */
function get_vote($game_id, $voter_id) {
    $db = open_db();
    $query = "SELECT vote FROM votes WHERE game_id = :game_id AND voter_id = :voter_id";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":game_id", $game_id);
    $stmt->bindParam(":voter_id", $voter_id);
    if(!$stmt->execute()) {
        close_db();
        return 0;
    }
    $result = $stmt->fetchAll();
    $ret = 0;
    foreach ($result as $row) {
        $ret = intval($row["vote"]);
    }
    return $ret;
}
?>
