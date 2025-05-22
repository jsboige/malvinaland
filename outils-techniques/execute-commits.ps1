# Script pour exécuter les commits selon le plan défini
# Ce script exécute les commits pour le projet Malvinaland de manière organisée

Write-Host "Exécution des commits pour la consolidation du projet Malvinaland" -ForegroundColor Cyan
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host ""

# Fonction pour afficher un message coloré
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

# Fonction pour exécuter une commande Git
function Execute-GitCommand {
    param (
        [string]$Command,
        [string]$Description
    )
    
    Write-ColorMessage "Exécution: $Command" -Color Gray
    Write-ColorMessage "($Description)" -Color Yellow
    
    try {
        Invoke-Expression $Command
        if ($LASTEXITCODE -eq 0) {
            Write-ColorMessage "Commande exécutée avec succès." -Color Green
            return $true
        } else {
            Write-ColorMessage "Erreur lors de l'exécution de la commande (code: $LASTEXITCODE)." -Color Red
            return $false
        }
    } catch {
        Write-ColorMessage "Exception lors de l'exécution de la commande: $_" -Color Red
        return $false
    }
}

# Fonction pour créer un commit
function Create-Commit {
    param (
        [string]$Name,
        [string]$Description,
        [string[]]$Files,
        [string]$Message
    )
    
    Write-ColorMessage "Création du commit: $Name" -Color Green
    Write-ColorMessage $Description -Color White
    Write-ColorMessage ""
    
    # Créer le fichier de message de commit
    $commitMessageFile = "commit-message-temp.txt"
    $Message | Out-File -FilePath $commitMessageFile -Encoding utf8
    
    # Ajouter les fichiers au commit
    $allFilesAdded = $true
    foreach ($file in $Files) {
        Write-ColorMessage "Ajout du fichier: $file" -Color Yellow
        $result = Execute-GitCommand -Command "git add `"$file`"" -Description "Ajout du fichier au staging"
        if (-not $result) {
            $allFilesAdded = $false
            Write-ColorMessage "Avertissement: Impossible d'ajouter le fichier $file. Il sera ignoré." -Color Yellow
        }
    }
    
    if (-not $allFilesAdded) {
        Write-ColorMessage "Certains fichiers n'ont pas pu être ajoutés. Voulez-vous continuer avec le commit? (O/N)" -Color Yellow
        $response = Read-Host
        if ($response -ne "O" -and $response -ne "o") {
            Write-ColorMessage "Commit annulé." -Color Red
            Remove-Item -Path $commitMessageFile -ErrorAction SilentlyContinue
            return $false
        }
    }
    
    # Créer le commit
    $result = Execute-GitCommand -Command "git commit -F `"$commitMessageFile`"" -Description "Création du commit"
    
    # Supprimer le fichier de message temporaire
    Remove-Item -Path $commitMessageFile -ErrorAction SilentlyContinue
    
    return $result
}

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

# Vérifier si Git est installé
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-ColorMessage "Git n'est pas installé ou n'est pas dans le PATH. Impossible d'exécuter les commits." -Color Red
    exit 1
}

# Vérifier l'état du dépôt Git
Write-ColorMessage "Vérification de l'état du dépôt Git..." -Color Yellow
git status

Write-ColorMessage "Voulez-vous exécuter les commits selon le plan défini? (O/N)" -Color Yellow
$response = Read-Host
if ($response -ne "O" -and $response -ne "o") {
    Write-ColorMessage "Exécution annulée." -Color Red
    exit 0
}

# Exécuter les commits
$allCommitsSuccessful = $true
foreach ($group in $commitGroups) {
    $result = Create-Commit -Name $group.Name -Description $group.Description -Files $group.Files -Message $group.Message
    if (-not $result) {
        $allCommitsSuccessful = $false
        Write-ColorMessage "Erreur lors de la création du commit $($group.Name). Voulez-vous continuer avec les commits suivants? (O/N)" -Color Yellow
        $response = Read-Host
        if ($response -ne "O" -and $response -ne "o") {
            Write-ColorMessage "Exécution des commits interrompue." -Color Red
            break
        }
    }
    
    Write-ColorMessage ""
}

# Pousser les commits vers le dépôt distant
if ($allCommitsSuccessful) {
    Write-ColorMessage "Tous les commits ont été créés avec succès." -Color Green
    Write-ColorMessage "Voulez-vous pousser les commits vers le dépôt distant? (O/N)" -Color Yellow
    $response = Read-Host
    if ($response -eq "O" -or $response -eq "o") {
        Execute-GitCommand -Command "git push origin main" -Description "Pousser les commits vers le dépôt distant"
    }
} else {
    Write-ColorMessage "Certains commits n'ont pas pu être créés. Veuillez vérifier l'état du dépôt Git." -Color Yellow
}

Write-ColorMessage ""
Write-ColorMessage "Exécution des commits terminée." -Color Cyan

# Mettre à jour le JOURNAL_MODIFICATIONS.md
Write-ColorMessage "Voulez-vous mettre à jour le JOURNAL_MODIFICATIONS.md avec un résumé des commits effectués? (O/N)" -Color Yellow
$response = Read-Host
if ($response -eq "O" -or $response -eq "o") {
    $date = Get-Date -Format "dd/MM/yyyy"
    $journalEntry = @"
## Date: $date - Consolidation du projet et préparation des commits

### Modifications effectuées

#### 1. Archivage de l'ancienne structure
- Déplacement de l'ancienne structure vers le répertoire archive/
- Conservation de l'historique et des fichiers importants
- Préparation pour la nouvelle architecture du site

#### 2. Mise en place de la nouvelle structure du projet
- Ajout du fichier de configuration Eleventy (.eleventy.js)
- Mise à jour du fichier .gitignore
- Ajout des fichiers package.json et package-lock.json pour les dépendances
- Ajout des fichiers manifest.json et service-worker.js pour la PWA
- Mise à jour du fichier web.config pour la configuration IIS
- Mise à jour du fichier index.html principal
- Mise à jour du README.md

#### 3. Ajout des fichiers source (src)
- Ajout des fichiers de données (_data)
- Ajout des layouts et templates (_includes)
- Ajout des fichiers de contenu Markdown (content)
- Ajout des assets (CSS, JavaScript, icônes)

#### 4. Ajout des fichiers générés (site)
- Ajout des fichiers HTML générés
- Ajout des assets (CSS, JavaScript, images)
- Ajout des fichiers de configuration pour le déploiement
- Ajout des dossiers pour les mondes

#### 5. Ajout des scripts et outils
- Scripts de déploiement (deploy-*.ps1)
- Scripts de test (test-*.ps1)
- Scripts d'optimisation d'images
- Scripts de préparation de commits
- Outils de création d'icônes

#### 6. Ajout de la documentation
- Guide d'utilisation et de modification
- Journal des modifications
- Documentation sur l'expérience mobile
- Documentation sur la structure du contenu
- Templates pour les nouveaux contenus
- Ressources diverses

#### 7. Correction des problèmes d'images et de scripts
- Correction du fichier web.config pour décommenter les types MIME
- Correction des chemins relatifs pour le script menu-mobile-fix.js
- Élimination de la duplication entre menu-mobile-fix.js et fix-mobile-menu.js
- Correction du chemin de l'image de la carte dans le fichier source src/content/carte.md
- Ajout d'un paramètre de version à l'URL de l'image pour contourner le cache du navigateur
- Pérennisation des modifications pour éviter qu'elles soient écrasées lors des futurs déploiements

### Résumé des problèmes résolus
- Restructuration complète du projet pour une meilleure organisation
- Correction des problèmes d'images et de scripts
- Mise en place d'une architecture plus robuste et maintenable
- Documentation complète du projet et des processus

### Prochaines étapes
1. Vérifier le bon fonctionnement du site après les commits
2. Planifier les futures améliorations
3. Mettre à jour la documentation si nécessaire

"@

    # Lire le contenu actuel du journal
    $journalContent = Get-Content -Path "JOURNAL_MODIFICATIONS.md" -Raw
    
    # Ajouter la nouvelle entrée au début du journal (après le titre)
    $newJournalContent = $journalContent -replace "# Journal des modifications.*?\n\n", "# Journal des modifications - Récupération des ressources d'images`n`n$journalEntry`n"
    
    # Écrire le nouveau contenu dans le fichier
    $newJournalContent | Out-File -FilePath "JOURNAL_MODIFICATIONS.md" -Encoding utf8
    
    Write-ColorMessage "Le journal des modifications a été mis à jour." -Color Green
}