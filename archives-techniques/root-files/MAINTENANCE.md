# Guide de maintenance du site Malvinaland

Ce guide fournit des instructions pour la maintenance du site Malvinaland, y compris des conseils pour résoudre les problèmes courants et des bonnes pratiques pour les futures mises à jour.

## Structure du site

Le site Malvinaland est organisé comme suit:

- `Site/index.html` - Page d'accueil principale
- `Site/carte.html` - Carte interactive des mondes
- `Site/Core/` - Contient les fichiers principaux du site (styles, scripts, etc.)
- `Site/Core/Mondes/` - Contient les pages des différents mondes
- `Site/PNJ/` - Contient les pages des personnages non-joueurs

## Problèmes courants et solutions

### 1. Problèmes de navigation

#### Symptômes
- Les liens ne fonctionnent pas correctement
- La navigation entre les pages est interrompue
- Les utilisateurs restent sur la même page après avoir cliqué sur un lien

#### Solutions
- Vérifier que les liens utilisent des chemins relatifs corrects
- Pour les liens vers les sections de la page d'accueil, utiliser des ancres (ex: `#monde-assemblee`)
- Pour les liens entre les pages, utiliser des chemins relatifs (ex: `carte.html`)
- Vérifier que le script `navigation.js` est correctement chargé et fonctionne

### 2. Problèmes d'affichage des images

#### Symptômes
- Les images ne s'affichent pas
- Des icônes d'image brisée apparaissent

#### Solutions
- Vérifier que les chemins vers les images sont corrects
- Utiliser l'attribut `onerror` pour fournir une image alternative
- Vérifier que les images existent dans les dossiers spécifiés

### 3. Problèmes de responsive design

#### Symptômes
- Le site ne s'affiche pas correctement sur mobile
- Le menu hamburger ne fonctionne pas

#### Solutions
- Vérifier que les media queries dans `styles.css` sont correctes
- Vérifier que le script `navigation.js` gère correctement le menu mobile
- Tester le site sur différents appareils et navigateurs

### 4. Problèmes de performance

#### Symptômes
- Le site est lent à charger
- Les animations sont saccadées

#### Solutions
- Optimiser les images (compression, dimensions appropriées)
- Minimiser les fichiers CSS et JavaScript
- Utiliser la technique de debounce pour les événements de défilement et de redimensionnement

## Bonnes pratiques pour les futures mises à jour

### 1. Structure des fichiers

- Maintenir une structure de site cohérente
- Éviter les redirections inutiles
- Placer les pages principales à la racine du site
- Organiser les ressources de manière logique

### 2. Gestion du code JavaScript

- Éviter les conflits entre scripts
- S'assurer que chaque fonctionnalité est gérée par un seul script
- Documenter clairement les responsabilités de chaque script
- Utiliser des commentaires pour expliquer le code complexe

### 3. Gestion des chemins de fichiers

- Utiliser des chemins relatifs cohérents dans toutes les pages
- Vérifier les chemins après chaque modification de la structure du site
- Utiliser des variables pour les chemins communs

### 4. Tests

- Tester régulièrement la navigation
- Vérifier que tous les liens fonctionnent correctement
- Tester sur différents navigateurs et appareils
- Utiliser les outils de développement pour détecter les erreurs JavaScript

## Déploiement

### 1. Préparation au déploiement

- Vérifier que tous les liens fonctionnent correctement
- Optimiser les images et les fichiers
- Mettre à jour les métadonnées (title, description, etc.)

### 2. Déploiement sur le serveur

- Utiliser le script `deploy.ps1` pour déployer le site
- Vérifier que tous les fichiers ont été correctement transférés
- Tester le site après le déploiement

### 3. Résolution des problèmes de déploiement

- Vérifier les logs du serveur
- Vérifier que le module URL Rewrite est installé pour la redirection HTTPS
- Consulter les logs IIS dans `%SystemDrive%\inetpub\logs\LogFiles`

## Contact

Pour toute question ou problème, contacter l'administrateur du site à l'adresse suivante: [adresse email].