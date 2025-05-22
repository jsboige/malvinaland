# Script simplifié de vérification de l'état du dépôt Malvinaland

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot

# Fonction pour afficher les messages
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

# Afficher l'en-tête
Write-ColorMessage "=== Vérification de l'état du dépôt Malvinaland ===" -Color Cyan
Write-ColorMessage "Date: $(Get-Date)" -Color Cyan
Write-ColorMessage ""

# Étape 1: Vérifier la structure du dépôt
Write-ColorMessage "Étape 1: Vérification de la structure du dépôt..." -Color Yellow

# Vérifier les dossiers principaux
$mainDirs = @("src", "site", "scripts", "ressources", "docs")
$missingDirs = @()

foreach ($dir in $mainDirs) {
    $dirPath = Join-Path -Path $rootPath -ChildPath $dir
    if (Test-Path $dirPath) {
        Write-ColorMessage "✓ Le dossier $dir existe" -Color Green
    } else {
        Write-ColorMessage "✗ Le dossier $dir n'existe pas" -Color Red
        $missingDirs += $dir
    }
}

if ($missingDirs.Count -eq 0) {
    Write-ColorMessage "✓ Tous les dossiers principaux sont présents" -Color Green
} else {
    Write-ColorMessage "✗ Dossiers manquants: $($missingDirs -join ', ')" -Color Red
}

# Étape 2: Vérifier les fichiers importants
Write-ColorMessage ""
Write-ColorMessage "Étape 2: Vérification des fichiers importants..." -Color Yellow

$importantFiles = @(
    "README.md",
    "site\web.config",
    "site\index.html",
    "docs\GUIDE_DEPLOIEMENT_IIS.md",
    "scripts\README.md"
)
$missingFiles = @()

foreach ($file in $importantFiles) {
    $filePath = Join-Path -Path $rootPath -ChildPath $file
    if (Test-Path $filePath) {
        Write-ColorMessage "✓ Le fichier $file existe" -Color Green
    } else {
        Write-ColorMessage "✗ Le fichier $file n'existe pas" -Color Red
        $missingFiles += $file
    }
}

if ($missingFiles.Count -eq 0) {
    Write-ColorMessage "✓ Tous les fichiers importants sont présents" -Color Green
} else {
    Write-ColorMessage "✗ Fichiers manquants: $($missingFiles -join ', ')" -Color Red
}

# Étape 3: Vérifier le fichier web.config
Write-ColorMessage ""
Write-ColorMessage "Étape 3: Vérification du fichier web.config..." -Color Yellow

$webConfigPath = Join-Path -Path $rootPath -ChildPath "site\web.config"
if (Test-Path $webConfigPath) {
    $webConfigContent = Get-Content -Path $webConfigPath -Raw
    $webConfigChecks = @(
        @{ Pattern = '<staticContent>'; Name = "Section staticContent" },
        @{ Pattern = '<httpCompression>'; Name = "Section httpCompression" },
        @{ Pattern = '<rewrite>'; Name = "Section rewrite" },
        @{ Pattern = '<httpProtocol>'; Name = "Section httpProtocol" },
        @{ Pattern = 'Content-Security-Policy'; Name = "Politique de sécurité du contenu (CSP)" }
    )
    
    $missingConfigs = @()
    foreach ($check in $webConfigChecks) {
        if ($webConfigContent -match $check.Pattern) {
            Write-ColorMessage "✓ $($check.Name) est présente" -Color Green
        } else {
            Write-ColorMessage "✗ $($check.Name) est manquante" -Color Red
            $missingConfigs += $check.Name
        }
    }
    
    if ($missingConfigs.Count -eq 0) {
        Write-ColorMessage "✓ Le fichier web.config est correctement configuré" -Color Green
    } else {
        Write-ColorMessage "✗ Le fichier web.config présente des problèmes: $($missingConfigs -join ', ')" -Color Red
    }
} else {
    Write-ColorMessage "✗ Le fichier web.config n'existe pas" -Color Red
}

# Étape 4: Vérifier le fichier .gitignore
Write-ColorMessage ""
Write-ColorMessage "Étape 4: Vérification du fichier .gitignore..." -Color Yellow

$gitignorePath = Join-Path -Path $rootPath -ChildPath ".gitignore"
if (Test-Path $gitignorePath) {
    $gitignoreContent = Get-Content -Path $gitignorePath -Raw
    $gitignoreChecks = @(
        @{ Pattern = 'node_modules'; Name = "Modules Node.js" },
        @{ Pattern = 'dist'; Name = "Dossier dist" },
        @{ Pattern = '\.log'; Name = "Fichiers de log" },
        @{ Pattern = 'IIS Temporary'; Name = "Fichiers temporaires IIS" }
    )
    
    $missingEntries = @()
    foreach ($check in $gitignoreChecks) {
        if ($gitignoreContent -match $check.Pattern) {
            Write-ColorMessage "✓ $($check.Name) sont ignorés" -Color Green
        } else {
            Write-ColorMessage "✗ $($check.Name) ne sont pas ignorés" -Color Red
            $missingEntries += $check.Name
        }
    }
    
    if ($missingEntries.Count -eq 0) {
        Write-ColorMessage "✓ Le fichier .gitignore est correctement configuré" -Color Green
    } else {
        Write-ColorMessage "✗ Le fichier .gitignore présente des problèmes: $($missingEntries -join ', ')" -Color Red
    }
} else {
    Write-ColorMessage "✗ Le fichier .gitignore n'existe pas" -Color Red
}

# Afficher le résumé
Write-ColorMessage ""
Write-ColorMessage "=== Résumé de la vérification ===" -Color Cyan

if ($missingDirs.Count -eq 0 -and $missingFiles.Count -eq 0 -and (-not (Test-Path $webConfigPath) -or $missingConfigs.Count -eq 0) -and (-not (Test-Path $gitignorePath) -or $missingEntries.Count -eq 0)) {
    Write-ColorMessage "✓ Le dépôt est propre et organisé" -Color Green
    Write-ColorMessage "✓ Le site peut être déployé correctement sur IIS" -Color Green
    Write-ColorMessage ""
    Write-ColorMessage "Félicitations ! Le dépôt Malvinaland est prêt pour le déploiement." -Color Green
} else {
    Write-ColorMessage "✗ Le dépôt présente des problèmes qui doivent être corrigés" -Color Red
    Write-ColorMessage ""
    Write-ColorMessage "Veuillez corriger les problèmes signalés avant de déployer le site." -Color Red
}