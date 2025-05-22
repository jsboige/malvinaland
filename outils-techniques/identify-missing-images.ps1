# Script pour identifier les images manquantes dans les mondes de Malvinaland
# Ce script analyse les fichiers markdown des mondes pour trouver les références aux images
# et vérifie si ces images existent dans le dossier des assets

param (
    [switch]$GeneratePlaceholders = $false
)

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot
$srcPath = Join-Path -Path $rootPath -ChildPath "src"
$contentPath = Join-Path -Path $srcPath -ChildPath "content\mondes"
$assetsPath = Join-Path -Path $srcPath -ChildPath "assets\images\mondes"
$placeholdersPath = Join-Path -Path $srcPath -ChildPath "assets\images\placeholders"
$reportPath = Join-Path -Path $rootPath -ChildPath "missing-images-report.md"

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
Ensure-Directory -Path $assetsPath
Ensure-Directory -Path $placeholdersPath

# Étape 1: Analyser les fichiers markdown des mondes
Write-Step "Analyse des fichiers markdown des mondes"

$mondes = Get-ChildItem -Path $contentPath -Directory | ForEach-Object { $_.Name }
Write-Host "Mondes trouvés: $($mondes -join ", ")" -ForegroundColor Green

$missingImages = @{}
$totalMissingCount = 0

foreach ($monde in $mondes) {
    Write-Host "Analyse du monde: $monde" -ForegroundColor Yellow
    
    $mondeContentPath = Join-Path -Path $contentPath -ChildPath $monde
    $mondeAssetsPath = Join-Path -Path $assetsPath -ChildPath $monde
    $mondePlaceholdersPath = Join-Path -Path $placeholdersPath -ChildPath $monde
    
    Ensure-Directory -Path $mondeAssetsPath
    Ensure-Directory -Path $mondePlaceholdersPath
    
    $markdownFiles = Get-ChildItem -Path $mondeContentPath -Filter "*.md" -Recurse
    $missingImages[$monde] = @()
    
    foreach ($file in $markdownFiles) {
        $content = Get-Content -Path $file.FullName -Raw
        
        # Rechercher les références d'images dans le markdown
        $imageMatches = [regex]::Matches($content, '!\[(.*?)\]\((.*?)\)')
        
        foreach ($match in $imageMatches) {
            $altText = $match.Groups[1].Value
            $imagePath = $match.Groups[2].Value
            
            # Normaliser le chemin de l'image
            if ($imagePath.StartsWith("/")) {
                $imagePath = $imagePath.Substring(1)
            }
            
            # Vérifier si l'image existe
            $fullImagePath = Join-Path -Path $rootPath -ChildPath $imagePath
            if (-not (Test-Path $fullImagePath)) {
                $missingImages[$monde] += [PSCustomObject]@{
                    AltText = $altText
                    Path = $imagePath
                    MarkdownFile = $file.FullName.Substring($rootPath.Length + 1)
                }
                $totalMissingCount++
                
                # Générer un placeholder si demandé
                if ($GeneratePlaceholders) {
                    $fileName = [System.IO.Path]::GetFileName($imagePath)
                    $placeholderFile = Join-Path -Path $mondePlaceholdersPath -ChildPath $fileName
                    
                    if ($placeholderFile.EndsWith(".jpg") -or $placeholderFile.EndsWith(".jpeg") -or $placeholderFile.EndsWith(".png")) {
                        $placeholderFile = [System.IO.Path]::ChangeExtension($placeholderFile, ".svg")
                    }
                    
                    $placeholderContent = @"
<svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">
    <rect width="100%" height="100%" fill="#f0f0f0"/>
    <text x="50%" y="40%" font-family="Arial" font-size="32" text-anchor="middle" dominant-baseline="middle" fill="#333">
        Image manquante: $monde
    </text>
    <text x="50%" y="50%" font-family="Arial" font-size="24" text-anchor="middle" dominant-baseline="middle" fill="#666">
        $altText
    </text>
    <text x="50%" y="60%" font-family="Arial" font-size="18" text-anchor="middle" dominant-baseline="middle" fill="#999">
        $imagePath
    </text>
</svg>
"@
                    
                    Set-Content -Path $placeholderFile -Value $placeholderContent
                    Write-Host "Placeholder créé: $placeholderFile" -ForegroundColor Green
                }
            }
        }
    }
}

# Étape 2: Générer le rapport des images manquantes
Write-Step "Génération du rapport des images manquantes"

$report = @"
# Rapport des images manquantes pour Malvinaland

Ce rapport liste toutes les images référencées dans les fichiers markdown des mondes mais qui n'existent pas dans le dossier des assets.

**Date de génération:** $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")

**Nombre total d'images manquantes:** $totalMissingCount

## Résumé par monde

"@

foreach ($monde in $mondes) {
    $count = $missingImages[$monde].Count
    $report += "`n- **$monde**: $count image(s) manquante(s)"
}

$report += "`n`n## Détails par monde`n"

foreach ($monde in $mondes) {
    $report += "`n### $monde`n"
    
    if ($missingImages[$monde].Count -eq 0) {
        $report += "`nAucune image manquante pour ce monde.`n"
    } else {
        $report += "`n| Texte alternatif | Chemin de l'image | Fichier markdown |`n"
        $report += "| --- | --- | --- |`n"
        
        foreach ($image in $missingImages[$monde]) {
            $report += "| $($image.AltText) | $($image.Path) | $($image.MarkdownFile) |`n"
        }
    }
}

$report += @"

## Instructions pour la génération d'images

Pour chaque image manquante, veuillez générer une image correspondant à la description fournie dans le texte alternatif.
Les images doivent être placées dans le chemin indiqué dans le rapport.

### Recommandations pour les images:

1. **Format**: JPG ou PNG, selon le contenu
2. **Résolution**: 1200x800 pixels minimum
3. **Style**: Cohérent avec l'univers de Malvinaland
4. **Nommage**: Respecter le nom de fichier indiqué dans le chemin

### Processus de génération:

1. Utiliser les descriptions fournies dans le texte alternatif
2. Générer des images qui correspondent au contexte du monde
3. Optimiser les images pour le web (taille de fichier raisonnable)
4. Placer les images dans le dossier correspondant

"@

# Exporter le rapport
Set-Content -Path $reportPath -Value $report
Write-Host "Rapport des images manquantes généré: $reportPath" -ForegroundColor Green

Write-Step "Opération terminée"
Write-Host "Nombre total d'images manquantes: $totalMissingCount" -ForegroundColor Yellow

if ($GeneratePlaceholders) {
    Write-Host "Des placeholders ont été générés dans: $placeholdersPath" -ForegroundColor Green
} else {
    Write-Host "Pour générer des placeholders pour les images manquantes, relancez le script avec le paramètre -GeneratePlaceholders" -ForegroundColor Yellow
}