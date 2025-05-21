Add-Type -AssemblyName System.Drawing

# Fonction pour créer une icône PNG
function Create-PngIcon {
    param (
        [string]$outputPath,
        [int]$width,
        [int]$height
    )
    
    # Créer une nouvelle image avec fond transparent
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    
    # Couleur de fond #3f51b5 (bleu indigo)
    $backgroundColor = [System.Drawing.ColorTranslator]::FromHtml("#3f51b5")
    
    # Remplir le cercle avec la couleur de fond
    $graphics.Clear([System.Drawing.Color]::Transparent)
    $brush = New-Object System.Drawing.SolidBrush($backgroundColor)
    $graphics.FillEllipse($brush, 0, 0, $width, $height)
    
    # Dessiner la lettre M en blanc
    $fontFamily = [System.Drawing.FontFamily]::GenericSansSerif
    $fontSize = $width * 0.6  # Taille de police proportionnelle à la largeur
    $font = New-Object System.Drawing.Font($fontFamily, $fontSize, [System.Drawing.FontStyle]::Bold)
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    
    # Mesurer le texte pour le centrer
    $textSize = $graphics.MeasureString("M", $font)
    $x = ($width - $textSize.Width) / 2
    $y = ($height - $textSize.Height) / 2
    
    # Dessiner le texte
    $graphics.DrawString("M", $font, $textBrush, $x, $y)
    
    # Sauvegarder l'image
    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Libérer les ressources
    $graphics.Dispose()
    $bitmap.Dispose()
    
    Write-Host "Icône PNG créée avec succès : $outputPath"
}

# Créer le répertoire s'il n'existe pas
$iconDir = "src\assets\icons"
if (-not (Test-Path $iconDir)) {
    New-Item -Path $iconDir -ItemType Directory -Force | Out-Null
}

# Créer l'icône 144x144
Create-PngIcon -outputPath "$iconDir\icon-144x144.png" -width 144 -height 144

# Copier l'icône dans le répertoire site/assets/icons
$siteIconDir = "site\assets\icons"
if (-not (Test-Path $siteIconDir)) {
    New-Item -Path $siteIconDir -ItemType Directory -Force | Out-Null
}
Copy-Item -Path "$iconDir\icon-144x144.png" -Destination "$siteIconDir\icon-144x144.png" -Force

Write-Host "Icône copiée avec succès dans $siteIconDir\icon-144x144.png"