# Script pour générer une image de carte simple pour Malvinaland
# Ce script crée une image PNG de base qui sera utilisée comme carte du site

# Vérifier si le dossier de destination existe, sinon le créer
$imageDir = "site/assets/images"
$carteDir = "$imageDir/carte"

if (-not (Test-Path $carteDir)) {
    Write-Host "Création du dossier $carteDir..."
    New-Item -Path $carteDir -ItemType Directory -Force | Out-Null
}

# Chemin de l'image à créer
$imagePath = "$imageDir/carte-malvinaland.png"

# Utilisation de System.Drawing pour créer une image simple
Add-Type -AssemblyName System.Drawing

# Définir les dimensions de l'image
$width = 800
$height = 600

# Créer un bitmap
$bitmap = New-Object System.Drawing.Bitmap($width, $height)

# Créer un objet Graphics à partir du bitmap
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

# Remplir l'arrière-plan avec une couleur claire
$backgroundColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
$graphics.Clear($backgroundColor)

# Définir les couleurs pour les différents mondes
$mondeColors = @{
    "Assemblée" = [System.Drawing.Color]::FromArgb(231, 76, 60)    # Rouge
    "Damier" = [System.Drawing.Color]::FromArgb(135, 206, 235)     # Bleu ciel
    "Elysée" = [System.Drawing.Color]::FromArgb(255, 255, 255)     # Blanc
    "Grange" = [System.Drawing.Color]::FromArgb(46, 204, 113)      # Vert
    "Jeux" = [System.Drawing.Color]::FromArgb(52, 152, 219)        # Bleu
    "Karibu" = [System.Drawing.Color]::FromArgb(255, 165, 0)       # Orange
    "Linge" = [System.Drawing.Color]::FromArgb(147, 112, 219)      # Violet
    "Rêves" = [System.Drawing.Color]::FromArgb(155, 89, 182)       # Pourpre
    "Sphinx" = [System.Drawing.Color]::FromArgb(255, 69, 0)        # Rouge-orange
    "Verger" = [System.Drawing.Color]::FromArgb(255, 192, 203)     # Rose
    "Zob" = [System.Drawing.Color]::FromArgb(255, 127, 80)         # Corail
}

# Créer un stylo pour dessiner les contours
$pen = New-Object System.Drawing.Pen([System.Drawing.Color]::Black, 2)

# Créer une police pour le texte
$font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Black)

# Dessiner un titre
$titleFont = New-Object System.Drawing.Font("Arial", 20, [System.Drawing.FontStyle]::Bold)
$titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(63, 81, 181))
$graphics.DrawString("Carte de Malvinaland", $titleFont, $titleBrush, 250, 30)

# Dessiner les mondes comme des cercles sur la carte
$mondePositions = @{
    "Assemblée" = @{X = 200; Y = 200; Radius = 40}
    "Damier" = @{X = 350; Y = 150; Radius = 45}
    "Elysée" = @{X = 500; Y = 200; Radius = 50}
    "Grange" = @{X = 650; Y = 250; Radius = 45}
    "Jeux" = @{X = 150; Y = 300; Radius = 40}
    "Karibu" = @{X = 300; Y = 350; Radius = 45}
    "Linge" = @{X = 450; Y = 400; Radius = 40}
    "Rêves" = @{X = 600; Y = 350; Radius = 45}
    "Sphinx" = @{X = 250; Y = 450; Radius = 40}
    "Verger" = @{X = 400; Y = 500; Radius = 45}
    "Zob" = @{X = 550; Y = 450; Radius = 40}
}

# Dessiner des lignes entre les mondes pour représenter les chemins
$paths = @(
    @("Assemblée", "Jeux"),
    @("Assemblée", "Zob"),
    @("Assemblée", "Karibu"),
    @("Damier", "Elysée"),
    @("Damier", "Grange"),
    @("Elysée", "Grange"),
    @("Elysée", "Rêves"),
    @("Grange", "Rêves"),
    @("Jeux", "Karibu"),
    @("Karibu", "Linge"),
    @("Karibu", "Sphinx"),
    @("Linge", "Rêves"),
    @("Linge", "Sphinx"),
    @("Linge", "Verger"),
    @("Rêves", "Zob"),
    @("Sphinx", "Verger"),
    @("Verger", "Zob")
)

# Dessiner d'abord les chemins
$pathPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(150, 150, 150), 2)
foreach ($path in $paths) {
    $monde1 = $path[0]
    $monde2 = $path[1]
    $x1 = $mondePositions[$monde1].X
    $y1 = $mondePositions[$monde1].Y
    $x2 = $mondePositions[$monde2].X
    $y2 = $mondePositions[$monde2].Y
    $graphics.DrawLine($pathPen, $x1, $y1, $x2, $y2)
}

# Dessiner ensuite les mondes
foreach ($monde in $mondePositions.Keys) {
    $x = $mondePositions[$monde].X
    $y = $mondePositions[$monde].Y
    $radius = $mondePositions[$monde].Radius
    
    # Créer un pinceau avec la couleur du monde
    $brush = New-Object System.Drawing.SolidBrush($mondeColors[$monde])
    
    # Dessiner le cercle représentant le monde
    $graphics.FillEllipse($brush, $x - $radius, $y - $radius, $radius * 2, $radius * 2)
    $graphics.DrawEllipse($pen, $x - $radius, $y - $radius, $radius * 2, $radius * 2)
    
    # Ajouter le nom du monde
    $textSize = $graphics.MeasureString($monde, $font)
    $textX = $x - ($textSize.Width / 2)
    $textY = $y - ($textSize.Height / 2)
    $graphics.DrawString($monde, $font, $textBrush, $textX, $textY)
}

# Ajouter une légende
$legendX = 650
$legendY = 450
$legendFont = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$graphics.DrawString("Légende", $legendFont, $titleBrush, $legendX, $legendY)

$legendItemFont = New-Object System.Drawing.Font("Arial", 10)
$legendY += 30
$graphics.DrawString("○ Mondes", $legendItemFont, $textBrush, $legendX, $legendY)
$legendY += 20
$graphics.DrawString("- Chemins", $legendItemFont, $textBrush, $legendX, $legendY)

# Ajouter une boussole simple
$compassX = 700
$compassY = 100
$compassRadius = 30
$compassBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$graphics.FillEllipse($compassBrush, $compassX - $compassRadius, $compassY - $compassRadius, $compassRadius * 2, $compassRadius * 2)
$graphics.DrawEllipse($pen, $compassX - $compassRadius, $compassY - $compassRadius, $compassRadius * 2, $compassRadius * 2)

# Dessiner les points cardinaux
$compassFont = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$graphics.DrawString("N", $compassFont, $textBrush, $compassX - 5, $compassY - $compassRadius + 5)
$graphics.DrawString("S", $compassFont, $textBrush, $compassX - 5, $compassY + $compassRadius - 15)
$graphics.DrawString("E", $compassFont, $textBrush, $compassX + $compassRadius - 15, $compassY - 5)
$graphics.DrawString("O", $compassFont, $textBrush, $compassX - $compassRadius + 5, $compassY - 5)

# Dessiner les lignes de la boussole
$graphics.DrawLine($pen, $compassX, $compassY - $compassRadius + 15, $compassX, $compassY + $compassRadius - 15)
$graphics.DrawLine($pen, $compassX - $compassRadius + 15, $compassY, $compassX + $compassRadius - 15, $compassY)

# Sauvegarder l'image
try {
    $bitmap.Save($imagePath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "Image de carte créée avec succès : $imagePath"
} catch {
    Write-Host "Erreur lors de la création de l'image : $_" -ForegroundColor Red
} finally {
    # Libérer les ressources
    $graphics.Dispose()
    $bitmap.Dispose()
    $pen.Dispose()
    $textBrush.Dispose()
    $titleBrush.Dispose()
    $pathPen.Dispose()
    foreach ($brush in $mondeColors.Values) {
        $brush.Dispose()
    }
}

# Créer également une version plus petite pour la page d'accueil
$thumbnailPath = "$imageDir/carte-malvinaland-thumbnail.png"
try {
    # Charger l'image originale
    $originalImage = [System.Drawing.Image]::FromFile($imagePath)
    
    # Créer une version réduite
    $thumbnailWidth = 400
    $thumbnailHeight = 300
    $thumbnail = New-Object System.Drawing.Bitmap($thumbnailWidth, $thumbnailHeight)
    $thumbnailGraphics = [System.Drawing.Graphics]::FromImage($thumbnail)
    $thumbnailGraphics.DrawImage($originalImage, 0, 0, $thumbnailWidth, $thumbnailHeight)
    
    # Sauvegarder la miniature
    $thumbnail.Save($thumbnailPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "Miniature de la carte créée avec succès : $thumbnailPath"
} catch {
    Write-Host "Erreur lors de la création de la miniature : $_" -ForegroundColor Red
} finally {
    if ($thumbnailGraphics) { $thumbnailGraphics.Dispose() }
    if ($thumbnail) { $thumbnail.Dispose() }
    if ($originalImage) { $originalImage.Dispose() }
}

Write-Host "Génération de la carte terminée."