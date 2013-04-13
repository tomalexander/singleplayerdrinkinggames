<?php
/*
 * Logs the user out of the website.
 */
setcookie("login_uuid","", time()-3600);
header("Location: https://singleplayerdrinkinggames.com/");
die();
?>
