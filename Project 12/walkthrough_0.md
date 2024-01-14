The ansible configuration is in this directory, spin up instances to serve for the jenkins server, webserver, database server and sonarqube server, in further projects we will be automating deployments of the infrastructure with terraform but for now we will be automating the configuration. For the Jenkins server allow `port 8080` and for the sonarqube server allow `port 9000`.

In the ansible-config-management folder, edit the inventory file with the ip-address of the instance spinned up, set the path of the private key path in ansible.cfg also copy the public key to `./ssh/authorized_keys` on your servers. Then ping the instance with:

```sh
ansible -m ping all
```

Proceed to run the configurations against the server, setting up the webserver, database server, sonarqube and jenkins server tasks.

```sh
ansible-playbook  -K root-playbooks/prod.yml
```

After succesful deployment, access the sonarqube server `<public-ip-address>:9000` the default username and password is `admin` respectively. Generate a token by clicking on the avatar of the administrator > My account > Generate token. After set the webhook for the jenkins server, click on administration > configuration > webhooks. Set the webhook just like this `http://<jenkins-server>/sonarqube-webhook/`. Click on save

Login to your jenkins server, navigate to manage jenkins > plugins, install sonar scanner plugins. 


