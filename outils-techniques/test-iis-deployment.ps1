# Script de test de la publication IIS pour Malvinaland
# Ce script vérifie que toutes les ressources sont correctement accessibles via le nom de domaine

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

# Fonction pour vérifier la configuration IIS
function Test-IISConfiguration {
    param (
        [string]$SiteName = "Malvinaland"
    )
    
    Write-ColorMessage "Vérification de la configuration IIS..." -Color Yellow
    
    try {
        # Vérifier si le module WebAdministration est disponible
        if (-not (Get-Module -ListAvailable -Name WebAdministration)) {
            Write-ColorMessage "[ERREUR] Le module WebAdministration n'est pas disponible. Veuillez l'installer." -Color Red
            return $false
        }
        
        # Importer le module WebAdministration
        Import-Module WebAdministration -ErrorAction Stop
        
        # Vérifier si le site existe
        $site = Get-Website | Where-Object { $_.Name -eq $SiteName }
        if (-not $site) {
            Write-ColorMessage "[ERREUR] Le site '$SiteName' n'existe pas dans IIS." -Color Red
            return $false
        }
        
        # Vérifier si le site est démarré
        if ($site.State -ne "Started") {
            Write-ColorMessage "[ERREUR] Le site '$SiteName' n'est pas démarré (État actuel: $($site.State))." -Color Red
            return $false
        }
        
        # Vérifier les liaisons
        $bindings = $site.bindings.Collection
        $httpsBinding = $bindings | Where-Object { $_.protocol -eq "https" }
        if (-not $httpsBinding) {
            Write-ColorMessage "[AVERTISSEMENT] Le site '$SiteName' n'a pas de liaison HTTPS." -Color Yellow
        } else {
            Write-ColorMessage "[OK] Le site '$SiteName' a une liaison HTTPS." -Color Green
        }
        
        # Vérifier le chemin physique
        $physicalPath = $site.PhysicalPath
        if (-not (Test-Path -Path $physicalPath)) {
            Write-ColorMessage "[ERREUR] Le chemin physique du site n'existe pas: $physicalPath" -Color Red
            return $false
        }
        
        Write-ColorMessage "[OK] Le site '$SiteName' est correctement configuré dans IIS." -Color Green
        return $true
    } catch {
        Write-ColorMessage "[ERREUR] Erreur lors de la vérification de la configuration IIS: $($_.Exception.Message)" -Color Red
        return $false
    }
}

# Fonction pour vérifier les ressources du site
function Test-SiteResources {
    param (
        [string]$BaseUrl,
        [string]$PhysicalPath
    )
    
    Write-ColorMessage "Vérification des ressources du site..." -Color Yellow
    
    # Liste des ressources à vérifier
    $resources = @(
        @{ Url = "$BaseUrl/"; Description = "Page d'accueil" },
        @{ Url = "$BaseUrl/carte"; Description = "Page de la carte" },
        @{ Url = "$BaseUrl/assets/images/carte-malvinaland.png"; Description = "Image de la carte" },
        @{ Url = "$BaseUrl/assets/css/main.css"; Description = "Feuille de style principale" },
        @{ Url = "$BaseUrl/assets/js/navigation.js"; Description = "Script de navigation" }
    )
    
    # Vérifier chaque ressource
    $allResourcesAccessible = $true
    foreach ($resource in $resources) {
        $isAccessible = Test-UrlAccess -Url $resource.Url -Description $resource.Description
        if (-not $isAccessible) {
            $allResourcesAccessible = $false
        }
    }
    
    # Vérifier les mondes
    $mondes = @(
        "assemblee", "grange", "jeux", "reves", "damier", 
        "linge", "verger", "zob", "elysee", "karibu", "sphinx"
    )
    
    foreach ($monde in $mondes) {
        $mondeUrl = "$BaseUrl/mondes/$monde"
        $isAccessible = Test-UrlAccess -Url $mondeUrl -Description "Page du monde $monde"
        if (-not $isAccessible) {
            $allResourcesAccessible = $false
        }
    }
    
    return $allResourcesAccessible
}

# Afficher un en-tête
Write-ColorMessage "=== Test de la publication IIS de Malvinaland ===" -Color Cyan
Write-ColorMessage "Date: $(Get-Date)" -Color Cyan
Write-ColorMessage ""

# Définir les chemins et URLs
$sitePath = "D:\Production\malvinaland\site"
$siteName = "Malvinaland"
$hostName = "malvinaland.myia.io"
$baseUrl = "https://$hostName"

# Étape 1: Vérifier que la carte a été correctement copiée
Write-ColorMessage "Étape 1: Vérification de la carte..." -Color Yellow
$carteSourcePath = "D:\Production\malvinaland\archive\Mondes\Carte de Malvinaland stylisée.png"
$carteDestPath1 = "D:\Production\malvinaland\site\assets\images\carte-malvinaland.png"
$carteDestPath2 = "D:\Production\malvinaland\src\assets\images\carte-malvinaland.png"

$carteSourceExists = Test-FileExists -FilePath $carteSourcePath -Description "Carte source"
$carteDestExists1 = Test-FileExists -FilePath $carteDestPath1 -Description "Carte dans site/assets"
$carteDestExists2 = Test-FileExists -FilePath $carteDestPath2 -Description "Carte dans src/assets"

if ($carteSourceExists -and $carteDestExists1 -and $carteDestExists2) {
    Write-ColorMessage "[OK] La carte a été correctement copiée." -Color Green
} else {
    Write-ColorMessage "[AVERTISSEMENT] La carte n'a pas été correctement copiée." -Color Yellow
}

# Étape 2: Vérifier la configuration IIS
Write-ColorMessage "Étape 2: Vérification de la configuration IIS..." -Color Yellow
$iisConfigOk = Test-IISConfiguration -SiteName $siteName

if (-not $iisConfigOk) {
    Write-ColorMessage "[AVERTISSEMENT] La configuration IIS n'est pas correcte. Voulez-vous exécuter le script de déploiement IIS? (O/N)" -Color Yellow
    $response = Read-Host
    if ($response -eq "O" -or $response -eq "o") {
        Write-ColorMessage "Exécution du script de déploiement IIS..." -Color Yellow
        & "D:\Production\malvinaland\scripts\deploy-iis-fixed.ps1"
    }
}

# Étape 3: Vérifier l'accès aux ressources
Write-ColorMessage "Étape 3: Vérification de l'accès aux ressources..." -Color Yellow
$resourcesOk = Test-SiteResources -BaseUrl $baseUrl -PhysicalPath $sitePath

if ($resourcesOk) {
    Write-ColorMessage "[OK] Toutes les ressources sont accessibles." -Color Green
} else {
    Write-ColorMessage "[AVERTISSEMENT] Certaines ressources ne sont pas accessibles." -Color Yellow
}

# Résumé
Write-ColorMessage ""
Write-ColorMessage "=== Résumé des tests ===" -Color Cyan
Write-ColorMessage "Carte copiée: $(if ($carteSourceExists -and $carteDestExists1 -and $carteDestExists2) { "Oui" } else { "Non" })" -Color $(if ($carteSourceExists -and $carteDestExists1 -and $carteDestExists2) { "Green" } else { "Red" })
Write-ColorMessage "Configuration IIS: $(if ($iisConfigOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($iisConfigOk) { "Green" } else { "Red" })
Write-ColorMessage "Accès aux ressources: $(if ($resourcesOk) { "OK" } else { "Problèmes détectés" })" -Color $(if ($resourcesOk) { "Green" } else { "Red" })

Write-ColorMessage ""
Write-ColorMessage "=== Test terminé ===" -Color Cyan
if ($carteSourceExists -and $carteDestExists1 -and $carteDestExists2 -and $iisConfigOk -and $resourcesOk) {
    Write-ColorMessage "Tous les tests ont réussi. Le site est correctement déployé." -Color Green
} else {
    Write-ColorMessage "Certains tests ont échoué. Veuillez corriger les problèmes identifiés." -Color Yellow
}