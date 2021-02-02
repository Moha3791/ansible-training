Lab 6 – Ansible Templates
==
Ansible utilise Jinja2, un moteur de création de modèles pour les
frameworks Python, utilisé pour générer du contenu ou des expressions
dynamiques. La création de modèles est extrêmement utile lors de la
création de fichiers de configuration personnalisés pour plusieurs
serveurs, mais uniques pour chacun d'entre eux.

Jinja2 utilise les doubles accolades {{ ... }} pour entourer une variable
qui a été définie. Pour les commentaires, utilisez {{\# \#}} et pour les
instructions conditionnelles, utilisez {% … %}.

Exemple 1
---------

Rappelez-vous du lab des variables, où nous avons distribué des fichiers
index.html selon la variable *stage.* Le même objectif peut être atteint
avec les templates J2.

Cette fois, nous allons distribuer le même fichier index.html, qui doit
changer de contenu selon le système d’exploitation.

Créons donc un playbook *test_server.yml* comme indiqué:
```yaml
---
- hosts: all
  become: yes
  tasks:
  - name: Install index.html
    template:
      src: index.html.j2
      dest: /var/www/html/index.html
      mode: 0644
```
Notre template Jinja2 de fichier `index.html` est **index.html.j2** qui
sera pushé vers le fichier `index.html` sur chaque serveur Web. N'oubliez
jamais de mettre l'extension ***.j2*** à la fin pour indiquer qu'il s'agit
d'un fichier *Jinja2*.

Créons maintenant le fichier modèle `index.html.j2`.
```Jinja2
<html>
  <center>
    <h1> The hostname of this webserver is {{ ansible_hostname> }}</h1>
    <h3> It is running on {{ ansible_os_family }} system </h3>
  </center>
</html>
```

Ce modèle est un fichier HTML simple dans lequel *ansible_hostname* et
*ansible_os_family* sont des variables qui seront remplacées par les
noms d'hôte et les systèmes d'exploitation respectifs des serveurs Web.
```
$ ansible-playbook test_server.yml
```
Rechargeons maintenant les pages Web pour les serveurs Web CentOS 7 et
Ubuntu .

### Filtres

Parfois, vous pouvez décider de remplacer la valeur d'une variable par
une chaîne qui apparaît d'une certaine manière.

#### Exemple 1: faire apparaître les chaînes en majuscules / minuscules

Par exemple, dans l'exemple précédent, nous pouvons décider de faire
apparaître les variables Ansible en majuscules. Pour ce faire, ajoutez
la valeur upper à la variable. De cette façon, la valeur de la variable
est convertie au format majuscule.

##### {{ ansible_hostname | upper }} => CENTOS 7

##### {{ ansible_os_family | upper }} => REDHAT
```html
<html>
  <center>
    <h1> The hostname of this webserver is {{ ansible_hostname | upper }}</h1>
    <h3> It is running on {{ ansible_os_family | upper }} system </h3>
  </center>
</html>
```

### Exemple 2: remplacer une chaîne par une autre

En outre, vous pouvez remplacer une chaîne par une autre.

Par exemple:

Le titre du film est {{ movie_name }} => Le titre du film est Ring .

Pour remplacer la sortie par une autre chaîne, utilisez l'argument
replace comme indiqué:

Le titre du film est {{ movie_name | replace (“Ring“,”Heist”) }} =>
Le titre du film est Heist .

### Exemple 3: répertorie et définit les filtres

Pour récupérer la plus petite valeur d'un tableau, utilisez le filtre
min .

{{ \[2, 3, 4, 5, 6, 7\] | min }} => 2

De même, pour récupérer le plus grand nombre, utilisez le filtre max .

{{ \[2, 3, 4, 5, 6, 7\] | max }} => 7

Pour afficher des valeurs uniques, utilisez le filtre unique .

{{ \[2, 3, 3, 2, 6, 7\] | unique }} => 2, 3

Utilisez le filtre aléatoire pour obtenir un nombre aléatoire entre 0 et
la valeur.

{{ 50 | random }} => Un certain nombre aléatoire

## Boucles:

Tout comme dans les langages de programmation, nous avons des boucles
dans Ansible Jinja2 .

Par exemple, pour générer un fichier contenant une liste de nombres,
utilisez la boucle for comme indiqué dans l'exemple ci-dessous:

#### Exemple 1:

> {% for number in \[0, 1, 2, 3, 4, 5, 6, 7\] %}
>
> {{ number }}
>
> {% end for %}

Vous pouvez également combiner la boucle for avec des instructions
if-else pour filtrer et obtenir certaines valeurs.

#### Exemple 2:

> {% for number in \[0, 1, 2, 3, 4, 5, 6, 7\] %}
>
> {% if number == 5 %}
>
> {{ number }}
>
> {% endif %}
>
> {% endfor %}
