# Scripts de déploiement et de maintenance

Ce dossier contient les scripts utilisés pour le déploiement et la maintenance du site Malvinaland.

## Scripts de déploiement

- deploy-iis-improved.ps1 : Script de déploiement amélioré pour IIS
- deploy-iis-admin.ps1 : Script de déploiement pour les administrateurs
- deploy-iis-simple.ps1 : Script de déploiement simplifié
- deploy-site-local.ps1 : Script de déploiement local pour les tests

## Scripts de maintenance

- clean-repository.ps1 : Nettoyage général du dépôt
- clean-temp-files.ps1 : Suppression des fichiers temporaires et doublons
- organize-repository.ps1 : Organisation des fichiers selon la structure recommandée
- verify-repository-health.ps1 : Vérification de l'état du dépôt

## Scripts d'optimisation

- optimize-images.js : Optimisation des images
- identify-missing-images.ps1 : Identification des images manquantes

## Utilisation

Pour exécuter un script, utilisez la commande suivante :

```powershell
.\scripts\nom-du-script.ps1
```

Pour exécuter un script avec des paramètres, utilisez la commande suivante :

```powershell
.\scripts\nom-du-script.ps1 -Parametre1 Valeur1 -Parametre2 Valeur2
```

La plupart des scripts acceptent les paramètres suivants :

- -Execute : Exécute les actions (par défaut, le script s'exécute en mode simulation)
- -Force : Force l'exécution sans demander de confirmation
