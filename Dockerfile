# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.16

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Prepare Installation
WORKDIR /tmp

# Update the source list for appropriate repository, trusty 14.04 LTS, in this case.
RUN echo "deb http://fr.archive.ubuntu.com/ubuntu/ trusty main" >> /etc/apt/sources.list
RUN echo "deb-src http://fr.archive.ubuntu.com/ubuntu/ trusty main universe" >> /etc/apt/sources.list
RUN echo "deb http://fr.archive.ubuntu.com/ubuntu/ trusty-security main" >> /etc/apt/sources.list
RUN echo "deb http://fr.archive.ubuntu.com/ubuntu/ trusty-updates main" >> /etc/apt/sources.list
RUN echo "deb-src http://fr.archive.ubuntu.com/ubuntu/ trusty-security main universe" >> /etc/apt/sources.list
RUN echo "deb-src http://fr.archive.ubuntu.com/ubuntu/ trusty-updates main universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y apache2 apache2-doc apache2-utils openssl

RUN mkdir /etc/apache2/ssl

# /etc/apache2/ssl/apache.cert :will not be needed if we use 3rd party CA
# # /etc/apache2/ssl/apache.key is the key to submit to a 3rd-party CA if any

ADD gen_ssl_cert.sh /etc/apache2/ssl/gen_ssl_cert.sh

RUN sh /etc/apache2/ssl/gen_ssl_cert.sh

# enable apache ssl module
RUN a2enmod ssl

# # configure vhost to listen to ssh before reloading apache2

RUN sed -i 's/SSLCertificateFile/\#SSLCertificateFile/g' /etc/apache2/sites-available/default-ssl.conf
RUN sed -i 's/SSLCertificateKeyFile/\#SSLCertificateKeyFile/g' /etc/apache2/sites-available/default-ssl.conf

RUN echo "SSLCertificateFile /etc/apache2/ssl/apache.cert" >> /etc/apache2/sites-available/default-ssl.conf
RUN echo "SSLCertificateKeyFile /etc/apache2/ssl/apache.key" >> /etc/apache2/sites-available/default-ssl.conf

RUN a2ensite default-ssl.conf

CMD service apache2 start &&\
/bin/bash

