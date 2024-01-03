### SPIN UP JENKINS SERVER

In this project we are going to start automating part of our routine tasks with a free and open source automation server – [Jenkins](https://www.jenkins.io/download/). It is one of the mostl popular CI/CD tools,

Spin up an EC2 Instance, create a security group allowing `port 80` && `port 8080`. [Jenkins](https://www.jenkins.io/doc/book/installing/linux/) listens on port 8080.

As we progress we are looking into the automation of things, we will be passing the script to install Jenkins in the `user-data`

```sh
sudo apt update -y
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install jenkins -y
```

Click launch instance. While the instance spins up, we will be updating the creating a github repo for the files on the `NFS SERVER`. 

Copy the jenkins public-ip-address, on your browser, paste the <public-ip-address>:8080, this should take you to the jenkins page, copy the password to authenticate.

```sh
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

choose to install selected plugins, NB: When installation fails, click the retry. Then create first admin user! Then save and finish.

NB: If Jenkins freezes, refresh the page and retry the action.




