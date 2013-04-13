<?php
include "users.php";

/*
 * Calls GetLogin, checks if user is logged in, and passes back the User Info
 */

$uuid = $_REQUEST["uuid"];
$user_info = get_login($uuid);
if ($user_info == null) {
    die("{\n    \"error\": \"UUID NOT LOGGED IN\"\n}");
}
echo json_encode($user_info);
?>
