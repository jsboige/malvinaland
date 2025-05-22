# Script de déploiement amélioré pour Malvinaland sur IIS
# Ce script corrige les problèmes de menu mobile, de chemins de fichiers et déploie automatiquement sur IIS

# Fonction pour afficher un message coloré
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

# Fonction pour corriger les chemins de fichiers dans un fichier HTML
function Fix-FilePaths {
    param (
        [string]$FilePath
    )
    
    Write-ColorMessage "Correction des chemins de fichiers dans $FilePath..." -Color Yellow
    
    try {
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
        
        # Corriger les chemins CSS
        $content = $content -replace 'href="dist/css/styles.min.css"', 'href="Core/styles.css"'
        
        # Corriger les chemins JavaScript
        $content = $content -replace 'src="dist/js/app.min.js"', 'src="app.js"'
        $content = $content -replace 'src="dist/js/navigation.min.js"', 'src="Core/navigation.js"'
        
        # Corriger les chemins d'images
        $content = $content -replace 'src="images/monde-([^/]+)/([^"]+)"', 'src="monde-$1/images/$2"'
        
        # Enregistrer les modifications
        Set-Content -Path $FilePath -Value $content -Encoding UTF8
        
        Write-ColorMessage "[OK] Chemins corriges dans $FilePath" -Color Green
    }
    catch {
        Write-ColorMessage "[ERREUR] Erreur lors de la correction des chemins dans $FilePath : $($_.Exception.Message)" -Color Red
    }
}

# Fonction pour corriger les problèmes de menu mobile
function Fix-MobileMenu {
    param (
        [string]$FilePath
    )
    
    Write-ColorMessage "Correction du menu mobile dans $FilePath..." -Color Yellow
    
    try {
        $content = Get-Content -Path $FilePath -Raw -Encoding UTF8
        
        # Supprimer les scripts inline de menu mobile
        $pattern1 = '(?s)<script>\s*// Script de correction pour le menu mobile directement dans la page.*?</script>'
        $content = $content -replace $pattern1, ''
        
        $pattern2 = '(?s)<script>\s*\(function\(\) \{\s*// Attendre que la page soit complètement chargée.*?}\)\(\);\s*</script>'
        $content = $content -replace $pattern2, ''
        
        # Ne plus ajouter le script menu-mobile-fix.js car il crée un conflit avec fix-mobile-menu.js
        # Le script fix-mobile-menu.js est déjà inclus via le template de base d'Eleventy
        # if ($content -notmatch '<script src="Core/menu-mobile-fix.js"') {
        #     $content = $content -replace '(</head>)', '    <script src="Core/menu-mobile-fix.js" defer></script>$1'
        # }
        
        # Enregistrer les modifications
        Set-Content -Path $FilePath -Value $content -Encoding UTF8
        
        Write-ColorMessage "[OK] Menu mobile corrige dans $FilePath" -Color Green
    }
    catch {
        Write-ColorMessage "[ERREUR] Erreur lors de la correction du menu mobile dans $FilePath : $($_.Exception.Message)" -Color Red
    }
}

# Fonction pour créer des fichiers README.md pour résoudre les erreurs 404
function Create-ReadmeFiles {
    param (
        [string]$SitePath
    )
    
    Write-ColorMessage "Création des fichiers README.md pour résoudre les erreurs 404..." -Color Yellow
    
    # Liste des mondes
    $mondes = @(
        "monde-assemblee",
        "monde-grange",
        "monde-jeux",
        "monde-reves",
        "monde-damier",
        "monde-linge",
        "monde-verger",
        "monde-zob",
        "monde-elysee",
        "monde-karibu",
        "monde-sphinx"
    )
    
    # Créer les répertoires et fichiers README.md pour chaque monde
    foreach ($monde in $mondes) {
        $mondeDir = Join-Path -Path $SitePath -ChildPath $monde
        
        # Créer le répertoire s'il n'existe pas
        if (-not (Test-Path -Path $mondeDir)) {
            New-Item -Path $mondeDir -ItemType Directory -Force | Out-Null
            Write-ColorMessage "[OK] Repertoire cree : $mondeDir" -Color Green
        }
        
        # Créer le fichier README.md s'il n'existe pas
        $readmePath = Join-Path -Path $mondeDir -ChildPath "readme.md"
        if (-not (Test-Path -Path $readmePath)) {
            # Extraire le nom du monde à partir de l'ID
            $mondeName = $monde -replace "monde-", ""
            $mondeName = (Get-Culture).TextInfo.ToTitleCase($mondeName)
            
            # Contenu du README.md
            $readmeContent = @"
# Le Monde $mondeName

Ce répertoire contient les ressources spécifiques au Monde $mondeName.

## Structure

* images/ : Images spécifiques à ce monde
* readme.md : Ce fichier

## Description

Le Monde $mondeName est l'un des mondes de Malvinaland. Pour plus d'informations, consultez la page principale du monde.
"@
            
            # Écrire le contenu dans le fichier
            Set-Content -Path $readmePath -Value $readmeContent -Encoding UTF8
            Write-ColorMessage "[OK] Fichier README.md cree : $readmePath" -Color Green
        }
        
        # Créer le répertoire images s'il n'existe pas
        $imagesDir = Join-Path -Path $mondeDir -ChildPath "images"
        if (-not (Test-Path -Path $imagesDir)) {
            New-Item -Path $imagesDir -ItemType Directory -Force | Out-Null
            Write-ColorMessage "[OK] Repertoire images cree : $imagesDir" -Color Green
        }
    }
}

# Fonction pour corriger le README.md principal
function Fix-MainReadme {
    param (
        [string]$SitePath
    )
    
    Write-ColorMessage "Correction du README.md principal..." -Color Yellow
    
    $readmePath = Join-Path -Path $SitePath -ChildPath "README.md"
    
    # Contenu du README.md principal
    $readmeContent = @"
# Malvinaland

Ce site présente les différents mondes de Malvinaland, un univers imaginaire riche en mystères et en aventures.

## Structure du site

* index.html : Page d'accueil
* carte.html : Carte interactive des mondes
* monde-*.html : Pages des différents mondes
* Core/ : Scripts et styles communs
* monde-*/ : Ressources spécifiques à chaque monde

## Mondes disponibles

* Monde de l'Assemblée
* Monde de la Grange
* Monde des Jeux
* Monde des Rêves
* Monde du Damier
* Monde du Linge
* Monde du Verger
* Monde du Zob
* Monde Elysée
* Monde Karibu
* Monde des Sphinx

## Déploiement

Pour déployer ce site sur IIS :

1. Assurez-vous que IIS est installé avec le module URL Rewrite
2. Copiez tous les fichiers dans le répertoire racine du site IIS
3. Configurez les autorisations appropriées pour IIS_IUSRS
4. Redémarrez le site IIS

## Maintenance

En cas de problème avec le menu mobile ou d'erreurs 404 :

1. Vérifiez que tous les fichiers ont été correctement copiés
2. Assurez-vous que les répertoires des mondes existent et contiennent un fichier readme.md
3. Videz le cache du navigateur et du serveur IIS
4. Redémarrez le site IIS
"@
    
    # Écrire le contenu dans le fichier
    Set-Content -Path $readmePath -Value $readmeContent -Encoding UTF8
    Write-ColorMessage "[OK] README.md principal corrige" -Color Green
}

# Fonction pour déployer les fichiers sur IIS
function Deploy-ToIIS {
    param (
        [string]$SourcePath,
        [string]$DestinationPath,
        [string]$SiteName = "Malvinaland",
        [string]$HostName = "malvinaland.myia.io"
    )
    
    Write-ColorMessage "Déploiement des fichiers sur IIS..." -Color Yellow
    
    try {
        # Vérifier si les dossiers existent
        if (-not (Test-Path -Path $SourcePath)) {
            Write-ColorMessage "[ERREUR] Le dossier source n'existe pas: $SourcePath" -Color Red
            return $false
        }
        
        # Créer le dossier de destination s'il n'existe pas
        if (-not (Test-Path -Path $DestinationPath)) {
            New-Item -Path $DestinationPath -ItemType Directory -Force | Out-Null
            Write-ColorMessage "[OK] Dossier de destination cree: $DestinationPath" -Color Green
        }
        
        # Copier les fichiers
        Write-ColorMessage "Copie des fichiers de $SourcePath vers $DestinationPath..." -Color Yellow
        Copy-Item -Path "$SourcePath\*" -Destination $DestinationPath -Recurse -Force
        Write-ColorMessage "[OK] Fichiers copies avec succes" -Color Green
        
        # Configurer IIS
        Import-Module WebAdministration -ErrorAction Stop
        
        # Vérifier si le site existe déjà
        $existingSite = Get-Website | Where-Object { $_.Name -eq $SiteName }
        
        if ($existingSite) {
            Write-ColorMessage "Le site '$SiteName' existe déjà." -Color Yellow
            
            # Mettre à jour le chemin physique si nécessaire
            if ($existingSite.PhysicalPath -ne $DestinationPath) {
                Set-ItemProperty "IIS:\Sites\$SiteName" -Name physicalPath -Value $DestinationPath
                Write-ColorMessage "[OK] Chemin physique mis a jour: $DestinationPath" -Color Green
            }
            
            # Vérifier si le site est démarré
            if ($existingSite.State -ne "Started") {
                Start-Website -Name $SiteName
                Write-ColorMessage "[OK] Site demarre" -Color Green
            }
        }
        else {
            # Créer un nouveau site
            New-Website -Name $SiteName -PhysicalPath $DestinationPath -Port 443 -HostHeader $HostName -Force
            Write-ColorMessage "[OK] Site '$SiteName' cree avec succes" -Color Green
            
            # Démarrer le site
            Start-Website -Name $SiteName
            Write-ColorMessage "[OK] Site demarre" -Color Green
        }
        
        # Configurer HTTPS si nécessaire
        $binding = Get-WebBinding -Name $SiteName -Protocol "https"
        if (-not $binding) {
            New-WebBinding -Name $SiteName -Protocol "https" -Port 443 -HostHeader $HostName -SslFlags 1
            Write-ColorMessage "[OK] Liaison HTTPS ajoutee" -Color Green
        }
        
        # Configurer les autorisations du dossier
        $acl = Get-Acl -Path $DestinationPath
        $iisUserAccess = $acl.Access | Where-Object { $_.IdentityReference -like "*IIS_IUSRS*" }
        
        if (-not $iisUserAccess) {
            $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
                "IIS_IUSRS",
                "ReadAndExecute",
                "ContainerInherit,ObjectInherit",
                "None",
                "Allow"
            )
            $acl.AddAccessRule($rule)
            Set-Acl -Path $DestinationPath -AclObject $acl
            Write-ColorMessage "[OK] Autorisations ajoutees pour IIS_IUSRS" -Color Green
        }
        else {
            Write-ColorMessage "[OK] Les autorisations pour IIS_IUSRS existent deja" -Color Green
        }
        
        return $true
    }
    catch {
        Write-ColorMessage "[ERREUR] Erreur lors du deploiement sur IIS: $($_.Exception.Message)" -Color Red
        return $false
    }
}

# Fonction pour vider le cache IIS et redémarrer le service
function Reset-IIS {
    param (
        [string]$SiteName = "Malvinaland"
    )
    
    Write-ColorMessage "Réinitialisation d'IIS..." -Color Yellow
    
    try {
        # Arrêter le site
        Stop-Website -Name $SiteName -ErrorAction SilentlyContinue
        Write-ColorMessage "[OK] Site arrete" -Color Green
        
        # Vider le cache IIS
        Write-ColorMessage "Vidage du cache IIS..." -Color Yellow
        
        # Supprimer les fichiers temporaires IIS
        $iisTemp = "C:\inetpub\temp\IIS Temporary Compressed Files"
        if (Test-Path -Path $iisTemp) {
            Remove-Item -Path "$iisTemp\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-ColorMessage "[OK] Fichiers temporaires IIS supprimes" -Color Green
        }
        
        # Redémarrer le service IIS
        Write-ColorMessage "Redémarrage du service IIS..." -Color Yellow
        iisreset /noforce
        Write-ColorMessage "[OK] Service IIS redemarre" -Color Green
        
        # Démarrer le site
        Start-Website -Name $SiteName -ErrorAction SilentlyContinue
        Write-ColorMessage "[OK] Site demarre" -Color Green
        
        return $true
    }
    catch {
        Write-ColorMessage "[ERREUR] Erreur lors de la reinitialisation d'IIS: $($_.Exception.Message)" -Color Red
        return $false
    }
}

# Afficher un en-tête
Write-ColorMessage "=== Déploiement amélioré de Malvinaland sur IIS ===" -Color Cyan
Write-ColorMessage "Date: $(Get-Date)" -Color Cyan
Write-ColorMessage ""

# Définir les chemins
$sourcePath = "D:\Production\malvinaland\site"
$destinationPath = "C:\inetpub\wwwroot\malvinaland"
$siteName = "Malvinaland"
$hostName = "malvinaland.myia.io"

# Étape 1: Corriger les chemins de fichiers dans les fichiers HTML
Write-ColorMessage "Étape 1: Correction des chemins de fichiers..." -Color Yellow
$htmlFiles = Get-ChildItem -Path $sourcePath -Filter "*.html" -Recurse
foreach ($htmlFile in $htmlFiles) {
    Fix-FilePaths -FilePath $htmlFile.FullName
}

# Étape 2: Corriger les problèmes de menu mobile
Write-ColorMessage "Étape 2: Correction des problèmes de menu mobile..." -Color Yellow
$htmlFiles = Get-ChildItem -Path $sourcePath -Filter "*.html" -Recurse
foreach ($htmlFile in $htmlFiles) {
    Fix-MobileMenu -FilePath $htmlFile.FullName
}

# Étape 3: Créer des fichiers README.md pour résoudre les erreurs 404
Write-ColorMessage "Étape 3: Création des fichiers README.md..." -Color Yellow
Create-ReadmeFiles -SitePath $sourcePath

# Étape 4: Corriger le README.md principal
Write-ColorMessage "Étape 4: Correction du README.md principal..." -Color Yellow
Fix-MainReadme -SitePath $sourcePath

# Étape 5: Déployer les fichiers sur IIS
Write-ColorMessage "Étape 5: Déploiement sur IIS..." -Color Yellow
$deploySuccess = Deploy-ToIIS -SourcePath $sourcePath -DestinationPath $destinationPath -SiteName $siteName -HostName $hostName

# Étape 6: Vider le cache IIS et redémarrer le service
if ($deploySuccess) {
    Write-ColorMessage "Étape 6: Réinitialisation d'IIS..." -Color Yellow
    Reset-IIS -SiteName $siteName
}

Write-ColorMessage ""
Write-ColorMessage "=== Déploiement terminé ===" -Color Cyan
Write-ColorMessage "Veuillez tester l'accès au site à l'adresse https://$hostName/" -Color Cyan