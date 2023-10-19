### CREATING WEBSERVERS

Spin up 3 webserver instances.

Install NFS CLIENT && MYSQL CLIENT && APACHE2 && INSTALL PHP DEPENDENCIES

```sh
sudo apt update
sudo apt install mysql-client -y
sudo apt install nfs-common -y
sudo apt install apache2 -y
sudo apt-get install php libapache2-mod-php php-mysql -y

```

Edit /etc/fstab with your preferred text editor, and add the below line

```sh
<nfs-server-private-ip-address>:/mnt/apps /var/www nfs defaults 0 0
```


Mount /var/www/ && target the NFS server's export for apps

```sh
sudo mount -t nfs -o rw,nosuid <NFS-Server-Private-IP-Address>:/mnt/apps /var/www
```

To confirm if it was succesfull, run the command and there should an output like this:

```sh
df -h
$ df -h
Filesystem              Size  Used Avail Use% Mounted on
/dev/root               7.6G  1.9G  5.7G  25% /
tmpfs                   475M     0  475M   0% /dev/shm
tmpfs                   190M  868K  190M   1% /run
tmpfs                   5.0M     0  5.0M   0% /run/lock
/dev/xvda15             105M  6.1M   99M   6% /boot/efi
tmpfs                    95M  4.0K   95M   1% /run/user/1000
<private-nfs-server-ip>:/mnt/apps  3.0G   54M  3.0G   2% /var/www
```

To mount the /mnt/logs for apache2. It almost the same procedure, but we need to back up the current files in there firsly.

```sh
mkdir -p ~/backups
sudo rsync -av /var/log/apache2/error.log ~/backups/error.log
sudo rsync -av /var/log/apache2/access.log ~/backups/access.log
sudo mount -t nfs -o rw,nosuid 172.31.21.30:/mnt/logs /var/log/apache2/
```

Check to see if the mount was successfull and recover the prev back up files

```sh
$ df -h
Filesystem              Size  Used Avail Use% Mounted on
/dev/root               7.6G  1.9G  5.7G  25% /
tmpfs                   475M     0  475M   0% /dev/shm
tmpfs                   190M  868K  190M   1% /run
tmpfs                   5.0M     0  5.0M   0% /run/lock
/dev/xvda15             105M  6.1M   99M   6% /boot/efi
tmpfs                    95M  4.0K   95M   1% /run/user/1000
<private-nfs-ip>:/mnt/apps  3.0G   54M  3.0G   2% /var/www
<private-nfs-ip>:/mnt/logs  3.0G   54M  3.0G   2% /var/log/apache2
sudo mv ~/backup/error.log /var/apache2/error.log
sudo mv ~/backup/error.log /var/apache2/access.log
```

Return to the `security-group` of the backup-server and `allow-inbound` rules from this webserver-ip-address on port `3306`

Ssh into NFS server, create a file index.html and index.php. Put any content of your choice in the index.html, but for index.php. Put the below file

```php
<?php
$servername = "db-server-addr";
$username = "db-username";
$password = "db-pass";
$dbname = "db-name";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

echo "Connected successfully";

// Perform a simple query
$sql = "SELECT * FROM your_table";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Output data of each row
    while($row = $result->fetch_assoc()) {
        echo "<br>id: " . $row["id"]. " - Name: " . $row["name"]. " - Email: " . $row["email"];
    }
} else {
    echo "0 results";
}

// Close connection
$conn->close();
?>
```

Then, restart apache with `sudo systemctl restart apache2`, you should be able to view the contents of your web, go ahead to add <public-ip-add>/index.php you should see `connected displayed`. This verifies that your DB can be accessed, try to alter the information in your index.php to a false information, return to the web browser and `/index.php` is not accessible. Return to the correct information and its accessible with the  `connected` shown.

Repeat this process for the remaining 2 servers, just that you will need to mount the `/mnt/apps` alone, the `files` persist for `/var/html`




### ATTACHING A LOAD BALANCER
On the EC2 dashboard, click on load balancer, create an `apllication load balancer`, set it to `internet facing` , choose the `vpc and mappings for the subnet`. Under the `listeners and routing` choose `HTTP for now`, then right click on `create target group`, choose `instances` and choose the three webservers. Return to the previous page, refresh and choose the target group. Create the load balancer