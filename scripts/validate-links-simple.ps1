# Script de validation simple des liens de documentation
param([string]$DocumentationDir = "site/documentation")

Write-Host "Validation des liens de documentation" -ForegroundColor Green
Write-Host "Repertoire : $DocumentationDir" -ForegroundColor Yellow

# Vérifier que le répertoire existe
if (-not (Test-Path $DocumentationDir)) {
    Write-Host "Erreur: Repertoire introuvable" -ForegroundColor Red
    exit 1
}

# Lister tous les fichiers HTML
Write-Host "`nFichiers HTML disponibles:" -ForegroundColor Cyan
$htmlFiles = Get-ChildItem -Path $DocumentationDir -Filter "*.html" -Recurse
$htmlCount = 0

foreach ($file in $htmlFiles) {
    $relativePath = $file.FullName.Replace((Get-Location).Path, "").TrimStart('\')
    Write-Host "  $relativePath" -ForegroundColor Green
    $htmlCount++
}

Write-Host "`nTotal: $htmlCount fichiers HTML trouves" -ForegroundColor White

# Vérifier les fichiers principaux attendus
$expectedFiles = @(
    "MANUEL_ADMINISTRATEUR.html",
    "GUIDE_PNJ_COMPLET.html", 
    "GUIDE_MAINTENANCE_SIMPLIFIE.html",
    "GUIDE_RESOLUTION_PROBLEMES.html",
    "GUIDE_DEMARRAGE_RAPIDE.html",
    "LISTE_GUIDES_CREES.html"
)

Write-Host "`nVerification des fichiers principaux:" -ForegroundColor Cyan
$validCount = 0

foreach ($expectedFile in $expectedFiles) {
    $fullPath = Join-Path $DocumentationDir $expectedFile
    if (Test-Path $fullPath) {
        Write-Host "  $expectedFile - OK" -ForegroundColor Green
        $validCount++
    } else {
        Write-Host "  $expectedFile - MANQUANT" -ForegroundColor Red
    }
}

# Vérifier les guides de préparation
$guidesDir = Join-Path $DocumentationDir "guides-preparation"
if (Test-Path $guidesDir) {
    Write-Host "`nGuides de preparation:" -ForegroundColor Cyan
    $guideFiles = Get-ChildItem -Path $guidesDir -Filter "*.html"
    foreach ($guide in $guideFiles) {
        Write-Host "  $($guide.Name) - OK" -ForegroundColor Green
    }
}

Write-Host "`nRESULTAT:" -ForegroundColor White
Write-Host "Fichiers principaux valides: $validCount/$($expectedFiles.Count)" -ForegroundColor White

if ($validCount -eq $expectedFiles.Count) {
    Write-Host "VALIDATION REUSSIE - Documentation prete" -ForegroundColor Green
} else {
    Write-Host "ATTENTION - Fichiers manquants detectes" -ForegroundColor Yellow
}