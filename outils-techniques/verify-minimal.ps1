# Script minimal de vérification de l'état du dépôt Malvinaland

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot

# Afficher l'en-tête
Write-Host "=== Vérification de l'état du dépôt Malvinaland ===" -ForegroundColor Cyan
Write-Host "Date: $(Get-Date)" -ForegroundColor Cyan
Write-Host ""

# Étape 1: Vérifier la structure du dépôt
Write-Host "Étape 1: Vérification de la structure du dépôt..." -ForegroundColor Yellow

# Vérifier les dossiers principaux
$mainDirs = @("src", "site", "scripts", "ressources", "docs")
$missingDirs = @()

foreach ($dir in $mainDirs) {
    $dirPath = Join-Path -Path $rootPath -ChildPath $dir
    if (Test-Path $dirPath) {
        Write-Host "✓ Le dossier $dir existe" -ForegroundColor Green
    } else {
        Write-Host "✗ Le dossier $dir n'existe pas" -ForegroundColor Red
        $missingDirs += $dir
    }
}

if ($missingDirs.Count -eq 0) {
    Write-Host "✓ Tous les dossiers principaux sont présents" -ForegroundColor Green
} else {
    Write-Host "✗ Dossiers manquants: $($missingDirs -join ', ')" -ForegroundColor Red
}

# Étape 2: Vérifier les fichiers importants
Write-Host ""
Write-Host "Étape 2: Vérification des fichiers importants..." -ForegroundColor Yellow

$importantFiles = @(
    "README.md",
    "site\web.config",
    "site\index.html",
    "docs\GUIDE_DEPLOIEMENT_IIS.md",
    "scripts\README.md"
)
$missingFiles = @()

foreach ($file in $importantFiles) {
    $filePath = Join-Path -Path $rootPath -ChildPath $file
    if (Test-Path $filePath) {
        Write-Host "✓ Le fichier $file existe" -ForegroundColor Green
    } else {
        Write-Host "✗ Le fichier $file n'existe pas" -ForegroundColor Red
        $missingFiles += $file
    }
}

if ($missingFiles.Count -eq 0) {
    Write-Host "✓ Tous les fichiers importants sont présents" -ForegroundColor Green
} else {
    Write-Host "✗ Fichiers manquants: $($missingFiles -join ', ')" -ForegroundColor Red
}

# Afficher le résumé
Write-Host ""
Write-Host "=== Résumé de la vérification ===" -ForegroundColor Cyan

if ($missingDirs.Count -eq 0 -and $missingFiles.Count -eq 0) {
    Write-Host "✓ Le dépôt est propre et organisé" -ForegroundColor Green
    Write-Host "✓ Le site peut être déployé correctement sur IIS" -ForegroundColor Green
    Write-Host ""
    Write-Host "Félicitations ! Le dépôt Malvinaland est prêt pour le déploiement." -ForegroundColor Green
} else {
    Write-Host "✗ Le dépôt présente des problèmes qui doivent être corrigés" -ForegroundColor Red
    Write-Host ""
    Write-Host "Veuillez corriger les problèmes signalés avant de déployer le site." -ForegroundColor Red
}