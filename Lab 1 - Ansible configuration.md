Lab : Configuration de Ansible
=====

## Étape 1 - Création d'un fichier d'inventaire personnalisé
Lors de l'installation, Ansible crée un fichier d'inventaire qui se trouve
généralement dans /etc/ansible/hosts. Il s'agit de l'emplacement par défaut
utilisé par Ansible lorsqu'un fichier d'inventaire personnalisé n'est pas fourni
avec l'option **-i**, lors d'un playbook ou de l'exécution d'une commande.

Même si vous pouvez utiliser ce fichier sans problème, l'utilisation de fichiers
d'inventaire par projet est une bonne pratique pour éviter de mélanger les
serveurs lors de l'exécution de commandes et de playbooks.
Le fait de disposer de fichiers d'inventaire par projet facilitera également le
partage de la configuration de l'approvisionnement avec les collaborateurs, étant
donné que vous incluez le fichier d'inventaire dans le référentiel de code du projet.

Pour commencer, accédez à votre dossier de départ et créez un nouveau fichier
d'inventaire à l'aide de l'éditeur de texte de votre choix.
```
vi hosts
```

Une liste de vos nœuds, avec un serveur par ligne, suffit pour mettre en place un fichier d'inventaire fonctionnel. Les noms d'hôte et les adresses IP sont interchangeables:
```
cat hosts
10.0.0.21
10.0.0.22
10.0.0.31
10.0.0.32
```
Une fois que vous avez configuré un fichier d'inventaire, vous pouvez utiliser
la commande `ansible-inventory` pour valider et obtenir des informations sur votre
inventaire Ansible:
```
ansible-inventory -i inventory --list
```
```
Output
{
    "_meta": {
        "hostvars": {}
    },
    "all": {
        "children": [
            "ungrouped"
        ]
    },
    "ungrouped": {
        "hosts": [
            "10.0.0.21",
            "10.0.0.22",
            "10.0.0.31",
            "10.0.0.32"
        ]
    }
}
```
Même si nous n'avons configuré aucun groupe dans notre inventaire, la sortie
montre 2 groupes distincts qui sont automatiquement déduits par Ansible: `all`
et `ungrouped`.
Comme son nom l'indique, `all` est utilisé pour désigner tous les serveurs de
votre fichier d'inventaire, quelle que soit leur organisation. Le groupe `ungrouped`
est utilisé pour faire référence aux serveurs qui ne sont pas répertoriés dans un groupe.

### Exécution de commandes et de playbooks avec des inventaires personnalisés
Pour exécuter des commandes Ansible avec un fichier d'inventaire personnalisé,
utilisez l'option **-i** comme suit:
```
ansible all -i hosts -m ping
```
Cela exécuterait le module ping sur toutes les hôtes répertoriées dans votre
fichier d'inventaire personnalisé.

De même, voici comment exécuter des playbooks Ansible avec un fichier
d'inventaire personnalisé:
```
ansible-playbook -i hosts playbook.yml
```

## Étape 2 - Organisation des serveurs en groupes et sous-groupes
Dans le fichier d'inventaire, vous pouvez organiser vos serveurs en différents
groupes et sous-groupes. En plus d'aider à garder vos hôtes en ordre, cette pratique
vous permettra d'utiliser des variables de groupe, une fonctionnalité qui peut
grandement faciliter la gestion de plusieurs environnements de préparation avec Ansible.

Un hôte peut faire partie de plusieurs groupes. Le fichier d'inventaire suivant
au format INI montre une configuration avec quatre groupes:
**webservers**, **dbservers**, **development** et **production**.
Vous remarquerez que les serveurs sont regroupés selon deux qualités différentes:
leur finalité (web et base de données) et leur utilisation (développement et production).
```
cat hosts
```
```
[webservers]
10.0.0.21
10.0.0.22

[dbservers]
10.0.0.31
10.0.0.32

[development]
10.0.0.21
10.0.0.31

[production]
10.0.0.22
10.0.0.32
```
Si vous exécutez à nouveau la commande `ansible-inventory` avec ce fichier d'inventaire,
vous verrez la disposition suivante:
```
Output
{
    "_meta": {
        "hostvars": {}
    },
    "all": {
        "children": [
            "dbservers",
            "development",
            "production",
            "ungrouped",
            "webservers"
        ]
    },
    "dbservers": {
        "hosts": [
            "10.0.0.31",
            "10.0.0.32"
        ]
    },
    "development": {
        "hosts": [
            "10.0.0.21",
            "10.0.0.31"
        ]
    },
    "production": {
        "hosts": [
            "10.0.0.22",
            "10.0.0.32"
        ]
    },
    "webservers": {
        "hosts": [
            "10.0.0.21",
            "10.0.0.22"
        ]
    }
}
```
Il est également possible d'agréger plusieurs groupes en tant qu'enfants sous un
groupe «parent». Le «parent» est alors appelé un **métagroupe**.
L'exemple suivant montre une autre façon d'organiser l'inventaire précédent à
l'aide de métagroupes pour obtenir une disposition comparable, mais plus granulaire:
```
cat hosts
```
```
[web_dev]
10.0.0.21

[web_prod]
10.0.0.22

[db_dev]
10.0.0.31

[db_prod]
10.0.0.32

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
```
Plus vous avez de serveurs, plus il est judicieux de séparer les groupes ou de
créer des arrangements alternatifs afin de pouvoir cibler de plus petits groupes
de serveurs selon vos besoins.

## Étape 3 - Configuration des alias d'hôte
Vous pouvez utiliser des alias pour nommer les serveurs de manière à faciliter
le référencement de ces serveurs ultérieurement, lors de l'exécution de commandes
et de playbooks.

Pour utiliser un alias, incluez une variable nommée `ansible_host` après le nom de
l'alias, contenant l'adresse IP ou le nom d'hôte correspondant du serveur qui doit
répondre à cet alias:

```
cat hosts
```
```shell
# ... contenu éliminé
server1 ansible_host=10.0.0.21
server2 ansible_host=10.0.0.22
server3 ansible_host=10.0.0.31
server4 ansible_host=10.0.0.32
# ... contenu éliminé
```
Si vous exécutiez la commande `ansible-inventory` avec ce fichier d'inventaire,
vous verriez une sortie similaire à celle-ci:
```
Output
{
    "_meta": {
        "hostvars": {
            "server1": {
                "ansible_host": "10.0.0.21"
            },
            "server2": {
                "ansible_host": "10.0.0.22"
            },
            "server3": {
                "ansible_host": "10.0.0.31"
            },
            "server4": {
                "ansible_host": "10.0.0.32"
            }
        }
    },
# ... contenu éliminé

    "web_dev": {
        "hosts": [
            "10.0.0.21"
        ]
    },
    "web_prod": {
        "hosts": [
            "10.0.0.22"
        ]
    },
# ... contenu éliminé
}
```
Notez comment les serveurs sont désormais référencés par leurs alias au lieu de
leurs adresses IP ou noms d'hôte. Cela facilite le ciblage de serveurs individuels
lors de l'exécution de commandes et de playbooks.

## Étape 4 - Configuration des variables d'hôte
Il est possible d'utiliser le fichier d'inventaire pour configurer des variables
qui modifieront le comportement par défaut d'Ansible lors de la connexion et de
l'exécution de commandes sur vos nœuds. C'est en fait ce que nous avons fait à
l'étape précédente, lors de la configuration des alias d'hôte. La variable `ansible_host`
indique à Ansible où trouver les nœuds distants, au cas où un alias serait utilisé
pour faire référence à ce serveur.

Les variables d'inventaire peuvent être définies par hôte ou par groupe. En plus
de personnaliser les paramètres par défaut d'Ansible, ces variables sont également
accessibles à partir de vos playbooks, ce qui permet une personnalisation supplémentaire
pour les hôtes et groupes individuels.

L'exemple suivant montre comment définir l'utilisateur distant par défaut lors de
la connexion à chacun des nœuds répertoriés dans ce fichier d'inventaire:

```
cat hosts
```
```shell
# ... contenu éliminé
server1 ansible_host=10.0.0.21 ansible_user=vagrant
# ... contenu éliminé
server2 ansible_host=10.0.0.22 ansible_user=vagrant
# ... contenu éliminé
server3 ansible_host=10.0.0.31 ansible_user=ubuntu
# ... contenu éliminé
server4 ansible_host=10.0.0.32 ansible_user=ubuntu
# ... contenu éliminé
```
Vous pouvez également créer un groupe pour agréger les hôtes avec des paramètres
similaires, puis configurer leurs variables au niveau du groupe:

```
cat hosts
```
```shell
# ... contenu éliminé
server1 ansible_host=10.0.0.21
# ... contenu éliminé
server2 ansible_host=10.0.0.22
# ... contenu éliminé
server3 ansible_host=10.0.0.31
# ... contenu éliminé
server4 ansible_host=10.0.0.32
# ... contenu éliminé

[webservers:vars]
ansible_user=vagrant

[dbservers:vars]
ansible_user=ubuntu
```
Cet arrangement d'inventaire générerait la sortie suivante avec `ansible-inventory`:
```
Output
{
    "_meta": {
        "hostvars": {
            "server1": {
                "ansible_host": "10.0.0.21",
                "ansible_user": "vagrant"
            },
            "server2": {
                "ansible_host": "10.0.0.22",
                "ansible_user": "vagrant"
            },
            "server3": {
                "ansible_host": "10.0.0.31",
                "ansible_user": "ubuntu"
            },
            "server4": {
                "ansible_host": "10.0.0.32",
                "ansible_user": "ubuntu"
            }
        }
    },

    ....
```
Notez que toutes les variables d'inventaire sont répertoriées dans le nœud **_meta**
dans la sortie JSON produite par `ansible-inventory`.

## Étape 5 - Utilisation de modèles pour cibler l'exécution des commandes et des playbooks
Lors de l'exécution de commandes et de playbooks avec Ansible, vous devez fournir une cible. Les modèles vous permettent de cibler des hôtes, des groupes ou des sous-groupes spécifiques dans votre fichier d'inventaire. Ils sont très flexibles et prennent en charge les expressions régulières et les caractères génériques.

Considérez le fichier d'inventaire suivant:

```
cat hosts
```
```
[web_dev]
server1 ansible_host=10.0.0.21

[web_prod]
server2 ansible_host=10.0.0.22

[db_dev]
server3 ansible_host=10.0.0.31

[db_prod]
server4 ansible_host=10.0.0.32

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

[webservers:vars]
ansible_user=vagrant

[dbservers:vars]
ansible_user=ubuntu
```
Imaginons maintenant que vous deviez exécuter une commande ciblant uniquement le(s)
serveur(s) de base de données qui s'exécutent en production. Dans cet exemple,
ce critère ne correspond qu'à 10.0.0.32; cependant, il se peut que vous ayez un
grand groupe de serveurs de base de données dans ce groupe. Au lieu de cibler
individuellement chaque serveur, vous pouvez utiliser le modèle suivant:
```shell
ansible webservers:\&production -m ping -i hosts
```
Le caractère **&** représente l'opération logique AND, ce qui signifie que les
cibles valides doivent être dans les deux groupes. Comme il s'agit d'une commande
ad hoc exécutée sur Bash, nous devons inclure le caractère **\\** d'échappement dans l'expression.

L'exemple précédent ne ciblerait que les serveurs présents à la fois dans les groupes
dbservers et production. Si vous vouliez faire le contraire, en ciblant uniquement
les serveurs qui sont présents dans le groupe dbservers mais pas dans le groupe
production, vous utiliseriez à la place le modèle suivant:
```shell
ansible dbservers:\!production -m ping -i hosts
```
Pour indiquer qu'une cible ne doit pas faire partie d'un certain groupe, vous pouvez
utiliser le caractère **!**. Une fois de plus, nous incluons le caractère **\\** d'échappement dans l'expression pour éviter les erreurs de ligne de commande, car les deux & et !
sont des caractères spéciaux qui peuvent être analysés par Bash.
```shell
ansible server1:server3 -m ping -i hosts
```
Le tableau suivant contient quelques exemples différents de modèles courants que
vous pouvez utiliser lors de l'exécution de commandes et de playbooks avec Ansible:

| Modèle          | Objectif de résultat                                        |
|-----------------|-------------------------------------------------------------|
| all             | Tous les hôtes de votre fichier d'inventaire                |
| host1           | Un seul hôte (host1)                                        |
| host1:host2     | Les deux host1 et host2                                     |
| group1          | Un seul groupe (group1)                                     |
| group1:group2   | Tous les serveurs dans group1 et group2                     |
| group1:\&group2 | Seuls les serveurs qui sont à la fois dans group1 et group2 |
| group1:\!group2 | Serveurs en group1 sauf ceux également en group2            |
