######
# Install LAMP Stack
######

yum update -y
amazon-linux-extras install -y lamp-mariadb10.4-php7.4 php7.4

yum install -y httpd mariadb-server
yum install -y php-bcmath php-ctype php-fileinfo php-json php-mbstring php-openssl php-pdo php-tokenizer php-xml

systemctl start httpd
systemctl enable httpd

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
exit $RESULT

$HOME/.config/composer/vendor/bin

######
# Install Laravel
######

composer global require laravel/installer
