Ansible Tower 3.8
===

# Installation de la plate-forme d'automatisation Ansible
Ce guide vous aide à mettre en place et à exécuter votre installation Ansible Automation Platform le plus rapidement possible.

À la fin de l'installation, à l'aide de votre navigateur Web, vous pouvez accéder et utiliser pleinement la plate-forme d'automatisation.

## Prérequis et exigences
À partir d'Ansible Tower 3.8, vous devez avoir des abonnements valides attachés avant d'installer et d'exécuter Ansible Automation Platform. Même si vous disposez déjà de licences valides des versions précédentes, vous devez toujours fournir vos informations d'identification ou un manifeste d'abonnement lors de la mise à niveau vers Tower 3.8. Voir Joindre des abonnements pour plus de détails.

Systèmes d'exploitation pris en charge :
* Red Hat Enterprise Linux 8.2 ou version ultérieure 64 bits (x86)
* Red Hat Enterprise Linux 7.7 ou version ultérieure 64 bits (x86)
* CentOS 7.7 ou version ultérieure 64 bits (x86)

2 CPU minimum pour les installations Automation Platform.
4 Go de RAM minimum pour les installations Automation Platform

## Téléchargez le programme d'installation d'Ansible Automation Platform

1. Accédez à la dernière version du programme d'installation intégré d'Ansible Automation Platform directement à partir de https://access.redhat.com/downloads/content/480 (notez que vous devez avoir un compte client Red Hat pour accéder aux téléchargements).

1. Ensuite, sélectionnez le dernier programme d'installation à télécharger.
1. Extrayez l'outil d'installation / mise à niveau:
```
root@localhost:~$ tar xvzf ansible-tower-setup-latest.tar.gz
root@localhost:~$ cd ansible-tower-setup-<tower_version>
```
1. Lors de l'installation ou de la mise à niveau, commencez par éditer le fichier d'inventaire dans le répertoire **ansible-tower-setup-<tower_version>**, en le remplaçant <tower_version>par le numéro de version, c'est-à-dire 3.8.0.

## Installation de la plate-forme d'automatisation Ansible
### Configuration du fichier d'inventaire
Le contenu du fichier d'inventaire doit être défini dans **./inventory**, à côté du du programme d'installation **./setup.sh**.

Les modifications apportées au processus d'installation nécessitent maintenant que vous remplissiez tous les champs de mot de passe dans le fichier d'inventaire. Si vous avez besoin de savoir où trouver les valeurs pour celles-ci, elles doivent être:

admin_password='' <- Mot de passe de l'administrateur local
pg_password='' <—- Trouvé dans /etc/tower/conf.d/postgres.py

### Lancer l'installations

Executer le script script.sh avec les droits d'administrateur:
```
root@localhost:~$ ./setup.sh
```
et attendre la fin de l'installation avec succès.

Une fois la configuration terminée, utilisez votre navigateur Web pour accéder à l'écran de connexion de Tawer. Votre serveur Tower est accessible depuis le port 80 (https://<TOWER_SERVER_NAME>/) mais sera redirigé vers le port 443 donc 443 doit également être disponible.

![](https://docs.ansible.com/ansible-tower/latest/html/quickinstall/_images/login-form.png)

## Importer un abonnement

Lorsque Tower est lancé pour la première fois, l'écran d'abonnement s'affiche automatiquement.
![](https://docs.ansible.com/ansible-tower/latest/html/quickinstall/_images/no-license.png)

1. Utilisez vos informations d'identification Red Hat (nom d'utilisateur et mot de passe) pour récupérer et importer votre abonnement, ou télécharger un manifeste d'abonnement que vous générez à partir de https://access.redhat.com/management/subscription_allocations.
1. Continuez en vérifiant le contrat de licence de l'utilisateur final
1. Après avoir spécifié vos préférences de suivi et d'analyse, cliquez sur Soumettre

Votre copie Tower est maintenant activée
Pour plus de détails consulter le [guide d'installation](https://docs.ansible.com/ansible-tower/latest/html/quickinstall/index.html).
# Utiliser Tower
## Examinez le tableau de bord de Tower
Le tableau de bord de Tower offre un cadre graphique convivial pour vos besoins d'orchestration. Sur le côté gauche du tableau de bord de Tower se trouve le menu de navigation, dans lequel vous pouvez accéder rapidement à vos projets, inventaires, job templates et jobs.

Cliquez sur l'icône Menu ![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/menu-icon.png) en haut de la navigation de gauche et la barre de navigation se développe pour afficher les icônes et les étiquettes; et se réduit pour n'afficher que les icônes. Affichez les étiquettes sans développer le menu en survolant les icônes.

![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/nav-bar-various-states.png)

Le tout dernier élément de la barre de navigation est l'icône Paramètres, qui permet d'accéder aux paramètres de configuration de Tower.

![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/ug-settings-menu-expanded.png)

La page Paramètres permet aux administrateurs de configurer l'authentification, les travaux, les attributs au niveau du système et de personnaliser l'interface utilisateur. Les versions précédentes d'Ansible Tower (3.2.x et antérieures) fournissent le menu Paramètres en haut de l'interface à côté des boutons utilisateur et de déconnexion. Reportez-vous à la section Configuration de Tower pour plus de détails. De plus, vous pouvez désormais accéder aux informations de licence du produit à partir de cette page.

![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/ug-settings-menu-screen.png)

Sur l'écran principal du tableau de bord de Tower, un résumé apparaît indiquant l'état actuel de votre travail . Les résumés des modèles récemment utilisés et des exécutions récentes de travaux sont également disponibles pour examen .

![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/home-dashboard.png)

## Configurer l'organisation

Une organisation est un ensemble logique d'utilisateurs, d'équipes, de projets et d'inventaires. Il s'agit de l'objet de plus haut niveau dans la hiérarchie des objets Tower.
Dans la barre de navigation de gauche, cliquez sur l'icône Organisations (![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/organizations-icon.png)).

![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/organizations-home-showing-example-organization.png)

Une organisation par défaut a été créée automatiquement et est disponible pour tous les utilisateurs d'Ansible Tower. Il peut être utilisé tel quel ou modifié ultérieurement si nécessaire.

Pour les besoins de ce lab, laissez l'organisation par défaut telle quelle et cliquez sur Enregistrer .

## Ajouter un utilisateur à l'organisation
Développez les détails des utilisateurs en cliquant sur l' onglet Utilisateurs de l'organisation par défaut que vous venez d'enregistrer (pas dans la barre de navigation de gauche).

![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-organizations-click-to-expand-users-section.png)

1. Pour ajouter un utilisateur, cliquez sur le bouton ajouter ![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/add-button.png).
1. Les autres utilisateurs n'ayant pas encore été créés, l'utilisateur «admin» est le seul utilisateur répertorié. Cochez la case en regard de l'utilisateur «admin» pour le sélectionner pour cette organisation. Cela étend la partie inférieure de l'assistant pour attribuer des rôles à l'utilisateur sélectionné.
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-organizations-create-user-form.png)
1. Cliquez dans le menu déroulant pour sélectionner un ou plusieurs rôles pour cet utilisateur.
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-organizations-add-admin-for-example-organization-assign-roles.png)
1. Une fois terminé, cliquez sur Enregistrer .

## Créez un nouvel inventaire et ajoutez-le à l'organisation
Un inventaire est un ensemble d'hôtes géré par Tower. Les inventaires sont attribués aux organisations, tandis que les autorisations de lancement de playbooks par rapport aux inventaires sont contrôlées au niveau de l'utilisateur et / ou de l'équipe.

Pour examiner les inventaires existants:

1. Cliquez sur l'icône Inventaires (![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/inventories-icon.png)) dans la barre de navigation de gauche.

1. Cliquez sur le bouton ajouter ![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/add-button.png) et sélectionnez **Inventaire** dans la liste du menu déroulant. Les inventaires intelligents sont décrits plus en détail dans les inventaires intelligents .
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-inventories-create-new-inventory.png)
Ansible Tower fournit un inventaire de démonstration que vous pouvez utiliser lorsque vous apprenez comment fonctionne Tower. Cliquez sur le lien «Demo Inventory» pour l'inventaire du stock fourni par Ansible Tower.

###  Groupes et hôtes
Notez que les inventaires sont divisés en groupes et en hôtes. Un groupe peut représenter un environnement particulier (par exemple «Datacenter 1» ou «Stage Testing»), un type de serveur (par exemple «Serveurs d'applications» ou «Serveurs de base de données»), ou toute autre représentation de votre environnement. Les groupes et hôtes qui appartiennent à l'inventaire de démonstration sont affichés respectivement dans les onglets Groupes et Hôtes .
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-inventories-demo-details.png)
1. Dans l' onglet Groupes, cliquez sur le bouton Ajouter ![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/add-button.png) pour ajouter des groupes à l'inventaire.
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-inventories-click-to-create-new-group.png)
1. De même, dans l' onglet Hôtes , cliquez sur le bouton Ajouter ![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/add-button.png) pour ajouter des hôtes aux groupes.
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-inventories-click-to-create-new-host.png)
Pour les besoins de ce Quick Start et pour tester que Tower est correctement configurée, un hôte local a été ajouté pour votre utilisation.
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-inventories-host-properties-form.png)
Cliquez sur **Cancel** (si aucune modification n'a été apportée) ou utilisez les liens de navigation du fil d'Ariane en haut du navigateur Ansible Tower pour revenir à l'écran de présentation des inventaires. Cliquer sur Enregistrer ne quitte pas la boîte de dialogue d'édition.

## Créez un identifiant

Les informations d'identification authentifient l'utilisateur de Tower pour lancer les playbooks Ansible, qui peuvent inclure des mots de passe et des clés SSH, par rapport aux hôtes d'inventaire. Vous pouvez également demander à l'utilisateur de Tower de saisir un mot de passe ou une phrase clé lors du lancement d'un playbook à l'aide de la fonction d'informations d'identification de Tower.

Créez une nouvelle information d'identification en cliquant sur l' icône d'Informations d'identification (![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/credentials-icon.png)) dans la barre de navigation de gauche.
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-credentials-setup-screen.png)
Dans le cadre de ce Quick Start, un identifiant de démonstration a été fourni pour votre utilisation.

Cliquez sur le nom du lien «Demo Credential» ou sur le bouton Edit (![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/edit-button.png)) pour examiner ou modifier ces informations d'identification.
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-credentials-create-new.png)

## Configurer un projet
Un projet est une collection logique de playbooks Ansible, représentés dans Tower.

Vous pouvez gérer les playbooks et les répertoires de playbooks en les plaçant manuellement sous le chemin de base du projet sur votre serveur Tower, ou en plaçant vos playbooks dans un système de gestion du code source (SCM) pris en charge par Tower, y compris Git, Subversion et Mercurial.

Pour revoir des projets existants ou pour en créer un nouveau, cliquez sur l' icône de Projets (![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/projects-icon.png)) dans la barre de navigation de gauche.
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-projects-home.png)

Ansible Tower simplifie le processus de démarrage en vous fournissant un projet de démonstration avec lequel travailler initialement.

Cliquez sur le lien du nom «Projet de démonstration» ou cliquez sur le bouton Modifier (![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/edit-button.png)) pour passer en revue le projet de stock fourni par Ansible Tower.

![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-demo-projects.png)
Cliquez sur Annuler (si aucune modification n'a été apportée) ou utilisez les liens de navigation du fil d'Ariane en haut du navigateur Ansible Tower pour revenir à l'écran de présentation des inventaires. Cliquer sur Enregistrer ne quitte pas la boîte de dialogue d'édition.

Avant que ce projet puisse être utilisé dans un modèle de travail, vous devez démarrer manuellement une synchronisation SCM pour ce projet. Mettez à jour le projet de démonstration basé sur SCM en cliquant sur le bouton Sync ![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/refresh-button.png) sous les actions disponibles du projet:
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-demo-project-sync-icon-hover.png)
Notez que le point d'état à côté du nom du projet, de la révision et des dernières informations d'exécution est mis à jour une fois la synchronisation terminée.
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-demo-proj-sync.png)

## Créez un nouveau Job Template

Un modèle de travail combine un playbook Ansible d'un projet et les paramètres requis pour le lancer. Passez en revue les travaux existants ou créez un nouveau modèle de travail en cliquant sur l'icône Modèles (![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/templates-icon.png)) dans la barre de navigation de gauche.
![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/job-templates-home-with-example-job-template.png)

Aux fins de ce démarrage rapide, un modèle de tâche de démonstration a été créé pour votre première utilisation.

Cliquez sur le bouton Modifier (![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/edit-button.png)) pour consulter le modèle de tâche de stock fourni par Ansible Tower.

![](https://docs.ansible.com/ansible-tower/latest/html/quickstart/_images/qs-job-templates-form.png)
Cliquez sur Annuler (si aucune modification n'a été apportée) ou utilisez les liens de navigation du fil d'Ariane en haut du navigateur Ansible Tower pour revenir à l'écran de présentation des modèles. Cliquer sur Enregistrer ne quitte pas la boîte de dialogue d'édition.
