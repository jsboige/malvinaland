# Script de correction des fichiers du site Malvinaland
# Ce script vérifie et corrige les chemins des ressources manquantes

Write-Host "Début de la correction des fichiers du site..." -ForegroundColor Green

# 1. Vérifier et créer les dossiers d'assets nécessaires
$assetFolders = @(
    "Site\assets\images\carte",
    "Site\assets\images\mondes\assemblee",
    "Site\assets\images\mondes\grange",
    "Site\assets\images\mondes\jeux",
    "Site\assets\images\mondes\reves",
    "Site\assets\images\mondes\damier",
    "Site\assets\images\mondes\linge",
    "Site\assets\images\mondes\verger",
    "Site\assets\images\mondes\zob",
    "Site\assets\images\mondes\elysee",
    "Site\assets\images\mondes\karibu",
    "Site\assets\images\mondes\sphinx"
)

foreach ($folder in $assetFolders) {
    if (-not (Test-Path $folder)) {
        Write-Host "Création du dossier: $folder" -ForegroundColor Yellow
        New-Item -Path $folder -ItemType Directory -Force | Out-Null
    }
}

# 2. Copier les images des mondes vers le dossier des assets
$mondesFolders = Get-ChildItem -Path "Mondes" -Directory | Where-Object { $_.Name -ne "web.config" }

foreach ($mondeFolder in $mondesFolders) {
    $mondeName = $mondeFolder.Name
    $targetFolder = $mondeName -replace "Le monde de l'", "" -replace "Le monde de la ", "" -replace "Le monde des ", "" -replace "Le monde du ", "" -replace "Le monde ", ""
    $targetFolder = $targetFolder.Trim().ToLower()
    
    # Créer le dossier cible s'il n'existe pas déjà
    $targetPath = "Site\assets\images\mondes\$targetFolder"
    if (-not (Test-Path $targetPath)) {
        Write-Host "Création du dossier pour les images de $mondeName : $targetPath" -ForegroundColor Yellow
        New-Item -Path $targetPath -ItemType Directory -Force | Out-Null
    }
    
    # Copier les images
    $images = Get-ChildItem -Path $mondeFolder.FullName -Filter "*.jpg" -Recurse
    foreach ($image in $images) {
        $targetFile = Join-Path -Path $targetPath -ChildPath $image.Name
        Write-Host "Copie de l'image: $($image.FullName) vers $targetFile" -ForegroundColor Cyan
        Copy-Item -Path $image.FullName -Destination $targetFile -Force
    }
    
    $images = Get-ChildItem -Path $mondeFolder.FullName -Filter "*.png" -Recurse
    foreach ($image in $images) {
        $targetFile = Join-Path -Path $targetPath -ChildPath $image.Name
        Write-Host "Copie de l'image: $($image.FullName) vers $targetFile" -ForegroundColor Cyan
        Copy-Item -Path $image.FullName -Destination $targetFile -Force
    }
}

# 3. Copier la carte principale
$carteSource = "Mondes\Carte de Malvinaland stylisée.png"
$carteTarget = "Site\assets\images\carte\Carte de Malvinaland stylisée.png"
if (Test-Path $carteSource) {
    Write-Host "Copie de la carte principale: $carteSource vers $carteTarget" -ForegroundColor Cyan
    Copy-Item -Path $carteSource -Destination $carteTarget -Force
}

# 4. Corriger les chemins dans les fichiers HTML
$htmlFiles = Get-ChildItem -Path "Site" -Filter "*.html" -Recurse

foreach ($htmlFile in $htmlFiles) {
    $content = Get-Content -Path $htmlFile.FullName -Raw
    
    # Corriger les chemins des images
    $content = $content -replace '/Mondes/([^"]+\.(?:jpg|png|gif))', '/assets/images/mondes/$1'
    $content = $content -replace '/Mondes/Carte de Malvinaland stylisée.png', '/assets/images/carte/Carte de Malvinaland stylisée.png'
    
    # Corriger les chemins des scripts
    $content = $content -replace '/Site/Core/', '/content/'
    
    # Écrire le contenu modifié
    Set-Content -Path $htmlFile.FullName -Value $content
    Write-Host "Correction des chemins dans: $($htmlFile.FullName)" -ForegroundColor Magenta
}

Write-Host "Correction des fichiers du site terminée!" -ForegroundColor Green