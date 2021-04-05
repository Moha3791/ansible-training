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

admin_password='' <- Mot de passe de l'administrateur local de la tour
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
