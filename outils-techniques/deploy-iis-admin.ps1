# Script de déploiement administrateur pour Malvinaland sur IIS
# Ce script doit être exécuté en tant qu'administrateur

# Définir les chemins
$sourcePath = "D:\Production\malvinaland\Site"
$destinationPath = "C:\inetpub\wwwroot\malvinaland"
$siteName = "Malvinaland"
$hostName = "malvinaland.myia.io"

# Fonction pour afficher un message coloré
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

# Afficher un en-tête
Write-ColorMessage "=== Déploiement administrateur de Malvinaland sur IIS ===" -Color Cyan
Write-ColorMessage "Date: $(Get-Date)" -Color Cyan
Write-ColorMessage ""

# Vérifier si le script est exécuté en tant qu'administrateur
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-ColorMessage "Ce script doit être exécuté en tant qu'administrateur." -Color Red
    Write-ColorMessage "Veuillez redémarrer PowerShell en tant qu'administrateur et réexécuter ce script." -Color Red
    exit
}

# Créer le dossier de destination s'il n'existe pas
if (-not (Test-Path -Path $destinationPath)) {
    New-Item -Path $destinationPath -ItemType Directory -Force | Out-Null
    Write-ColorMessage "Dossier de destination créé: $destinationPath" -Color Green
}

# Copier les fichiers
Write-ColorMessage "Copie des fichiers de $sourcePath vers $destinationPath..." -Color Yellow
Copy-Item -Path "$sourcePath\*" -Destination $destinationPath -Recurse -Force
Write-ColorMessage "Fichiers copiés avec succès" -Color Green

# Configurer IIS
try {
    Import-Module WebAdministration -ErrorAction Stop
    
    # Vérifier si le site existe déjà
    $existingSite = Get-Website | Where-Object { $_.Name -eq $siteName }
    
    if ($existingSite) {
        Write-ColorMessage "Le site '$siteName' existe déjà." -Color Yellow
        
        # Mettre à jour le chemin physique si nécessaire
        if ($existingSite.PhysicalPath -ne $destinationPath) {
            Set-ItemProperty "IIS:\Sites\$SiteName" -Name physicalPath -Value $destinationPath
            Write-ColorMessage "Chemin physique mis à jour: $destinationPath" -Color Green
        }
        
        # Vérifier si le site est démarré
        if ($existingSite.State -ne "Started") {
            Start-Website -Name $siteName
            Write-ColorMessage "Site démarré" -Color Green
        }
    }
    else {
        # Créer un nouveau site
        New-Website -Name $siteName -PhysicalPath $destinationPath -Port 443 -HostHeader $hostName -Force
        Write-ColorMessage "Site '$siteName' créé avec succès" -Color Green
        
        # Démarrer le site
        Start-Website -Name $siteName
        Write-ColorMessage "Site démarré" -Color Green
    }
    
    # Configurer HTTPS si nécessaire
    $binding = Get-WebBinding -Name $siteName -Protocol "https"
    if (-not $binding) {
        New-WebBinding -Name $siteName -Protocol "https" -Port 443 -HostHeader $hostName -SslFlags 1
        Write-ColorMessage "Liaison HTTPS ajoutée" -Color Green
    }
    
    # Configurer les autorisations du dossier
    $acl = Get-Acl -Path $destinationPath
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
        Set-Acl -Path $destinationPath -AclObject $acl
        Write-ColorMessage "Autorisations ajoutées pour IIS_IUSRS" -Color Green
    }
    else {
        Write-ColorMessage "Les autorisations pour IIS_IUSRS existent déjà" -Color Green
    }
    
    # Vider le cache IIS
    Write-ColorMessage "Vidage du cache IIS..." -Color Yellow
    
    # Supprimer les fichiers temporaires IIS
    $iisTemp = "C:\inetpub\temp\IIS Temporary Compressed Files"
    if (Test-Path -Path $iisTemp) {
        Remove-Item -Path "$iisTemp\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-ColorMessage "Fichiers temporaires IIS supprimés" -Color Green
    }
    
    # Redémarrer le service IIS
    Write-ColorMessage "Redémarrage du service IIS..." -Color Yellow
    iisreset /noforce
    Write-ColorMessage "Service IIS redémarré" -Color Green
    
    # Démarrer le site
    Start-Website -Name $siteName -ErrorAction SilentlyContinue
    Write-ColorMessage "Site démarré" -Color Green
}
catch {
    Write-ColorMessage "Erreur lors de la configuration IIS: $($_.Exception.Message)" -Color Red
}

Write-ColorMessage ""
Write-ColorMessage "=== Déploiement terminé ===" -Color Cyan
Write-ColorMessage "Veuillez tester l'accès au site à l'adresse https://$hostName/" -Color Cyan