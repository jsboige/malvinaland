# Organisation du dépôt Git "Les mondes de Malvinha"

Ce document résume les modifications apportées pour organiser le dépôt Git "Les mondes de Malvinha".

## Structure des branches

Le dépôt est organisé en plusieurs branches :

- **main** : Branche principale contenant le code stable
- **dev** : Branche de développement à partir de laquelle sont créées les branches thématiques
- **feature/site-principal** : Optimisation de la structure du site pour déploiement IIS
- **feature/mondes** : Organisation des mondes avec un système de navigation commun
- **feature/documentation** : Centralisation de la documentation dans un répertoire dédié

## Modifications apportées

### Branche feature/site-principal

- Création d'un fichier index.html à la racine pour rediriger vers le site principal
- Création d'un fichier web.config pour la configuration IIS
- Correction des chemins relatifs dans les fichiers HTML et JavaScript

### Branche feature/mondes

- Création d'un fichier de configuration centralisé pour les mondes (Core/mondes-config.js)
- Création d'un système de navigation commun (Core/navigation.js)
- Mise à jour du monde de l'assemblée pour utiliser le système de navigation commun
- Création d'un fichier web.config dans le dossier Mondes/ pour la configuration IIS

### Branche feature/documentation

- Création d'un répertoire Documentation/ à la racine du projet
- Organisation de la documentation en trois sous-répertoires :
  - Installation/ : Guides d'installation et d'utilisation
  - Guides/ : Guides méthodologiques et prompts
  - Mondes/ : Documentation spécifique aux mondes

## Problèmes rencontrés

Lors de la fusion de la branche feature/documentation dans la branche dev, nous avons rencontré un problème avec le répertoire Documentation/. Git indique que le répertoire existe déjà, mais il n'est pas visible dans le système de fichiers.

## Recommandations

1. Utiliser la branche dev comme base pour le développement futur
2. Créer des branches thématiques pour chaque nouvelle fonctionnalité
3. Fusionner régulièrement les branches thématiques dans la branche dev
4. Fusionner la branche dev dans la branche main uniquement lorsque le code est stable