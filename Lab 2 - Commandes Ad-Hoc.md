
Lab 2 – Ad-hoc Commands
==
# Introduction

Il existe plusieurs tâches dans Ansible pour lesquelles vous n'avez pas
besoin d'écrire un Playbook Ansible; vous pouvez simplement
exécuter une commande ad-hoc pour cette tâche. Il s'agit d'une
commande à une seule ligne pour effectuer une seule tâche sur l'hôte
cible. Ces commandes sont présentes dans /usr/bin/ansible

# Ad-hoc setup

## Créons un espace de travail pour nos commandes ad-hoc.
Veuillez noter que certaines des choses que nous allons créer seront abordées plus tard dans ce cours.

## Créons maintenant une configuration et un fichier d'inventaire pour ansible

Copiez et collez ce qui suit pour créer un fichier *Ansible Config*. Vous pouvez également le créer vous-même dans un éditeur de fichiers tel que vim.
```
cat > ansible.cfg <<EOF
[defaults]
inventory = hosts
host_key_checking = False
callback_whitelist = timer
forks = 5
gathering = explicit
[ssh_connection]
pipelining = True
ssh_args = -C -o ControlMaster=auto -o ControlPersist=60s -o
EOF
```
Copiez et collez ce qui suit pour créer un fichier d'inventaire.
```
cat > hosts <<EOF

[web_dev]
centos01 ansible_host=10.0.0.21

[web_prod]
centos02 ansible_host=10.0.0.22

[db_dev]
ubuntu01 ansible_host=10.0.0.31

[db_prod]
ubuntu02 ansible_host=10.0.0.32

[webservers:children]
web_dev
web_prod

[dbservers:children]
db_dev
db_prod

[development:children]
web_dev
db_dev

[production:children]
web_prod
db_prod

[all:vars]
ansible_user=vagrant

EOF
```
## Commandes Ad-hoc

### Commandes de base

La commande ad-hoc ci-dessous exécute un module **ping** sur toutes les
hôtes du fichier inventaire. Ici **-m** est l'option pour un module.
```
ansible all -m ping
```
**Example of output:**
```
10.0.0.31 | SUCCESS => {
  "ansible_facts": {
    "discovered_interpreter_python": "/usr/bin/python3"
  },
  "changed": false,
  "ping": "pong"
}

10.0.0.21 | SUCCESS => {
  "ansible_facts": {
    "discovered_interpreter_python": "/usr/bin/python"
  },
  "changed": false,
  "ping": "pong"
}
```
La commande mentionnée ci-dessous exécute le module `setup` (Gather facts)
sur un groupe d'hôtes, l’option **-a** ou **--args** sert à définir les arguments
du module exécuté.
```
ansible all -m setup -a "filter=ansible_distribution*"
```
**Exemple d’output:**
```
10.0.0.21 | SUCCESS =>; {
  "ansible_facts": {
    "ansible_distribution": "CentOS",
    "ansible_distribution_file_parsed": true,
    "ansible_distribution_file_path": "/etc/redhat-release",
    "ansible_distribution_file_variety": "RedHat",
    "ansible_distribution_major_version": "7",
    "ansible_distribution_release": "Core",
    "ansible_distribution_version": "7.8",
    "discovered_interpreter_python": "/usr/bin/python"
  },
  "changed": false
}

10.0.0.31 | SUCCESS => {
  "ansible_facts": {
    "ansible_distribution": "Ubuntu",
    "ansible_distribution_file_parsed": true,
    "ansible_distribution_file_path": "/etc/os-release",
    "ansible_distribution_file_variety": "Debian",
    "ansible_distribution_major_version": "16",
    "ansible_distribution_release": "xenial",
    "ansible_distribution_version": "16.04",
    "discovered_interpreter_python": "/usr/bin/python3"
  },
  "changed": false
}
```
**Autres exemples pour la commande de configuration “setup”**
```
# Display facts from all hosts and store them indexed by hostname at /tmp/facts.

ansible all -m setup --tree /tmp/facts

# Display only facts regarding memory found by ansible on all hosts and
output them.

ansible all -m setup -a 'filter=ansible_*_mb'

# Display only facts returned by facter.

ansible all -m setup -a 'filter=facter_*'

# Display only facts about certain interfaces.

ansible all -m setup -a 'filter=ansible_eth[0-2]'

# Restrict additional gathered facts to network and virtual.

ansible all -m setup -a 'gather_subset=network,virtual'

# Do not call puppet facter or ohai even if present.

ansible all -m setup -a 'gather_subset=!facter,!ohai'

# Only collect the minimum amount of facts:

ansible all -m setup -a 'gather_subset=!all'

# Display facts from Windows hosts with custom facts stored in
C:\\custom_facts.

ansible windows -m setup -a "fact_path='c:\\custom_facts'"
```
### Authentification par mot de passe

Nous allons maintenant exécuter une commande Ad-Hoc en utilisant
l'authentification par mot de passe ssh. (CentOS/RHEL, vous devez
installer le paquet supplémentaire appelé 'sshpass' sur les nœuds).

Les nœuds **ubuntu** contiennent déjà un utilisateur ubuntu, on va lui
activer la connexion par mot de passe tout d’abord. (suivez ce guide en
cas de besoin:
**[*https://help.thorntech.com/docs/sftp-gateway-classic/enable-password-login/*](https://help.thorntech.com/docs/sftp-gateway-classic/enable-password-login/)**)
```
ansible dbservers -m ping -u ubuntu --ask-pass
```
**Exemple d’output:**
```
ubuntu01 | SUCCESS => {
  "ansible_facts": {
    "discovered_interpreter_python": "/usr/bin/python3"
  },
  "changed": false,
  "ping": "pong"
}
```
### Module shell

La commande ci-dessous vous permet d'exécuter des commandes ad-hoc en
tant qu'utilisateur non root avec des privilèges root.
L'option **--become** donne les privilèges root et l'option **-K** demande le mot
de passe.
```
ansible dbservers -m shell -a 'fdisk -l' -u ubuntu --become -k
```
**Exemple d’Output:**
```
ubuntu01 | CHANGED | rc=0 >>
Disk /dev/sdb: 10 MiB, 10485760 bytes, 20480 sectors
Units: sectors of 1 \* 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk /dev/sda: 10 GiB, 10737418240 bytes, 20971520 sectors
Units: sectors of 1 \* 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x291a2629
Device Boot Start End Sectors Size Id Type
/dev/sda1 \* 2048 20971486 20969439 10G 83 Linux
```
### Redémarrer le système

Cette commande ad-hoc est utilisée pour redémarrer le système avec
l'option **-f** pour définir le nombre de forks (exécutions concurrentes).
```
ansible all -a "/sbin/reboot" -f 1
```
**Exemple d’Output:**
```
ubuntu01 | CHANGED | rc=0 >>
Disk /dev/sdb: 10 MiB, 10485760 bytes, 20480 sectors
Units: sectors of 1 \* 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk /dev/sda: 10 GiB, 10737418240 bytes, 20971520 sectors
Units: sectors of 1 \* 512 = 5
```
### Transfert de fichiers

La commande ad-hoc ansible ci-dessous est utilisée pour copier un
fichier d'une source vers une destination pour un groupe d'hôtes défini
dans le fichier d'inventaire. Si la sortie avec le paramètre «changed»
est «true», le fichier a été copié vers la destination.
```
ansible all -m copy -a 'src=file1.txt dest=/home/vagrant/Desktop/ owner=root mode=0644' --become
```
Exécutez la commande ci-dessous pour vérifier si le module `copy` a
fonctionné correctement ou non. Le fichier copié doit arriver à la
destination mentionnée dans la commande précédente.
```
ls -l /home/vagrant/Desktop
```
### le module fetch

La commande ad-hoc ci-dessous est utilisée pour télécharger un
fichier à partir d'une hôte définie dans la commande (l’inverse de copy).
```
ansible ubuntu01 -m fetch -a "src=/home/vagrant/ubuntu01.txt dest=/tmp/ flat=yes"
```
**Exemple d’Output:**
```
ubuntu01 | CHANGED > {
"changed": true,
"checksum": "d25c92b5a19de37a9f01205ede54b0b8d60e7cf2",
"dest": "/tmp/ubuntu01.txt",
"md5sum": "e01c22cf59ec1148308e76866c68d125",
"remote_checksum": "d25c92b5a19de37a9f01205ede54b0b8d60e7cf2",
"remote_md5sum": null
}
```
Vérifiez si le fichier a été téléchargé ou non à la destination
mentionnée dans la commande.
```
 ls /tmp
```

---
[Next Lab ->](./Lab%203%20-%20playbooks.md)
