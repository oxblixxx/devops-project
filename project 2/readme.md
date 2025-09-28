# ⚙️ Setting Up a LEMP Stack (Linux, Nginx, MySQL, PHP)

A LEMP stack is a powerful and popular set of open-source software used to build and run dynamic websites and web applications. It's an acronym for Linux, Nginx (pronounced "Engine-X"), MySQL, and PHP.

---

## 🐧 Setting Up the Linux Server

This project uses an Ubuntu virtual machine (VM) on AWS as the base. I have configured the server's security group to allow traffic on key ports: **22 (SSH)** for secure remote access, **80 (HTTP)** for standard web traffic, and **443 (HTTPS)** for secure web traffic. I use a key pair to securely log in and manage the server remotely.

After setting up the VM, run the following commands to ensure the system's package list is up-to-date and all installed software is upgraded to its latest version.

```bash
sudo apt update -y
sudo apt upgrade -y
```

## 🌐 Installing Nginx
Nginx is a high-performance web server that efficiently handles HTTP requests and serves static content. It can also function as a reverse proxy and load balancer.

To install Nginx on the Ubuntu VM, use the following commands:

```sh
sudo apt install nginx -y
sudo systemctl enable nginx
```

After installation, verify that Nginx is running correctly. You can do this from the terminal using the systemctl status command:

```sh
sudo systemctl status nginx
```

A successful installation will show Nginx as active (running). You can also confirm this by accessing the server's public IP address in a web browser (e.g., http://<public_ip_address>). If everything's set up correctly, the default Nginx welcome page will be displayed. You can also test this locally from the server's terminal with curl:

```sh
curl http://localhost
curl http://127.0.0.1
```

## 🗃️ Installing and Securing MySQL
MySQL is a widely used open-source relational database management system (RDBMS) for storing, managing, and retrieving structured data.

Install MySQL Server with this command:

```sh
sudo apt install mysql-server -y
sudo systemctl status mysql
```

After installation, it's crucial to secure the database. Run the security script and follow the prompts. Be sure to remove anonymous users and disallow remote root login.

```sh
sudo mysql_secure_installation
```

After securing the installation, log in to the MySQL console to set the password for the root user.

```sh
sudo mysql
```

Set the root password using this command, replacing 'your-preferred-password' with a strong password. Note the use of backticks and the semicolon.

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your-preferred-password';
```
Exit the MySQL console using the exit command. To confirm the password works, try logging back in with the password prompt.

```sh
sudo mysql -u root -p
```

## 💻 Installing PHP and Required Dependencies
To ensure PHP works seamlessly with your LEMP stack, you need to install the necessary packages. We'll install php-fpm (FastCGI Process Manager) and other essential extensions for database interaction and image handling.

```
sudo apt install php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip -y
```
After installation, check the status of the PHP-FPM service to ensure it's running.

```
sudo systemctl status php-fpm
```

## 🚧 Configuring Nginx for PHP
Now, let's configure Nginx to serve the PHP application. First, create a root directory for the project.

```sh
sudo mkdir -p /var/www/html/lemp
```

Next, assign the correct ownership and permissions to the directory so Nginx can access it. The www-data user is the default Nginx user.

```sh
sudo chown -R www-data:www-data /var/www/html
sudo chown g+s /var/www/html
sudo chmod -R 775 /var/www/html/lemp
```

Now, create a new Nginx configuration file for your site in the /etc/nginx/sites-available/ directory.

```sh
sudo nano /etc/nginx/sites-available/lemp
```

Paste the following configuration into the file. Replace <public-ip-address> with your server's IP and <website-url> with your domain name (if you have one).

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
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

Key Directives Explained:
listen 80;: Nginx will listen for incoming connections on port 80 (HTTP).

server_name;: Defines the domain names and IP addresses for this server block.

root;: Specifies the root directory of your website's files.

index;: Sets the priority for the default file to serve (e.g., index.php will be checked before index.html).

location ~ .php$ { ... }: This block tells Nginx to process files ending in .php using the FastCGI Process Manager (php-fpm).

location ~ /.ht { ... }: This block denies access to any .htaccess files, which is a good security practice.

To enable your new configuration, create a symbolic link from the sites-available directory to the sites-enabled directory.

```sh
sudo ln -s /etc/nginx/sites-available/lemp /etc/nginx/sites-enabled/
sudo rm -rf /etc/nginx/sites-enabled/default
```

Finally, check for any syntax errors and reload Nginx to apply the new configuration.

```sh
sudo nginx -t
sudo systemctl restart nginx
```

🧪 Testing the LEMP Stack
To verify everything is working, create a simple index.html file in the root directory.

```
sudo nano /var/www/html/lemp/index.html
```

Add the following content:

```html
<html>
<p>Hello World</p>
</html>
```

Visit the server's public IP address in a browser. You should see "Hello World" displayed. Now, let's test the PHP part of the stack.

Create an index.php file in the same directory.

```sh
sudo nano /var/www/lemp/index.php
```

Add the following PHP code:

```php
<?php
phpinfo();
?>
```

Access <your-public-ip-address>/index.php in your browser. You should see a detailed page with information about your PHP installation. Remember to remove this file after testing, as it can expose sensitive information about your server.

```sh
sudo rm /var/www/lemp/index.php
```

## 💾 Fetching Data From MySQL Database
To demonstrate the full stack's capability, let's connect PHP to MySQL. First, create a new database and a user with specific privileges.

Log in to the MySQL console:

```sh
sudo mysql -u root -p
```

Create a new database and a user. In this example, we'll name the database testdb and the user oxblixx.

```sh
CREATE DATABASE testdb;
CREATE USER 'oxblixx'@'localhost' IDENTIFIED BY 'password-login';
GRANT ALL PRIVILEGES ON testdb.* TO 'oxblixx'@'localhost';
FLUSH PRIVILEGES;
```

Exit the console and log in as the new user to confirm the credentials work.

```sh
sudo mysql -u oxblixx -p
```

Once logged in, create a todo_list table within the testdb database.

```sh
USE testdb;
CREATE TABLE todo_list (
    item_id INT AUTO_INCREMENT,
    content VARCHAR(255),
    PRIMARY KEY(item_id)
);
```

Schema Breakdown:
item_id: An INT column that automatically increments with each new row, serving as a unique PRIMARY KEY.

content: A VARCHAR(255) column that stores the to-do item's content, with a maximum length of 255 characters.

Now, insert a few sample items into the todo_list table:

```sh
INSERT INTO todo_list (content) VALUES ("Welcome to my World");
INSERT INTO todo_list (content) VALUES ("Documenting my project");
INSERT INTO todo_list (content) VALUES ("Refactoring old code");
```

Verify the entries by querying the table:
```sh
SELECT * FROM todo_list;
```

Finally, create a PHP file to query the database and display the results on a webpage.

```sh
sudo nano /var/www/html/lemp/todo_list.php
```

Paste the following PHP code into the file, replacing the placeholder values with your database credentials.

```sh
<?php
$user = "oxblixx";
$password = "password-login";
$database = "testdb";

try {
    $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
    echo "<h2>TODO List</h2><ol>";
    foreach($db->query("SELECT content FROM todo_list") as $row) {
        echo "<li>" . htmlspecialchars($row['content']) . "</li>";
    }
    echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
?>
```
**NB: IN PRODUCTION CREDENTIALS WONT BE HARDCORDED AS IT IS CURRENTLY.**

Access <your-public-ip-address>/todo_list.php in your browser. If everything is configured correctly, you'll see a list of the to-do items you added to the database.

🎉 Congratulations! a complete LEMP stack and demonstrated communication between Nginx, PHP, and MySQL.
