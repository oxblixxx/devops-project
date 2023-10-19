# SETUP MYSQL SERVER
Spin up an instance for DB.
Install MYSQL-SERVER on the server.

```sh
sudo apt update -y && sudo apt upgrade -y
sudo apt install mysql-server -y
```

On your db-server instance:

- Login with `sudo mysql` and set password for sudo with 

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'put-in-your-preffered-password';

```   


- To sequre mysql db, run:

```sh
sudo mysql_secure_installation

```

- Create a database 

```sql
`CREATE DATABASE testdb`,
```

- Create a user,

```sql
 CREATE USER 'oxblixx'@'%' IDENTIFIED WITH mysql_native_password BY 'password-login';`
```
and grant priviledges 

```sql
`GRANT ALL ON testdb.* TO 'oxblixx'@'%';`

```
- Configure MYSQL-SERVER to allow connections from remote hosts, edit.

```sh
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

edit both addresses from `127.0.0.1 to <web-server public address>

Restart mysql server with:

```sh
sudo systemctl restart mysql
```









