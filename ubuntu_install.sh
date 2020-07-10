#!/bin/bash

######
# Install LAMP Stack
######

apt update -y
apt install -y apache2 mysql-server php php-mysql libapache2-mod-php php-cli
apt install -y git zip php-bcmath php-ctype php-zip php-fileinfo php-json php-mbstring php-openssl php-pdo php-tokenizer php-xml

systemctl enable apache2
systemctl start apache2

######
# Install Composer
######

EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi
php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
mv composer.phar /usr/bin/composer

######
# Install Laravel
######

composer global require laravel/installer

export PATH="~/.composer/vendor/bin:$PATH" 

laravel new test
