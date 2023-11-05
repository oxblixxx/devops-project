# Refactoring

Create a new issue for refactoring on the ansible repo, create a branch for the issue. Create a new directory `nested-playbooks`, move common.yml, for a descriptive name, it's renamed as install.yml. Move the code in `site.yml` to `prod.yml`. The prod.yml is our master playbook so we will import other playbooks there. Delete the site.yml file. In prod.yml update the code there:

```yml
---

- hosts: all

- import_playbook: ../nested-playbooks/install.yml
```

You should have this folder structure

```
├── base-playbooks
    └── dev.yml
    └── uat.yml
    └── prod.yml
├── nested-playbooks
│   └── install.yml
├── inventory
└── ansibible.cfg
```



In the above code the [import](https://docs.ansible.com/ansible/2.9/user_guide/playbooks_reuse_includes.html) is used,

Test the playbook against the new configuration. Create a new file `install-del.yml`, update it with the below code:

```yml 
---
- name: update web, nfs and db servers
  hosts: webservers, db
  become: yes
  become_user: root
  tasks:
  - name: delete wireshark
    apt:
      name: wireshark
      state: absent
```

Update the prod.yml file to `install-del`

```yml
- hosts: all

- import_playbook: ../base-playbooks/install-del.yml
```

Run this command:

```sh
ansible-playbook playbooks/prod.yml
```


# Implementing Roles
Create a role webserver, it can be created manually and automatically. Create a directory roles run:

```sh
mkdir roles && cd roles
ansible-galaxy init webserver
```

Delete tests, files and vars as they are not in use for now. You have this structure

```
└── webserver
    ├── README.md
    ├── defaults
    │   └── main.yml
    ├── handlers
    │   └── main.yml
    ├── meta
    │   └── main.yml
    ├── tasks
    │   └── main.yml
    └── templates
```