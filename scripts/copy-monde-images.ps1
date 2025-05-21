# Script pour copier les images des mondes depuis le dossier ressources vers le dossier site/assets/images/mondes
# Ce script assure que tous les dossiers des mondes sont présents et contiennent les images nécessaires

# Définir les chemins source et destination
$sourceDir = "ressources/images"
$destDir = "site/assets/images/mondes"

# Vérifier si le dossier de destination existe, sinon le créer
if (-not (Test-Path $destDir)) {
    Write-Host "Création du dossier $destDir..."
    New-Item -Path $destDir -ItemType Directory -Force | Out-Null
}

# Définir la correspondance entre les noms de dossiers source et destination
$mondeMapping = @{
    "Le monde de l'assemblée" = "assemblee"
    "Le monde de la grange" = "grange"
    "Le monde des jeux" = "jeux"
    "Le monde des rêves" = "reves"
    "Le monde du damier" = "damier"
    "Le monde du linge" = "linge"
    "Le monde du verger" = "verger"
    "Le monde du Zob" = "zob"
    "Le monde Elysée" = "elysee"
    "Le monde Karibu" = "karibu"
    "Le monde orange des Sphinx" = "sphinx"
}

# Fonction pour copier les images d'un monde
function Copy-MondeImages {
    param (
        [string]$sourceName,
        [string]$destName
    )
    
    $sourceMondeDir = Join-Path $sourceDir $sourceName
    $destMondeDir = Join-Path $destDir $destName
    
    # Vérifier si le dossier source existe
    if (-not (Test-Path $sourceMondeDir)) {
        Write-Host "Dossier source non trouvé : $sourceMondeDir" -ForegroundColor Yellow
        return
    }
    
    # Créer le dossier de destination s'il n'existe pas
    if (-not (Test-Path $destMondeDir)) {
        Write-Host "Création du dossier $destMondeDir..."
        New-Item -Path $destMondeDir -ItemType Directory -Force | Out-Null
    }
    
    # Obtenir la liste des fichiers image dans le dossier source
    $imageFiles = Get-ChildItem -Path $sourceMondeDir -File | Where-Object { 
        $_.Extension -match '\.(jpg|jpeg|png|gif|webp)$' 
    }
    
    # Copier chaque image
    foreach ($file in $imageFiles) {
        $destFile = Join-Path $destMondeDir $file.Name
        
        # Vérifier si le fichier existe déjà et s'il est différent
        $shouldCopy = $true
        if (Test-Path $destFile) {
            $sourceHash = Get-FileHash -Path $file.FullName -Algorithm MD5
            $destHash = Get-FileHash -Path $destFile -Algorithm MD5
            
            if ($sourceHash.Hash -eq $destHash.Hash) {
                Write-Host "Le fichier $($file.Name) existe déjà et est identique. Ignoré." -ForegroundColor Gray
                $shouldCopy = $false
            }
        }
        
        if ($shouldCopy) {
            Write-Host "Copie de $($file.Name) vers $destMondeDir..."
            Copy-Item -Path $file.FullName -Destination $destFile -Force
        }
    }
    
    # Vérifier le nombre d'images copiées
    $copiedFiles = Get-ChildItem -Path $destMondeDir -File | Where-Object { 
        $_.Extension -match '\.(jpg|jpeg|png|gif|webp)$' 
    }
    
    Write-Host "Monde $destName : $($copiedFiles.Count) images présentes." -ForegroundColor Green
}

# Copier les images pour chaque monde
Write-Host "Début de la copie des images des mondes..." -ForegroundColor Cyan

foreach ($monde in $mondeMapping.GetEnumerator()) {
    Write-Host "Traitement du monde : $($monde.Key) -> $($monde.Value)" -ForegroundColor Cyan
    Copy-MondeImages -sourceName $monde.Key -destName $monde.Value
}

# Vérifier que tous les dossiers des mondes sont présents
$expectedMondes = $mondeMapping.Values
$existingMondes = Get-ChildItem -Path $destDir -Directory | ForEach-Object { $_.Name }

# Identifier les mondes manquants
$missingMondes = $expectedMondes | Where-Object { $existingMondes -notcontains $_ }
if ($missingMondes.Count -gt 0) {
    Write-Host "Mondes manquants : $($missingMondes -join ', ')" -ForegroundColor Yellow
    
    # Créer les dossiers manquants
    foreach ($monde in $missingMondes) {
        $missingDir = Join-Path $destDir $monde
        Write-Host "Création du dossier manquant : $missingDir" -ForegroundColor Yellow
        New-Item -Path $missingDir -ItemType Directory -Force | Out-Null
    }
}

# Afficher un résumé
$totalImages = 0
foreach ($monde in $existingMondes) {
    $mondeDir = Join-Path $destDir $monde
    $imageCount = (Get-ChildItem -Path $mondeDir -File | Where-Object { 
        $_.Extension -match '\.(jpg|jpeg|png|gif|webp)$' 
    }).Count
    $totalImages += $imageCount
}

Write-Host "Copie des images terminée." -ForegroundColor Green
Write-Host "Total des images copiées : $totalImages" -ForegroundColor Green
Write-Host "Tous les dossiers des mondes sont présents : $($existingMondes.Count) mondes." -ForegroundColor Green