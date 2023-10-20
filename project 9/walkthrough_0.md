# CONFIGURE AN NGINX LOAD-BALANCER INSTANCE
In the previous project, we have an apache load-balancer, a devops engineer must have multiple approach to path. You can stop 2 the `apache-load balancer` to implement this project.  We will be implementing [nginx](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/) as our load balancer in this project

Spin up an EC2 instance with security group to allow `https`,`http`,`ssh` and outbound rule to traffic to the webservers behind it. It must be in the same VPC.

In the user data, put the below setup to install and start nginx on launch

```sh
sudo apt update -y
sudo apt install nginx -y
```

After the instance spins up, ssh into it, confirm if nginx is up and running

```sh
sudo systemctl enable nginx
sudo systemctl status nginx
```

Firstly we need to update `/etc/hosts` file to add our webservers

```sh
<private-ip-address> Web1
<private-ip-address> Web2
<private-ip-address> Web3
```


Then cd into `/etc/nginx/nginx.conf` in the `html block` update with this block of code

```sh
 upstream devopsproject {
    server Web1 weight=5;
    server Web2 weight=5;
  }

server {
    listen 80;
    server_name www.domain.com;
    location / {
      proxy_pass http://devopsproject;
    }
  }

#comment out this line
#       include /etc/nginx/sites-enabled/*;
```

Then run `sudo systemctl restart nginx`.


