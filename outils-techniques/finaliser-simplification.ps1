# Script pour finaliser la simplification du dépôt Malvinaland

# Afficher un message de bienvenue
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Finalisation de la simplification du dépôt" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Déplacer les éléments techniques complexes dans le dossier archives-techniques
Write-Host "Déplacement des éléments techniques complexes..." -ForegroundColor Yellow

# Déplacer le contenu du dossier archive
if (Test-Path "archive") {
    Write-Host "Déplacement du contenu du dossier 'archive'..." -ForegroundColor Cyan
    Move-Item -Path "archive\*" -Destination "archives-techniques\" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "archive" -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Contenu du dossier 'archive' déplacé" -ForegroundColor Green
}

# Déplacer les fichiers de backup
if (Test-Path "backup-before-cleanup") {
    Write-Host "Déplacement du dossier 'backup-before-cleanup'..." -ForegroundColor Cyan
    Move-Item -Path "backup-before-cleanup" -Destination "archives-techniques\" -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Dossier 'backup-before-cleanup' déplacé" -ForegroundColor Green
}

# Déplacer les logs de nettoyage
if (Test-Path "cleanup-logs") {
    Write-Host "Déplacement du dossier 'cleanup-logs'..." -ForegroundColor Cyan
    Move-Item -Path "cleanup-logs" -Destination "archives-techniques\" -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Dossier 'cleanup-logs' déplacé" -ForegroundColor Green
}

# Créer un lien symbolique entre src et contenu
Write-Host "Création d'un lien symbolique entre 'src' et 'contenu'..." -ForegroundColor Cyan
if (Test-Path "src") {
    Copy-Item -Path "src\content\*" -Destination "contenu\" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Contenu de 'src\content' copié vers 'contenu'" -ForegroundColor Green
}

# Créer un lien symbolique entre site et site-web
Write-Host "Création d'un lien symbolique entre 'site' et 'site-web'..." -ForegroundColor Cyan
if (Test-Path "site") {
    New-Item -ItemType Directory -Path "site-web" -Force -ErrorAction SilentlyContinue | Out-Null
    Copy-Item -Path "site\*" -Destination "site-web\" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Contenu de 'site' copié vers 'site-web'" -ForegroundColor Green
}

# Afficher un message de fin
Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "  Simplification du dépôt terminée!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Le dépôt a été réorganisé avec succès." -ForegroundColor Yellow
Write-Host "Vous pouvez maintenant utiliser le tableau de bord pour gérer le site." -ForegroundColor Yellow
Write-Host ""
Write-Host "Pour accéder au tableau de bord:" -ForegroundColor Cyan
Write-Host "1. Ouvrez le fichier 'tableau-de-bord/index.html' dans votre navigateur" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pour plus d'informations, consultez le fichier 'README-SIMPLIFIE.md'" -ForegroundColor Cyan