# Script de vérification après les commits pour la nouvelle structure simplifiée
# Ce script vérifie que le site fonctionne correctement après les commits

Write-Host "Vérification du site après les commits (nouvelle structure)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# Fonction pour afficher un message coloré
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

# Fonction pour vérifier l'existence d'un fichier ou dossier
function Test-FileExists {
    param (
        [string]$FilePath,
        [string]$Description
    )
    
    if (Test-Path -Path $FilePath) {
        Write-ColorMessage "[OK] $Description existe: $FilePath" -Color Green
        return $true
    } else {
        Write-ColorMessage "[ERREUR] $Description n'existe pas: $FilePath" -Color Red
        return $false
    }
}

# Fonction pour vérifier la structure simplifiée
function Test-SimplifiedStructure {
    Write-ColorMessage "Vérification de la structure simplifiée..." -Color Yellow
    
    $requiredDirectories = @(
        @{ Path = "contenu"; Description = "Dossier de contenu" },
        @{ Path = "contenu/mondes"; Description = "Dossier des mondes" },
        @{ Path = "contenu/personnages"; Description = "Dossier des personnages" },
        @{ Path = "contenu/carte"; Description = "Dossier de la carte" },
        @{ Path = "contenu/organisateurs"; Description = "Dossier des organisateurs" },
        @{ Path = "guides"; Description = "Dossier des guides" },
        @{ Path = "guides/consultation"; Description = "Dossier des guides de consultation" },
        @{ Path = "guides/modification"; Description = "Dossier des guides de modification" },
        @{ Path = "guides/structure"; Description = "Dossier des guides de structure" },
        @{ Path = "tableau-de-bord"; Description = "Dossier du tableau de bord" },
        @{ Path = "outils-techniques"; Description = "Dossier des outils techniques" },
        @{ Path = "archives-techniques"; Description = "Dossier des archives techniques" },
        @{ Path = "site-web"; Description = "Dossier du site web" },
        @{ Path = "site-web/assets"; Description = "Dossier des assets du site web" },
        @{ Path = "site-web/content"; Description = "Dossier du contenu du site web" }
    )
    
    $requiredFiles = @(
        @{ Path = "README-SIMPLIFIE.md"; Description = "README simplifié" },
        @{ Path = "tableau-de-bord/index.html"; Description = "Tableau de bord" },
        @{ Path = "temp-deploy-site-web.ps1"; Description = "Script de déploiement temporaire" },
        @{ Path = "site-web/index.html"; Description = "Page d'accueil du site web" },
        @{ Path = "site-web/manifest.json"; Description = "Manifest du site web" },
        @{ Path = "site-web/service-worker.js"; Description = "Service worker du site web" }
    )
    
    $allDirectoriesExist = $true
    foreach ($dir in $requiredDirectories) {
        $exists = Test-FileExists -FilePath $dir.Path -Description $dir.Description
        if (-not $exists) {
            $allDirectoriesExist = $false
        }
    }
    
    $allFilesExist = $true
    foreach ($file in $requiredFiles) {
        $exists = Test-FileExists -FilePath $file.Path -Description $file.Description
        if (-not $exists) {
            $allFilesExist = $false
        }
    }
    
    return $allDirectoriesExist -and $allFilesExist
}

# Fonction pour vérifier les mondes
function Test-Mondes {
    Write-ColorMessage "Vérification des mondes..." -Color Yellow
    
    $mondes = @(
        "assemblee", "grange", "jeux", "reves", "damier", 
        "linge", "verger", "zob", "elysee", "karibu", "sphinx"
    )
    
    $allMondesExist = $true
    foreach ($monde in $mondes) {
        # Vérifier le dossier du monde dans contenu
        $mondePath = "contenu/mondes/$monde"
        $mondeExists = Test-FileExists -FilePath $mondePath -Description "Dossier du monde $monde"
        
        # Vérifier le dossier du monde dans site-web
        $siteWebMondePath = "site-web/content/mondes/$monde"
        $siteWebMondeExists = Test-FileExists -FilePath $siteWebMondePath -Description "Dossier du monde $monde dans site-web"
        
        if (-not ($mondeExists -and $siteWebMondeExists)) {
            $allMondesExist = $false
        }
    }
    
    return $allMondesExist
}

# Fonction pour vérifier le tableau de bord
function Test-TableauDeBord {
    Write-ColorMessage "Vérification du tableau de bord..." -Color Yellow
    
    $tableauDeBordPath = "tableau-de-bord/index.html"
    $tableauDeBordExists = Test-FileExists -FilePath $tableauDeBordPath -Description "Fichier index.html du tableau de bord"
    
    if ($tableauDeBordExists) {
        $tableauDeBordContent = Get-Content -Path $tableauDeBordPath -Raw
        
        # Vérifier que le tableau de bord contient des liens vers les sections importantes
        $requiredLinks = @(
            "contenu/mondes",
            "contenu/personnages",
            "contenu/carte",
            "guides/modification",
            "guides/consultation"
        )
        
        $allLinksExist = $true
        foreach ($link in $requiredLinks) {
            if ($tableauDeBordContent -notmatch [regex]::Escape($link)) {
                Write-ColorMessage "[ERREUR] Le tableau de bord ne contient pas de lien vers $link" -Color Red
                $allLinksExist = $false
            }
        }
        
        if ($allLinksExist) {
            Write-ColorMessage "[OK] Le tableau de bord contient tous les liens nécessaires" -Color Green
        }
        
        return $allLinksExist
    }
    
    return $false
}

# Fonction pour vérifier le script de déploiement temporaire
function Test-DeploymentScript {
    Write-ColorMessage "Vérification du script de déploiement temporaire..." -Color Yellow
    
    $scriptPath = "temp-deploy-site-web.ps1"
    $scriptExists = Test-FileExists -FilePath $scriptPath -Description "Script de déploiement temporaire"
    
    if ($scriptExists) {
        $scriptContent = Get-Content -Path $scriptPath -Raw
        
        # Vérifier que le script contient les éléments nécessaires
        $requiredElements = @(
            "site-web",
            "http-server",
            "localhost:8080"
        )
        
        $allElementsExist = $true
        foreach ($element in $requiredElements) {
            if ($scriptContent -notmatch [regex]::Escape($element)) {
                Write-ColorMessage "[ERREUR] Le script de déploiement ne contient pas l'élément $element" -Color Red
                $allElementsExist = $false
            }
        }
        
        if ($allElementsExist) {
            Write-ColorMessage "[OK] Le script de déploiement contient tous les éléments nécessaires" -Color Green
        }
        
        return $allElementsExist
    }
    
    return $false
}

# Fonction pour vérifier le site web
function Test-SiteWeb {
    Write-ColorMessage "Vérification du site web..." -Color Yellow
    
    $requiredFiles = @(
        @{ Path = "site-web/index.html"; Description = "Page d'accueil du site web" },
        @{ Path = "site-web/manifest.json"; Description = "Manifest du site web" },
        @{ Path = "site-web/service-worker.js"; Description = "Service worker du site web" },
        @{ Path = "site-web/assets/css/main.css"; Description = "CSS principal du site web" },
        @{ Path = "site-web/assets/js/navigation.js"; Description = "Script de navigation du site web" }
    )
    
    $allFilesExist = $true
    foreach ($file in $requiredFiles) {
        $exists = Test-FileExists -FilePath $file.Path -Description $file.Description
        if (-not $exists) {
            $allFilesExist = $false
        }
    }
    
    return $allFilesExist
}

# Exécuter les vérifications
$structureOk = Test-SimplifiedStructure
Write-ColorMessage ""

$mondesOk = Test-Mondes
Write-ColorMessage ""

$tableauDeBordOk = Test-TableauDeBord
Write-ColorMessage ""

$deploymentScriptOk = Test-DeploymentScript
Write-ColorMessage ""

$siteWebOk = Test-SiteWeb
Write-ColorMessage ""

# Afficher le résumé
Write-ColorMessage "=== Résumé des vérifications ===" -Color Cyan
Write-ColorMessage "Structure simplifiée: $(if ($structureOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($structureOk) { "Green" } else { "Red" })
Write-ColorMessage "Mondes: $(if ($mondesOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($mondesOk) { "Green" } else { "Red" })
Write-ColorMessage "Tableau de bord: $(if ($tableauDeBordOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($tableauDeBordOk) { "Green" } else { "Red" })
Write-ColorMessage "Script de déploiement: $(if ($deploymentScriptOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($deploymentScriptOk) { "Green" } else { "Red" })
Write-ColorMessage "Site web: $(if ($siteWebOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($siteWebOk) { "Green" } else { "Red" })
Write-ColorMessage ""

# Conclusion
if ($structureOk -and $mondesOk -and $tableauDeBordOk -and $deploymentScriptOk -and $siteWebOk) {
    Write-ColorMessage "Toutes les vérifications ont réussi. Le site est prêt à être déployé." -Color Green
} else {
    Write-ColorMessage "Certaines vérifications ont échoué. Veuillez corriger les problèmes identifiés avant de déployer le site." -Color Yellow
}

# Proposer de lancer le script de déploiement temporaire si tout est OK
if ($structureOk -and $mondesOk -and $tableauDeBordOk -and $deploymentScriptOk -and $siteWebOk) {
    Write-ColorMessage "Voulez-vous lancer le script de déploiement temporaire? (O/N)" -Color Yellow
    $response = Read-Host
    if ($response -eq "O" -or $response -eq "o") {
        Write-ColorMessage "Lancement du script de déploiement temporaire..." -Color Yellow
        & "./temp-deploy-site-web.ps1"
    }
}
