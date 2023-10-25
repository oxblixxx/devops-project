## SETTING UP GIT AND JENKINS ARTIFACTS BUILD

In this project we will be using the previously spinned `Jenkins-server`. Edit the name to `Jenkins-Ansible-server` to be able to signify it.

Create a [repo](https://github.com/oxblixxx/ansible-config-mgt) for the ansible configurations, set up webhooks like you did in the previous project. Create and configure a freestyle project in Jenkins dashboard for `ansible` and set a post-build to create arifacts alone and to copy all files `**`.

Clone the repo to your preferred IDE, on the terminal install ansible:

`sudo apt install ansible -y`

Mind you in this project we will be exploring more of git by creating branches, merging pull request and the likes because we will update our playbook continuosly to automate things.

In a working environment, there will be a several developers on a project. Create a new issue with a perfect description for ease, create a branch for that issue. Checkout to the branch on your IDE.


ssh, install ansible.

create a freestyle project on jenkins  `ansible-config-mgmt`

in the configuration, set it post-build to build artifacts `**`

generate a ssh-key for ansible

create a user, edit `/etc/ssh/sshd_config` passwordauthentication=yes

copy the ssh key


clone project to vs code, connect vscode to your instance, we will be testing the code from vscode.




