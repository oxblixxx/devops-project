## COPY ARTIFACTS TO NFS SERVER
SSH into your NFS server, create a ssh key:

```sh
ssh-keygen 
```

cd into .ssh directory, there are various ways to install public key for remote login using the `ssh-copy-id` command. But we will be using the a different approach. Enter the command `ls` to see there is a file `authorized_keys`. Copy the public key `id_rsa.pub` to the `authorized_keys` folder.

```sh
cat id_rsa.pub >> ~/.ssh/authorized_keys
```

Return to Jenkins main dashboard, install `publish over ssh` on Jenkins server, navigate to manage jenkins>plugins>available plugins, then install `publish over ssh`

Return to Jenkins dashboard, navigate to manage jenkins>system. Scroll down locate `public over ssh`

![public over ssh](https://drive.google.com/file/d/1Iy7_JXEUD_9pFgmr_dq6tbotOUC09YdC/view?usp=share_link)



in 