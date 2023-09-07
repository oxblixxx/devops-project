# Setting up a LEMP STACK(Linux, Nginx, PHP, MySql)

# Spin up a Linux server

## Spin up a Linux distro of your choice, I spinned up an Ubuntu distro. Allow inbound rules of port 80 and port 22 for ssh.
# Install nginx

## Ssh into the instance and update the linux distro and run the command to install Nginx on your server. 

``sh
sudo apt update -y
sudo apt upgrade -y
sudo apt install nginx -y
``

## thereafter confirm to see that Nginx is install on your server accessing it with <publicipaddres>:80. You can also run this commands below on your terminal:

```sh
curl http://localhost:80
curl http://127.0.0.1:80
```

# Install MySql

MySQL is an open-source relational database management system (RDBMS) that is widely used for storing, managing, and retrieving structured data. To install MySql run :

``
sudo apt install mysql-server -y
``

The database needs to be secured by running a script. Follow the prompt to set the password security.
NB: This is the administrator of the database and the password should be secured. Run

```
sudo mysql_secure_installation
```

Login into the console with:

``
sudo mysql
``

Then set the password for the root user. Be mindful of the semi-colon and the inverted comma wrapping the password.

``
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'put-in-your-preffered-password';
``

exit the mysql with the exit command.

login back to MySql console with sudo Mysql -p then put in

# Install php

Install PHP packages :

```
sudo apt install php-fpm php-mysql -y
```

# CONFIGURING NGINX 

Cd into /var/www then create a directory in it. Assign ownership of the current system user as the owner of the directory 

```
sudo mkdir /lemp
sudo chown $USER:$USER /var/www/lemp
```

Create a configuration file in Nginx's sites-available directory. Paste in the bare-bone configuration:

```
cd /etc/nginx/sites-available
sudo nano /lemp
```

```
server {
    listen 80;
    server_name <public-ip-address> <website-url>;
    root /var/www/lemp;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

}
```
NB:
- The first block of location instrycts nginx to return a 404 error after trying to check directives for the file but cant be found, the second block indicates the php dependencies installed while the third block denies it to display any file with .htaccess to the user on the site, incase of a misconfiguration.

- listen - defines the protocol to listen on, incase of ssl 443 will be used instead.

- root - specifies the directory of the web file

- index index.html - specifies the file according to there priority.

The next step to do is to enable the config file to the ../sites-enabled directory. Run the command:
NB : That's l as in L for Lion
```
sudo ln -s /etc/nginx/sites-available/projectLEMP /etc/nginx/sites-enabled/
```

NB: This command is different for enabling sites-available for the Apache server, A2ensite command will be used instead.

Run the below commands to check for errors in the configuration file, to unlink the default nginx file and to reload nginx. You should get a ok message on success.

```
sudo nginx -t
sudo unlink /etc/nginx/sites-available/default
sudo systemctl restart nginx
```
cd into /var/www/lemp to input a test page for nginx default page, create an index.html file and edit with an example code below

```
<html>
<p>Hello World</p>
</html>
```

Go to your web browser, view with your public ip address irrespective of the port number.

To confirm if php is corresponding. Create an index.php file in the pwd /var/www/lemp with the below code:

```
<?php
phpinfo();
```

Access the page with <your-public-ipaddress>/index.php

ensure to remove the file as it contains important info about your server
```
sudo rm /var/www/lemp/index.php
```

# RETRIEVE DATA FROM MYSQL DB
Here we are creating a DB with access to Nginx to query from the DB and display it.

Create a database and a user assigned to the database. Login to the MYSQL create a DB and confirm the created DB.

```
mysql > CREATE DATABASE testdb;
mysql > SHOW DATABASES;
```

Create a new user and grant priviledges on the database, this gives the user full priviledges on the newly created db.

```
mysql > CREATE USER 'oxblixx'@'%' IDENTIFIED WITH mysql_native_password BY 'password-login';
mysql > GRANT ALL ON testdb.* TO 'oxblixx'@'%';
```

Exit the MYSQL console and try to login the new user to confirm the credentials.

```
mysql > sudo mysql -u oxblixx -p
```

-u flag - indicates the username.
-p flag - password to prompted.

Create a table named todo_list. Run the below commands to create a table, then insert rows into the table

```
mysql> CREATE TABLE testdb.todo_list (
   --> item_id INT AUTO_INCREMENT,
   --> content VARCHAR(255),
   --> PRIMARY KEY(item_id)
   --> );
```


PRIMARY KEY - is a unique key identifier for each rows
contnt VARCHAR(255) - second column, the VARCHAR specifies the characteristics attribute and to accept contents up to 255
item_id - name of the first column
INT - the datatype is an INTERGER
AUTO_INCREMENT - automatic increment in the columns to generate key identifiers.

Then insert a few context into the testdb, alter the commands to give different entries, then confirm the entries, this should display the entries:

```
mysql> INSERT INTO testdb.todo_list (content) VALUES ("Welcome to my World");
mysql> SELECT * FROM testdb.todo_list;
```

To query the db, cd into /var/www/lemp. Create a file todo_list.php, insert the below code, replace the variables with the correct details:

```
<?php
$user = "example_user";
$password = "password";
$database = "example_database";
$table = "todo_list";

try {
  $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
  echo "<h2>TODO</h2><ol>";
  foreach($db->query("SELECT content FROM $table") as $row) {
    echo "<li>" . $row['content'] . "</li>";
  }
  echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
```

Access the queried db with your <public-ip-address/todo_list.php>

![]()


Congratulations! That means the php environment is ready to connect and interact the with MYSQL server.



