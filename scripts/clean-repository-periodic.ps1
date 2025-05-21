# Script de nettoyage périodique du dépôt Malvinaland
# Ce script peut être exécuté régulièrement pour maintenir la propreté du dépôt

param (
    [switch]$Execute = $false,
    [switch]$Force = $false
)

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot
$reportPath = Join-Path -Path $rootPath -ChildPath "cleanup-periodic-report.csv"
$logPath = Join-Path -Path $rootPath -ChildPath "cleanup-logs"

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

# Créer le dossier de logs
Ensure-Directory -Path $logPath

# Fonction pour écrire dans le journal
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    $logFile = Join-Path -Path $logPath -ChildPath "cleanup-$(Get-Date -Format 'yyyy-MM-dd').log"
    Add-Content -Path $logFile -Value $logMessage
    
    switch ($Level) {
        "INFO" { Write-Host $Message -ForegroundColor White }
        "SUCCESS" { Write-Host $Message -ForegroundColor Green }
        "WARNING" { Write-Host $Message -ForegroundColor Yellow }
        "ERROR" { Write-Host $Message -ForegroundColor Red }
    }
}

# Étape 1: Rechercher les fichiers temporaires ou de sauvegarde
Write-Step "Recherche des fichiers temporaires ou de sauvegarde"
Write-Log "Début de la recherche des fichiers temporaires ou de sauvegarde"

$tempPatterns = @("*.tmp", "*.temp", "*.bak", "*.old", "*.orig", "*.save", "*.backup", "*.copy", "*.log.*")
$tempFiles = @()

foreach ($pattern in $tempPatterns) {
    $tempFiles += Get-ChildItem -Path $rootPath -Recurse -Filter $pattern | 
        Where-Object { 
            -not $_.FullName.Contains("node_modules") -and 
            -not $_.FullName.Contains("dist") -and
            -not $_.FullName.Contains("archive") -and
            -not $_.FullName.Contains("cleanup-logs") -and
            -not $_.FullName.Contains(".git")
        }
}

if ($tempFiles.Count -gt 0) {
    Write-Log "Fichiers temporaires ou de sauvegarde trouvés: $($tempFiles.Count)" -Level "WARNING"
    foreach ($file in $tempFiles) {
        Write-Log "  $($file.FullName.Substring($rootPath.Length + 1))" -Level "WARNING"
    }
} else {
    Write-Log "Aucun fichier temporaire ou de sauvegarde trouvé" -Level "SUCCESS"
}

# Étape 2: Rechercher les fichiers de log volumineux
Write-Step "Recherche des fichiers de log volumineux"
Write-Log "Début de la recherche des fichiers de log volumineux"

$logFiles = Get-ChildItem -Path $rootPath -Recurse -Filter "*.log" | 
    Where-Object { 
        -not $_.FullName.Contains("node_modules") -and 
        -not $_.FullName.Contains("dist") -and
        -not $_.FullName.Contains("archive") -and
        -not $_.FullName.Contains("cleanup-logs") -and
        -not $_.FullName.Contains(".git") -and
        $_.Length -gt 1MB
    }

if ($logFiles.Count -gt 0) {
    Write-Log "Fichiers de log volumineux trouvés: $($logFiles.Count)" -Level "WARNING"
    foreach ($file in $logFiles) {
        $sizeInMB = [Math]::Round($file.Length / 1MB, 2)
        Write-Log "  $($file.FullName.Substring($rootPath.Length + 1)) - $sizeInMB MB" -Level "WARNING"
    }
} else {
    Write-Log "Aucun fichier de log volumineux trouvé" -Level "SUCCESS"
}

# Étape 3: Rechercher les dossiers vides
Write-Step "Recherche des dossiers vides"
Write-Log "Début de la recherche des dossiers vides"

$emptyDirs = Get-ChildItem -Path $rootPath -Directory -Recurse | 
    Where-Object { 
        -not $_.FullName.Contains("node_modules") -and 
        -not $_.FullName.Contains("dist") -and
        -not $_.FullName.Contains("archive") -and
        -not $_.FullName.Contains("cleanup-logs") -and
        -not $_.FullName.Contains(".git") -and
        (Get-ChildItem -Path $_.FullName -Recurse -File).Count -eq 0
    }

if ($emptyDirs.Count -gt 0) {
    Write-Log "Dossiers vides trouvés: $($emptyDirs.Count)" -Level "WARNING"
    foreach ($dir in $emptyDirs) {
        Write-Log "  $($dir.FullName.Substring($rootPath.Length + 1))" -Level "WARNING"
    }
} else {
    Write-Log "Aucun dossier vide trouvé" -Level "SUCCESS"
}

# Étape 4: Vérifier la cohérence des chemins de fichiers
Write-Step "Vérification de la cohérence des chemins de fichiers"
Write-Log "Début de la vérification de la cohérence des chemins de fichiers"

$htmlFiles = Get-ChildItem -Path (Join-Path -Path $rootPath -ChildPath "site") -Recurse -Filter "*.html"
$pathIssues = @()

foreach ($htmlFile in $htmlFiles) {
    $content = Get-Content -Path $htmlFile.FullName -Raw
    
    # Vérifier les références à des fichiers JavaScript
    $jsMatches = [regex]::Matches($content, 'src="([^"]+\.js)"')
    foreach ($match in $jsMatches) {
        $jsPath = $match.Groups[1].Value
        if ($jsPath.StartsWith("/")) {
            $fullJsPath = Join-Path -Path $rootPath -ChildPath "site$jsPath"
        } else {
            $htmlDir = Split-Path -Parent $htmlFile.FullName
            $fullJsPath = Join-Path -Path $htmlDir -ChildPath $jsPath
        }
        
        if (-not (Test-Path $fullJsPath)) {
            $pathIssues += [PSCustomObject]@{
                File = $htmlFile.FullName.Substring($rootPath.Length + 1)
                Issue = "Référence à un fichier JavaScript inexistant: $jsPath"
                Path = $fullJsPath
            }
        }
    }
    
    # Vérifier les références à des fichiers CSS
    $cssMatches = [regex]::Matches($content, 'href="([^"]+\.css)"')
    foreach ($match in $cssMatches) {
        $cssPath = $match.Groups[1].Value
        if ($cssPath.StartsWith("/")) {
            $fullCssPath = Join-Path -Path $rootPath -ChildPath "site$cssPath"
        } else {
            $htmlDir = Split-Path -Parent $htmlFile.FullName
            $fullCssPath = Join-Path -Path $htmlDir -ChildPath $cssPath
        }
        
        if (-not (Test-Path $fullCssPath)) {
            $pathIssues += [PSCustomObject]@{
                File = $htmlFile.FullName.Substring($rootPath.Length + 1)
                Issue = "Référence à un fichier CSS inexistant: $cssPath"
                Path = $fullCssPath
            }
        }
    }
    
    # Vérifier les références à des images
    $imgMatches = [regex]::Matches($content, 'src="([^"]+\.(png|jpg|jpeg|gif|svg))"')
    foreach ($match in $imgMatches) {
        $imgPath = $match.Groups[1].Value
        if ($imgPath.StartsWith("/")) {
            $fullImgPath = Join-Path -Path $rootPath -ChildPath "site$imgPath"
        } else {
            $htmlDir = Split-Path -Parent $htmlFile.FullName
            $fullImgPath = Join-Path -Path $htmlDir -ChildPath $imgPath
        }
        
        if (-not (Test-Path $fullImgPath)) {
            $pathIssues += [PSCustomObject]@{
                File = $htmlFile.FullName.Substring($rootPath.Length + 1)
                Issue = "Référence à une image inexistante: $imgPath"
                Path = $fullImgPath
            }
        }
    }
}

if ($pathIssues.Count -gt 0) {
    Write-Log "Problèmes de cohérence des chemins de fichiers trouvés: $($pathIssues.Count)" -Level "WARNING"
    foreach ($issue in $pathIssues) {
        Write-Log "  $($issue.File): $($issue.Issue)" -Level "WARNING"
    }
} else {
    Write-Log "Aucun problème de cohérence des chemins de fichiers trouvé" -Level "SUCCESS"
}

# Étape 5: Créer le rapport de nettoyage
Write-Step "Création du rapport de nettoyage"
Write-Log "Début de la création du rapport de nettoyage"

$report = @()

# Ajouter les fichiers temporaires au rapport
foreach ($file in $tempFiles) {
    $report += [PSCustomObject]@{
        Path = $file.FullName.Substring($rootPath.Length + 1)
        Size = $file.Length
        LastModified = $file.LastWriteTime
        Action = "Delete"
        Reason = "Fichier temporaire ou de sauvegarde"
    }
}

# Ajouter les fichiers de log volumineux au rapport
foreach ($file in $logFiles) {
    $report += [PSCustomObject]@{
        Path = $file.FullName.Substring($rootPath.Length + 1)
        Size = $file.Length
        LastModified = $file.LastWriteTime
        Action = "Archive"
        Reason = "Fichier de log volumineux"
    }
}

# Ajouter les dossiers vides au rapport
foreach ($dir in $emptyDirs) {
    $report += [PSCustomObject]@{
        Path = $dir.FullName.Substring($rootPath.Length + 1)
        Size = 0
        LastModified = $dir.LastWriteTime
        Action = "Delete"
        Reason = "Dossier vide"
    }
}

# Ajouter les problèmes de cohérence des chemins de fichiers au rapport
foreach ($issue in $pathIssues) {
    $report += [PSCustomObject]@{
        Path = $issue.File
        Size = (Get-Item -Path (Join-Path -Path $rootPath -ChildPath $issue.File)).Length
        LastModified = (Get-Item -Path (Join-Path -Path $rootPath -ChildPath $issue.File)).LastWriteTime
        Action = "Fix"
        Reason = $issue.Issue
    }
}

# Exporter le rapport
$report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding UTF8
Write-Log "Rapport de nettoyage généré: $reportPath" -Level "SUCCESS"

# Étape 6: Exécuter les actions de nettoyage si demandé
if ($Execute) {
    Write-Step "Exécution des actions de nettoyage"
    Write-Log "Début de l'exécution des actions de nettoyage" -Level "WARNING"
    
    if (-not $Force) {
        Write-Host "Cette opération va supprimer des fichiers temporaires et archiver des fichiers de log volumineux." -ForegroundColor Yellow
        $confirmation = Read-Host "Continuer? (O/N)"
        if ($confirmation -ne "O") {
            Write-Log "Opération annulée par l'utilisateur" -Level "WARNING"
            Write-Host "Opération annulée." -ForegroundColor Red
            exit
        }
    }
    
    # Exécuter les actions de nettoyage
    foreach ($item in $report) {
        $fullPath = Join-Path -Path $rootPath -ChildPath $item.Path
        
        switch ($item.Action) {
            "Delete" {
                if (Test-Path $fullPath) {
                    try {
                        Remove-Item -Path $fullPath -Force -Recurse
                        Write-Log "Supprimé: $($item.Path)" -Level "SUCCESS"
                    } catch {
                        Write-Log "Erreur lors de la suppression de $($item.Path): $_" -Level "ERROR"
                    }
                }
            }
            "Archive" {
                if (Test-Path $fullPath) {
                    try {
                        $archiveDir = Join-Path -Path $logPath -ChildPath "archived-logs"
                        Ensure-Directory -Path $archiveDir
                        
                        $fileName = Split-Path -Leaf $fullPath
                        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
                        $archivePath = Join-Path -Path $archiveDir -ChildPath "${timestamp}_${fileName}"
                        
                        Copy-Item -Path $fullPath -Destination $archivePath -Force
                        Remove-Item -Path $fullPath -Force
                        Write-Log "Archivé: $($item.Path) -> $archivePath" -Level "SUCCESS"
                    } catch {
                        Write-Log "Erreur lors de l'archivage de $($item.Path): $_" -Level "ERROR"
                    }
                }
            }
        }
    }
} else {
    Write-Log "Mode simulation. Aucune action n'a été exécutée." -Level "INFO"
    Write-Host "Mode simulation. Aucune action n'a été exécutée." -ForegroundColor Yellow
    Write-Host "Pour exécuter les actions, utilisez le paramètre -Execute" -ForegroundColor Yellow
    Write-Host "Exemple: .\scripts\clean-repository-periodic.ps1 -Execute" -ForegroundColor Yellow
}

Write-Step "Opération terminée"
Write-Log "Opération terminée" -Level "SUCCESS"
Write-Host "Le rapport de nettoyage est disponible ici: $reportPath" -ForegroundColor Green
Write-Host "Les logs de nettoyage sont disponibles ici: $logPath" -ForegroundColor Green

if (-not $Execute) {
    Write-Host "Pour exécuter les actions de nettoyage, relancez le script avec le paramètre -Execute" -ForegroundColor Yellow
}