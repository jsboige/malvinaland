# Nettoyage du Dépôt Malvinaland

Ce document identifie les fichiers obsolètes ou redondants dans le projet Malvinaland et propose une organisation optimale des fichiers pour l'avenir.

## Table des matières

1. [Fichiers obsolètes ou redondants](#fichiers-obsolètes-ou-redondants)
2. [Organisation optimale des fichiers](#organisation-optimale-des-fichiers)
3. [Plan d'action pour le nettoyage](#plan-daction-pour-le-nettoyage)

## Fichiers obsolètes ou redondants

Après analyse de la structure du projet, les fichiers et dossiers suivants ont été identifiés comme obsolètes ou redondants :

### Fichiers redondants entre la racine et le dossier `Site/`

| Fichier à la racine | Fichier dupliqué | Recommandation |
|---------------------|------------------|----------------|
| `index.html` | `Site/index.html` | Conserver uniquement `Site/index.html` |
| `web.config` | `Site/web.config` | Conserver uniquement `Site/web.config` |
| `Core/mondes-config.js` | `Site/Core/mondes-config.js` | Conserver uniquement `Site/Core/mondes-config.js` |
| `Core/navigation.js` | `Site/Core/navigation.js` | Conserver uniquement `Site/Core/navigation.js` |

### Documentation dupliquée

| Fichier | Fichier dupliqué | Recommandation |
|---------|------------------|----------------|
| `README.md` | `docs/README.md` | Fusionner en un seul fichier à la racine |
| `README_ORGANISATION.md` | `docs/README_ORGANISATION.md` | Intégrer dans `DOCUMENTATION.md` |
| `guide_creation_prompts.md` | `docs/guide_creation_prompts.md` | Conserver uniquement dans `docs/` |
| `guide_installation.md` | `docs/guide_installation.md` | Intégrer dans `DOCUMENTATION.md` |
| `prompt_enrichissement_monde.md` | `docs/prompt_enrichissement_monde.md` | Conserver uniquement dans `docs/` |
| `prompts_site_web.md` | `docs/prompts_site_web.md` | Conserver uniquement dans `docs/` |
| `blocs_taches_mondes.md` | `docs/blocs_taches_mondes.md` | Conserver uniquement dans `docs/` |

### Fichiers README redondants dans les mondes

| Dossier | Fichier | Recommandation |
|---------|---------|----------------|
| `Mondes/Le monde de l'assemblée/README.md` | `Site/Mondes/Le monde de l'assemblée/index.html` | Intégrer le contenu du README dans la page HTML |
| `Mondes/Le monde de la grange/README.md` | `Site/Mondes/Le monde de la grange/index.html` | Intégrer le contenu du README dans la page HTML |
| `Mondes/Le monde des jeux/README.md` | `Site/Mondes/Le monde des jeux/index.html` | Intégrer le contenu du README dans la page HTML |
| `Mondes/Le monde des rêves/README.md` | `Site/Mondes/Le monde des rêves/index.html` | Intégrer le contenu du README dans la page HTML |
| `Mondes/Le monde du damier/README.md` | `Site/Mondes/Le monde du damier/index.html` | Intégrer le contenu du README dans la page HTML |
| `Mondes/Le monde du linge/README.md` | `Site/Mondes/Le monde du linge/index.html` | Intégrer le contenu du README dans la page HTML |
| `Mondes/Le monde du verger/README.md` | `Site/Mondes/Le monde du verger/index.html` | Intégrer le contenu du README dans la page HTML |
| `Mondes/Le monde du Zob/README.md` | `Site/Mondes/Le monde du Zob/index.html` | Intégrer le contenu du README dans la page HTML |
| `Mondes/Le monde Elysée/README.md` | `Site/Mondes/Le monde Elysée/index.html` | Intégrer le contenu du README dans la page HTML |
| `Mondes/Le monde Karibu/README.md` | `Site/Mondes/Le monde Karibu/index.html` | Intégrer le contenu du README dans la page HTML |
| `Mondes/Le monde orange des Sphinx/README.md` | `Site/Mondes/Le monde orange des Sphinx/index.html` | Intégrer le contenu du README dans la page HTML |

### Fichiers de configuration redondants

| Fichier | Fichier dupliqué | Recommandation |
|---------|------------------|----------------|
| `Mondes/web.config` | `Site/Mondes/web.config` | Conserver uniquement `Site/Mondes/web.config` |

### Fichiers potentiellement obsolètes

| Fichier | Raison | Recommandation |
|---------|--------|----------------|
| `matériel.md` | Semble être une documentation de travail | Archiver dans `docs/archive/` |
| `Mondes/Le monde des jeux/guide_installation.md` | Redondant avec `guide_installation.md` | Supprimer ou intégrer dans la documentation principale |
| `Mondes/Le monde des rêves/prompt_monde_des_reves.md` | Document de travail | Archiver dans `docs/Prompts/` |
| `Mondes/Le monde du verger/prompt_monde_du_verger.md` | Document de travail | Archiver dans `docs/Prompts/` |

## Organisation optimale des fichiers

Pour optimiser l'organisation des fichiers du projet, voici une structure recommandée :

```
malvinaland/
│
├── site/                           # Site web déployable (léger)
│   ├── index.html                  # Page de redirection vers Core/index.html
│   ├── web.config                  # Configuration IIS
│   ├── app.js                      # Script JavaScript principal
│   ├── carte.html                  # Page de la carte interactive
│   │
│   ├── Core/                       # Configuration et navigation communes
│   │   ├── mondes-config.js
│   │   ├── navigation.js
│   │   ├── image-loader.js
│   │   ├── index.html
│   │   └── styles.css
│   │
│   ├── Composants/                 # Composants réutilisables
│   │   └── styles.css
│   │
│   ├── Mondes/                     # Structure légère des mondes
│   │   ├── Carte de Malvinaland stylisée.png
│   │   ├── web.config
│   │   ├── monde-commun.css        # Styles communs à tous les mondes
│   │   ├── monde-commun.js         # Scripts communs à tous les mondes
│   │   ├── monde-mobile.css        # Styles spécifiques pour mobile
│   │   ├── monde-navigation.js     # Navigation spécifique aux mondes
│   │   │
│   │   ├── Le monde de l'assemblée/
│   │   │   ├── index.html
│   │   │   ├── script.js
│   │   │   ├── styles.css
│   │   │   └── thumbnails/
│   │   │
│   │   └── [Autres mondes...]
│   │
│   ├── PNJ/                        # Personnages non-joueurs
│   │   ├── index.html
│   │   ├── pnj-script.js
│   │   ├── pnj-styles.css
│   │   └── [Pages spécifiques aux PNJ]
│   │
│   └── Services/                   # Service worker pour le fonctionnement hors ligne
│       ├── serviceWorker.js
│       └── sw.js
│
├── ressources/                     # Ressources volumineuses (non déployées)
│   └── images/                     # Images haute résolution
│       ├── Le monde de l'assemblée/
│       ├── Le monde de la grange/
│       └── [Autres mondes...]
│
├── docs/                           # Documentation et fichiers de développement
│   ├── Cartes/                     # Documentation sur la carte
│   ├── Narration/                  # Documentation sur la narration
│   ├── Prompts/                    # Prompts pour la génération de contenu
│   └── archive/                    # Documents archivés
│
├── scripts/                        # Scripts de déploiement et d'automatisation
│   ├── deploy.ps1                  # Script de déploiement principal
│   ├── test-iis-deployment.ps1     # Script de test du déploiement IIS
│   └── fix-iis-deployment.ps1      # Script de correction du déploiement IIS
│
├── Tests/                          # Tests automatisés
│   ├── browser-tests/              # Tests de navigateur
│   ├── content-tests/              # Tests de contenu
│   ├── jinavigator-tests/          # Tests spécifiques
│   └── reports/                    # Rapports de tests
│
├── DOCUMENTATION.md                # Documentation principale
├── GUIDE_DEVELOPPEMENT.md          # Guide de développement
├── AMELIORATIONS.md                # Résumé des améliorations
├── NETTOYAGE.md                    # Recommandations de nettoyage
└── README.md                       # Présentation du projet
```

Cette structure présente plusieurs avantages :

1. **Séparation claire des préoccupations** : Le site déployable, les ressources volumineuses et la documentation sont clairement séparés.
2. **Organisation modulaire** : Chaque partie du site est organisée dans son propre dossier avec une structure cohérente.
3. **Réduction de la duplication** : Les fichiers redondants sont éliminés ou consolidés.
4. **Facilité de maintenance** : La structure est plus intuitive et plus facile à maintenir.
5. **Meilleure évolutivité** : La structure est conçue pour faciliter l'ajout de nouveaux mondes ou fonctionnalités.

## Plan d'action pour le nettoyage

Voici un plan d'action en plusieurs étapes pour nettoyer le dépôt :

### Étape 1 : Sauvegarde

1. Créer une branche de sauvegarde du dépôt actuel
2. Créer une archive ZIP du dépôt actuel comme sauvegarde supplémentaire

### Étape 2 : Consolidation de la documentation

1. Créer les nouveaux fichiers de documentation (`DOCUMENTATION.md`, `GUIDE_DEVELOPPEMENT.md`, `AMELIORATIONS.md`, `NETTOYAGE.md`)
2. Fusionner le contenu des fichiers README redondants
3. Déplacer les documents de travail dans le dossier `docs/archive/`

### Étape 3 : Réorganisation des fichiers

1. Créer la nouvelle structure de dossiers
2. Déplacer les fichiers vers leurs nouveaux emplacements
3. Mettre à jour les références dans les fichiers

### Étape 4 : Suppression des fichiers redondants

1. Identifier tous les fichiers qui ont été consolidés ou déplacés
2. Supprimer ces fichiers après avoir vérifié qu'ils ne sont plus nécessaires

### Étape 5 : Mise à jour des scripts de déploiement

1. Mettre à jour le script `deploy.ps1` pour qu'il utilise la nouvelle structure
2. Mettre à jour les scripts `test-iis-deployment.ps1` et `fix-iis-deployment.ps1` si nécessaire

### Étape 6 : Tests

1. Tester le site localement pour s'assurer que tout fonctionne correctement
2. Tester le processus de déploiement avec la nouvelle structure
3. Vérifier que toutes les fonctionnalités du site fonctionnent comme prévu

### Étape 7 : Documentation des changements

1. Mettre à jour le fichier README.md pour refléter la nouvelle structure
2. Documenter les changements effectués dans un journal de modifications
3. Mettre à jour la documentation avec les nouvelles informations

### Étape 8 : Déploiement

1. Déployer la nouvelle version du site
2. Surveiller le site pour détecter d'éventuels problèmes
3. Corriger les problèmes identifiés

### Script PowerShell pour automatiser le nettoyage

Voici un exemple de script PowerShell qui pourrait être utilisé pour automatiser une partie du processus de nettoyage :

```powershell
# Script de nettoyage du dépôt Malvinaland
# Ce script automatise le processus de nettoyage du dépôt

# Fonction pour afficher un message coloré
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

# Fonction pour créer un dossier s'il n'existe pas
function EnsureFolderExists {
    param (
        [string]$folderPath
    )
    
    if (-not (Test-Path -Path $folderPath)) {
        New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
        Write-ColorMessage "Dossier créé: $folderPath" -Color Green
    }
}

# Fonction pour déplacer un fichier et mettre à jour les références
function MoveFileAndUpdateReferences {
    param (
        [string]$sourcePath,
        [string]$destinationPath
    )
    
    if (Test-Path -Path $sourcePath) {
        # Créer le dossier de destination s'il n'existe pas
        $destinationFolder = Split-Path -Path $destinationPath -Parent
        EnsureFolderExists -folderPath $destinationFolder
        
        # Déplacer le fichier
        Move-Item -Path $sourcePath -Destination $destinationPath -Force
        Write-ColorMessage "Fichier déplacé: $sourcePath -> $destinationPath" -Color Green
    }
    else {
        Write-ColorMessage "Fichier source introuvable: $sourcePath" -Color Yellow
    }
}

# Fonction pour archiver un fichier
function ArchiveFile {
    param (
        [string]$sourcePath,
        [string]$archiveFolder
    )
    
    if (Test-Path -Path $sourcePath) {
        # Créer le dossier d'archive s'il n'existe pas
        EnsureFolderExists -folderPath $archiveFolder
        
        # Obtenir le nom du fichier
        $fileName = Split-Path -Path $sourcePath -Leaf
        
        # Déplacer le fichier vers le dossier d'archive
        Move-Item -Path $sourcePath -Destination "$archiveFolder\$fileName" -Force
        Write-ColorMessage "Fichier archivé: $sourcePath -> $archiveFolder\$fileName" -Color Green
    }
    else {
        Write-ColorMessage "Fichier source introuvable: $sourcePath" -Color Yellow
    }
}

# Définition des chemins
$rootPath = $PSScriptRoot
$docsPath = Join-Path -Path $rootPath -ChildPath "docs"
$archivePath = Join-Path -Path $docsPath -ChildPath "archive"
$scriptsPath = Join-Path -Path $rootPath -ChildPath "scripts"

# Afficher un en-tête
Write-ColorMessage "=== Script de nettoyage du dépôt Malvinaland ===" -Color Cyan
Write-ColorMessage "Date: $(Get-Date)" -Color Cyan
Write-ColorMessage ""

# Étape 1 : Créer les dossiers nécessaires
Write-ColorMessage "Étape 1 : Création des dossiers nécessaires..." -Color Yellow
EnsureFolderExists -folderPath $docsPath
EnsureFolderExists -folderPath $archivePath
EnsureFolderExists -folderPath $scriptsPath

# Étape 2 : Déplacer les scripts de déploiement
Write-ColorMessage "Étape 2 : Déplacement des scripts de déploiement..." -Color Yellow
MoveFileAndUpdateReferences -sourcePath "$rootPath\deploy.ps1" -destinationPath "$scriptsPath\deploy.ps1"
MoveFileAndUpdateReferences -sourcePath "$rootPath\test-iis-deployment.ps1" -destinationPath "$scriptsPath\test-iis-deployment.ps1"
MoveFileAndUpdateReferences -sourcePath "$rootPath\fix-iis-deployment.ps1" -destinationPath "$scriptsPath\fix-iis-deployment.ps1"

# Étape 3 : Archiver les fichiers obsolètes
Write-ColorMessage "Étape 3 : Archivage des fichiers obsolètes..." -Color Yellow
ArchiveFile -sourcePath "$rootPath\matériel.md" -archiveFolder $archivePath
ArchiveFile -sourcePath "$rootPath\Mondes\Le monde des jeux\guide_installation.md" -archiveFolder "$archivePath\Mondes"
ArchiveFile -sourcePath "$rootPath\Mondes\Le monde des rêves\prompt_monde_des_reves.md" -archiveFolder "$docsPath\Prompts"
ArchiveFile -sourcePath "$rootPath\Mondes\Le monde du verger\prompt_monde_du_verger.md" -archiveFolder "$docsPath\Prompts"

# Étape 4 : Supprimer les fichiers redondants
Write-ColorMessage "Étape 4 : Suppression des fichiers redondants..." -Color Yellow
$redundantFiles = @(
    "$rootPath\index.html",
    "$rootPath\web.config",
    "$rootPath\README_ORGANISATION.md"
)

foreach ($file in $redundantFiles) {
    if (Test-Path -Path $file) {
        Remove-Item -Path $file -Force
        Write-ColorMessage "Fichier supprimé: $file" -Color Green
    }
    else {
        Write-ColorMessage "Fichier introuvable: $file" -Color Yellow
    }
}

# Afficher un message de fin
Write-ColorMessage ""
Write-ColorMessage "=== Nettoyage terminé ===" -Color Cyan
Write-ColorMessage "Le dépôt a été nettoyé selon les recommandations." -Color Cyan
Write-ColorMessage "Veuillez vérifier que tout fonctionne correctement avant de valider les changements." -Color Cyan
```

Ce script peut être adapté en fonction des besoins spécifiques du projet et des fichiers à nettoyer.