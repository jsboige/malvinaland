# Script de validation des liens de documentation
# Vérifie que tous les fichiers HTML référencés dans index.html existent

param(
    [string]$DocumentationDir = "site/documentation"
)

Write-Host "🔍 Validation des liens de documentation Malvinaland" -ForegroundColor Green
Write-Host "📁 Répertoire : $DocumentationDir" -ForegroundColor Yellow

# Lire le fichier index.html
$indexPath = Join-Path $DocumentationDir "index.html"
if (-not (Test-Path $indexPath)) {
    Write-Host "❌ Fichier index.html introuvable : $indexPath" -ForegroundColor Red
    exit 1
}

$indexContent = Get-Content -Path $indexPath -Raw

# Extraire tous les liens vers des fichiers .html
$htmlLinks = [regex]::Matches($indexContent, 'href="([^"]+\.html)"') | ForEach-Object { $_.Groups[1].Value }

Write-Host "`n📋 Liens HTML trouvés dans index.html :" -ForegroundColor Cyan

$totalLinks = 0
$validLinks = 0
$brokenLinks = @()

foreach ($link in $htmlLinks) {
    $totalLinks++
    
    # Construire le chemin complet
    if ($link.StartsWith("/")) {
        # Lien absolu - ignorer pour cette validation locale
        Write-Host "⚠️  Lien absolu ignoré : $link" -ForegroundColor Yellow
        continue
    }
    
    $fullPath = Join-Path $DocumentationDir $link
    
    if (Test-Path $fullPath) {
        Write-Host "✅ $link" -ForegroundColor Green
        $validLinks++
    } else {
        Write-Host "❌ $link" -ForegroundColor Red
        $brokenLinks += $link
    }
}

# Vérifier les fichiers dans guides-preparation/
$guidesDir = Join-Path $DocumentationDir "guides-preparation"
if (Test-Path $guidesDir) {
    Write-Host "`n📁 Vérification du dossier guides-preparation/" -ForegroundColor Cyan
    
    $guideLinks = [regex]::Matches($indexContent, 'href="guides-preparation/([^"]+\.html)"') | ForEach-Object { $_.Groups[1].Value }
    
    foreach ($guideLink in $guideLinks) {
        $totalLinks++
        $fullPath = Join-Path $guidesDir $guideLink
        
        if (Test-Path $fullPath) {
            Write-Host "✅ guides-preparation/$guideLink" -ForegroundColor Green
            $validLinks++
        } else {
            Write-Host "❌ guides-preparation/$guideLink" -ForegroundColor Red
            $brokenLinks += "guides-preparation/$guideLink"
        }
    }
}

# Rapport final
Write-Host "`n" + "="*50 -ForegroundColor White
Write-Host "📊 RAPPORT DE VALIDATION" -ForegroundColor White
Write-Host "="*50 -ForegroundColor White

Write-Host "📈 Total des liens vérifiés : $totalLinks" -ForegroundColor Cyan
Write-Host "✅ Liens valides : $validLinks" -ForegroundColor Green
Write-Host "❌ Liens cassés : $($brokenLinks.Count)" -ForegroundColor Red

if ($brokenLinks.Count -eq 0) {
    Write-Host "`n🎉 VALIDATION RÉUSSIE ! Tous les liens fonctionnent." -ForegroundColor Green
    Write-Host "✅ La documentation est prête pour le déploiement." -ForegroundColor Green
} else {
    Write-Host "`n⚠️  LIENS CASSÉS DÉTECTÉS :" -ForegroundColor Red
    foreach ($brokenLink in $brokenLinks) {
        Write-Host "   - $brokenLink" -ForegroundColor Red
    }
    Write-Host "`n🔧 Veuillez corriger ces liens avant le déploiement." -ForegroundColor Yellow
}

# Lister tous les fichiers HTML disponibles
Write-Host "`n📄 Fichiers HTML disponibles :" -ForegroundColor Cyan
Get-ChildItem -Path $DocumentationDir -Filter "*.html" -Recurse | ForEach-Object {
    $relativePath = $_.FullName.Replace((Resolve-Path $DocumentationDir).Path, "").TrimStart('\', '/')
    Write-Host "   📄 $relativePath" -ForegroundColor White
}

Write-Host "`n✨ Validation terminée." -ForegroundColor Green