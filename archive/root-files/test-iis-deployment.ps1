# Script de test du déploiement IIS pour Malvinaland
# Ce script vérifie que le site est correctement déployé sur IIS

Write-Host "Début des tests de déploiement IIS..." -ForegroundColor Green

# 1. Vérifier que le site est accessible
$siteUrl = "https://malvinaland.myia.io/"
Write-Host "Test d'accès à la page d'accueil: $siteUrl" -ForegroundColor Cyan

try {
    $response = Invoke-WebRequest -Uri $siteUrl -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ La page d'accueil est accessible (code 200)" -ForegroundColor Green
    } else {
        Write-Host "❌ La page d'accueil a retourné un code inattendu: $($response.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Erreur lors de l'accès à la page d'accueil: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. Vérifier l'accès aux pages principales
$pagesToTest = @(
    "https://malvinaland.myia.io/content/",
    "https://malvinaland.myia.io/content/carte/",
    "https://malvinaland.myia.io/content/narration/",
    "https://malvinaland.myia.io/content/personnages/",
    "https://malvinaland.myia.io/content/mondes/assemblee/",
    "https://malvinaland.myia.io/content/mondes/grange/",
    "https://malvinaland.myia.io/content/mondes/jeux/"
)

foreach ($page in $pagesToTest) {
    Write-Host "Test d'accès à la page: $page" -ForegroundColor Cyan
    
    try {
        $response = Invoke-WebRequest -Uri $page -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ Page accessible (code 200)" -ForegroundColor Green
        } else {
            Write-Host "❌ Page a retourné un code inattendu: $($response.StatusCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Erreur lors de l'accès à la page: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 3. Vérifier l'accès aux ressources statiques
$resourcesToTest = @(
    "https://malvinaland.myia.io/assets/css/main.css",
    "https://malvinaland.myia.io/assets/js/navigation.js",
    "https://malvinaland.myia.io/assets/js/fix-mobile-menu.js",
    "https://malvinaland.myia.io/assets/images/carte/Carte de Malvinaland stylisée.png"
)

foreach ($resource in $resourcesToTest) {
    Write-Host "Test d'accès à la ressource: $resource" -ForegroundColor Cyan
    
    try {
        $response = Invoke-WebRequest -Uri $resource -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ Ressource accessible (code 200)" -ForegroundColor Green
        } else {
            Write-Host "❌ Ressource a retourné un code inattendu: $($response.StatusCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Erreur lors de l'accès à la ressource: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Tests de déploiement IIS terminés!" -ForegroundColor Green