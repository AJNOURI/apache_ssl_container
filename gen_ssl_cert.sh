#!/bin/bash

commonname=apachehttps.lab
country=FR
state=IDF
locality=Panam
organization=cciethebeginning.wordpress.com
organizationalunit=IT
email=ajn.bin@gmail.com

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.cert -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
