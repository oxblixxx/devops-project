Launch a second RedHat EC2 instance that will have a role – ‘DB Server’
In future projects we will be learning about automations

While launching your `DB-SERVER` scroll down to `advanced details`

locate `user-data` paste the below script there. This data script is to set up a basic LAMP (Linux, Apache, MySQL, PHP) stack and install WordPress :

```sh
#!/bin/bash
#!/bin/bash
sudo apt update -y

# Install Apache, PHP, and required modules
sudo apt install -y wget apache2 php libapache2-mod-php php-mysql php-fpm php-json

# Enable and start Apache
sudo systemctl enable apache2
sudo systemctl start apache2

# Install additional repositories for PHP
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php

# Install PHP and required modules
sudo apt update -y
sudo apt install -y php7.4 php7.4-opcache php7.4-gd php7.4-curl php7.4-mysql

# Start PHP-FPM
sudo systemctl start php7.4-fpm
sudo systemctl enable php7.4-fpm

# Install and configure MySQL server
sudo apt install -y mysql-server

# Start MySQL and enable it to start on boot
sudo systemctl start mysql
sudo systemctl enable mysql

# Secure MySQL installation (set root password and remove anonymous users)
sudo mysql_secure_installation

# Adjust SELinux permissions (Ubuntu doesn't use SELinux, so these commands are not needed)
# setsebool -P httpd_execmem 1

# Restart Apache
sudo systemctl restart apache2

# Install wordpress
sudo mkdir -p wordpress
sudo cd wordpress
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
sudo rm -rf latest.tar.gz
sudo cp wordpress/wp-config-sample.php wordpress/wp-config.php
sudo cp -R wordpress /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod 755 /var/www/html/wordpress

```
Repeat the same steps as for the Web Server, but instead of apps-lv create db-lv and mount it to /db directory instead of
