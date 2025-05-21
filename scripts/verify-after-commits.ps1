# Script de vérification après les commits
# Ce script vérifie que le site fonctionne correctement après les commits

Write-Host "Vérification du site après les commits" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Fonction pour afficher un message coloré
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

# Fonction pour vérifier l'existence d'un fichier
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

# Fonction pour tester l'accès à une URL
function Test-UrlAccess {
    param (
        [string]$Url,
        [string]$Description
    )
    
    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-ColorMessage "[OK] $Description est accessible: $Url (Code: $($response.StatusCode))" -Color Green
            return $true
        } else {
            Write-ColorMessage "[AVERTISSEMENT] $Description a retourné un code non-200: $Url (Code: $($response.StatusCode))" -Color Yellow
            return $false
        }
    } catch {
        Write-ColorMessage "[ERREUR] Impossible d'accéder à ${Description}: ${Url} (Erreur: $($_.Exception.Message))" -Color Red
        return $false
    }
}

# Fonction pour vérifier la structure du projet
function Test-ProjectStructure {
    Write-ColorMessage "Vérification de la structure du projet..." -Color Yellow
    
    $requiredDirectories = @(
        @{ Path = "src"; Description = "Répertoire source" },
        @{ Path = "src/_data"; Description = "Répertoire de données" },
        @{ Path = "src/_includes"; Description = "Répertoire des layouts" },
        @{ Path = "src/assets"; Description = "Répertoire des assets source" },
        @{ Path = "src/content"; Description = "Répertoire du contenu source" },
        @{ Path = "site"; Description = "Répertoire du site généré" },
        @{ Path = "site/assets"; Description = "Répertoire des assets générés" },
        @{ Path = "site/content"; Description = "Répertoire du contenu généré" },
        @{ Path = "scripts"; Description = "Répertoire des scripts" },
        @{ Path = "archive"; Description = "Répertoire d'archive" }
    )
    
    $requiredFiles = @(
        @{ Path = ".eleventy.js"; Description = "Fichier de configuration Eleventy" },
        @{ Path = "package.json"; Description = "Fichier de configuration npm" },
        @{ Path = "manifest.json"; Description = "Fichier manifest pour la PWA" },
        @{ Path = "service-worker.js"; Description = "Service worker pour la PWA" },
        @{ Path = "web.config"; Description = "Fichier de configuration IIS" },
        @{ Path = "site/web.config"; Description = "Fichier de configuration IIS du site" },
        @{ Path = "src/content/carte.md"; Description = "Fichier source de la carte" },
        @{ Path = "site/content/carte/index.html"; Description = "Fichier généré de la carte" },
        @{ Path = "site/assets/images/carte-malvinaland.png"; Description = "Image de la carte" }
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
        # Vérifier le fichier source
        $sourceFile = "src/content/mondes/$monde/index.md"
        $sourceExists = Test-FileExists -FilePath $sourceFile -Description "Fichier source du monde $monde"
        
        # Vérifier le fichier généré
        $generatedFile = "site/content/mondes/$monde/index.html"
        $generatedExists = Test-FileExists -FilePath $generatedFile -Description "Fichier généré du monde $monde"
        
        if (-not ($sourceExists -and $generatedExists)) {
            $allMondesExist = $false
        }
    }
    
    return $allMondesExist
}

# Fonction pour vérifier les images
function Test-Images {
    Write-ColorMessage "Vérification des images..." -Color Yellow
    
    # Vérifier l'image de la carte
    $carteImage = "site/assets/images/carte-malvinaland.png"
    $carteExists = Test-FileExists -FilePath $carteImage -Description "Image de la carte"
    
    # Vérifier que l'image est référencée correctement dans le HTML
    $carteHtml = Get-Content -Path "site/content/carte/index.html" -Raw
    if ($carteHtml -match '/assets/images/carte-malvinaland.png\?v=\d+') {
        Write-ColorMessage "[OK] L'image de la carte est correctement référencée dans le HTML avec un paramètre de version" -Color Green
        $carteReferenced = $true
    } else {
        Write-ColorMessage "[ERREUR] L'image de la carte n'est pas correctement référencée dans le HTML ou n'a pas de paramètre de version" -Color Red
        $carteReferenced = $false
    }
    
    return $carteExists -and $carteReferenced
}

# Fonction pour vérifier les scripts
function Test-Scripts {
    Write-ColorMessage "Vérification des scripts..." -Color Yellow
    
    $requiredScripts = @(
        @{ Path = "site/assets/js/navigation.js"; Description = "Script de navigation" },
        @{ Path = "site/assets/js/auth.js"; Description = "Script d'authentification" },
        @{ Path = "site/assets/js/image-loader.js"; Description = "Script de chargement d'images" },
        @{ Path = "site/assets/js/fix-mobile-menu.js"; Description = "Script de correction du menu mobile" },
        @{ Path = "site/assets/js/register-sw.js"; Description = "Script d'enregistrement du service worker" },
        @{ Path = "site/Core/menu-mobile-fix.js"; Description = "Script de correction du menu mobile (Core)" }
    )
    
    $allScriptsExist = $true
    foreach ($script in $requiredScripts) {
        $exists = Test-FileExists -FilePath $script.Path -Description $script.Description
        if (-not $exists) {
            $allScriptsExist = $false
        }
    }
    
    # Vérifier que les scripts sont référencés correctement dans le HTML
    $indexHtml = Get-Content -Path "site/index.html" -Raw
    $scriptsReferenced = $true
    
    $requiredReferences = @(
        "/assets/js/navigation.js",
        "/assets/js/auth.js",
        "/assets/js/register-sw.js"
    )
    
    foreach ($ref in $requiredReferences) {
        if ($indexHtml -notmatch [regex]::Escape($ref)) {
            Write-ColorMessage "[ERREUR] Le script $ref n'est pas référencé dans index.html" -Color Red
            $scriptsReferenced = $false
        }
    }
    
    if ($scriptsReferenced) {
        Write-ColorMessage "[OK] Tous les scripts nécessaires sont référencés dans index.html" -Color Green
    }
    
    return $allScriptsExist -and $scriptsReferenced
}

# Fonction pour vérifier le web.config
function Test-WebConfig {
    Write-ColorMessage "Vérification du fichier web.config..." -Color Yellow
    
    $webConfig = Get-Content -Path "site/web.config" -Raw
    
    # Vérifier les types MIME
    if ($webConfig -match '<mimeMap fileExtension=".json" mimeType="application/json" />') {
        Write-ColorMessage "[OK] Le type MIME pour .json est correctement configuré" -Color Green
        $jsonMimeOk = $true
    } else {
        Write-ColorMessage "[ERREUR] Le type MIME pour .json n'est pas correctement configuré" -Color Red
        $jsonMimeOk = $false
    }
    
    # Vérifier les règles de réécriture
    if ($webConfig -match '<rule name="Redirect root to content - carte"') {
        Write-ColorMessage "[OK] La règle de réécriture pour la carte est correctement configurée" -Color Green
        $carteRewriteOk = $true
    } else {
        Write-ColorMessage "[ERREUR] La règle de réécriture pour la carte n'est pas correctement configurée" -Color Red
        $carteRewriteOk = $false
    }
    
    return $jsonMimeOk -and $carteRewriteOk
}

# Fonction pour vérifier le site en local
function Test-LocalSite {
    Write-ColorMessage "Vérification du site en local..." -Color Yellow
    
    # Vérifier si le site peut être servi localement
    if (Get-Command npx -ErrorAction SilentlyContinue) {
        Write-ColorMessage "Tentative de démarrage du serveur local..." -Color Yellow
        
        try {
            # Démarrer un serveur HTTP simple pour tester le site
            $job = Start-Job -ScriptBlock {
                Set-Location $using:PWD
                npx http-server ./site -p 8080 -s
            }
            
            # Attendre que le serveur démarre
            Start-Sleep -Seconds 3
            
            # Tester l'accès au site
            $siteAccessible = Test-UrlAccess -Url "http://localhost:8080" -Description "Site local"
            $carteAccessible = Test-UrlAccess -Url "http://localhost:8080/carte" -Description "Page de la carte"
            
            # Arrêter le serveur
            Stop-Job -Job $job
            Remove-Job -Job $job
            
            return $siteAccessible -and $carteAccessible
        } catch {
            Write-ColorMessage "[ERREUR] Erreur lors du test du site local: $_" -Color Red
            return $false
        }
    } else {
        Write-ColorMessage "[AVERTISSEMENT] npx n'est pas disponible. Impossible de tester le site en local." -Color Yellow
        return $true  # Ne pas échouer le test si npx n'est pas disponible
    }
}

# Exécuter les vérifications
$structureOk = Test-ProjectStructure
Write-ColorMessage ""

$mondesOk = Test-Mondes
Write-ColorMessage ""

$imagesOk = Test-Images
Write-ColorMessage ""

$scriptsOk = Test-Scripts
Write-ColorMessage ""

$webConfigOk = Test-WebConfig
Write-ColorMessage ""

$localSiteOk = Test-LocalSite
Write-ColorMessage ""

# Afficher le résumé
Write-ColorMessage "=== Résumé des vérifications ===" -Color Cyan
Write-ColorMessage "Structure du projet: $(if ($structureOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($structureOk) { "Green" } else { "Red" })
Write-ColorMessage "Mondes: $(if ($mondesOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($mondesOk) { "Green" } else { "Red" })
Write-ColorMessage "Images: $(if ($imagesOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($imagesOk) { "Green" } else { "Red" })
Write-ColorMessage "Scripts: $(if ($scriptsOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($scriptsOk) { "Green" } else { "Red" })
Write-ColorMessage "Web.config: $(if ($webConfigOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($webConfigOk) { "Green" } else { "Red" })
Write-ColorMessage "Site local: $(if ($localSiteOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($localSiteOk) { "Green" } else { "Red" })
Write-ColorMessage ""

# Conclusion
if ($structureOk -and $mondesOk -and $imagesOk -and $scriptsOk -and $webConfigOk -and $localSiteOk) {
    Write-ColorMessage "Toutes les vérifications ont réussi. Le site est prêt à être déployé." -Color Green
} else {
    Write-ColorMessage "Certaines vérifications ont échoué. Veuillez corriger les problèmes identifiés avant de déployer le site." -Color Yellow
}

# Proposer de lancer le script de déploiement IIS si tout est OK
if ($structureOk -and $mondesOk -and $imagesOk -and $scriptsOk -and $webConfigOk -and $localSiteOk) {
    Write-ColorMessage "Voulez-vous lancer le script de déploiement IIS? (O/N)" -Color Yellow
    $response = Read-Host
    if ($response -eq "O" -or $response -eq "o") {
        Write-ColorMessage "Lancement du script de déploiement IIS..." -Color Yellow
        & "D:\Production\malvinaland\scripts\deploy-iis-fixed.ps1"
    }
}