# 🌍 Malvinaland - Jeu de Piste Immersif

Bienvenue dans le dépôt du jeu de piste immersif "Malvinaland", conçu pour la maison de campagne à Sabres. Cette aventure narrative et ludique propose un parcours d'énigmes à travers le jardin, les bâtiments et les espaces décorés de la propriété.

Ce document présente la nouvelle architecture basée sur 11ty (Eleventy) qui permet une génération automatique du site à partir de fichiers Markdown et une séparation claire du contenu pour les joueurs et les organisateurs.

## 🏗️ Nouvelle Architecture

La nouvelle architecture utilise 11ty (Eleventy) comme générateur de site statique pour créer un site web à partir de fichiers Markdown. Cette approche offre plusieurs avantages :

- **Source unique de vérité** : Tout le contenu est stocké dans des fichiers Markdown
- **Génération automatique** : Le site est généré automatiquement à partir des fichiers Markdown
- **Séparation du contenu** : Le contenu pour les joueurs et les organisateurs est séparé via un système d'authentification
- **Optimisation des images** : Les images sont automatiquement optimisées et des miniatures sont générées

### Structure du projet

```
malvinaland/
├── src/                          # Sources du site
│   ├── _data/                    # Données globales
│   │   ├── mondes.js             # Configuration des mondes
│   │   └── site.js               # Configuration du site
│   ├── _includes/                # Templates réutilisables
│   │   ├── layouts/              # Layouts de base
│   │   │   ├── base.njk          # Layout de base
│   │   │   ├── monde.njk         # Layout pour les mondes
│   │   │   └── organisateur.njk  # Layout pour les pages organisateurs
│   ├── assets/                   # Ressources statiques
│   │   ├── images/               # Images optimisées
│   │   │   ├── mondes/           # Images des mondes
│   │   │   └── placeholders/     # Placeholders pour les images manquantes
│   │   ├── css/                  # Styles CSS
│   │   └── js/                   # Scripts JavaScript
│   └── content/                  # Contenu source unique
│       ├── index.md              # Page d'accueil
│       ├── mondes/               # Contenu des mondes
│       │   ├── assemblee/        # Un monde par dossier
│       │   ├── grange/           # Un monde par dossier
│       │   ├── jeux/             # Un monde par dossier
│       │   └── reves/            # Un monde par dossier
│       └── organisateurs/        # Contenu réservé aux organisateurs
├── dist/                         # Site généré (ignoré par git)
├── scripts/                      # Scripts utilitaires
│   ├── deploy.ps1                # Script de déploiement
│   ├── optimize-images.js        # Script d'optimisation des images
│   ├── clean-repository.ps1      # Script de nettoyage du dépôt
│   └── identify-missing-images.ps1 # Script d'identification des images manquantes
├── archive/                      # Fichiers archivés (créé par le script de nettoyage)
├── .eleventy.js                  # Configuration d'Eleventy
├── package.json                  # Dépendances et scripts npm
└── README.md                     # Ce fichier
```

## 🚀 Installation et développement

### Prérequis

- Node.js 18.x ou supérieur
- npm 9.x ou supérieur
- PowerShell 5.1 ou supérieur (pour les scripts de déploiement)

### Installation

1. Cloner le dépôt
   ```bash
   git clone https://github.com/votre-organisation/malvinaland.git
   cd malvinaland
   ```

2. Installer les dépendances
   ```bash
   npm install
   ```

3. Lancer le serveur de développement
   ```bash
   npm run dev
   ```

4. Ouvrir le navigateur à l'adresse http://localhost:8080

### Scripts disponibles

- `npm run dev` : Lance le serveur de développement
- `npm run build` : Génère le site (version joueurs uniquement)
- `npm run build:all` : Génère le site (avec contenu organisateurs)
- `npm run optimize-images` : Optimise les images et génère des miniatures
- `npm run clean` : Nettoie le dépôt (déplace les fichiers obsolètes dans le dossier archive)
- `npm run deploy` : Déploie le site sur le serveur IIS

## 🧹 Nettoyage du dépôt

Le dépôt a été nettoyé pour éliminer les fichiers redondants et obsolètes. Un script de nettoyage a été créé pour faciliter cette tâche :

```powershell
# Exécuter en mode simulation (sans modifier les fichiers)
.\scripts\clean-repository.ps1

# Exécuter en mode réel (déplace les fichiers obsolètes dans le dossier archive)
.\scripts\clean-repository.ps1 -Execute
```

Le script effectue les opérations suivantes :
1. Identifie les fichiers essentiels à la nouvelle architecture
2. Déplace les fichiers obsolètes dans un dossier d'archive
3. Supprime les fichiers temporaires ou de build
4. Crée des placeholders pour les images manquantes

## 🖼️ Gestion des images

### Identification des images manquantes

Un script a été créé pour identifier les images référencées dans les fichiers Markdown mais qui n'existent pas dans le dossier des assets :

```powershell
# Identifier les images manquantes
.\scripts\identify-missing-images.ps1

# Identifier les images manquantes et générer des placeholders
.\scripts\identify-missing-images.ps1 -GeneratePlaceholders
```

Le script génère un rapport détaillé des images manquantes pour chaque monde, avec les informations suivantes :
- Texte alternatif de l'image
- Chemin de l'image
- Fichier Markdown qui référence l'image

### Optimisation des images

Les images sont automatiquement optimisées lors du build du site. Le script d'optimisation des images effectue les opérations suivantes :
1. Redimensionne les images pour qu'elles aient une taille raisonnable
2. Compresse les images pour réduire leur poids
3. Génère des miniatures pour le chargement différé

```bash
npm run optimize-images
```

## 📝 Édition du contenu

### Structure des fichiers Markdown

Chaque monde possède un fichier `index.md` qui contient le contenu principal du monde. Voici un exemple de structure :

```markdown
---
layout: layouts/monde.njk
title: Le Monde de l'Assemblée
monde: assemblee
---

## 🏞️ Introduction et description du lieu

Description du monde...

## 🎭 Ambiance et atmosphère

Description de l'ambiance...

::: organisateurs-only
## 🧩 Notes pour les organisateurs

Informations réservées aux organisateurs...
:::

## 📚 Histoire locale

Histoire du monde...
```

### Contenu réservé aux organisateurs

Pour ajouter du contenu visible uniquement par les organisateurs, utilisez la syntaxe suivante :

```markdown
::: organisateurs-only
Ce contenu est visible uniquement par les organisateurs.
:::
```

## 🚀 Déploiement

### Déploiement automatique

Le site peut être déployé automatiquement sur le serveur IIS à l'aide du script de déploiement :

```powershell
# Déployer le site (version joueurs uniquement)
.\scripts\deploy.ps1

# Déployer le site (avec contenu organisateurs)
.\scripts\deploy.ps1 -IncludeOrganisateurs
```

### Déploiement manuel

1. Générer le site
   ```bash
   npm run build
   ```

2. Copier le contenu du dossier `dist/` sur le serveur web

## 📋 Préparation pour la génération d'images

Pour préparer le projet pour la génération d'images par un autre agent, suivez ces étapes :

1. Exécuter le script d'identification des images manquantes
   ```powershell
   .\scripts\identify-missing-images.ps1 -GeneratePlaceholders
   ```

2. Consulter le rapport généré (`missing-images-report.md`) qui liste toutes les images manquantes

3. Fournir ce rapport à l'agent chargé de la génération d'images

## 🤝 Contribution

Pour contribuer au projet, veuillez suivre ces étapes :

1. Créer une branche pour votre fonctionnalité
2. Développer votre fonctionnalité ou correction de bug
3. Tester votre code
4. Soumettre une pull request

## 📞 Support et contact

Pour toute question ou assistance concernant le projet, veuillez contacter l'équipe de développement.
