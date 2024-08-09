This project illustrates the implementation of NFS server for centralized storage across webservers, configuring MySQL for database management, deploying multiple web servers with Apache and PHP,and integrating load balancing to distribute traffic evenly across the web servers. This setup ensures high availability, fault tolerance, and seamless operation, catering to the needs of a dynamic and high-demand DevOps environment. Also, in the project consists of following components:
 
1. CSP: AWS
2. Webserver Linux: Ubuntu
3. Database Server: Ubuntu 20.04 + MySQL
4. Programming Language: PHP
5. Code Repository: GitHub

This project is further improved configuring Jenkins to automatically deploy source code changes from Git to the NFS server and copy successful builds over SSH to the NFS server.

[Jenkins-Artifact-Copy-To-Nfs](https://github.com/oxblixxx/devops-project/tree/main/project%208)
# REFS 
[HOW TO SET UP A NFS](https://tldp.org/HOWTO/NFS-HOWTO/server.html)

![LB-SERVER-MYSQL-NFS](./images/NFS-LB-MYSQL-WEBSERVER.png)
