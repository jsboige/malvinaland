# Script de nettoyage des fichiers temporaires et doublons
# Ce script identifie et supprime les fichiers temporaires et les doublons dans le dépôt Malvinaland

param (
    [switch]$Execute = $false,
    [switch]$Force = $false
)

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot
$logPath = Join-Path -Path $rootPath -ChildPath "cleanup-logs"
$logFile = Join-Path -Path $logPath -ChildPath "temp-files-cleanup-$(Get-Date -Format 'yyyy-MM-dd_HH-mm').log"

# Fonction pour afficher les messages
function Write-Log {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
    Add-Content -Path $logFile -Value $Message
}

# Créer le dossier de logs s'il n'existe pas
if (-not (Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType Directory -Force | Out-Null
    Write-Log "Dossier de logs créé: $logPath" -Color Green
}

# Afficher l'en-tête
Write-Log "=== Nettoyage des fichiers temporaires et doublons ===" -Color Cyan
Write-Log "Date: $(Get-Date)" -Color Cyan
Write-Log ""

# Définir les extensions de fichiers temporaires
$tempExtensions = @(
    "*.tmp",
    "*.temp",
    "*.bak",
    "*.swp",
    "*.log",
    "*.cache"
)

# Définir les motifs de noms de fichiers temporaires
$tempPatterns = @(
    "*_temp_*",
    "*_old_*",
    "*_backup_*",
    "*_bak_*",
    "*_copy_*",
    "*_copie_*",
    "*_double_*",
    "*_doublon_*",
    "*_test_*",
    "*_essai_*"
)

# Étape 1: Identifier les fichiers temporaires
Write-Log "Étape 1: Identification des fichiers temporaires..." -Color Yellow

$tempFiles = @()

# Rechercher par extension
foreach ($ext in $tempExtensions) {
    $files = Get-ChildItem -Path $rootPath -Filter $ext -Recurse -File | 
        Where-Object { 
            -not $_.FullName.Contains("node_modules") -and 
            -not $_.FullName.Contains("dist") -and
            -not $_.FullName.Contains("archive") -and
            -not $_.FullName.Contains(".git") -and
            -not $_.FullName.Contains("backup-before-cleanup")
        }
    
    $tempFiles += $files
}

# Rechercher par motif de nom
foreach ($pattern in $tempPatterns) {
    $files = Get-ChildItem -Path $rootPath -Filter $pattern -Recurse -File | 
        Where-Object { 
            -not $_.FullName.Contains("node_modules") -and 
            -not $_.FullName.Contains("dist") -and
            -not $_.FullName.Contains("archive") -and
            -not $_.FullName.Contains(".git") -and
            -not $_.FullName.Contains("backup-before-cleanup")
        }
    
    $tempFiles += $files
}

# Éliminer les doublons
$tempFiles = $tempFiles | Sort-Object -Property FullName -Unique

Write-Log "Nombre de fichiers temporaires identifiés: $($tempFiles.Count)" -Color Yellow

# Étape 2: Identifier les doublons
Write-Log "Étape 2: Identification des doublons..." -Color Yellow

$allFiles = Get-ChildItem -Path $rootPath -Recurse -File |
    Where-Object {
        -not $_.FullName.Contains("node_modules") -and
        -not $_.FullName.Contains("dist") -and
        -not $_.FullName.Contains("archive") -and
        -not $_.FullName.Contains(".git") -and
        -not $_.FullName.Contains("backup-before-cleanup") -and
        -not $_.FullName.Contains("cleanup-logs")
    }

$fileHashes = @{}
$duplicateFiles = @()

foreach ($file in $allFiles) {
    # Ignorer les fichiers de taille nulle (placeholders)
    if ($file.Length -eq 0) {
        continue
    }
    
    # Ignorer les doublons entre src et site (structure normale)
    $relativePath = $file.FullName.Substring($rootPath.Length + 1)
    if ($relativePath -match "^src[\\/]" -and (Test-Path (Join-Path -Path $rootPath -ChildPath $relativePath.Replace("src\", "site\")))) {
        continue
    }
    if ($relativePath -match "^site[\\/]" -and (Test-Path (Join-Path -Path $rootPath -ChildPath $relativePath.Replace("site\", "src\")))) {
        continue
    }
    
    # Calculer le hash du fichier
    $hash = Get-FileHash -Path $file.FullName -Algorithm MD5
    
    # Vérifier si le hash existe déjà
    if ($fileHashes.ContainsKey($hash.Hash)) {
        # Vérifier si l'un des fichiers est dans src et l'autre dans site
        $originalPath = $fileHashes[$hash.Hash]
        $originalRelativePath = $originalPath.Substring($rootPath.Length + 1)
        
        if (($relativePath -match "^src[\\/]" -and $originalRelativePath -match "^site[\\/]") -or
            ($relativePath -match "^site[\\/]" -and $originalRelativePath -match "^src[\\/]")) {
            continue
        }
        
        # C'est un doublon
        $duplicateFiles += [PSCustomObject]@{
            Path = $file.FullName
            OriginalPath = $originalPath
            Hash = $hash.Hash
            Size = $file.Length
        }
    } else {
        # Ajouter le hash à la liste
        $fileHashes[$hash.Hash] = $file.FullName
    }
}

Write-Log "Nombre de doublons identifiés: $($duplicateFiles.Count)" -Color Yellow

# Étape 3: Afficher les fichiers à supprimer
Write-Log "Étape 3: Liste des fichiers à supprimer..." -Color Yellow

Write-Log "Fichiers temporaires:" -Color Yellow
foreach ($file in $tempFiles) {
    $relativePath = $file.FullName.Substring($rootPath.Length + 1)
    Write-Log "  - $relativePath ($($file.Length) octets)" -Color Yellow
}

Write-Log "Fichiers en double:" -Color Yellow
foreach ($file in $duplicateFiles) {
    $relativePath = $file.Path.Substring($rootPath.Length + 1)
    $relativeOriginalPath = $file.OriginalPath.Substring($rootPath.Length + 1)
    Write-Log "  - $relativePath ($($file.Size) octets) - Doublon de: $relativeOriginalPath" -Color Yellow
}

# Étape 4: Supprimer les fichiers si demandé
if ($Execute) {
    Write-Log "Étape 4: Suppression des fichiers..." -Color Yellow
    
    if (-not $Force) {
        $confirmation = Read-Host "Cette opération va supprimer les fichiers temporaires et les doublons. Continuer? (O/N)"
        if ($confirmation -ne "O") {
            Write-Log "Opération annulée." -Color Red
            exit
        }
    }
    
    # Supprimer les fichiers temporaires
    foreach ($file in $tempFiles) {
        $relativePath = $file.FullName.Substring($rootPath.Length + 1)
        try {
            Remove-Item -Path $file.FullName -Force
            Write-Log "✓ Fichier temporaire supprimé: $relativePath" -Color Green
        } catch {
            Write-Log "✗ Erreur lors de la suppression du fichier temporaire $relativePath : $($_.Exception.Message)" -Color Red
        }
    }
    
    # Supprimer les doublons
    foreach ($file in $duplicateFiles) {
        $relativePath = $file.Path.Substring($rootPath.Length + 1)
        try {
            Remove-Item -Path $file.Path -Force
            Write-Log "✓ Doublon supprimé: $relativePath" -Color Green
        } catch {
            Write-Log "✗ Erreur lors de la suppression du doublon $relativePath : $($_.Exception.Message)" -Color Red
        }
    }
} else {
    Write-Log "Mode simulation. Aucune action n'a été exécutée." -Color Yellow
    Write-Log "Pour exécuter les actions, utilisez le paramètre -Execute" -Color Yellow
    Write-Log "Exemple: .\scripts\clean-temp-files.ps1 -Execute" -Color Yellow
}

Write-Log ""
Write-Log "=== Nettoyage terminé ===" -Color Cyan
Write-Log "Le rapport de nettoyage est disponible ici: $logFile" -Color Green