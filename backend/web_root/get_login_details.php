<?php
include "users.php";

$uuid = $_REQUEST["uuid"];

$user_info = get_login($uuid);
if ($user_info == null)
{
    die("UUID NOT LOGGED IN");
}
echo json_encode($user_info);
?>