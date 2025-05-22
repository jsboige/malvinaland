# Script pour transférer le contenu détaillé des mondes qui ont échoué

# Liste des mondes à traiter
$mondes = @(
    @{Source="Le monde des rêves"; Destination="monde-reves"},
    @{Source="Le monde Elysée"; Destination="monde-elysee"}
)

# Fonction pour extraire le contenu entre deux balises HTML
function Extract-Content {
    param (
        [string]$content,
        [string]$startTag,
        [string]$endTag
    )
    
    $startIndex = $content.IndexOf($startTag)
    if ($startIndex -eq -1) {
        return $null
    }
    
    $startIndex = $startIndex + $startTag.Length
    $endIndex = $content.IndexOf($endTag, $startIndex)
    
    if ($endIndex -eq -1) {
        return $null
    }
    
    return $content.Substring($startIndex, $endIndex - $startIndex)
}

# Fonction pour remplacer le contenu entre deux balises HTML
function Replace-Content {
    param (
        [string]$content,
        [string]$startTag,
        [string]$endTag,
        [string]$newContent
    )
    
    $startIndex = $content.IndexOf($startTag)
    if ($startIndex -eq -1) {
        return $content
    }
    
    $startIndex = $startIndex + $startTag.Length
    $endIndex = $content.IndexOf($endTag, $startIndex)
    
    if ($endIndex -eq -1) {
        return $content
    }
    
    $before = $content.Substring(0, $startIndex)
    $after = $content.Substring($endIndex)
    
    return $before + $newContent + $after
}

# Fonction pour créer un répertoire s'il n'existe pas
function Ensure-Directory {
    param (
        [string]$path
    )
    
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "Répertoire créé : $path"
    }
}

# Fonction pour créer un fichier d'espace réservé pour une image
function Create-PlaceholderImage {
    param (
        [string]$path
    )
    
    if (-not (Test-Path $path)) {
        "Placeholder image" | Out-File -FilePath $path -Encoding utf8
        Write-Host "Fichier d'espace réservé créé : $path"
    }
}

# Fonction pour extraire les noms d'images référencées dans le contenu HTML
function Extract-ImageNames {
    param (
        [string]$content
    )
    
    $images = @()
    $pattern = 'src="([^"]+\.jpg)"'
    $matches = [regex]::Matches($content, $pattern)
    
    foreach ($match in $matches) {
        $imagePath = $match.Groups[1].Value
        $imageName = [System.IO.Path]::GetFileName($imagePath)
        $images += $imageName
    }
    
    return $images
}

# Traitement de chaque monde
foreach ($monde in $mondes) {
    $sourceDir = "Site/Mondes/$($monde.Source)"
    $sourceFile = "$sourceDir/index.html"
    $destFile = "Site/$($monde.Destination).html"
    $imageDir = "Site/images/$($monde.Destination)"
    
    Write-Host "Traitement de $($monde.Source) -> $($monde.Destination)"
    
    # Vérifier si les fichiers source et destination existent
    if (-not (Test-Path $sourceFile)) {
        Write-Host "Fichier source non trouvé : $sourceFile" -ForegroundColor Red
        continue
    }
    
    if (-not (Test-Path $destFile)) {
        Write-Host "Fichier destination non trouvé : $destFile" -ForegroundColor Red
        continue
    }
    
    # Lire le contenu des fichiers
    $sourceContent = Get-Content -Path $sourceFile -Raw -Encoding UTF8
    $destContent = Get-Content -Path $destFile -Raw -Encoding UTF8
    
    # Extraire les sections du fichier source
    $mainContent = Extract-Content -content $sourceContent -startTag "<main>" -endTag "</main>"
    
    if ($mainContent -eq $null) {
        Write-Host "Impossible d'extraire le contenu principal du fichier source" -ForegroundColor Red
        continue
    }
    
    # Remplacer le contenu principal dans le fichier destination
    $newDestContent = Replace-Content -content $destContent -startTag "<main>" -endTag "</main>" -newContent $mainContent
    
    # Écrire le nouveau contenu dans le fichier destination
    $newDestContent | Out-File -FilePath $destFile -Encoding utf8
    Write-Host "Contenu transféré pour $($monde.Destination)" -ForegroundColor Green
    
    # Créer le répertoire pour les images
    Ensure-Directory -path $imageDir
    
    # Extraire les noms d'images référencées et créer des fichiers d'espace réservé
    $images = Extract-ImageNames -content $mainContent
    foreach ($image in $images) {
        $imagePath = "$imageDir/$image"
        Create-PlaceholderImage -path $imagePath
    }
}

Write-Host "Transfert terminé pour les mondes restants" -ForegroundColor Green