# Script pour préparer les commits de manière organisée
# Ce script propose un plan de commits logiques pour le projet Malvinaland

Write-Host "Plan de commits pour la consolidation du projet Malvinaland" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host ""

# Définir les groupes de commits
$commitGroups = @(
    @{
        Name = "1. Archivage de l'ancienne structure";
        Description = "Déplace l'ancienne structure du projet vers le répertoire archive";
        Files = @(
            # Fichiers supprimés (ils seront ajoutés à l'archive)
            "Cartes/prompt_carte.md",
            "Core/mondes-config.js",
            "Core/navigation.js",
            "Installation/guide_utilisation.md",
            "Installation/instructions_installation.md",
            "Mondes/Carte de Malvinaland stylisée.png",
            "Mondes/Carte de Malvinhaland.png",
            "Mondes/Le monde Elysée/README.md",
            "Mondes/Le monde Elysée/index.html",
            "Mondes/Le monde Elysée/script.js",
            "Mondes/Le monde Elysée/styles.css",
            "Mondes/Le monde Karibu/README.md",
            "Mondes/Le monde Karibu/index.html",
            "Mondes/Le monde Karibu/script.js",
            "Mondes/Le monde Karibu/styles.css",
            "Mondes/Le monde de l'assemblée/README.md",
            "Mondes/Le monde de l'assemblée/index.html",
            "Mondes/Le monde de l'assemblée/script.js",
            "Mondes/Le monde de l'assemblée/styles.css",
            "Mondes/Le monde de la grange/.vscode/settings.json",
            "Mondes/Le monde de la grange/README.md",
            "Mondes/Le monde de la grange/index.html",
            "Mondes/Le monde de la grange/script.js",
            "Mondes/Le monde de la grange/styles.css",
            "Mondes/Le monde des jeux/README.md",
            "Mondes/Le monde des jeux/guide_installation.md",
            "Mondes/Le monde des jeux/index.html",
            "Mondes/Le monde des jeux/script.js",
            "Mondes/Le monde des jeux/styles.css",
            "Mondes/Le monde des rêves/README.md",
            "Mondes/Le monde des rêves/index.html",
            "Mondes/Le monde des rêves/prompt_monde_des_reves.md",
            "Mondes/Le monde des rêves/script.js",
            "Mondes/Le monde des rêves/styles.css",
            "Mondes/Le monde du Zob/README.md",
            "Mondes/Le monde du Zob/index.html",
            "Mondes/Le monde du Zob/script.js",
            "Mondes/Le monde du Zob/styles.css",
            "Mondes/Le monde du damier/README.md",
            "Mondes/Le monde du damier/index.html",
            "Mondes/Le monde du damier/script.js",
            "Mondes/Le monde du damier/styles.css",
            "Mondes/Le monde du linge/README.md",
            "Mondes/Le monde du linge/index.html",
            "Mondes/Le monde du linge/script.js",
            "Mondes/Le monde du linge/styles.css",
            "Mondes/Le monde du verger/README.md",
            "Mondes/Le monde du verger/index.html",
            "Mondes/Le monde du verger/prompt_monde_du_verger.md",
            "Mondes/Le monde du verger/script.js",
            "Mondes/Le monde du verger/styles.css",
            "Mondes/Le monde orange des Sphinx/README.md",
            "Mondes/Le monde orange des Sphinx/index.html",
            "Mondes/Le monde orange des Sphinx/script.js",
            "Mondes/Le monde orange des Sphinx/styles.css",
            "Mondes/web.config",
            "Narration/narration_transversale.md",
            "Prompts/conseils_utilisation.md",
            "Prompts/prompts_illustrations.md",
            "README_ORGANISATION.md",
            "Site/Composants/styles.css",
            "Site/Core/index.html",
            "Site/Services/serviceWorker.js",
            "Site/Services/sw.js",
            "Site/app.js",
            "blocs_taches_mondes.md",
            "deploy.ps1",
            "guide_creation_prompts.md",
            "guide_installation.md",
            "matériel.md",
            "prompt_enrichissement_monde.md",
            "prompts_site_web.md",
            # Répertoire d'archive
            "archive/"
        );
        Message = @"
Archivage de l'ancienne structure du projet

- Déplacement de l'ancienne structure vers le répertoire archive/
- Conservation de l'historique et des fichiers importants
- Préparation pour la nouvelle architecture du site
"@
    },
    @{
        Name = "2. Mise en place de la nouvelle structure du projet";
        Description = "Ajoute les fichiers de configuration et de structure pour la nouvelle architecture";
        Files = @(
            ".eleventy.js",
            ".gitignore",
            "package.json",
            "package-lock.json",
            "manifest.json",
            "service-worker.js",
            "web.config",
            "index.html",
            "README.md"
        );
        Message = @"
Mise en place de la nouvelle structure du projet

- Ajout du fichier de configuration Eleventy (.eleventy.js)
- Mise à jour du fichier .gitignore
- Ajout des fichiers package.json et package-lock.json pour les dépendances
- Ajout des fichiers manifest.json et service-worker.js pour la PWA
- Mise à jour du fichier web.config pour la configuration IIS
- Mise à jour du fichier index.html principal
- Mise à jour du README.md
"@
    },
    @{
        Name = "3. Ajout des fichiers source (src)";
        Description = "Ajoute les fichiers source pour la génération du site";
        Files = @(
            "src/"
        );
        Message = @"
Ajout des fichiers source (src)

- Ajout des fichiers de données (_data)
- Ajout des layouts et templates (_includes)
- Ajout des fichiers de contenu Markdown (content)
- Ajout des assets (CSS, JavaScript, icônes)
"@
    },
    @{
        Name = "4. Ajout des fichiers générés (site)";
        Description = "Ajoute les fichiers générés pour le site déployé";
        Files = @(
            "site/"
        );
        Message = @"
Ajout des fichiers générés (site)

- Ajout des fichiers HTML générés
- Ajout des assets (CSS, JavaScript, images)
- Ajout des fichiers de configuration pour le déploiement
- Ajout des dossiers pour les mondes
"@
    },
    @{
        Name = "5. Ajout des scripts et outils";
        Description = "Ajoute les scripts PowerShell et autres outils pour la maintenance du site";
        Files = @(
            "scripts/",
            "create-icon.ps1",
            "create-png-icon.ps1"
        );
        Message = @"
Ajout des scripts et outils

- Scripts de déploiement (deploy-*.ps1)
- Scripts de test (test-*.ps1)
- Scripts d'optimisation d'images
- Scripts de préparation de commits
- Outils de création d'icônes
"@
    },
    @{
        Name = "6. Ajout de la documentation";
        Description = "Ajoute les fichiers de documentation pour le projet";
        Files = @(
            "COMMENT_MODIFIER.md",
            "GUIDE_PNJ.md",
            "JOURNAL_MODIFICATIONS.md",
            "MOBILE_EXPERIENCE.md",
            "STRUCTURE_CONTENU.md",
            "WORKFLOW.md",
            "ressources/",
            "templates/"
        );
        Message = @"
Ajout de la documentation

- Guide d'utilisation et de modification
- Journal des modifications
- Documentation sur l'expérience mobile
- Documentation sur la structure du contenu
- Templates pour les nouveaux contenus
- Ressources diverses
"@
    },
    @{
        Name = "7. Correction des problèmes d'images et de scripts";
        Description = "Corrige les problèmes d'images et de scripts identifiés";
        Files = @(
            "site/web.config",
            "site/Core/menu-mobile-fix.js",
            "Site/Core/navigation.js",
            "Site/Core/styles.css",
            "src/content/carte.md",
            "site/content/carte/index.html"
        );
        Message = @"
Correction des problèmes d'images et de scripts

- Correction du fichier web.config pour décommenter les types MIME
- Correction des chemins relatifs pour le script menu-mobile-fix.js
- Élimination de la duplication entre menu-mobile-fix.js et fix-mobile-menu.js
- Correction du chemin de l'image de la carte dans le fichier source src/content/carte.md
- Ajout d'un paramètre de version à l'URL de l'image pour contourner le cache du navigateur
- Pérennisation des modifications pour éviter qu'elles soient écrasées lors des futurs déploiements
"@
    }
);

# Afficher le plan de commits
foreach ($group in $commitGroups) {
    Write-Host "Commit $($group.Name)" -ForegroundColor Green
    Write-Host $group.Description -ForegroundColor White
    Write-Host "Fichiers concernés:" -ForegroundColor Yellow
    foreach ($file in $group.Files) {
        Write-Host "  - $file" -ForegroundColor Gray
    }
    Write-Host "Message de commit:" -ForegroundColor Yellow
    Write-Host $group.Message -ForegroundColor White
    Write-Host ""
}

# Générer les commandes Git pour chaque groupe
Write-Host "Commandes Git pour exécuter les commits:" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

foreach ($group in $commitGroups) {
    $commitMessageFile = "commit-message-$($group.Name.Split('.')[0]).txt"
    
    Write-Host "# Commit $($group.Name)" -ForegroundColor Green
    Write-Host "# Créer le fichier de message de commit" -ForegroundColor Gray
    Write-Host "`$message = @`"" -ForegroundColor White
    Write-Host $group.Message -ForegroundColor White
    Write-Host "`"`@" -ForegroundColor White
    Write-Host "`$message | Out-File -FilePath `"$commitMessageFile`" -Encoding utf8" -ForegroundColor White
    Write-Host ""
    
    Write-Host "# Ajouter les fichiers au commit" -ForegroundColor Gray
    foreach ($file in $group.Files) {
        Write-Host "git add `"$file`"" -ForegroundColor White
    }
    Write-Host ""
    
    Write-Host "# Créer le commit" -ForegroundColor Gray
    Write-Host "git commit -F `"$commitMessageFile`"" -ForegroundColor White
    Write-Host ""
    Write-Host "# Supprimer le fichier de message temporaire" -ForegroundColor Gray
    Write-Host "Remove-Item -Path `"$commitMessageFile`"" -ForegroundColor White
    Write-Host ""
}

Write-Host "# Pousser tous les commits vers le dépôt distant" -ForegroundColor Green
Write-Host "git push origin main" -ForegroundColor White
Write-Host ""

Write-Host "Plan de commits terminé. Exécutez les commandes ci-dessus pour créer les commits." -ForegroundColor Cyan