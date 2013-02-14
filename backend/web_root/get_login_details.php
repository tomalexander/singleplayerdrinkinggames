<?php
include "users.php";

$uuid = $_REQUEST["uuid"];

$user_info = get_login($uuid);
if ($user_info == null)
{
    die("{\n    \"error\": \"UUID NOT LOGGED IN\"\n}");
}
echo json_encode($user_info);
?>