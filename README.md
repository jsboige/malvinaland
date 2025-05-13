# 🌍 Malvinaland - Jeu de Piste Immersif

Bienvenue dans le dépôt du jeu de piste immersif "Malvinaland", conçu pour la maison de campagne à Sabres. Cette aventure narrative et ludique propose un parcours d'énigmes à travers le jardin, les bâtiments et les espaces décorés de la propriété.

Ce document explique également la procédure de déploiement du projet selon la nouvelle arborescence qui sépare le site web déployable (léger) des ressources volumineuses (photos haute résolution).

## Structure du projet

La nouvelle arborescence est organisée comme suit :

```
Les mondes de Malvinha/
│
├── site/                           # Site web déployable (léger)
│   ├── index.html                  # Page de redirection vers Core/index.html
│   ├── web.config                  # Configuration IIS
│   ├── Core/                       # Configuration et navigation communes
│   │   ├── mondes-config.js
│   │   ├── navigation.js
│   │   ├── image-loader.js         # Script de chargement différé des images
│   │   └── index.html              # Page d'accueil principale
│   │
│   ├── Mondes/                     # Structure légère des mondes
│   │   ├── Carte de Malvinaland stylisée.png  # Image essentielle
│   │   ├── web.config
│   │   │
│   │   ├── Le monde de l'assemblée/
│   │   │   ├── index.html
│   │   │   ├── script.js
│   │   │   ├── styles.css
│   │   │   └── thumbnails/         # Miniatures des images (légères)
│   │   │
│   │   └── [Autres mondes...]
│   │
│   └── Site/                       # Structure modulaire du site
│
├── ressources/                     # Ressources volumineuses (non déployées)
│   └── images/                     # Images haute résolution
│       ├── Le monde de l'assemblée/
│       ├── Le monde de la grange/
│       └── [Autres mondes...]
│
└── docs/                           # Documentation et fichiers de développement
```

## Procédure de déploiement

### Prérequis

- PowerShell 5.1 ou supérieur
- .NET Framework 4.5 ou supérieur (pour la manipulation des images)
- Droits d'administrateur sur le serveur de déploiement

### Étapes de déploiement

1. **Préparation**
   - Cloner ou télécharger le projet complet
   - Ouvrir une console PowerShell en tant qu'administrateur
   - Se positionner dans le répertoire racine du projet

2. **Exécution du script de déploiement**
   ```powershell
   .\deploy.ps1
   ```

3. **Vérification**
   - Vérifier que la structure de dossiers a été correctement créée
   - Vérifier que les miniatures ont été générées dans les dossiers `thumbnails/`
   - Vérifier que les images haute résolution ont été déplacées dans le dossier `ressources/images/`

4. **Déploiement sur le serveur web**
   - Copier uniquement le dossier `site/` sur le serveur web
   - Conserver le dossier `ressources/` sur un stockage local ou un serveur de fichiers séparé

## Fonctionnement du chargement différé des images

Le système de chargement différé des images fonctionne comme suit :

1. Les images haute résolution sont stockées dans le dossier `ressources/images/`
2. Des miniatures légères sont générées et stockées dans les dossiers `thumbnails/` de chaque monde
3. Le script `image-loader.js` détecte les images avec l'attribut `data-high-res` et les charge en arrière-plan lorsque :
   - L'utilisateur survole l'image avec la souris
   - L'utilisateur clique sur l'image
   - L'image devient visible dans la fenêtre du navigateur

### Exemple d'utilisation dans le HTML

```html
<img src="thumbnails/image.jpg" data-high-res="../../ressources/images/Le monde de l'assemblée/image.jpg" alt="Description de l'image">
```

## Maintenance et mise à jour

### Ajout de nouvelles images

Pour ajouter de nouvelles images à un monde existant :

1. Placer les images haute résolution dans le dossier `ressources/images/[Nom du monde]/`
2. Exécuter à nouveau le script `deploy.ps1` pour générer les miniatures
3. Mettre à jour les références dans les fichiers HTML

### Ajout d'un nouveau monde

Pour ajouter un nouveau monde :

1. Créer le dossier du monde dans la structure existante
2. Ajouter les fichiers HTML, JS et CSS nécessaires
3. Ajouter les images dans le dossier `ressources/images/[Nouveau monde]/`
4. Mettre à jour le fichier `Core/mondes-config.js` pour inclure le nouveau monde
5. Exécuter le script `deploy.ps1` pour générer la structure complète

## Résolution des problèmes courants

### Les miniatures ne sont pas générées

- Vérifier que le .NET Framework est correctement installé
- Vérifier les droits d'accès aux dossiers
- Consulter les logs d'erreur générés par le script

### Les images haute résolution ne se chargent pas

- Vérifier que les chemins relatifs sont corrects dans les attributs `data-high-res`
- Vérifier que le script `image-loader.js` est bien chargé dans les pages HTML
- Vérifier la console du navigateur pour d'éventuelles erreurs JavaScript

### Erreurs lors de l'exécution du script de déploiement

- Exécuter PowerShell en tant qu'administrateur
- Vérifier la politique d'exécution PowerShell avec la commande `Get-ExecutionPolicy`
- Si nécessaire, modifier la politique avec `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process`

## Support et contact

Pour toute question ou assistance concernant la procédure de déploiement, veuillez contacter l'équipe de développement à l'adresse suivante : [adresse email].
