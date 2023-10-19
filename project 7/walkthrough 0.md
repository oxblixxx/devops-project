## NFS SERVER
As we are progressing in this project, we will be introuducing some best practices to speed up the development by using `devops tooling` && to avoid loads of ClickOps.  

Spin up an EC2 instance for the [NFS SERVER](https://www.techtarget.com/searchenterprisedesktop/definition/Network-File-System). On the page to spin up an EC2 instance, locate `advance details.` We will be using [user-data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) to set up some pre-commands to execute while the instance is been launched. 

Copy and paste the below to the user-data column.

```sh
# Update package lists
sudo apt update

# Install NFS utilities
sudo apt install nfs-kernel-server -y

# Start and enable NFS server
sudo systemctl start nfs-kernel-server
sudo systemctl enable nfs-kernel-server

# Check the status of NFS server
sudo systemctl status nfs-kernel-server

```

This will take longer than usual, select the instance and click on status check to check if both checks are passed. Create a logical volume like we did in project 5.

1. Ensure there are 3 Logical Volumes. 
- lv-opt:  To be used by webserver logs
- lv-apps: To be used by webservers, and
- lv-logs: To be used by Jenkins server in Project 8

2.  Format the disks as [xfs](https://www.xmodulo.com/create-mount-xfs-file-system-linux.html):

```sh
sudo mkfs.xfs <logical volume name>
```
3. Create mount points on /mnt directory for the logical volumes as follow:

```sh
mkdir /mnt/logs /mnt/apps /mnt/opt
mount lv-logs on /mnt/logs 
mount lv-apps on /mnt/apps 
mount lv-opt on /mnt/opt 
```

Export the mounts for webservers’ subnet cidr to connect as clients. Inside the same subnet, but in production set up you would probably want to separate each tier inside its own subnet for higher level of security. 


Set file permisions for the directories
```sh
sudo chown -R nobody: /mnt/apps
sudo chown -R nobody: /mnt/logs
sudo chown -R nobody: /mnt/opt

sudo chmod -R 750 /mnt/apps
sudo chmod -R 750 /mnt/logs
sudo chmod -R 750 /mnt/opt

sudo systemctl restart nfs-server.service
```

Using your preferred editor configure NFS client to communitcate with the server which of course should be located in the same CIDR range[^1]

```
nano vi /etc/exports

/mnt/apps <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash)
/mnt/logs <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash)
/mnt/opt <Subnet-CIDR>(rw,sync,no_all_squash,no_root_squash)
```

The /etc/exports file is a configuration file used by the NFS (Network File System) server to specify the directories and options that are available for sharing with NFS clients.

NB: It's not best practices to specify `no_all_squah`. You should not specify this option without a good reason.

Run the below command to export the saved file system:

```sh
sudo exportfs -arv

```

The sudo exportfs -arv command is used to export or re-export all directories specified in the /etc/exports file on an NFS (Network File System) 

NFS runs on port `2049`. You can use the rpc command to fetch it as well:

```sh
rpcinfo -p | grep nfs
```
Port 2049 (TCP/UDP): The primary port for NFS. It is used for the NFS service itself and handles file and directory operations.

Port 111 (TCP/UDP): Portmapper or RPCBIND, which is used by NFS to dynamically assign ports for various services.

You need to allow the 4 ports in total, both tcp & udp for `2049` && `111`.


[^1]:https://nfs.sourceforge.net/nfs-howto/ar01s03.html
