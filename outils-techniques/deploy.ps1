# Script de déploiement pour "Les mondes de Malvinha"
# Ce script réorganise la structure du projet selon le README et génère des miniatures pour les images

# Définition des chemins
$rootPath = $PSScriptRoot
$sitePath = Join-Path -Path $rootPath -ChildPath "site"
$resourcesPath = Join-Path -Path $rootPath -ChildPath "ressources"
$resourcesImagesPath = Join-Path -Path $resourcesPath -ChildPath "images"
$docsPath = Join-Path -Path $rootPath -ChildPath "docs"

# Fonction pour créer un dossier s'il n'existe pas
function EnsureFolderExists {
    param (
        [string]$folderPath
    )
    
    if (-not (Test-Path -Path $folderPath)) {
        New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
        Write-Host "Dossier créé: $folderPath" -ForegroundColor Green
    }
}

# Fonction pour générer une miniature d'une image
function GenerateThumbnail {
    param (
        [string]$sourcePath,
        [string]$targetPath,
        [int]$maxWidth = 300,
        [int]$maxHeight = 200
    )
    
    try {
        Add-Type -AssemblyName System.Drawing
        
        # Charger l'image source
        $image = [System.Drawing.Image]::FromFile($sourcePath)
        
        # Calculer les dimensions de la miniature
        $ratio = [Math]::Min(($maxWidth / $image.Width), ($maxHeight / $image.Height))
        $newWidth = [int]($image.Width * $ratio)
        $newHeight = [int]($image.Height * $ratio)
        
        # Créer la miniature
        $thumbnail = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
        $graphics = [System.Drawing.Graphics]::FromImage($thumbnail)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($image, 0, 0, $newWidth, $newHeight)
        
        # Enregistrer la miniature
        $thumbnail.Save($targetPath, $image.RawFormat)
        
        # Libérer les ressources
        $graphics.Dispose()
        $thumbnail.Dispose()
        $image.Dispose()
        
        Write-Host "Miniature générée: $targetPath" -ForegroundColor Green
    }
    catch {
        Write-Host "Erreur lors de la génération de la miniature: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Fonction pour mettre à jour les références dans les fichiers HTML
function UpdateHtmlReferences {
    param (
        [string]$htmlPath,
        [string]$mondeName
    )
    
    try {
        $content = Get-Content -Path $htmlPath -Raw -Encoding UTF8
        
        # Remplacer les références aux images
        $pattern = '<img src="assets/([^"]+)" alt="([^"]+)" class="gallery-image">'
        $replacement = '<img src="thumbnails/$1" data-high-res="../../ressources/images/' + $mondeName + '/$1" alt="$2" class="gallery-image">'
        $content = $content -replace $pattern, $replacement
        
        # Mettre à jour les chemins vers Core
        $content = $content -replace '../../Core/', '../../Core/'
        
        # Mettre à jour les chemins vers Services
        $content = $content -replace '../../Services/', '../../Services/'
        $content = $content -replace '/Services/', '/Services/'
        $content = $content -replace 'Services/sw.js', 'Services/sw.js'
        
        # Mettre à jour les chemins vers Composants
        $content = $content -replace '../../Composants/', '../../Composants/'
        $content = $content -replace '/Composants/', '/Composants/'
        
        # Mettre à jour les références à app.js
        $content = $content -replace '../../app.js', '../../app.js'
        $content = $content -replace '/app.js', '/app.js'
        
        # Ajouter le script de chargement différé des images
        $scriptPattern = '<script src="../../Core/navigation.js"></script>'
        $scriptReplacement = '<script src="../../Core/navigation.js"></script>' + "`r`n" + '    <script src="../../Core/image-loader.js"></script>'
        $content = $content -replace $scriptPattern, $scriptReplacement
        
        # Enregistrer les modifications
        Set-Content -Path $htmlPath -Value $content -Encoding UTF8
        
        Write-Host "Références mises à jour dans: $htmlPath" -ForegroundColor Green
    }
    catch {
        Write-Host "Erreur lors de la mise à jour des références: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Fonction pour créer le script de chargement différé des images
function CreateImageLoaderScript {
    param (
        [string]$targetPath
    )
    
    $scriptContent = @"
/**
 * Script de chargement différé des images
 * Ce script détecte les images avec l'attribut data-high-res et les charge en arrière-plan
 */
document.addEventListener('DOMContentLoaded', function() {
    // Sélectionner toutes les images avec l'attribut data-high-res
    const images = document.querySelectorAll('img[data-high-res]');
    
    // Pour chaque image
    images.forEach(function(img) {
        // Précharger l'image haute résolution
        const highResUrl = img.getAttribute('data-high-res');
        const preloadImage = new Image();
        preloadImage.src = highResUrl;
        
        // Charger l'image haute résolution au survol
        img.addEventListener('mouseenter', function() {
            img.src = highResUrl;
        });
        
        // Charger l'image haute résolution au clic
        img.addEventListener('click', function() {
            img.src = highResUrl;
        });
        
        // Observer l'image pour la charger quand elle devient visible
        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    img.src = highResUrl;
                    observer.unobserve(img);
                }
            });
        });
        
        observer.observe(img);
    });
});
"@
    
    Set-Content -Path $targetPath -Value $scriptContent -Encoding UTF8
    Write-Host "Script de chargement différé créé: $targetPath" -ForegroundColor Green
}

# Afficher un message de bienvenue
Write-Host "=== Script de déploiement pour 'Les mondes de Malvinha' ===" -ForegroundColor Cyan
Write-Host "Ce script va réorganiser la structure du projet et générer des miniatures pour les images." -ForegroundColor Cyan
Write-Host "Veuillez patienter pendant le processus de déploiement..." -ForegroundColor Cyan
Write-Host ""

# Étape 1: Créer la structure de dossiers
Write-Host "Étape 1: Création de la structure de dossiers..." -ForegroundColor Yellow

# Créer les dossiers principaux
EnsureFolderExists -folderPath $sitePath
EnsureFolderExists -folderPath $resourcesPath
EnsureFolderExists -folderPath $resourcesImagesPath
EnsureFolderExists -folderPath $docsPath

# Créer les dossiers pour les images
EnsureFolderExists -folderPath (Join-Path -Path $sitePath -ChildPath "assets")
EnsureFolderExists -folderPath (Join-Path -Path $sitePath -ChildPath "thumbnails")

# Créer les sous-dossiers du site
EnsureFolderExists -folderPath (Join-Path -Path $sitePath -ChildPath "Core")
EnsureFolderExists -folderPath (Join-Path -Path $sitePath -ChildPath "Mondes")
EnsureFolderExists -folderPath (Join-Path -Path $sitePath -ChildPath "PNJ")

# Étape 2: Copier les fichiers nécessaires
Write-Host "Étape 2: Copie des fichiers nécessaires..." -ForegroundColor Yellow

# Copier les fichiers de base
Copy-Item -Path (Join-Path -Path $rootPath -ChildPath "index.html") -Destination $sitePath -Force
Copy-Item -Path (Join-Path -Path $rootPath -ChildPath "web.config") -Destination $sitePath -Force

# Copier les fichiers Core
Copy-Item -Path (Join-Path -Path $rootPath -ChildPath "Core\*") -Destination (Join-Path -Path $sitePath -ChildPath "Core") -Recurse -Force

# Créer le script de chargement différé des images
CreateImageLoaderScript -targetPath (Join-Path -Path $sitePath -ChildPath "Core\image-loader.js")

# Créer le dossier Services dans le dossier site
$siteServicesPath = Join-Path -Path $sitePath -ChildPath "Services"
EnsureFolderExists -folderPath $siteServicesPath

# Copier les fichiers du service worker
Write-Host "Copie des fichiers du service worker..." -ForegroundColor Yellow
Copy-Item -Path (Join-Path -Path $rootPath -ChildPath "Site\Services\sw.js") -Destination $siteServicesPath -Force
Copy-Item -Path (Join-Path -Path $rootPath -ChildPath "Site\Services\serviceWorker.js") -Destination $siteServicesPath -Force

# Copier le fichier app.js dans le dossier site
Write-Host "Copie du fichier app.js..." -ForegroundColor Yellow
Copy-Item -Path (Join-Path -Path $rootPath -ChildPath "Site\app.js") -Destination $sitePath -Force

# Créer le dossier Composants dans le dossier site
$siteComposantsPath = Join-Path -Path $sitePath -ChildPath "Composants"
EnsureFolderExists -folderPath $siteComposantsPath

# Copier les styles du dossier Composants
Write-Host "Copie des styles du dossier Composants..." -ForegroundColor Yellow
Copy-Item -Path (Join-Path -Path $rootPath -ChildPath "Site\Composants\styles.css") -Destination $siteComposantsPath -Force

# Copier la carte de Malvinaland
$carteSource = Join-Path -Path $rootPath -ChildPath "Mondes\Carte de Malvinaland stylisée.png"
$carteDestination = Join-Path -Path $sitePath -ChildPath "Mondes\Carte de Malvinaland stylisée.png"
Copy-Item -Path $carteSource -Destination $carteDestination -Force

# Copier le web.config des mondes
Copy-Item -Path (Join-Path -Path $rootPath -ChildPath "Mondes\web.config") -Destination (Join-Path -Path $sitePath -ChildPath "Mondes") -Force

# Étape 3: Traiter chaque monde
Write-Host "Étape 3: Traitement des mondes..." -ForegroundColor Yellow

# Récupérer tous les dossiers de mondes
$mondesFolders = Get-ChildItem -Path (Join-Path -Path $rootPath -ChildPath "Mondes") -Directory | Where-Object { $_.Name -like "Le monde*" -or $_.Name -like "Le Monde*" }

foreach ($mondeFolder in $mondesFolders) {
    $mondeName = $mondeFolder.Name
    Write-Host "Traitement du monde: $mondeName" -ForegroundColor Cyan
    
    # Créer les dossiers pour ce monde
    $siteMondePath = Join-Path -Path $sitePath -ChildPath "Mondes\$mondeName"
    $siteMondeThumbnailsPath = Join-Path -Path $siteMondePath -ChildPath "thumbnails"
    $siteMondeAssetsPath = Join-Path -Path $siteMondePath -ChildPath "assets"
    $resourcesMondePath = Join-Path -Path $resourcesImagesPath -ChildPath $mondeName
    
    EnsureFolderExists -folderPath $siteMondePath
    EnsureFolderExists -folderPath $siteMondeThumbnailsPath
    EnsureFolderExists -folderPath $siteMondeAssetsPath
    EnsureFolderExists -folderPath $resourcesMondePath
    
    # Copier les fichiers HTML, JS et CSS
    Copy-Item -Path (Join-Path -Path $mondeFolder.FullName -ChildPath "*.html") -Destination $siteMondePath -Force
    Copy-Item -Path (Join-Path -Path $mondeFolder.FullName -ChildPath "*.js") -Destination $siteMondePath -Force
    Copy-Item -Path (Join-Path -Path $mondeFolder.FullName -ChildPath "*.css") -Destination $siteMondePath -Force
    
    # Traiter les images
    $assetsFolder = Join-Path -Path $mondeFolder.FullName -ChildPath "assets"
    if (Test-Path -Path $assetsFolder) {
        $images = Get-ChildItem -Path $assetsFolder -File -Include "*.jpg", "*.jpeg", "*.png", "*.gif"
        
        foreach ($image in $images) {
            # Copier l'image dans le dossier assets du monde
            $assetsDestination = Join-Path -Path $siteMondeAssetsPath -ChildPath $image.Name
            Copy-Item -Path $image.FullName -Destination $assetsDestination -Force
            
            # Copier l'image haute résolution dans le dossier ressources
            $highResDestination = Join-Path -Path $resourcesMondePath -ChildPath $image.Name
            Copy-Item -Path $image.FullName -Destination $highResDestination -Force
            
            # Générer une miniature
            $thumbnailDestination = Join-Path -Path $siteMondeThumbnailsPath -ChildPath $image.Name
            GenerateThumbnail -sourcePath $image.FullName -targetPath $thumbnailDestination
        }
    }
    
    # Mettre à jour les références dans les fichiers HTML
    $htmlFiles = Get-ChildItem -Path $siteMondePath -Filter "*.html"
    foreach ($htmlFile in $htmlFiles) {
        UpdateHtmlReferences -htmlPath $htmlFile.FullName -mondeName $mondeName
    }
}

# Étape 4: Copier la documentation dans le dossier docs
Write-Host "Étape 4: Copie de la documentation..." -ForegroundColor Yellow

$docFiles = @(
    "README.md",
    "README_ORGANISATION.md",
    "guide_creation_prompts.md",
    "guide_installation.md",
    "matériel.md",
    "prompt_enrichissement_monde.md",
    "prompts_site_web.md",
    "blocs_taches_mondes.md"
)

foreach ($docFile in $docFiles) {
    $sourcePath = Join-Path -Path $rootPath -ChildPath $docFile
    if (Test-Path -Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $docsPath -Force
    }
}

# Copier les dossiers de documentation
$docFolders = @(
    "Cartes",
    "Narration",
    "Prompts"
)

foreach ($docFolder in $docFolders) {
    $sourcePath = Join-Path -Path $rootPath -ChildPath $docFolder
    if (Test-Path -Path $sourcePath) {
        $destinationPath = Join-Path -Path $docsPath -ChildPath $docFolder
        EnsureFolderExists -folderPath $destinationPath
        Copy-Item -Path "$sourcePath\*" -Destination $destinationPath -Recurse -Force
    }
}

# Étape 5: Mise à jour du fichier index.html dans le dossier site
Write-Host "Étape 5: Mise à jour du fichier index.html dans le dossier site..." -ForegroundColor Yellow

$siteIndexPath = Join-Path -Path $sitePath -ChildPath "index.html"
if (Test-Path -Path $siteIndexPath) {
    try {
        $indexContent = Get-Content -Path $siteIndexPath -Raw -Encoding UTF8
        
        # Mettre à jour les références dans le fichier index.html
        $indexContent = $indexContent -replace 'Core/index.html', 'Core/index.html'
        $indexContent = $indexContent -replace '<script src="app.js">', '<script src="app.js">'
        
        # Enregistrer les modifications
        Set-Content -Path $siteIndexPath -Value $indexContent -Encoding UTF8
        
        Write-Host "Références mises à jour dans: $siteIndexPath" -ForegroundColor Green
    }
    catch {
        Write-Host "Erreur lors de la mise à jour des références dans index.html: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Étape 6: Finalisation
Write-Host "Étape 6: Finalisation du déploiement..." -ForegroundColor Yellow

# Créer un fichier README dans le dossier site
$siteReadmeContent = @"
# Site déployable "Les mondes de Malvinha"

Ce dossier contient la version déployable du site "Les mondes de Malvinha".
Il est conçu pour être léger et ne contient que les fichiers nécessaires au fonctionnement du site.

Les images haute résolution sont stockées dans le dossier `../ressources/images/`.

## Structure du site

- `index.html` : Page de redirection vers Core/index.html
- `web.config` : Configuration IIS
- `app.js` : Script JavaScript principal
- `Core/` : Configuration et navigation communes
- `Composants/` : Styles CSS communs
- `Mondes/` : Structure légère des mondes avec miniatures
- `Services/` : Service worker pour le fonctionnement hors ligne

## Déploiement

Pour déployer ce site, copiez simplement ce dossier sur votre serveur web.
"@

Set-Content -Path (Join-Path -Path $sitePath -ChildPath "README.md") -Value $siteReadmeContent -Encoding UTF8

# Créer un fichier README dans le dossier ressources
$resourcesReadmeContent = @"
# Ressources "Les mondes de Malvinha"

Ce dossier contient les ressources volumineuses du projet "Les mondes de Malvinha".
Il n'est pas destiné à être déployé sur le serveur web, mais à être conservé localement.

## Structure

- `images/` : Images haute résolution organisées par monde
"@

Set-Content -Path (Join-Path -Path $resourcesPath -ChildPath "README.md") -Value $resourcesReadmeContent -Encoding UTF8

# Afficher un message de fin
Write-Host ""
Write-Host "=== Déploiement terminé avec succès ===" -ForegroundColor Green
Write-Host "La structure du projet a été réorganisée selon le README." -ForegroundColor Green
Write-Host "Les miniatures ont été générées dans les dossiers 'thumbnails/'." -ForegroundColor Green
Write-Host "Les images haute résolution ont été déplacées dans le dossier 'ressources/images/'." -ForegroundColor Green
Write-Host ""
Write-Host "Pour déployer le site sur un serveur IIS :" -ForegroundColor Cyan
Write-Host "1. Copiez uniquement le dossier 'site/' sur le serveur web dans le répertoire racine du site IIS" -ForegroundColor Cyan
Write-Host "2. Assurez-vous que le site est configuré dans IIS Manager avec le bon chemin physique" -ForegroundColor Cyan
Write-Host "3. Vérifiez que les autorisations sont correctement définies pour l'utilisateur IIS" -ForegroundColor Cyan
Write-Host "4. Assurez-vous que le module URL Rewrite est installé pour la redirection HTTPS" -ForegroundColor Cyan
Write-Host "5. Testez l'accès au site via https://malvinaland.myia.io/" -ForegroundColor Cyan
Write-Host "6. Conservez le dossier 'ressources/' sur un stockage local ou un serveur de fichiers séparé" -ForegroundColor Cyan
Write-Host ""