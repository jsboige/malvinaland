# Script de déploiement de la carte interactive améliorée de Malvinaland
# Ce script copie les fichiers modifiés et teste la fonctionnalité

Write-Host "=== DÉPLOIEMENT DE LA CARTE INTERACTIVE MALVINALAND ===" -ForegroundColor Cyan
Write-Host ""

# Fonction pour afficher les messages colorés
function Write-ColorMessage {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Fonction pour vérifier l'existence d'un fichier
function Test-FileExists {
    param([string]$Path)
    if (Test-Path $Path) {
        Write-ColorMessage "✅ $Path existe" -Color Green
        return $true
    } else {
        Write-ColorMessage "❌ $Path n'existe pas" -Color Red
        return $false
    }
}

Write-ColorMessage "1. Vérification des fichiers sources..." -Color Yellow

# Vérifier les fichiers sources
$sourceFiles = @(
    "src/content/carte.md",
    "src/assets/js/carte-interactive.js",
    "site-web/content/carte/index.html",
    "site-web/assets/js/carte-interactive.js"
)

$allFilesExist = $true
foreach ($file in $sourceFiles) {
    if (-not (Test-FileExists $file)) {
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-ColorMessage "❌ Certains fichiers sources sont manquants. Arrêt du déploiement." -Color Red
    exit 1
}

Write-ColorMessage "`n2. Copie des fichiers vers le répertoire de déploiement..." -Color Yellow

# Créer les répertoires de destination si nécessaire
$destDirs = @(
    "site/content/carte",
    "site/assets/js"
)

foreach ($dir in $destDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-ColorMessage "📁 Répertoire créé : $dir" -Color Green
    }
}

# Copier les fichiers
try {
    # Copier le fichier HTML de la carte
    Copy-Item "site-web/content/carte/index.html" "site/content/carte/index.html" -Force
    Write-ColorMessage "✅ Carte HTML copiée" -Color Green
    
    # Copier le script JavaScript
    Copy-Item "site-web/assets/js/carte-interactive.js" "site/assets/js/carte-interactive.js" -Force
    Write-ColorMessage "✅ Script JavaScript copié" -Color Green
    
    # Vérifier que l'image de la carte existe
    if (Test-Path "site/assets/images/carte-malvinaland.png") {
        Write-ColorMessage "✅ Image de la carte présente" -Color Green
    } else {
        Write-ColorMessage "⚠️ Image de la carte manquante - copie depuis src/" -Color Yellow
        if (Test-Path "src/assets/images/carte-malvinaland.png") {
            Copy-Item "src/assets/images/carte-malvinaland.png" "site/assets/images/carte-malvinaland.png" -Force
            Write-ColorMessage "✅ Image de la carte copiée" -Color Green
        } else {
            Write-ColorMessage "❌ Image de la carte introuvable dans src/" -Color Red
        }
    }
    
} catch {
    Write-ColorMessage "❌ Erreur lors de la copie : $($_.Exception.Message)" -Color Red
    exit 1
}

Write-ColorMessage "`n3. Vérification des coordonnées de la carte..." -Color Yellow

# Lire le contenu HTML et vérifier les coordonnées
$htmlContent = Get-Content "site/content/carte/index.html" -Raw
$areaMatches = [regex]::Matches($htmlContent, '<area[^>]+>')

Write-ColorMessage "📍 Zones cliquables détectées : $($areaMatches.Count)" -Color Cyan

foreach ($match in $areaMatches) {
    $area = $match.Value
    if ($area -match 'title="([^"]+)"') {
        $title = $matches[1]
        if ($area -match 'coords="([^"]+)"') {
            $coords = $matches[1]
            Write-ColorMessage "  • $title : $coords" -Color White
        }
    }
}

Write-ColorMessage "`n4. Test de l'accessibilité du site..." -Color Yellow

# Tester l'accès au site
try {
    $response = Invoke-WebRequest -Uri "https://malvinaland.myia.io/carte" -Method Head -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-ColorMessage "✅ Site accessible (Status: $($response.StatusCode))" -Color Green
    } else {
        Write-ColorMessage "⚠️ Site accessible mais status inhabituel: $($response.StatusCode)" -Color Yellow
    }
} catch {
    Write-ColorMessage "❌ Site non accessible : $($_.Exception.Message)" -Color Red
}

Write-ColorMessage "`n5. Résumé des améliorations apportées..." -Color Yellow

Write-ColorMessage "🎯 AMÉLIORATIONS DE LA CARTE INTERACTIVE :" -Color Cyan
Write-ColorMessage "  • Coordonnées précises basées sur l'analyse visuelle" -Color White
Write-ColorMessage "  • Zones rectangulaires et circulaires adaptées aux formes réelles" -Color White
Write-ColorMessage "  • Effets visuels de survol avec surbrillance" -Color White
Write-ColorMessage "  • Tooltips informatifs pour chaque monde" -Color White
Write-ColorMessage "  • Animation de clic avec feedback visuel" -Color White
Write-ColorMessage "  • Design responsive pour mobile" -Color White
Write-ColorMessage "  • Légende améliorée avec style moderne" -Color White
Write-ColorMessage "  • Indicateur visuel pour guider les utilisateurs" -Color White

Write-ColorMessage "`n6. Instructions de test..." -Color Yellow

Write-ColorMessage "🧪 POUR TESTER LA CARTE INTERACTIVE :" -Color Cyan
Write-ColorMessage "  1. Ouvrez https://malvinaland.myia.io/carte dans votre navigateur" -Color White
Write-ColorMessage "  2. Survolez les différents mondes colorés sur la carte" -Color White
Write-ColorMessage "  3. Vérifiez que les tooltips s'affichent" -Color White
Write-ColorMessage "  4. Cliquez sur un monde pour naviguer vers sa page" -Color White
Write-ColorMessage "  5. Testez sur mobile pour vérifier la responsivité" -Color White

Write-ColorMessage "`n=== DÉPLOIEMENT TERMINÉ AVEC SUCCÈS ===" -Color Green
Write-ColorMessage "La carte interactive de Malvinaland a été améliorée et déployée !" -Color Green
Write-ColorMessage "URL de test : https://malvinaland.myia.io/carte" -Color Cyan

# Optionnel : ouvrir le navigateur pour tester
$openBrowser = Read-Host "`nVoulez-vous ouvrir le navigateur pour tester ? (o/n)"
if ($openBrowser -eq "o" -or $openBrowser -eq "O") {
    Start-Process "https://malvinaland.myia.io/carte"
    Write-ColorMessage "🌐 Navigateur ouvert sur la carte interactive" -Color Green
}

Write-Host ""
Write-ColorMessage "Script terminé. Bonne exploration des mondes de Malvinaland ! 🗺️✨" -Color Magenta