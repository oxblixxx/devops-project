# Setting up a LEMP STACK(Linux, Nginx, PHP, MySql)
A LEMP stack is used build and run dynamic websites and web applications. The acronym LEMP comprises of Linux, Nginx, Mysql and PHP. 

# Setting up a Linux Server.
For this project, an ubuntu virtual machine (VM) is spinned up on AWS to serve as the foundation for our application. To ensure secure and efficient access, configured the server's security group settings to allow traffic on key ports 22, 80 and 443. A key pair is generated and private key is used to securely log in and manage the server remotely. A set of initial commands is executed to prepare the environment for the project.

```sh
sudo apt update -y
sudo apt upgrade -y
```

# Setting up Nginx
Nginx is a high-performance web server that handles HTTP requests and serves static content. It can also act as a reverse proxy and load balancer. To install Nginx on the VM, execute the below commands.

```sh
sudo apt install nginx -y
sudo systemctl enable nginx
```

After completing the installation and configuration of Nginx, the next step is to verify that it is running correctly on your server. From the terminal, this can be verified by executing the below command:

```sh
sudo systemctl status nginx
```

The result should prompt that Nginx is running. Also Nginx installation can be confirmed using the curl command. To do this, you can access Nginx by entering the server's public IP address followed by port 80 in a web browser (e.g., http://<public_ip_address>:80). If Nginx is set up properly, the  default Nginx welcome page should be displated.

```sh
curl http://localhost:80
curl http://127.0.0.1:80
```

# Setting up MySql
MySQL is an open-source relational database management system (RDBMS) that is widely used for storing, managing, and retrieving structured data. Execute the below command to install MySQL and to verify it's installation

```sh
sudo apt install mysql-server -y
sudo systemctl status mysql
```

While MySQL is a powerful and reliable database management system, it is crucial to implement security measures to protect your data from unauthorized access and potential threats. Run the security script and follow the prompts, also ensure to remove **ANONYMOUS USERS**.

```sh
sudo mysql_secure_installation
```

Proceed to login into the console, then set the password for the root user. Be mindful of the semi-colon and the inverted comma wrapping the password.

```sh
sudo mysql
```

Then set the password for the root user. Be mindful of the semi-colon and the inverted comma wrapping the password.

```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'put-in-your-preffered-password';
```

Exit the mysql with the `exit` command. Login back to MySql console with `sudo Mysql -u root -p` then put in password.

# Setting up php
To set up the environment for PHP and ensure it works seamlessly with the LEMP stack (Linux, Nginx, MySQL, PHP), you need to install the necessary PHP dependencies. These dependencies include the PHP core, extensions, and modules required to run PHP scripts, interact with the web server (Nginx), and communicate with the database (MySQL).

```sh
sudo apt install php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip -y
```

# Nginx Configuration 

Create a file directory for the app in `/var/www`. Assign ownership of the current system user as the owner of the directory.

```sh
cd /var/www/
sudo mkdir -p lemp
sudo chown $USER:$USER -R /var/www/lemp
```

Create a configuration file in Nginx's sites-available directory. Paste in the below bare-bone configuration:

```sh
cd /etc/nginx/sites-available
sudo nano lemp
```

Here is the configurati
```sh
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
- The first block of location instructs Nginx to return a 404 error after trying to check directives for the file but cant be found, the second block indicates the php dependencies installed while the third block denies it to display any file with .htaccess to the user on the site, incase of a misconfiguration.

- listen - defines the protocol to listen on, incase of ssl 443 will be used instead.

- root - specifies the directory of the web file

- index index.html - specifies the file according to there priority.

The next step to do is to enable the config file to the ../sites-enabled directory. Run the command:
NB : That's l as in L for Lion

```sh
sudo ln -s /etc/nginx/sites-available/lemp /etc/nginx/sites-enabled/
```

NB: This command is similar for enabling sites for the Apache server, A2ensite command will be used instead.

Run the below commands to check for errors in the configuration file, to unlink the default nginx file and to reload nginx. You should get a ok message on success.

```sh
sudo nginx -t
sudo unlink /etc/nginx/sites-available/default
sudo systemctl restart nginx
```

In the `/var/www/lemp` directory, create a test index.html file, with a simple code below.

```html
<html>
<p>Hello World</p>
</html>
```

Visit the public ip address on your web browser, the content in the html file should be shown. To confirm if php is corresponding, create an `index.php` file in the `/var/www/lemp` with the below code:

```php
<?php
phpinfo();
```

Access the page with <your-public-ipaddress>/index.php. Ensure to remove the file as it contains important info about your server.

```sh
sudo rm /var/www/lemp/index.php
```

# FETCH DATA FROM MYSQL DB
Here we are creating a DB with access to Nginx to query from the DB and display it. Create a database and a user assigned to the database. Login to the MYSQL create a DB and confirm the created DB.

```sh
mysql > CREATE DATABASE testdb;
mysql > SHOW DATABASES;
```

Then create a new user and grant priviledges on the database to the user, this gives the user full priviledges on the newly created db.

```sh
mysql > CREATE USER 'oxblixx'@'%' IDENTIFIED WITH mysql_native_password BY 'password-login';
mysql > GRANT ALL ON testdb.* TO 'oxblixx'@'%';
```

Exit the MYSQL console and try to login the new user to confirm the credentials.

```sh
mysql > sudo mysql -u oxblixx -p
```

-u flag - indicates the username.
-p flag - password to prompted.

Create a table named todo_list. Run the below commands to create a table, then insert rows into the table

```sh
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

![project 2/project 2/to_do.jpg](fff)


Congratulations! That means the php environment is ready to connect and interact the with MYSQL server.



