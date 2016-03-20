<?php
header('Content-Type: text/plain');
echo "Server IP: ".$_SERVER['SERVER_ADDR'];
echo "\nClient IP: ".$_SERVER['REMOTE_ADDR'];
echo "\nIP used by client = ".$_SERVER['HTTP_HOST'];
echo "\nX-Forwarded-for: ".$_SERVER['HTTP_X_FORWARDED_FOR'];
echo "\nDNS name used by client = ".$_SERVER['SERVER_NAME'];
?>
