# Malvinaland

Ce site presente les differents mondes de Malvinaland, un univers imaginaire riche en mysteres et en aventures.

## Structure du site

* index.html : Page d'accueil
* carte.html : Carte interactive des mondes
* monde-*.html : Pages des differents mondes
* Core/ : Scripts et styles communs
* monde-*/ : Ressources specifiques a chaque monde

## Mondes disponibles

* Monde de l'Assemblee
* Monde de la Grange
* Monde des Jeux
* Monde des Reves
* Monde du Damier
* Monde du Linge
* Monde du Verger
* Monde du Zob
* Monde Elysee
* Monde Karibu
* Monde des Sphinx

## Deploiement

Pour deployer ce site sur IIS :

* Assurez-vous que IIS est installe avec le module URL Rewrite
* Copiez tous les fichiers dans le repertoire racine du site IIS
* Configurez les autorisations appropriees pour IIS_IUSRS
* Redemarrez le site IIS

## Maintenance

En cas de probleme avec le menu mobile ou d'erreurs 404 :

* Verifiez que tous les fichiers ont ete correctement copies
* Assurez-vous que les repertoires des mondes existent et contiennent un fichier readme.md
* Videz le cache du navigateur et du serveur IIS
* Redemarrez le site IIS
