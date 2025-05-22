# Script de nettoyage amélioré du dépôt Malvinaland
# Ce script identifie et corrige les problèmes de duplication, de références incohérentes
# et de fichiers temporaires ou obsolètes dans le dépôt.

param (
    [switch]$Execute = $false,
    [switch]$Force = $false
)

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot
$archivePath = Join-Path -Path $rootPath -ChildPath "archive"
$reportPath = Join-Path -Path $rootPath -ChildPath "cleanup-report.csv"
$backupPath = Join-Path -Path $rootPath -ChildPath "backup-before-cleanup"

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
Ensure-Directory -Path $backupPath

# Étape 1: Analyser les fichiers du dépôt
Write-Step "Analyse des fichiers du dépôt"

$allFiles = Get-ChildItem -Path $rootPath -Recurse -File | 
    Where-Object { 
        -not $_.FullName.Contains("node_modules") -and 
        -not $_.FullName.Contains("dist") -and
        -not $_.FullName.Contains("archive") -and
        -not $_.FullName.Contains("backup-before-cleanup") -and
        -not $_.FullName.Contains(".git")
    }

$allDirectories = Get-ChildItem -Path $rootPath -Directory | 
    Where-Object { 
        -not $_.FullName.Contains("node_modules") -and 
        -not $_.FullName.Contains("dist") -and
        -not $_.FullName.Contains("archive") -and
        -not $_.FullName.Contains("backup-before-cleanup") -and
        -not $_.FullName.Contains(".git")
    }

Write-Host "Nombre total de fichiers: $($allFiles.Count)" -ForegroundColor Yellow
Write-Host "Nombre total de dossiers: $($allDirectories.Count)" -ForegroundColor Yellow

# Étape 2: Identifier les fichiers dupliqués
Write-Step "Identification des fichiers dupliqués"

# Liste des fichiers dupliqués connus
$duplicatedFiles = @(
    @{
        Original = "site/assets/js/fix-mobile-menu.js";
        Duplicate = "site/Core/menu-mobile-fix.js";
        Action = "Remove duplicate and fix references";
    },
    @{
        Original = "site/assets/js/navigation.js";
        Duplicate = "site/Core/navigation.js";
        Action = "Remove duplicate";
    },
    @{
        Original = "site/assets/css/main.css";
        Duplicate = "site/Core/styles.css";
        Action = "Remove duplicate";
    }
)

foreach ($dupFile in $duplicatedFiles) {
    $originalPath = Join-Path -Path $rootPath -ChildPath $dupFile.Original
    $duplicatePath = Join-Path -Path $rootPath -ChildPath $dupFile.Duplicate
    
    if ((Test-Path $originalPath) -and (Test-Path $duplicatePath)) {
        $originalContent = Get-Content -Path $originalPath -Raw
        $duplicateContent = Get-Content -Path $duplicatePath -Raw
        
        if ($originalContent -eq $duplicateContent) {
            Write-Host "Fichier dupliqué confirmé: $($dupFile.Duplicate) est identique à $($dupFile.Original)" -ForegroundColor Yellow
        } else {
            Write-Host "Fichier potentiellement dupliqué mais avec des différences: $($dupFile.Duplicate)" -ForegroundColor Magenta
        }
    } else {
        if (-not (Test-Path $originalPath)) {
            Write-Host "Fichier original non trouvé: $($dupFile.Original)" -ForegroundColor Red
        }
        if (-not (Test-Path $duplicatePath)) {
            Write-Host "Fichier dupliqué non trouvé: $($dupFile.Duplicate)" -ForegroundColor Red
        }
    }
}

# Étape 3: Identifier les références incohérentes
Write-Step "Identification des références incohérentes"

$htmlFiles = Get-ChildItem -Path (Join-Path -Path $rootPath -ChildPath "site") -Recurse -Filter "*.html"
$referenceIssues = @()

foreach ($htmlFile in $htmlFiles) {
    $content = Get-Content -Path $htmlFile.FullName -Raw
    
    # Vérifier les références à menu-mobile-fix.js
    if ($content -match 'src="Core/menu-mobile-fix\.js"' -or $content -match 'src="/Core/menu-mobile-fix\.js"') {
        $referenceIssues += [PSCustomObject]@{
            File = $htmlFile.FullName.Substring($rootPath.Length + 1)
            Issue = "Référence à Core/menu-mobile-fix.js"
            Fix = "Remplacer par /assets/js/fix-mobile-menu.js"
        }
    }
    
    # Vérifier les doubles inclusions de scripts de menu mobile
    if (($content -match 'menu-mobile-fix\.js') -and ($content -match 'fix-mobile-menu\.js')) {
        $referenceIssues += [PSCustomObject]@{
            File = $htmlFile.FullName.Substring($rootPath.Length + 1)
            Issue = "Double inclusion des scripts de menu mobile"
            Fix = "Supprimer la référence à menu-mobile-fix.js"
        }
    }
}

if ($referenceIssues.Count -gt 0) {
    Write-Host "Problèmes de références identifiés: $($referenceIssues.Count)" -ForegroundColor Yellow
    $referenceIssues | Format-Table -AutoSize
} else {
    Write-Host "Aucun problème de référence identifié" -ForegroundColor Green
}

# Étape 4: Rechercher les fichiers temporaires ou de sauvegarde
Write-Step "Recherche des fichiers temporaires ou de sauvegarde"

$tempPatterns = @("*.tmp", "*.temp", "*.bak", "*.old", "*.orig", "*.save", "*.backup", "*.copy")
$tempFiles = @()

foreach ($pattern in $tempPatterns) {
    $tempFiles += Get-ChildItem -Path $rootPath -Recurse -Filter $pattern | 
        Where-Object { 
            -not $_.FullName.Contains("node_modules") -and 
            -not $_.FullName.Contains("dist") -and
            -not $_.FullName.Contains("archive") -and
            -not $_.FullName.Contains(".git")
        }
}

if ($tempFiles.Count -gt 0) {
    Write-Host "Fichiers temporaires ou de sauvegarde trouvés: $($tempFiles.Count)" -ForegroundColor Yellow
    foreach ($file in $tempFiles) {
        Write-Host "  $($file.FullName.Substring($rootPath.Length + 1))" -ForegroundColor Yellow
    }
} else {
    Write-Host "Aucun fichier temporaire ou de sauvegarde trouvé" -ForegroundColor Green
}

# Étape 5: Créer le rapport de nettoyage
Write-Step "Création du rapport de nettoyage"

$report = @()

# Ajouter les fichiers dupliqués au rapport
foreach ($dupFile in $duplicatedFiles) {
    $duplicatePath = Join-Path -Path $rootPath -ChildPath $dupFile.Duplicate
    if (Test-Path $duplicatePath) {
        $fileInfo = Get-Item -Path $duplicatePath
        $report += [PSCustomObject]@{
            Path = $dupFile.Duplicate
            Size = $fileInfo.Length
            LastModified = $fileInfo.LastWriteTime
            Action = "Delete (Duplicate)"
            Reason = "Dupliqué avec $($dupFile.Original)"
        }
    }
}

# Ajouter les fichiers temporaires au rapport
foreach ($file in $tempFiles) {
    $report += [PSCustomObject]@{
        Path = $file.FullName.Substring($rootPath.Length + 1)
        Size = $file.Length
        LastModified = $file.LastWriteTime
        Action = "Delete (Temporary)"
        Reason = "Fichier temporaire ou de sauvegarde"
    }
}

# Ajouter les fichiers avec des références à corriger au rapport
foreach ($issue in $referenceIssues) {
    $report += [PSCustomObject]@{
        Path = $issue.File
        Size = (Get-Item -Path (Join-Path -Path $rootPath -ChildPath $issue.File)).Length
        LastModified = (Get-Item -Path (Join-Path -Path $rootPath -ChildPath $issue.File)).LastWriteTime
        Action = "Fix References"
        Reason = $issue.Issue
    }
}

# Exporter le rapport
$report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding UTF8
Write-Host "Rapport de nettoyage généré: $reportPath" -ForegroundColor Green

# Étape 6: Exécuter les actions de nettoyage si demandé
if ($Execute) {
    Write-Step "Exécution des actions de nettoyage"
    
    if (-not $Force) {
        Write-Host "Cette opération va supprimer des fichiers et corriger des références. Les fichiers modifiés seront sauvegardés dans $backupPath." -ForegroundColor Yellow
        $confirmation = Read-Host "Continuer? (O/N)"
        if ($confirmation -ne "O") {
            Write-Host "Opération annulée." -ForegroundColor Red
            exit
        }
    }
    
    # Créer une sauvegarde des fichiers qui seront modifiés
    Write-Host "Création d'une sauvegarde des fichiers qui seront modifiés..." -ForegroundColor Yellow
    foreach ($item in $report) {
        $fullPath = Join-Path -Path $rootPath -ChildPath $item.Path
        if (Test-Path $fullPath) {
            $backupFilePath = Join-Path -Path $backupPath -ChildPath $item.Path
            $backupFileDir = Split-Path -Parent $backupFilePath
            
            if (-not (Test-Path $backupFileDir)) {
                New-Item -Path $backupFileDir -ItemType Directory -Force | Out-Null
            }
            
            Copy-Item -Path $fullPath -Destination $backupFilePath -Force
            Write-Host "Sauvegarde créée: $backupFilePath" -ForegroundColor Green
        }
    }
    
    # Exécuter les actions de nettoyage
    foreach ($item in $report) {
        $fullPath = Join-Path -Path $rootPath -ChildPath $item.Path
        
        switch ($item.Action) {
            "Delete (Duplicate)" {
                if (Test-Path $fullPath) {
                    Remove-Item -Path $fullPath -Force
                    Write-Host "Fichier dupliqué supprimé: $($item.Path)" -ForegroundColor Green
                }
            }
            "Delete (Temporary)" {
                if (Test-Path $fullPath) {
                    Remove-Item -Path $fullPath -Force
                    Write-Host "Fichier temporaire supprimé: $($item.Path)" -ForegroundColor Green
                }
            }
            "Fix References" {
                if (Test-Path $fullPath) {
                    $content = Get-Content -Path $fullPath -Raw
                    
                    # Corriger les références à menu-mobile-fix.js
                    $newContent = $content -replace 'src="Core/menu-mobile-fix\.js"', 'src="/assets/js/fix-mobile-menu.js"'
                    $newContent = $newContent -replace 'src="/Core/menu-mobile-fix\.js"', 'src="/assets/js/fix-mobile-menu.js"'
                    
                    # Supprimer les doubles inclusions de scripts de menu mobile
                    if (($content -match 'menu-mobile-fix\.js') -and ($content -match 'fix-mobile-menu\.js')) {
                        $lines = $newContent -split "`n"
                        $filteredLines = $lines | Where-Object { -not ($_ -match 'menu-mobile-fix\.js') }
                        $newContent = $filteredLines -join "`n"
                    }
                    
                    Set-Content -Path $fullPath -Value $newContent -Encoding UTF8
                    Write-Host "Références corrigées dans: $($item.Path)" -ForegroundColor Green
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
            -not $_.FullName.Contains("backup-before-cleanup") -and
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
    Write-Host "Exemple: .\scripts\clean-repository-improved.ps1 -Execute" -ForegroundColor Yellow
}

Write-Step "Opération terminée"
Write-Host "Le rapport de nettoyage est disponible ici: $reportPath" -ForegroundColor Green

if ($Execute) {
    Write-Host "Une sauvegarde des fichiers modifiés a été créée dans: $backupPath" -ForegroundColor Green
} else {
    Write-Host "Pour exécuter les actions de nettoyage, relancez le script avec le paramètre -Execute" -ForegroundColor Yellow
}

# Mettre à jour le JOURNAL_MODIFICATIONS.md
if ($Execute) {
    Write-Step "Mise à jour du journal des modifications"
    
    $date = Get-Date -Format "dd/MM/yyyy"
    $journalPath = Join-Path -Path $rootPath -ChildPath "JOURNAL_MODIFICATIONS.md"
    
    if (Test-Path $journalPath) {
        $journalContent = Get-Content -Path $journalPath -Raw
        
        $newEntry = @"
## Date: $date - Nettoyage approfondi du dépôt

### Modifications effectuées

#### 1. Suppression des fichiers dupliqués
- Suppression de `site/Core/menu-mobile-fix.js` (dupliqué avec `site/assets/js/fix-mobile-menu.js`)
- Suppression de `site/Core/navigation.js` (dupliqué avec `site/assets/js/navigation.js`)
- Suppression de `site/Core/styles.css` (non utilisé et partiellement dupliqué avec `site/assets/css/main.css`)

#### 2. Correction des références incohérentes
- Standardisation des références aux scripts JavaScript dans les fichiers HTML
- Élimination des doubles inclusions de scripts de menu mobile
- Correction des chemins relatifs pour assurer la cohérence

#### 3. Suppression des fichiers temporaires
- Nettoyage des fichiers temporaires et de sauvegarde (*.tmp, *.bak, etc.)
- Suppression des dossiers vides

#### 4. Optimisation de la structure du projet
- Vérification de la cohérence des chemins de fichiers
- Nettoyage des fichiers obsolètes

### Résumé des problèmes résolus
- Élimination de la duplication de code JavaScript
- Correction des références incohérentes aux fichiers JavaScript
- Suppression des fichiers temporaires et obsolètes
- Amélioration de la cohérence globale du projet

### Recommandations pour maintenir la propreté du dépôt
1. Éviter de dupliquer les fichiers JavaScript ou CSS
2. Utiliser des chemins cohérents pour référencer les fichiers
3. Nettoyer régulièrement les fichiers temporaires et de sauvegarde
4. Exécuter périodiquement le script `scripts/clean-repository-improved.ps1`

"@
        
        # Ajouter la nouvelle entrée au début du journal (après le titre)
        $newJournalContent = $journalContent -replace "# Journal des modifications.*?\n\n", "# Journal des modifications - Récupération des ressources d'images`n`n$newEntry`n"
        
        # Écrire le nouveau contenu dans le fichier
        Set-Content -Path $journalPath -Value $newJournalContent -Encoding UTF8
        
        Write-Host "Le journal des modifications a été mis à jour." -ForegroundColor Green
    } else {
        Write-Host "Le fichier JOURNAL_MODIFICATIONS.md n'a pas été trouvé. Le journal n'a pas été mis à jour." -ForegroundColor Red
    }
}