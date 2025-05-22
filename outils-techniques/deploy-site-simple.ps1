# Script simplifié pour déployer le site Malvinaland localement
# Ce script est conçu pour être facile à utiliser, même sans connaissances techniques

# Afficher un message de bienvenue
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Déploiement simplifié du site Malvinaland" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ce script va déployer le site Malvinaland sur votre ordinateur" -ForegroundColor Yellow
Write-Host "pour que vous puissiez le consulter localement." -ForegroundColor Yellow
Write-Host ""

# Vérifier si npm est installé
try {
    $npmVersion = npm -v
    Write-Host "✅ npm est installé (version $npmVersion)" -ForegroundColor Green
} catch {
    Write-Host "❌ npm n'est pas installé sur votre ordinateur." -ForegroundColor Red
    Write-Host "Veuillez installer Node.js depuis https://nodejs.org/" -ForegroundColor Red
    Write-Host "puis réessayer ce script." -ForegroundColor Red
    exit 1
}

# Demander confirmation avant de continuer
Write-Host ""
$confirmation = Read-Host "Voulez-vous continuer? (O/N)"
if ($confirmation -ne "O" -and $confirmation -ne "o") {
    Write-Host "Opération annulée." -ForegroundColor Yellow
    exit 0
}

# Créer un dossier temporaire pour le déploiement
Write-Host ""
Write-Host "Création d'un dossier temporaire pour le déploiement..." -ForegroundColor Cyan
$tempDir = "temp-deploy-$(Get-Date -Format 'yyyyMMddHHmmss')"
New-Item -ItemType Directory -Path $tempDir | Out-Null
Write-Host "✅ Dossier temporaire créé" -ForegroundColor Green

# Copier les fichiers nécessaires
Write-Host ""
Write-Host "Copie des fichiers du site..." -ForegroundColor Cyan
Copy-Item -Path "site\*" -Destination $tempDir -Recurse
Write-Host "✅ Fichiers copiés" -ForegroundColor Green

# Installer un serveur web simple
Write-Host ""
Write-Host "Installation d'un serveur web simple..." -ForegroundColor Cyan
Set-Location $tempDir
npm install -g http-server --silent
Write-Host "✅ Serveur web installé" -ForegroundColor Green

# Lancer le serveur web
Write-Host ""
Write-Host "Lancement du serveur web..." -ForegroundColor Cyan
Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "  🌐 Le site Malvinaland est maintenant accessible à l'adresse:" -ForegroundColor Green
Write-Host "  http://localhost:8080" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Pour arrêter le serveur, appuyez sur Ctrl+C" -ForegroundColor Yellow
Write-Host ""

# Lancer le navigateur
Start-Process "http://localhost:8080"

# Lancer le serveur
http-server -p 8080

# Nettoyer après l'arrêt du serveur
Write-Host ""
Write-Host "Nettoyage..." -ForegroundColor Cyan
Set-Location ..
Remove-Item -Path $tempDir -Recurse -Force
Write-Host "✅ Nettoyage terminé" -ForegroundColor Green
Write-Host ""
Write-Host "Merci d'avoir utilisé le déploiement simplifié de Malvinaland!" -ForegroundColor Cyan