#!/bin/bash

######
# Install LAMP Stack
######
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update -y
sudo apt install -y apache2 mysql-server php7.4 php7.4-mysql libapache2-mod-php php7.4-cli
sudo apt install -y git zip php7.4-zip php7.4-bcmath php7.4-json php7.4-mbstring php7.4-common php7.4-tokenizer php7.4-xml

sudo systemctl enable apache2
sudo systemctl start apache2

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
sudo mv composer.phar /usr/bin/composer

######
# Install Laravel
######

composer global require laravel/installer

export PATH="~/.config/composer/vendor/bin:$PATH"

laravel new test
