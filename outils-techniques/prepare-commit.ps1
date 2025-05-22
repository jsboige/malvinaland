# Script de préparation pour le commit final de Malvinaland
# Ce script exécute les différentes étapes de nettoyage et de préparation,
# puis génère un message de commit descriptif

param (
    [switch]$Execute = $false
)

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot
$commitMessagePath = Join-Path -Path $rootPath -ChildPath "commit-message.txt"

# Fonction pour afficher les messages
function Write-Step {
    param ([string]$Message)
    Write-Host "=== $Message ===" -ForegroundColor Cyan
}

# Vérifier si Git est installé
try {
    $gitVersion = git --version
    Write-Host "Git version: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "Git n'est pas installé ou n'est pas dans le PATH. Veuillez installer Git." -ForegroundColor Red
    exit 1
}

# Étape 1: Nettoyer le dépôt
Write-Step "Nettoyage du dépôt"
if ($Execute) {
    & "$PSScriptRoot\clean-repository.ps1" -Execute
} else {
    & "$PSScriptRoot\clean-repository.ps1"
    Write-Host "Mode simulation. Pour exécuter réellement le nettoyage, utilisez le paramètre -Execute" -ForegroundColor Yellow
}

# Étape 2: Identifier les images manquantes
Write-Step "Identification des images manquantes"
& "$PSScriptRoot\identify-missing-images.ps1" -GeneratePlaceholders

# Étape 3: Optimiser les images existantes
Write-Step "Optimisation des images"
npm run optimize-images

# Étape 4: Générer le site
Write-Step "Génération du site"
npm run build

# Étape 5: Préparer le message de commit
Write-Step "Préparation du message de commit"

$commitMessage = @"
🧹 Nettoyage du dépôt et préparation pour le commit final

## Résumé des modifications
- Migration vers une architecture basée sur 11ty (Eleventy)
- Nettoyage des fichiers obsolètes et redondants
- Préparation pour la génération d'images
- Mise à jour de la documentation

## Détails techniques
- Création de scripts de nettoyage et d'identification des images manquantes
- Mise à jour du fichier .gitignore
- Création de placeholders pour les images manquantes
- Optimisation des images existantes

## Mondes migrés
- Le Monde de l'Assemblée
- Le Monde de la Grange
- Le Monde des Jeux
- Le Monde des Rêves

## Prochaines étapes
- Génération des images manquantes
- Migration des mondes restants
- Déploiement sur le serveur de production

Ce commit a été préparé automatiquement par le script prepare-commit.ps1.
"@

Set-Content -Path $commitMessagePath -Value $commitMessage
Write-Host "Message de commit généré: $commitMessagePath" -ForegroundColor Green

# Étape 6: Afficher les instructions pour le commit
Write-Step "Instructions pour le commit"
Write-Host "Pour finaliser le commit, exécutez les commandes suivantes:" -ForegroundColor Yellow
Write-Host "git add ." -ForegroundColor White
Write-Host "git commit -F commit-message.txt" -ForegroundColor White
Write-Host "git push" -ForegroundColor White

# Étape 7: Exécuter les commandes Git si demandé
if ($Execute) {
    Write-Step "Exécution des commandes Git"
    
    $confirmation = Read-Host "Voulez-vous exécuter les commandes Git maintenant? (O/N)"
    if ($confirmation -eq "O") {
        git add .
        git commit -F $commitMessagePath
        
        $pushConfirmation = Read-Host "Voulez-vous également pousser les modifications vers le dépôt distant? (O/N)"
        if ($pushConfirmation -eq "O") {
            git push
            Write-Host "Les modifications ont été poussées vers le dépôt distant." -ForegroundColor Green
        } else {
            Write-Host "Les modifications ont été committées localement. Utilisez 'git push' pour les pousser vers le dépôt distant." -ForegroundColor Yellow
        }
    } else {
        Write-Host "Les commandes Git n'ont pas été exécutées. Vous pouvez les exécuter manuellement plus tard." -ForegroundColor Yellow
    }
}

Write-Step "Opération terminée"
Write-Host "Le dépôt est prêt pour le commit final." -ForegroundColor Green