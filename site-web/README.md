# Malvinaland

Ce site présente les différents mondes de Malvinaland, un univers imaginaire riche en mystères et en aventures.

## Structure du site

* index.html : Page d'accueil
* content/carte/index.html : Carte interactive des mondes
* content/mondes/*/index.html : Pages des différents mondes
* assets/ : Ressources (CSS, JavaScript, images)
* Core/ : Scripts et styles communs

## Documentation

Pour plus d'informations, consultez les documents suivants :

- [Guide de démarrage rapide](GUIDE_DEMARRAGE_RAPIDE.md) ✨ NOUVEAU
- [Identifiants de test](content/organisateurs/identifiants-test.md) ✨ NOUVEAU

## Corrections récentes (22/05/2025)

Les problèmes suivants ont été corrigés :

- ✅ Carte interactive : Les clics sur la carte fonctionnent maintenant correctement
- ✅ Erreurs 404 : Les ressources manquantes ont été ajoutées
- ✅ Menu mobile : L'expérience mobile a été améliorée
- ✅ Liens entre mondes : Tous les liens entre les mondes fonctionnent correctement
- ✅ Documentation : Guide de démarrage rapide et identifiants de test ajoutés

## Mondes disponibles

* Monde de l'Assemblée
* Monde de la Grange
* Monde des Jeux
* Monde des Rêves
* Monde du Damier
* Monde du Linge
* Monde du Verger
* Monde du Zob
* Monde Elysée
* Monde Karibu
* Monde des Sphinx

## Test local

Pour tester le site localement :

1. Exécutez le script `temp-deploy-site-web.ps1` à la racine du projet
2. Le site sera accessible à l'adresse http://localhost:8080

## Déploiement

Pour déployer ce site sur IIS :

1. Assurez-vous que IIS est installé avec le module URL Rewrite
2. Copiez tous les fichiers dans le répertoire racine du site IIS
3. Configurez les autorisations appropriées pour IIS_IUSRS
4. Redémarrez le site IIS

## Maintenance

En cas de problème avec le menu mobile ou d'erreurs 404 :

1. Vérifiez que tous les fichiers ont été correctement copiés
2. Assurez-vous que les répertoires des mondes existent et contiennent un fichier readme.md
3. Videz le cache du navigateur et du serveur IIS
4. Redémarrez le site IIS
5. Consultez le Guide de démarrage rapide pour plus d'informations
