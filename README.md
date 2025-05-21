# Malvinaland

Ce dépôt contient le code source et les ressources du site Malvinaland, un univers imaginaire riche en mystères et en aventures.

## Structure du dépôt

- src/ : Code source du site
- site/ : Site généré pour le déploiement
- scripts/ : Scripts de déploiement et de maintenance
- ressources/ : Ressources partagées
- docs/ : Documentation du projet

## Documentation

Pour plus d'informations, consultez les documents suivants :

- [Guide de maintenance](docs/GUIDE_MAINTENANCE.md)
- [Guide des PNJ](docs/GUIDE_PNJ.md)
- [Expérience mobile](docs/MOBILE_EXPERIENCE.md)
- [Journal des modifications](docs/JOURNAL_MODIFICATIONS.md)
- [Comment modifier le site](docs/COMMENT_MODIFIER.md)
- [Guide de déploiement IIS](docs/GUIDE_DEPLOIEMENT_IIS.md)

## Déploiement IIS

Le site est configuré pour être déployé sur IIS. Pour des instructions détaillées, consultez le [Guide de déploiement IIS](docs/GUIDE_DEPLOIEMENT_IIS.md).

Utilisez les scripts suivants pour le déploiement :

- scripts/deploy-iis-improved.ps1 : Script de déploiement amélioré
- scripts/deploy-iis-admin.ps1 : Script de déploiement pour les administrateurs
- scripts/optimize-iis-config.ps1 : Script d'optimisation de la configuration IIS

## Maintenance

Pour nettoyer et organiser le dépôt :

- scripts/clean-repository.ps1 : Nettoyage général du dépôt
- scripts/clean-temp-files.ps1 : Suppression des fichiers temporaires et doublons
- scripts/organize-repository.ps1 : Organisation des fichiers selon la structure recommandée
