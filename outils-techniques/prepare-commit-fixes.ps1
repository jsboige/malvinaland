# Script pour préparer un commit avec toutes les modifications apportées
# Ce script résume les changements effectués et prépare un message de commit

Write-Host "Préparation du commit pour les corrections d'images et de scripts..." -ForegroundColor Cyan

# Vérifier si git est installé
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git n'est pas installé ou n'est pas dans le PATH. Impossible de préparer le commit." -ForegroundColor Red
    exit 1
}

# Résumé des modifications
$modifications = @(
    "Correction du fichier web.config pour décommenter les types MIME",
    "Correction des chemins relatifs pour le script menu-mobile-fix.js",
    "Élimination de la duplication entre menu-mobile-fix.js et fix-mobile-menu.js",
    "Génération d'une image de carte simple",
    "Création des dossiers pour les images des mondes",
    "Correction du chemin de l'image de la carte dans le fichier source src/content/carte.md",
    "Pérennisation des modifications pour éviter qu'elles soient écrasées lors des futurs déploiements"
)

# Afficher le résumé des modifications
Write-Host "`nRésumé des modifications :" -ForegroundColor Green
foreach ($mod in $modifications) {
    Write-Host "- $mod" -ForegroundColor White
}

# Vérifier les fichiers modifiés
Write-Host "`nFichiers modifiés :" -ForegroundColor Yellow
git status --porcelain

# Préparer le message de commit
$commitMessage = @"
Correction des problèmes d'images et de scripts et pérennisation des modifications

- Correction du fichier web.config pour décommenter les types MIME
- Correction des chemins relatifs pour le script menu-mobile-fix.js
- Élimination de la duplication entre menu-mobile-fix.js et fix-mobile-menu.js
- Génération d'une image de carte simple
- Création des dossiers pour les images des mondes
- Correction du chemin de l'image de la carte dans le fichier source src/content/carte.md
- Pérennisation des modifications pour éviter qu'elles soient écrasées lors des futurs déploiements

Résolution des problèmes identifiés :
1. L'image de la carte a été générée et correctement référencée dans les fichiers sources et déployés
2. Les images des mondes ont été copiées dans les dossiers appropriés
3. Les problèmes de chemins et de règles de réécriture d'URL dans le web.config ont été corrigés
4. Les erreurs de script liées aux chemins relatifs ont été corrigées
5. Les modifications ont été pérennisées pour ne pas être écrasées lors des futurs déploiements
"@

# Écrire le message de commit dans un fichier temporaire
$commitMessagePath = "commit-message.txt"
$commitMessage | Out-File -FilePath $commitMessagePath -Encoding utf8

Write-Host "`nMessage de commit préparé et enregistré dans $commitMessagePath" -ForegroundColor Green
Write-Host "Pour effectuer le commit, exécutez la commande suivante :" -ForegroundColor Cyan
Write-Host "git add . && git commit -F $commitMessagePath" -ForegroundColor White

# Instructions pour vérifier les modifications avant de committer
Write-Host "`nAvant de committer, vérifiez que toutes les modifications sont correctes :" -ForegroundColor Yellow
Write-Host "1. Vérifiez que l'image de la carte a été générée correctement" -ForegroundColor White
Write-Host "2. Vérifiez que les dossiers des mondes contiennent les images nécessaires" -ForegroundColor White
Write-Host "3. Vérifiez que les chemins des scripts sont corrects dans les fichiers HTML" -ForegroundColor White
Write-Host "4. Vérifiez que le fichier web.config a été correctement modifié" -ForegroundColor White
Write-Host "5. Vérifiez que le fichier src/content/carte.md référence correctement l'image de la carte" -ForegroundColor White
Write-Host "6. Vérifiez que le JOURNAL_MODIFICATIONS.md a été mis à jour avec les dernières modifications" -ForegroundColor White

Write-Host "`nPréparation du commit terminée." -ForegroundColor Green