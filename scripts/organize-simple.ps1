# Script simplifié d'organisation du dépôt Malvinaland

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot

# Fonction pour afficher les messages
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

# Fonction pour créer un dossier s'il n'existe pas
function Ensure-Directory {
    param ([string]$Path)
    
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
        Write-ColorMessage "Dossier créé: $Path" -Color Green
    }
}

# Afficher l'en-tête
Write-ColorMessage "=== Organisation du dépôt Malvinaland ===" -Color Cyan
Write-ColorMessage "Date: $(Get-Date)" -Color Cyan
Write-ColorMessage ""

# Étape 1: Créer la structure de dossiers recommandée
Write-ColorMessage "Étape 1: Création de la structure de dossiers recommandée..." -Color Yellow

# Créer les dossiers principaux
$mainDirs = @("src", "site", "scripts", "ressources", "docs")
foreach ($dir in $mainDirs) {
    $dirPath = Join-Path -Path $rootPath -ChildPath $dir
    Ensure-Directory -Path $dirPath
}

# Créer les sous-dossiers de src
$srcSubDirs = @(
    "_data",
    "_includes\layouts",
    "assets\css",
    "assets\js",
    "assets\icons",
    "assets\images",
    "content",
    "content\mondes",
    "content\organisateurs"
)

foreach ($subDir in $srcSubDirs) {
    $subDirPath = Join-Path -Path $rootPath -ChildPath "src\$subDir"
    Ensure-Directory -Path $subDirPath
}

# Créer les sous-dossiers de site
$siteSubDirs = @(
    "assets\css",
    "assets\js",
    "assets\icons",
    "assets\images",
    "content",
    "content\mondes",
    "content\organisateurs",
    "Core"
)

foreach ($subDir in $siteSubDirs) {
    $subDirPath = Join-Path -Path $rootPath -ChildPath "site\$subDir"
    Ensure-Directory -Path $subDirPath
}

# Créer les sous-dossiers de ressources
$ressourcesSubDirs = @(
    "images",
    "documents",
    "templates"
)

foreach ($subDir in $ressourcesSubDirs) {
    $subDirPath = Join-Path -Path $rootPath -ChildPath "ressources\$subDir"
    Ensure-Directory -Path $subDirPath
}

# Étape 2: Déplacer les fichiers de configuration IIS
Write-ColorMessage "Étape 2: Organisation des fichiers de configuration IIS..." -Color Yellow

# Vérifier si web.config existe à la racine
$rootWebConfig = Join-Path -Path $rootPath -ChildPath "web.config"
$siteWebConfig = Join-Path -Path $rootPath -ChildPath "site\web.config"

if (Test-Path $rootWebConfig) {
    if (-not (Test-Path $siteWebConfig)) {
        # Copier web.config vers le dossier site
        Copy-Item -Path $rootWebConfig -Destination $siteWebConfig -Force
        Write-ColorMessage "web.config copié vers site\web.config" -Color Green
    } else {
        # Comparer les deux fichiers
        $rootContent = Get-Content -Path $rootWebConfig -Raw
        $siteContent = Get-Content -Path $siteWebConfig -Raw
        
        if ($rootContent -ne $siteContent) {
            Copy-Item -Path $rootWebConfig -Destination $siteWebConfig -Force
            Write-ColorMessage "web.config mis à jour dans site\web.config" -Color Green
        } else {
            Write-ColorMessage "web.config est identique dans les deux emplacements" -Color Green
        }
    }
}

# Étape 3: Organiser les fichiers de documentation
Write-ColorMessage "Étape 3: Organisation des fichiers de documentation..." -Color Yellow

$docFiles = @(
    "README.md",
    "GUIDE_MAINTENANCE.md",
    "GUIDE_PNJ.md",
    "MOBILE_EXPERIENCE.md",
    "JOURNAL_MODIFICATIONS.md",
    "COMMENT_MODIFIER.md"
)

$docsPath = Join-Path -Path $rootPath -ChildPath "docs"

foreach ($file in $docFiles) {
    $sourcePath = Join-Path -Path $rootPath -ChildPath $file
    $destPath = Join-Path -Path $docsPath -ChildPath $file
    
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        Write-ColorMessage "$file copié vers docs\" -Color Green
    }
}

# Créer un README.md principal à la racine
$mainReadmePath = Join-Path -Path $rootPath -ChildPath "README.md"
$mainReadmeContent = @'
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

## Déploiement IIS

Le site est configuré pour être déployé sur IIS. Utilisez les scripts suivants pour le déploiement :

- scripts/deploy-iis-improved.ps1 : Script de déploiement amélioré
- scripts/deploy-iis-admin.ps1 : Script de déploiement pour les administrateurs

## Maintenance

Pour nettoyer et organiser le dépôt :

- scripts/clean-repository.ps1 : Nettoyage général du dépôt
- scripts/clean-temp-files.ps1 : Suppression des fichiers temporaires et doublons
- scripts/organize-repository.ps1 : Organisation des fichiers selon la structure recommandée
'@

Set-Content -Path $mainReadmePath -Value $mainReadmeContent -Force
Write-ColorMessage "README.md principal créé/mis à jour" -Color Green

# Étape 4: Organiser les fichiers de scripts
Write-ColorMessage "Étape 4: Organisation des fichiers de scripts..." -Color Yellow

# Créer un README.md pour le dossier scripts
$scriptsReadmePath = Join-Path -Path $rootPath -ChildPath "scripts\README.md"
$scriptsReadmeContent = @'
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
'@

Set-Content -Path $scriptsReadmePath -Value $scriptsReadmeContent -Force
Write-ColorMessage "README.md pour scripts créé/mis à jour" -Color Green

# Étape 5: Vérifier la structure finale
Write-ColorMessage "Étape 5: Vérification de la structure finale..." -Color Yellow

$missingDirs = @()
foreach ($dir in $mainDirs) {
    $dirPath = Join-Path -Path $rootPath -ChildPath $dir
    if (-not (Test-Path $dirPath)) {
        $missingDirs += $dir
    }
}

if ($missingDirs.Count -gt 0) {
    Write-ColorMessage "Dossiers manquants: $($missingDirs -join ', ')" -Color Yellow
} else {
    Write-ColorMessage "Tous les dossiers principaux sont présents" -Color Green
}

Write-ColorMessage ""
Write-ColorMessage "=== Organisation terminée ===" -Color Cyan
Write-ColorMessage "Le dépôt a été organisé selon la structure recommandée." -Color Green