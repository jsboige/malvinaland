# Script simplifié pour nettoyer le dépôt Malvinaland
# Ce script est conçu pour être facile à utiliser, même sans connaissances techniques

# Afficher un message de bienvenue
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Nettoyage simplifié du dépôt Malvinaland" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ce script va nettoyer le dépôt Malvinaland en:" -ForegroundColor Yellow
Write-Host "- Supprimant les fichiers temporaires" -ForegroundColor Yellow
Write-Host "- Supprimant les fichiers de sauvegarde" -ForegroundColor Yellow
Write-Host "- Supprimant les dossiers vides" -ForegroundColor Yellow
Write-Host ""

# Demander confirmation avant de continuer
$confirmation = Read-Host "Voulez-vous continuer? (O/N)"
if ($confirmation -ne "O" -and $confirmation -ne "o") {
    Write-Host "Opération annulée." -ForegroundColor Yellow
    exit 0
}

# Créer un dossier de logs si nécessaire
$logDir = "cleanup-logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}

# Créer un fichier de log
$logFile = "$logDir\cleanup-$(Get-Date -Format 'yyyyMMddHHmmss').log"
"Nettoyage du dépôt Malvinaland - $(Get-Date)" | Out-File -FilePath $logFile

# Fonction pour écrire dans le log et à l'écran
function Write-Log {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    $Message | Out-File -FilePath $logFile -Append
    Write-Host $Message -ForegroundColor $Color
}

# Rechercher et supprimer les fichiers temporaires
Write-Log "" 
Write-Log "Recherche des fichiers temporaires..." "Cyan"
$tempFiles = Get-ChildItem -Path . -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
    $_.Extension -match '\.tmp$|\.temp$|\.bak$|\.old$|\.orig$|\.save$|\.backup$|\.copy$'
}

if ($tempFiles.Count -eq 0) {
    Write-Log "✅ Aucun fichier temporaire trouvé" "Green"
} else {
    Write-Log "Fichiers temporaires trouvés: $($tempFiles.Count)" "Yellow"
    foreach ($file in $tempFiles) {
        Write-Log "  - Suppression: $($file.FullName)" "Yellow"
        Remove-Item -Path $file.FullName -Force
    }
    Write-Log "✅ Fichiers temporaires supprimés" "Green"
}

# Rechercher et supprimer les fichiers de log volumineux
Write-Log ""
Write-Log "Recherche des fichiers de log volumineux..." "Cyan"
$logFiles = Get-ChildItem -Path . -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
    $_.Extension -match '\.log$' -and $_.Length -gt 1MB
}

if ($logFiles.Count -eq 0) {
    Write-Log "✅ Aucun fichier de log volumineux trouvé" "Green"
} else {
    Write-Log "Fichiers de log volumineux trouvés: $($logFiles.Count)" "Yellow"
    foreach ($file in $logFiles) {
        Write-Log "  - Archivage: $($file.FullName)" "Yellow"
        $archiveDir = "archives-techniques\logs"
        if (-not (Test-Path $archiveDir)) {
            New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null
        }
        Move-Item -Path $file.FullName -Destination "$archiveDir\$($file.Name)" -Force
    }
    Write-Log "✅ Fichiers de log volumineux archivés" "Green"
}

# Rechercher et supprimer les dossiers vides
Write-Log ""
Write-Log "Recherche des dossiers vides..." "Cyan"
$emptyDirs = @()
$allDirs = Get-ChildItem -Path . -Directory -Recurse -ErrorAction SilentlyContinue

foreach ($dir in $allDirs) {
    $items = Get-ChildItem -Path $dir.FullName -Recurse -ErrorAction SilentlyContinue
    if ($items.Count -eq 0) {
        $emptyDirs += $dir
    }
}

if ($emptyDirs.Count -eq 0) {
    Write-Log "✅ Aucun dossier vide trouvé" "Green"
} else {
    Write-Log "Dossiers vides trouvés: $($emptyDirs.Count)" "Yellow"
    foreach ($dir in $emptyDirs) {
        Write-Log "  - Suppression: $($dir.FullName)" "Yellow"
        Remove-Item -Path $dir.FullName -Force
    }
    Write-Log "✅ Dossiers vides supprimés" "Green"
}

# Afficher un résumé
Write-Log ""
Write-Log "==================================================" "Cyan"
Write-Log "  Résumé du nettoyage" "Cyan"
Write-Log "==================================================" "Cyan"
Write-Log "- Fichiers temporaires supprimés: $($tempFiles.Count)" "White"
Write-Log "- Fichiers de log archivés: $($logFiles.Count)" "White"
Write-Log "- Dossiers vides supprimés: $($emptyDirs.Count)" "White"
Write-Log ""
Write-Log "Le journal de nettoyage a été enregistré dans: $logFile" "Green"
Write-Log ""
Write-Log "Merci d'avoir utilisé le nettoyage simplifié de Malvinaland!" "Cyan"