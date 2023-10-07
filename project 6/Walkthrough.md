## WEB-SERVER ARCHITECTURE
A web server architecture refers to the structure and organization of components that work together to deliver web content to users.  The client is the user's device, such as a web browser or a mobile application sends request to the web server. The web server is responsible for handling incoming requests from clients and returning the appropriate responses.

- mysql-client: The MySQL client is a software tool that allows users to interact with the MySQL server. The client communicates with the MySQL server to perform operations like querying the database, updating records, and managing database structures.
- mysql-server: The MySQL server is the core component that manages the database itself. The server listens for client requests and responds by executing SQL queries, 

## IMPLEMENTING A WEB-SERVER ARCHITECTURE MYSQL

Login into your AWS console, spin 2 instances one to represent the `server` the other for the `client`.
Install MYSQL-SERVER on the server.
```
sudo apt update -y && sudo apt upgrade -y
sudo apt install mysql-server -y
```
 Install MYSQL-CLIENT on the client
```
sudo apt update -y && sudo apt upgrade -y
sudo apt install mysql-client -y
```

On AWS console, allow inbound rules on your `MYSQL-SERVER` on port `3306` which is default for MYSQL-SERVER for your <public-ipadddress> of MYSQL-CLIENT.

On your server instance:

- Login with `sudo mysql` and set password for sudo with `ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'put-in-your-preffered-password';`
- Run `sudo mysql_secure_installation` to secure your server DB.
- Create a database `CREATE DATABASE testdb`,
- Create a user `CREATE USER 'oxblixx'@'%' IDENTIFIED WITH mysql_native_password BY 'password-login';` and grant priviledges `GRANT ALL ON testdb.* TO 'oxblixx'@'%';`
- Configure MYSQL-SERVER to allow connections from remote hosts `sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf` edit both addresses from `127.0.0.1 to 0.0.0.0`

On your Client Instance:
Enter the below command:
```
mysql -h <hostname> -u <username> -p
```

<hostname> = MYSQL-SERVER Public-ipv4 address
<username> = username set
password will be requested on prompt.

then run `SHOW DATABASES;` You should see the created `testdb`. 

CONGRATULATIONS!!!
