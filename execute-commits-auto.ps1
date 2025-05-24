# Script pour exécuter les commits selon la nouvelle structure simplifiée
# Version automatisée qui répond automatiquement "O" à toutes les questions

Write-Host "Exécution des commits pour la nouvelle structure simplifiée de Malvinaland" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
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
        # Automatiquement répondre "O"
        $response = "O"
        Write-ColorMessage "Réponse automatique: $response" -Color Yellow
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

# Définir les groupes de commits pour la nouvelle structure
$commitGroups = @(
    @{
        Name = "1. Archivage de l'ancienne structure";
        Description = "Supprime les fichiers de l'ancienne structure qui ont été archivés";
        Files = @(
            "archive/"
        );
        Message = @"
Archivage de l'ancienne structure du projet

- Suppression des fichiers de l'ancienne structure qui ont été archivés
- Préparation pour la nouvelle structure simplifiée
"@
    },
    @{
        Name = "2. Mise en place de la nouvelle structure simplifiée";
        Description = "Ajoute le README simplifié et le tableau de bord";
        Files = @(
            "README-SIMPLIFIE.md",
            "tableau-de-bord/"
        );
        Message = @"
Mise en place de la nouvelle structure simplifiée

- Ajout du README simplifié expliquant la nouvelle organisation
- Ajout du tableau de bord pour faciliter la gestion du site
"@
    },
    @{
        Name = "3. Ajout du contenu";
        Description = "Ajoute les fichiers de contenu du site";
        Files = @(
            "contenu/"
        );
        Message = @"
Ajout du contenu du site

- Ajout des fichiers de contenu pour les mondes
- Ajout des fichiers de contenu pour les personnages
- Ajout des fichiers de contenu pour la carte
- Ajout des fichiers de contenu pour les organisateurs
"@
    },
    @{
        Name = "4. Ajout des guides";
        Description = "Ajoute les guides d'utilisation et de modification";
        Files = @(
            "guides/"
        );
        Message = @"
Ajout des guides d'utilisation et de modification

- Ajout des guides de consultation
- Ajout des guides de modification
- Ajout des guides de structure
"@
    },
    @{
        Name = "5. Ajout des outils techniques";
        Description = "Ajoute les scripts et outils pour la maintenance du site";
        Files = @(
            "outils-techniques/"
        );
        Message = @"
Ajout des outils techniques

- Scripts de déploiement simplifiés
- Scripts de nettoyage simplifiés
- Scripts d'organisation simplifiés
- Scripts de vérification simplifiés
"@
    },
    @{
        Name = "6. Ajout du site web";
        Description = "Ajoute les fichiers générés pour le site web";
        Files = @(
            "site-web/"
        );
        Message = @"
Ajout des fichiers du site web

- Ajout des fichiers HTML générés
- Ajout des assets (CSS, JavaScript, images)
- Ajout des fichiers de configuration pour le déploiement
- Ajout des dossiers pour les mondes
"@
    },
    @{
        Name = "7. Ajout des archives techniques";
        Description = "Ajoute les archives techniques pour référence future";
        Files = @(
            "archives-techniques/"
        );
        Message = @"
Ajout des archives techniques

- Conservation des fichiers techniques importants
- Organisation des archives pour référence future
"@
    },
    @{
        Name = "8. Ajout du script de déploiement temporaire";
        Description = "Ajoute le script temporaire pour déployer le site web";
        Files = @(
            "temp-deploy-site-web.ps1"
        );
        Message = @"
Ajout du script de déploiement temporaire

- Script pour déployer le site web localement
- Basé sur le script deploy-site-simple.ps1 mais utilisant site-web au lieu de site
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
# Automatiquement répondre "O"
$response = "O"
Write-ColorMessage "Réponse automatique: $response" -Color Yellow
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
        # Automatiquement répondre "O"
        $response = "O"
        Write-ColorMessage "Réponse automatique: $response" -Color Yellow
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
    # Automatiquement répondre "O"
    $response = "O"
    Write-ColorMessage "Réponse automatique: $response" -Color Yellow
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
# Automatiquement répondre "O"
$response = "O"
Write-ColorMessage "Réponse automatique: $response" -Color Yellow
if ($response -eq "O" -or $response -eq "o") {
    $date = Get-Date -Format "dd/MM/yyyy"
    $journalEntry = @"
## Date: $date - Mise en place de la nouvelle structure simplifiée

### Modifications effectuées

#### 1. Archivage de l'ancienne structure
- Suppression des fichiers de l'ancienne structure qui ont été archivés
- Préparation pour la nouvelle structure simplifiée

#### 2. Mise en place de la nouvelle structure simplifiée
- Ajout du README simplifié expliquant la nouvelle organisation
- Ajout du tableau de bord pour faciliter la gestion du site

#### 3. Ajout du contenu
- Ajout des fichiers de contenu pour les mondes
- Ajout des fichiers de contenu pour les personnages
- Ajout des fichiers de contenu pour la carte
- Ajout des fichiers de contenu pour les organisateurs

#### 4. Ajout des guides
- Ajout des guides de consultation
- Ajout des guides de modification
- Ajout des guides de structure

#### 5. Ajout des outils techniques
- Scripts de déploiement simplifiés
- Scripts de nettoyage simplifiés
- Scripts d'organisation simplifiés
- Scripts de vérification simplifiés

#### 6. Ajout du site web
- Ajout des fichiers HTML générés
- Ajout des assets (CSS, JavaScript, images)
- Ajout des fichiers de configuration pour le déploiement
- Ajout des dossiers pour les mondes

#### 7. Ajout des archives techniques
- Conservation des fichiers techniques importants
- Organisation des archives pour référence future

#### 8. Ajout du script de déploiement temporaire
- Script pour déployer le site web localement
- Basé sur le script deploy-site-simple.ps1 mais utilisant site-web au lieu de site

### Résumé des changements
- Restructuration complète du projet pour une meilleure organisation
- Simplification de l'interface utilisateur avec le tableau de bord
- Documentation améliorée avec les guides
- Conservation des fichiers techniques importants dans les archives

### Prochaines étapes
1. Vérifier le bon fonctionnement du site après les commits
2. Former les utilisateurs à la nouvelle structure
3. Planifier les futures améliorations

"@

    # Lire le contenu actuel du journal
    if (Test-Path "JOURNAL_MODIFICATIONS.md") {
        $journalContent = Get-Content -Path "JOURNAL_MODIFICATIONS.md" -Raw
        
        # Ajouter la nouvelle entrée au début du journal (après le titre)
        $newJournalContent = $journalContent -replace "# Journal des modifications.*?\n\n", "# Journal des modifications - Nouvelle structure simplifiée`n`n$journalEntry`n"
        
        # Écrire le nouveau contenu dans le fichier
        $newJournalContent | Out-File -FilePath "JOURNAL_MODIFICATIONS.md" -Encoding utf8
    } else {
        # Créer un nouveau fichier journal
        $newJournalContent = "# Journal des modifications - Nouvelle structure simplifiée`n`n$journalEntry`n"
        $newJournalContent | Out-File -FilePath "JOURNAL_MODIFICATIONS.md" -Encoding utf8
    }
    
    Write-ColorMessage "Le journal des modifications a été mis à jour." -Color Green
}

# Proposer de vérifier le site après les commits
Write-ColorMessage "Voulez-vous vérifier le site après les commits? (O/N)" -Color Yellow
# Automatiquement répondre "O"
$response = "O"
Write-ColorMessage "Réponse automatique: $response" -Color Yellow
if ($response -eq "O" -or $response -eq "o") {
    Write-ColorMessage "Lancement du script de vérification..." -Color Yellow
    & "./verify-after-commits-new-structure.ps1"
}