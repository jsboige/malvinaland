# Script de nettoyage du dépôt Malvinaland
# Ce script identifie les fichiers essentiels à la nouvelle architecture,
# déplace les fichiers obsolètes dans un dossier d'archive et prépare le dépôt pour le commit final

param (
    [switch]$Execute = $false,
    [switch]$Force = $false
)

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot
$archivePath = Join-Path -Path $rootPath -ChildPath "archive"
$reportPath = Join-Path -Path $rootPath -ChildPath "cleanup-report.csv"
$placeholderPath = Join-Path -Path $rootPath -ChildPath "src\assets\images\placeholders"

# Fonction pour afficher les messages
function Write-Step {
    param ([string]$Message)
    Write-Host "=== $Message ===" -ForegroundColor Cyan
}

# Fonction pour créer un dossier s'il n'existe pas
function Ensure-Directory {
    param ([string]$Path)
    
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
        Write-Host "Dossier créé: $Path" -ForegroundColor Green
    }
}

# Créer les dossiers nécessaires
Ensure-Directory -Path $archivePath
Ensure-Directory -Path $placeholderPath

# Définir les fichiers et dossiers essentiels à la nouvelle architecture
$essentialPaths = @(
    ".eleventy.js",
    ".gitignore",
    "package.json",
    "package-lock.json",
    "README.md",
    "scripts\deploy.ps1",
    "scripts\optimize-images.js",
    "scripts\clean-repository.ps1",
    "src",
    "web.config"
)

# Définir les dossiers à archiver (contenu ancien mais potentiellement utile)
$archivePaths = @(
    "Mondes",
    "Core",
    "docs",
    "Narration",
    "Prompts",
    "Tests",
    "Installation",
    "Cartes"
)

# Définir les fichiers à supprimer (temporaires, builds, etc.)
$deletePaths = @(
    "dist",
    "node_modules",
    "Site",
    "-Force",
    "*.log",
    "*.tmp",
    "*.temp",
    "*.bak"
)

# Définir les fichiers de documentation à conserver
$documentationFiles = @(
    "ARCHITECTURE_MALVINALAND.md",
    "README_NOUVELLE_ARCHITECTURE.md",
    "DOCUMENTATION.md",
    "GUIDE_DEVELOPPEMENT.md"
)

# Étape 1: Analyser les fichiers du dépôt
Write-Step "Analyse des fichiers du dépôt"

$allFiles = Get-ChildItem -Path $rootPath -Recurse -File | 
    Where-Object { 
        -not $_.FullName.Contains("node_modules") -and 
        -not $_.FullName.Contains("dist") -and
        -not $_.FullName.Contains("archive") -and
        -not $_.FullName.Contains(".git")
    }

$allDirectories = Get-ChildItem -Path $rootPath -Directory | 
    Where-Object { 
        -not $_.FullName.Contains("node_modules") -and 
        -not $_.FullName.Contains("dist") -and
        -not $_.FullName.Contains("archive") -and
        -not $_.FullName.Contains(".git")
    }

Write-Host "Nombre total de fichiers: $($allFiles.Count)" -ForegroundColor Yellow
Write-Host "Nombre total de dossiers: $($allDirectories.Count)" -ForegroundColor Yellow

# Étape 2: Identifier les mondes migrés et non migrés
Write-Step "Identification des mondes migrés et non migrés"

$migratedWorlds = @("assemblee", "grange", "jeux", "reves")
$allWorlds = Get-ChildItem -Path (Join-Path -Path $rootPath -ChildPath "Mondes") -Directory | ForEach-Object { $_.Name.ToLower().Replace("le monde ", "").Replace("le monde de ", "").Replace("le monde du ", "").Replace("le monde des ", "") }

$nonMigratedWorlds = $allWorlds | Where-Object { $migratedWorlds -notcontains $_ }

Write-Host "Mondes migrés: $($migratedWorlds -join ", ")" -ForegroundColor Green
Write-Host "Mondes non migrés: $($nonMigratedWorlds -join ", ")" -ForegroundColor Yellow

# Étape 3: Créer le rapport de nettoyage
Write-Step "Création du rapport de nettoyage"

$report = @()

foreach ($file in $allFiles) {
    $relativePath = $file.FullName.Substring($rootPath.Length + 1)
    $action = "Archive"  # Par défaut, archiver
    
    # Vérifier si le fichier est essentiel
    foreach ($path in $essentialPaths) {
        if ($relativePath -like "$path*") {
            $action = "Keep"
            break
        }
    }
    
    # Vérifier si le fichier est à supprimer
    foreach ($path in $deletePaths) {
        if ($relativePath -like "$path*") {
            $action = "Delete"
            break
        }
    }
    
    # Vérifier si le fichier est un document à conserver
    foreach ($doc in $documentationFiles) {
        if ($relativePath -eq $doc) {
            $action = "Keep"
            break
        }
    }
    
    $report += [PSCustomObject]@{
        Path = $relativePath
        Size = $file.Length
        LastModified = $file.LastWriteTime
        Action = $action
    }
}

# Exporter le rapport
$report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding UTF8
Write-Host "Rapport de nettoyage généré: $reportPath" -ForegroundColor Green

# Étape 4: Exécuter les actions si demandé
if ($Execute) {
    Write-Step "Exécution des actions de nettoyage"
    
    if (-not $Force) {
        $confirmation = Read-Host "Cette opération va archiver et supprimer des fichiers. Continuer? (O/N)"
        if ($confirmation -ne "O") {
            Write-Host "Opération annulée." -ForegroundColor Red
            exit
        }
    }
    
    # Traiter chaque fichier selon l'action définie
    foreach ($item in $report) {
        $fullPath = Join-Path -Path $rootPath -ChildPath $item.Path
        
        switch ($item.Action) {
            "Keep" {
                Write-Host "Conservation: $($item.Path)" -ForegroundColor Green
            }
            "Archive" {
                $archiveFilePath = Join-Path -Path $archivePath -ChildPath $item.Path
                $archiveFileDir = Split-Path -Parent $archiveFilePath
                
                if (-not (Test-Path $archiveFileDir)) {
                    New-Item -Path $archiveFileDir -ItemType Directory -Force | Out-Null
                }
                
                try {
                    Copy-Item -Path $fullPath -Destination $archiveFilePath -Force
                    Remove-Item -Path $fullPath -Force
                    Write-Host "Archivé: $($item.Path)" -ForegroundColor Yellow
                } catch {
                    Write-Host "Erreur lors de l'archivage de $($item.Path): $_" -ForegroundColor Red
                }
            }
            "Delete" {
                try {
                    if (Test-Path $fullPath) {
                        Remove-Item -Path $fullPath -Force
                        Write-Host "Supprimé: $($item.Path)" -ForegroundColor Red
                    }
                } catch {
                    Write-Host "Erreur lors de la suppression de $($item.Path): $_" -ForegroundColor Red
                }
            }
        }
    }
    
    # Nettoyer les dossiers vides
    Write-Host "Nettoyage des dossiers vides..." -ForegroundColor Yellow
    Get-ChildItem -Path $rootPath -Directory -Recurse | 
        Where-Object { 
            -not $_.FullName.Contains("node_modules") -and 
            -not $_.FullName.Contains("dist") -and
            -not $_.FullName.Contains("archive") -and
            -not $_.FullName.Contains(".git") -and
            (Get-ChildItem -Path $_.FullName -Recurse -File).Count -eq 0
        } | 
        Sort-Object -Property FullName -Descending | 
        ForEach-Object {
            try {
                Remove-Item -Path $_.FullName -Force
                Write-Host "Dossier vide supprimé: $($_.FullName.Substring($rootPath.Length + 1))" -ForegroundColor Yellow
            } catch {
                Write-Host "Erreur lors de la suppression du dossier vide $($_.FullName.Substring($rootPath.Length + 1)): $_" -ForegroundColor Red
            }
        }
} else {
    Write-Host "Mode simulation. Aucune action n'a été exécutée." -ForegroundColor Yellow
    Write-Host "Pour exécuter les actions, utilisez le paramètre -Execute" -ForegroundColor Yellow
    Write-Host "Exemple: .\scripts\clean-repository.ps1 -Execute" -ForegroundColor Yellow
}

# Étape 5: Créer des placeholders pour les images manquantes
Write-Step "Création des placeholders pour les images manquantes"

# Créer un placeholder pour chaque monde
foreach ($monde in $migratedWorlds) {
    $mondePlaceholderDir = Join-Path -Path $placeholderPath -ChildPath $monde
    Ensure-Directory -Path $mondePlaceholderDir
    
    # Créer un placeholder générique pour le monde
    $placeholderContent = @"
<svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">
    <rect width="100%" height="100%" fill="#f0f0f0"/>
    <text x="50%" y="50%" font-family="Arial" font-size="48" text-anchor="middle" dominant-baseline="middle" fill="#333">
        Image placeholder: $monde
    </text>
</svg>
"@
    
    $placeholderFile = Join-Path -Path $mondePlaceholderDir -ChildPath "placeholder.svg"
    Set-Content -Path $placeholderFile -Value $placeholderContent
    Write-Host "Placeholder créé: $placeholderFile" -ForegroundColor Green
}

Write-Step "Opération terminée"
Write-Host "Le rapport de nettoyage est disponible ici: $reportPath" -ForegroundColor Green
Write-Host "Les fichiers archivés sont disponibles ici: $archivePath" -ForegroundColor Green
Write-Host "Les placeholders pour les images sont disponibles ici: $placeholderPath" -ForegroundColor Green

if (-not $Execute) {
    Write-Host "Pour exécuter les actions de nettoyage, relancez le script avec le paramètre -Execute" -ForegroundColor Yellow
}