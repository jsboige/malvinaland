# Script de vérification de l'état du dépôt Malvinaland
# Ce script vérifie que le dépôt est propre et organisé, et que le site peut être déployé correctement sur IIS

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot
$logPath = Join-Path -Path $rootPath -ChildPath "cleanup-logs"
$logFile = Join-Path -Path $logPath -ChildPath "verify-repository-$(Get-Date -Format 'yyyy-MM-dd_HH-mm').log"

# Fonction pour afficher les messages
function Write-Log {
    param (
        [string]$Message,
        [string]$Color = "White",
        [switch]$NoLog = $false
    )
    
    Write-Host $Message -ForegroundColor $Color
    if (-not $NoLog) {
        Add-Content -Path $logFile -Value $Message
    }
}

# Fonction pour vérifier si un dossier existe
function Test-DirectoryExists {
    param (
        [string]$Path,
        [string]$Description
    )
    
    if (Test-Path $Path) {
        Write-Log "✓ $Description existe" -Color Green
        return $true
    } else {
        Write-Log "✗ $Description n'existe pas" -Color Red
        return $false
    }
}

# Fonction pour vérifier si un fichier existe
function Test-FileExists {
    param (
        [string]$Path,
        [string]$Description
    )
    
    if (Test-Path $Path) {
        Write-Log "✓ $Description existe" -Color Green
        return $true
    } else {
        Write-Log "✗ $Description n'existe pas" -Color Red
        return $false
    }
}

# Fonction pour vérifier si un fichier contient un motif
function Test-FileContains {
    param (
        [string]$Path,
        [string]$Pattern,
        [string]$Description
    )
    
    if (Test-Path $Path) {
        $content = Get-Content -Path $Path -Raw
        if ($content -match $Pattern) {
            Write-Log "✓ $Description" -Color Green
            return $true
        } else {
            Write-Log "✗ $Description" -Color Red
            return $false
        }
    } else {
        Write-Log "✗ Le fichier $Path n'existe pas" -Color Red
        return $false
    }
}

# Créer le dossier de logs s'il n'existe pas
if (-not (Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType Directory -Force | Out-Null
    Write-Log "Dossier de logs créé: $logPath" -Color Green
}

# Afficher l'en-tête
Write-Log "=== Vérification de l'état du dépôt Malvinaland ===" -Color Cyan
Write-Log "Date: $(Get-Date)" -Color Cyan
Write-Log ""

# Étape 1: Vérifier la structure du dépôt
Write-Log "Étape 1: Vérification de la structure du dépôt..." -Color Yellow

$structureOk = $true

# Vérifier les dossiers principaux
$mainDirs = @(
    @{ Path = "src"; Description = "Le dossier src" },
    @{ Path = "site"; Description = "Le dossier site" },
    @{ Path = "scripts"; Description = "Le dossier scripts" },
    @{ Path = "ressources"; Description = "Le dossier ressources" },
    @{ Path = "docs"; Description = "Le dossier docs" }
)

foreach ($dir in $mainDirs) {
    $dirExists = Test-DirectoryExists -Path (Join-Path -Path $rootPath -ChildPath $dir.Path) -Description $dir.Description
    $structureOk = $structureOk -and $dirExists
}

# Vérifier les sous-dossiers importants
$subDirs = @(
    @{ Path = "src\_data"; Description = "Le dossier src\_data" },
    @{ Path = "src\_includes\layouts"; Description = "Le dossier src\_includes\layouts" },
    @{ Path = "src\assets"; Description = "Le dossier src\assets" },
    @{ Path = "src\content"; Description = "Le dossier src\content" },
    @{ Path = "site\assets"; Description = "Le dossier site\assets" },
    @{ Path = "site\content"; Description = "Le dossier site\content" },
    @{ Path = "site\Core"; Description = "Le dossier site\Core" }
)

foreach ($dir in $subDirs) {
    $dirExists = Test-DirectoryExists -Path (Join-Path -Path $rootPath -ChildPath $dir.Path) -Description $dir.Description
    $structureOk = $structureOk -and $dirExists
}

# Vérifier les fichiers importants
$importantFiles = @(
    @{ Path = "README.md"; Description = "Le fichier README.md principal" },
    @{ Path = "site\web.config"; Description = "Le fichier web.config" },
    @{ Path = "site\index.html"; Description = "La page d'accueil" },
    @{ Path = "docs\GUIDE_DEPLOIEMENT_IIS.md"; Description = "Le guide de déploiement IIS" },
    @{ Path = "scripts\README.md"; Description = "Le README.md des scripts" }
)

foreach ($file in $importantFiles) {
    $fileExists = Test-FileExists -Path (Join-Path -Path $rootPath -ChildPath $file.Path) -Description $file.Description
    $structureOk = $structureOk -and $fileExists
}

if ($structureOk) {
    Write-Log "✓ La structure du dépôt est correcte" -Color Green
} else {
    Write-Log "✗ La structure du dépôt présente des problèmes" -Color Red
}

# Étape 2: Vérifier la configuration IIS
Write-Log ""
Write-Log "Étape 2: Vérification de la configuration IIS..." -Color Yellow

$iisConfigOk = $true

# Vérifier le fichier web.config
$webConfigPath = Join-Path -Path $rootPath -ChildPath "site\web.config"
$webConfigExists = Test-FileExists -Path $webConfigPath -Description "Le fichier web.config"
$iisConfigOk = $iisConfigOk -and $webConfigExists

if ($webConfigExists) {
    # Vérifier les sections importantes du fichier web.config
    $sections = @(
        @{ Pattern = '<staticContent>'; Description = "La section staticContent est présente" },
        @{ Pattern = '<httpCompression>'; Description = "La section httpCompression est présente" },
        @{ Pattern = '<rewrite>'; Description = "La section rewrite est présente" },
        @{ Pattern = '<httpProtocol>'; Description = "La section httpProtocol est présente" },
        @{ Pattern = 'Content-Security-Policy'; Description = "La politique de sécurité du contenu (CSP) est configurée" },
        @{ Pattern = '<rule name="Redirect mondes paths"'; Description = "La règle de réécriture pour les mondes est présente" }
    )
    
    foreach ($section in $sections) {
        $sectionExists = Test-FileContains -Path $webConfigPath -Pattern $section.Pattern -Description $section.Description
        $iisConfigOk = $iisConfigOk -and $sectionExists
    }
}

if ($iisConfigOk) {
    Write-Log "✓ La configuration IIS est correcte" -Color Green
} else {
    Write-Log "✗ La configuration IIS présente des problèmes" -Color Red
}

# Étape 3: Vérifier les scripts de déploiement
Write-Log ""
Write-Log "Étape 3: Vérification des scripts de déploiement..." -Color Yellow

$scriptsOk = $true

# Vérifier les scripts importants
$importantScripts = @(
    @{ Path = "scripts\deploy-iis-improved.ps1"; Description = "Le script de déploiement amélioré" },
    @{ Path = "scripts\optimize-iis-config.ps1"; Description = "Le script d'optimisation de la configuration IIS" },
    @{ Path = "scripts\clean-temp-files.ps1"; Description = "Le script de nettoyage des fichiers temporaires" },
    @{ Path = "scripts\organize-simple.ps1"; Description = "Le script d'organisation des fichiers" }
)

foreach ($script in $importantScripts) {
    $scriptExists = Test-FileExists -Path (Join-Path -Path $rootPath -ChildPath $script.Path) -Description $script.Description
    $scriptsOk = $scriptsOk -and $scriptExists
}

if ($scriptsOk) {
    Write-Log "✓ Les scripts de déploiement sont présents" -Color Green
} else {
    Write-Log "✗ Certains scripts de déploiement sont manquants" -Color Red
}

# Étape 4: Vérifier la documentation
Write-Log ""
Write-Log "Étape 4: Vérification de la documentation..." -Color Yellow

$docsOk = $true

# Vérifier les documents importants
$importantDocs = @(
    @{ Path = "docs\GUIDE_MAINTENANCE.md"; Description = "Le guide de maintenance" },
    @{ Path = "docs\GUIDE_PNJ.md"; Description = "Le guide des PNJ" },
    @{ Path = "docs\MOBILE_EXPERIENCE.md"; Description = "Le document sur l'expérience mobile" },
    @{ Path = "docs\JOURNAL_MODIFICATIONS.md"; Description = "Le journal des modifications" },
    @{ Path = "docs\COMMENT_MODIFIER.md"; Description = "Le guide de modification du site" },
    @{ Path = "docs\GUIDE_DEPLOIEMENT_IIS.md"; Description = "Le guide de déploiement IIS" }
)

foreach ($doc in $importantDocs) {
    $docExists = Test-FileExists -Path (Join-Path -Path $rootPath -ChildPath $doc.Path) -Description $doc.Description
    $docsOk = $docsOk -and $docExists
}

# Vérifier que le README.md principal fait référence au guide de déploiement IIS
$readmePath = Join-Path -Path $rootPath -ChildPath "README.md"
$readmeContainsGuide = Test-FileContains -Path $readmePath -Pattern "GUIDE_DEPLOIEMENT_IIS" -Description "Le README.md fait référence au guide de déploiement IIS"
$docsOk = $docsOk -and $readmeContainsGuide

if ($docsOk) {
    Write-Log "✓ La documentation est complète" -Color Green
} else {
    Write-Log "✗ La documentation présente des lacunes" -Color Red
}

# Étape 5: Vérifier les fichiers ignorés par Git
Write-Log ""
Write-Log "Étape 5: Vérification des fichiers ignorés par Git..." -Color Yellow

$gitignoreOk = $true

# Vérifier le fichier .gitignore
$gitignorePath = Join-Path -Path $rootPath -ChildPath ".gitignore"
$gitignoreExists = Test-FileExists -Path $gitignorePath -Description "Le fichier .gitignore"
$gitignoreOk = $gitignoreOk -and $gitignoreExists

if ($gitignoreExists) {
    # Vérifier les entrées importantes du fichier .gitignore
    $entries = @(
        @{ Pattern = 'node_modules'; Description = "Les modules Node.js sont ignorés" },
        @{ Pattern = 'dist'; Description = "Le dossier dist est ignoré" },
        @{ Pattern = '\.log'; Description = "Les fichiers de log sont ignorés" },
        @{ Pattern = 'IIS Temporary'; Description = "Les fichiers temporaires IIS sont ignorés" },
        @{ Pattern = 'backup-before-cleanup'; Description = "Les sauvegardes sont ignorées" }
    )
    
    foreach ($entry in $entries) {
        $entryExists = Test-FileContains -Path $gitignorePath -Pattern $entry.Pattern -Description $entry.Description
        $gitignoreOk = $gitignoreOk -and $entryExists
    }
}

if ($gitignoreOk) {
    Write-Log "✓ Le fichier .gitignore est correctement configuré" -Color Green
} else {
    Write-Log "✗ Le fichier .gitignore présente des problèmes" -Color Red
}

# Afficher le résumé
Write-Log ""
Write-Log "=== Résumé de la vérification ===" -Color Cyan

$allOk = $structureOk -and $iisConfigOk -and $scriptsOk -and $docsOk -and $gitignoreOk

if ($allOk) {
    Write-Log "✓ Le dépôt est propre et organisé" -Color Green
    Write-Log "✓ Le site peut être déployé correctement sur IIS" -Color Green
    Write-Log ""
    Write-Log "Félicitations ! Le dépôt Malvinaland est prêt pour le déploiement." -Color Green
} else {
    Write-Log "✗ Le dépôt présente des problèmes qui doivent être corrigés" -Color Red
    Write-Log ""
    Write-Log "Veuillez corriger les problèmes signalés avant de déployer le site." -Color Red
}

Write-Log ""
Write-Log "Le rapport de vérification est disponible ici: $logFile" -Color Cyan