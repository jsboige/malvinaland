<#
.SYNOPSIS
    Script de vérification de l'état du dépôt Git de Malvinaland.

.DESCRIPTION
    Ce script effectue une série de vérifications pour s'assurer que le dépôt Git de Malvinaland
    est en bon état après le nettoyage et l'organisation. Il vérifie la présence des fichiers essentiels,
    détecte les doublons et fichiers obsolètes, vérifie les références dans les fichiers HTML,
    s'assure que le site peut être généré et déployé correctement, et vérifie que la documentation est à jour.

.PARAMETER OutputFile
    Chemin du fichier de sortie pour le rapport. Par défaut: "rapport-sante-depot.html"

.PARAMETER Verbose
    Affiche des informations détaillées pendant l'exécution.

.PARAMETER FixIssues
    Tente de résoudre automatiquement certains problèmes détectés.

.PARAMETER OpenReport
    Ouvre automatiquement le rapport HTML dans le navigateur par défaut après sa génération.

.EXAMPLE
    .\verify-repository-health.ps1
    Exécute la vérification et génère un rapport dans le fichier par défaut.

.EXAMPLE
    .\verify-repository-health.ps1 -OutputFile "mon-rapport.html" -Verbose
    Exécute la vérification avec des messages détaillés et génère un rapport dans "mon-rapport.html".

.EXAMPLE
    .\verify-repository-health.ps1 -FixIssues
    Exécute la vérification et tente de résoudre automatiquement certains problèmes détectés.

.EXAMPLE
    .\verify-repository-health.ps1 -OpenReport
    Exécute la vérification et ouvre automatiquement le rapport HTML dans le navigateur par défaut.

.NOTES
    Auteur: Équipe Malvinaland
    Date de création: 21/05/2025
    Version: 1.0
#>

[CmdletBinding()]
param (
    [string]$OutputFile = "rapport-sante-depot.html",
    [switch]$FixIssues,
    [switch]$OpenReport
)

#region Fonctions utilitaires

function Write-ColorOutput {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        
        [Parameter(Mandatory = $false)]
        [string]$ForegroundColor = "White"
    )
    
    $originalColor = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Message
    $host.UI.RawUI.ForegroundColor = $originalColor
}

function Test-CommandExists {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Command
    )
    
    $exists = $null -ne (Get-Command -Name $Command -ErrorAction SilentlyContinue)
    return $exists
}

function Get-RelativePath {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )
    
    $rootPath = (Get-Location).Path
    $relativePath = $Path.Replace($rootPath, "").TrimStart("\")
    return $relativePath
}

function Get-FileHash {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )
    
    try {
        $fileContent = Get-Content -Path $FilePath -Raw -ErrorAction Stop
        $hashAlgorithm = [System.Security.Cryptography.SHA256]::Create()
        $contentBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)
        $hashBytes = $hashAlgorithm.ComputeHash($contentBytes)
        $hash = [System.BitConverter]::ToString($hashBytes) -replace '-', ''
        return $hash
    }
    catch {
        return "ERROR_COMPUTING_HASH"
    }
}

function Test-GitRepository {
    $gitDir = Join-Path -Path (Get-Location) -ChildPath ".git"
    return Test-Path -Path $gitDir -PathType Container
}
#endregion

#region Variables globales

# Structure pour stocker les résultats des vérifications
$script:HealthReport = @{
    StartTime = Get-Date
    EndTime = $null
    Summary = @{
        TotalIssues = 0
        CriticalIssues = 0
        WarningIssues = 0
        InfoIssues = 0
    }
    Sections = @()
}

# Définition des fichiers et dossiers essentiels
$essentialFiles = @(
    ".eleventy.js",
    "package.json",
    "index.html",
    "manifest.json",
    "service-worker.js",
    "src/_includes/layouts/base.njk",
    "src/_includes/layouts/monde.njk",
    "src/_includes/layouts/organisateur.njk",
    "src/_data/mondes.js",
    "src/_data/site.js",
    "src/assets/css/main.css",
    "src/assets/js/navigation.js",
    "src/content/index.md"
)

$essentialDirectories = @(
    "src",
    "src/_includes",
    "src/_data",
    "src/assets",
    "src/content",
    "src/content/mondes",
    "scripts"
)

# Définition des extensions de fichiers à vérifier pour les références
$fileExtensionsToCheck = @("*.html", "*.md", "*.njk", "*.js", "*.css")

# Définition des motifs de fichiers obsolètes
$obsoletePatterns = @(
    "*.bak",
    "*.tmp",
    "*-old.*",
    "*-backup.*",
    "*.old",
    "*.obsolete"
)

#endregion

#region Fonctions de vérification

function Add-ReportSection {
    param (
        [string]$Title,
        [string]$Description,
        [array]$Issues = @(),
        [array]$Recommendations = @()
    )
    
    $section = @{
        Title = $Title
        Description = $Description
        Issues = $Issues
        Recommendations = $Recommendations
        IssueCount = $Issues.Count
        HasCriticalIssues = ($Issues | Where-Object { $_.Severity -eq "Critical" }).Count -gt 0
    }
    
    $script:HealthReport.Sections += $section
    
    # Mettre à jour le résumé
    $script:HealthReport.Summary.TotalIssues += $Issues.Count
    $script:HealthReport.Summary.CriticalIssues += ($Issues | Where-Object { $_.Severity -eq "Critical" }).Count
    $script:HealthReport.Summary.WarningIssues += ($Issues | Where-Object { $_.Severity -eq "Warning" }).Count
    $script:HealthReport.Summary.InfoIssues += ($Issues | Where-Object { $_.Severity -eq "Info" }).Count
}

function Add-Issue {
    param (
        [string]$Title,
        [string]$Description,
        [string]$Severity = "Warning", # Critical, Warning, Info
        [string]$FilePath = "",
        [string]$Solution = ""
    )
    
    $issue = @{
        Title = $Title
        Description = $Description
        Severity = $Severity
        FilePath = $FilePath
        Solution = $Solution
    }
    
    return $issue
}
function Test-EssentialFiles {
    Write-ColorOutput "Vérification des fichiers essentiels..." -ForegroundColor Cyan
    
    $issues = @()
    
    foreach ($file in $essentialFiles) {
        $filePath = Join-Path -Path (Get-Location) -ChildPath $file
        if (-not (Test-Path -Path $filePath -PathType Leaf)) {
            $issues += Add-Issue -Title "Fichier essentiel manquant" `
                -Description "Le fichier essentiel '$file' est manquant." `
                -Severity "Critical" `
                -FilePath $file `
                -Solution "Restaurer le fichier à partir d'une sauvegarde ou du dépôt Git."
        }
        else {
            Write-Verbose "Fichier essentiel trouvé: $file"
        }
    }
    
    foreach ($dir in $essentialDirectories) {
        $dirPath = Join-Path -Path (Get-Location) -ChildPath $dir
        if (-not (Test-Path -Path $dirPath -PathType Container)) {
            $issues += Add-Issue -Title "Répertoire essentiel manquant" `
                -Description "Le répertoire essentiel '$dir' est manquant." `
                -Severity "Critical" `
                -FilePath $dir `
                -Solution "Restaurer le répertoire à partir d'une sauvegarde ou du dépôt Git."
        }
        else {
            Write-Verbose "Répertoire essentiel trouvé: $dir"
        }
    }
    
    $recommendations = @(
        "Assurez-vous que tous les fichiers essentiels sont présents dans le dépôt.",
        "Utilisez Git pour restaurer les fichiers manquants: git checkout -- <chemin-du-fichier>",
        "Si des fichiers sont intentionnellement supprimés, mettez à jour la liste des fichiers essentiels dans ce script."
    )
    
    Add-ReportSection -Title "Fichiers Essentiels" `
        -Description "Vérification de la présence des fichiers et répertoires essentiels au fonctionnement du site." `
        -Issues $issues `
        -Recommendations $recommendations
}

function Test-DuplicateFiles {
    Write-ColorOutput "Recherche de fichiers en double..." -ForegroundColor Cyan
    
    $issues = @()
    $fileHashes = @{}
    
    # Exclure les répertoires node_modules et .git
    $excludedDirs = @("node_modules", ".git", "backup-before-cleanup")
    
    # Obtenir tous les fichiers (sauf dans les répertoires exclus)
    $allFiles = Get-ChildItem -Path (Get-Location) -Recurse -File | 
        Where-Object { 
            $exclude = $false
            foreach ($dir in $excludedDirs) {
                if ($_.FullName -like "*\$dir\*") {
                    $exclude = $true
                    break
                }
            }
            -not $exclude
        }
    
    $totalFiles = $allFiles.Count
    $processedFiles = 0
    
    foreach ($file in $allFiles) {
        $processedFiles++
        if ($processedFiles % 100 -eq 0) {
            Write-Progress -Activity "Analyse des fichiers en double" -Status "Traitement des fichiers" -PercentComplete (($processedFiles / $totalFiles) * 100)
        }
        
        # Ignorer les fichiers binaires et les fichiers trop volumineux
        if ($file.Length -gt 5MB -or $file.Extension -in @(".jpg", ".jpeg", ".png", ".gif", ".ico", ".pdf", ".zip", ".rar")) {
            continue
        }
        
        $hash = Get-FileHash -FilePath $file.FullName
        $relativePath = Get-RelativePath -Path $file.FullName
        
        if ($hash -ne "ERROR_COMPUTING_HASH") {
            if ($fileHashes.ContainsKey($hash)) {
                $existingFile = $fileHashes[$hash]
                $issues += Add-Issue -Title "Fichier en double détecté" `
                    -Description "Le fichier '$relativePath' est identique à '$existingFile'." `
                    -Severity "Warning" `
                    -FilePath $relativePath `
                    -Solution "Examiner les fichiers et supprimer les doublons si nécessaire."
            }
            else {
                $fileHashes[$hash] = $relativePath
            }
        }
    }
    
    Write-Progress -Activity "Analyse des fichiers en double" -Completed
    
    # Recherche de fichiers obsolètes
    Write-ColorOutput "Recherche de fichiers obsolètes..." -ForegroundColor Cyan
    
    foreach ($pattern in $obsoletePatterns) {
        $obsoleteFiles = Get-ChildItem -Path (Get-Location) -Recurse -File -Filter $pattern | 
            Where-Object { 
                $exclude = $false
                foreach ($dir in $excludedDirs) {
                    if ($_.FullName -like "*\$dir\*") {
                        $exclude = $true
                        break
                    }
                }
                -not $exclude
            }
        
        foreach ($file in $obsoleteFiles) {
            $relativePath = Get-RelativePath -Path $file.FullName
            $issues += Add-Issue -Title "Fichier potentiellement obsolète" `
                -Description "Le fichier '$relativePath' correspond à un motif de fichier obsolète ($pattern)." `
                -Severity "Info" `
                -FilePath $relativePath `
                -Solution "Examiner le fichier et le supprimer s'il n'est plus nécessaire."
        }
    }
    
    $recommendations = @(
        "Examinez les fichiers en double et déterminez lesquels conserver.",
        "Supprimez les fichiers obsolètes qui ne sont plus nécessaires.",
        "Utilisez Git pour suivre les modifications et éviter de créer des copies de sauvegarde manuelles."
    )
    
    Add-ReportSection -Title "Fichiers en Double et Obsolètes" `
        -Description "Détection des fichiers en double et des fichiers potentiellement obsolètes." `
        -Issues $issues `
        -Recommendations $recommendations
}
function Test-HtmlReferences {
    Write-ColorOutput "Vérification des références dans les fichiers HTML..." -ForegroundColor Cyan
    
    $issues = @()
    
    # Obtenir tous les fichiers HTML, MD, NJK, JS et CSS
    $filesToCheck = @()
    foreach ($ext in $fileExtensionsToCheck) {
        $filesToCheck += Get-ChildItem -Path (Get-Location) -Recurse -File -Filter $ext | 
            Where-Object { $_.FullName -notlike "*\node_modules\*" -and $_.FullName -notlike "*\.git\*" }
    }
    
    # Collecter tous les fichiers existants pour vérifier les références
    $allFiles = Get-ChildItem -Path (Get-Location) -Recurse -File | 
        Where-Object { $_.FullName -notlike "*\node_modules\*" -and $_.FullName -notlike "*\.git\*" }
    
    $allFilePaths = @{}
    foreach ($file in $allFiles) {
        $relativePath = Get-RelativePath -Path $file.FullName
        $allFilePaths[$relativePath] = $true
        # Ajouter également des chemins avec des barres obliques avant
        $allFilePaths["/$relativePath"] = $true
    }
    
    # Modèles regex pour trouver les références
    $regexPatterns = @(
        # Liens HTML
        '(?:href|src)=["'']([^"'']+\.(?:html|css|js|jpg|jpeg|png|gif|svg|ico|pdf|md))["'']',
        # Importations CSS
        '@import\s+[''"]([^"'']+\.css)[''"]',
        # Importations JavaScript
        'import\s+.*?from\s+[''"]([^"'']+\.js)[''"]',
        # Références d'images dans Markdown
        '!\[.*?\]\(([^)]+\.(?:jpg|jpeg|png|gif|svg))\)',
        # Liens dans Markdown
        '\[.*?\]\(([^)]+\.(?:html|md))\)'
    )
    
    foreach ($file in $filesToCheck) {
        $relativePath = Get-RelativePath -Path $file.FullName
        $content = Get-Content -Path $file.FullName -Raw
        
        foreach ($pattern in $regexPatterns) {
            $matches = [regex]::Matches($content, $pattern)
            
            foreach ($match in $matches) {
                $reference = $match.Groups[1].Value
                
                # Ignorer les URLs externes et les ancres
                if ($reference -like "http*://*" -or $reference -like "#*") {
                    continue
                }
                
                # Normaliser le chemin de référence
                $normalizedRef = $reference -replace '\\', '/'
                
                # Gérer les chemins relatifs
                if (-not ($normalizedRef -like "/*")) {
                    $fileDir = Split-Path -Parent $file.FullName
                    $refPath = Join-Path -Path $fileDir -ChildPath $normalizedRef
                    $refPath = [System.IO.Path]::GetFullPath($refPath)
                    $normalizedRef = Get-RelativePath -Path $refPath
                }
                else {
                    # Supprimer le slash initial pour la comparaison
                    $normalizedRef = $normalizedRef.TrimStart('/')
                }
                
                # Vérifier si le fichier référencé existe
                if (-not $allFilePaths.ContainsKey($normalizedRef) -and -not $allFilePaths.ContainsKey("/$normalizedRef")) {
                    $issues += Add-Issue -Title "Référence cassée" `
                        -Description "Dans le fichier '$relativePath', la référence à '$reference' est cassée." `
                        -Severity "Warning" `
                        -FilePath $relativePath `
                        -Solution "Corriger la référence ou ajouter le fichier manquant."
                }
            }
        }
    }
    
    $recommendations = @(
        "Corrigez les références cassées en mettant à jour les chemins ou en ajoutant les fichiers manquants.",
        "Utilisez des chemins relatifs cohérents dans tout le projet.",
        "Considérez l'utilisation d'un outil de vérification de liens comme 'broken-link-checker' pour une analyse plus approfondie."
    )
    
    Add-ReportSection -Title "Références HTML" `
        -Description "Vérification des références (liens, images, scripts, styles) dans les fichiers HTML, Markdown et autres." `
        -Issues $issues `
        -Recommendations $recommendations
}

function Test-SiteGeneration {
    Write-ColorOutput "Vérification de la génération du site..." -ForegroundColor Cyan
    
    $issues = @()
    
    # Vérifier si npm est installé
    if (-not (Test-CommandExists -Command "npm")) {
        $issues += Add-Issue -Title "npm non installé" `
            -Description "npm n'est pas installé ou n'est pas dans le PATH, impossible de vérifier la génération du site." `
            -Severity "Critical" `
            -Solution "Installer Node.js et npm depuis https://nodejs.org/"
        
        Add-ReportSection -Title "Génération du Site" `
            -Description "Vérification de la capacité à générer le site correctement." `
            -Issues $issues `
            -Recommendations @("Installer Node.js et npm pour permettre la génération du site.")
        
        return
    }
    
    # Vérifier si package.json existe et contient les scripts nécessaires
    if (-not (Test-Path -Path "package.json" -PathType Leaf)) {
        $issues += Add-Issue -Title "package.json manquant" `
            -Description "Le fichier package.json est manquant, impossible de vérifier la génération du site." `
            -Severity "Critical" `
            -Solution "Restaurer le fichier package.json à partir d'une sauvegarde ou du dépôt Git."
    }
    else {
        try {
            $packageJson = Get-Content -Path "package.json" -Raw | ConvertFrom-Json
            
            # Vérifier si les scripts nécessaires existent
            $requiredScripts = @("build", "start")
            foreach ($script in $requiredScripts) {
                if (-not $packageJson.scripts.$script) {
                    $issues += Add-Issue -Title "Script npm manquant" `
                        -Description "Le script '$script' est manquant dans package.json." `
                        -Severity "Warning" `
                        -FilePath "package.json" `
                        -Solution "Ajouter le script '$script' dans package.json."
                }
            }
            
            # Vérifier les dépendances
            $requiredDependencies = @("@11ty/eleventy")
            foreach ($dep in $requiredDependencies) {
                if (-not $packageJson.dependencies.$dep -and -not $packageJson.devDependencies.$dep) {
                    $issues += Add-Issue -Title "Dépendance manquante" `
                        -Description "La dépendance '$dep' est manquante dans package.json." `
                        -Severity "Warning" `
                        -FilePath "package.json" `
                        -Solution "Ajouter la dépendance en exécutant 'npm install $dep --save-dev'."
                }
            }
        }
        catch {
            $issues += Add-Issue -Title "Erreur de parsing de package.json" `
                -Description "Impossible de parser le fichier package.json: $_" `
                -Severity "Critical" `
                -FilePath "package.json" `
                -Solution "Corriger le format du fichier package.json."
        }
    }
    
    # Vérifier si node_modules existe
    if (-not (Test-Path -Path "node_modules" -PathType Container)) {
        $issues += Add-Issue -Title "node_modules manquant" `
            -Description "Le répertoire node_modules est manquant, les dépendances ne sont pas installées." `
            -Severity "Warning" `
            -Solution "Exécuter 'npm install' pour installer les dépendances."
    }
    
    # Vérifier si .eleventy.js existe et est valide
    if (-not (Test-Path -Path ".eleventy.js" -PathType Leaf)) {
        $issues += Add-Issue -Title ".eleventy.js manquant" `
            -Description "Le fichier de configuration .eleventy.js est manquant." `
            -Severity "Critical" `
            -Solution "Restaurer le fichier .eleventy.js à partir d'une sauvegarde ou du dépôt Git."
    }
    
    # Si l'option FixIssues est activée et qu'il n'y a pas de problèmes critiques, tenter de générer le site
    if ($FixIssues -and ($issues | Where-Object { $_.Severity -eq "Critical" }).Count -eq 0) {
        Write-ColorOutput "Tentative d'installation des dépendances..." -ForegroundColor Yellow
        
        try {
            $output = npm install 2>&1
            if ($LASTEXITCODE -ne 0) {
                $issues += Add-Issue -Title "Échec de l'installation des dépendances" `
                    -Description "L'exécution de 'npm install' a échoué: $output" `
                    -Severity "Critical" `
                    -Solution "Résoudre les problèmes d'installation des dépendances manuellement."
            }
            else {
                Write-ColorOutput "Dépendances installées avec succès." -ForegroundColor Green
                
                Write-ColorOutput "Tentative de génération du site..." -ForegroundColor Yellow
                
                $output = npm run build 2>&1
                if ($LASTEXITCODE -ne 0) {
                    $issues += Add-Issue -Title "Échec de la génération du site" `
                        -Description "L'exécution de 'npm run build' a échoué: $output" `
                        -Severity "Critical" `
                        -Solution "Résoudre les problèmes de génération du site manuellement."
                }
                else {
                    Write-ColorOutput "Site généré avec succès." -ForegroundColor Green
                }
            }
        }
        catch {
            $issues += Add-Issue -Title "Erreur lors de l'exécution des commandes npm" `
                -Description "Une erreur s'est produite lors de l'exécution des commandes npm: $_" `
                -Severity "Critical" `
                -Solution "Vérifier l'installation de Node.js et npm."
        }
    }
    
    $recommendations = @(
        "Assurez-vous que toutes les dépendances sont correctement installées avec 'npm install'.",
        "Vérifiez que les scripts de build et de démarrage sont correctement configurés dans package.json.",
        "Exécutez 'npm run build' pour générer le site et vérifier qu'il n'y a pas d'erreurs."
    )
    
    Add-ReportSection -Title "Génération du Site" `
        -Description "Vérification de la capacité à générer le site correctement." `
        -Issues $issues `
        -Recommendations $recommendations
}
function Test-Documentation {
    Write-ColorOutput "Vérification de la documentation..." -ForegroundColor Cyan
    
    $issues = @()
    
    # Liste des fichiers de documentation à vérifier
    $docFiles = @(
        "README.md",
        "GUIDE_MAINTENANCE.md",
        "GUIDE_PNJ.md",
        "COMMENT_MODIFIER.md",
        "JOURNAL_MODIFICATIONS.md",
        "MOBILE_EXPERIENCE.md"
    )
    
    foreach ($file in $docFiles) {
        if (-not (Test-Path -Path $file -PathType Leaf)) {
            $issues += Add-Issue -Title "Fichier de documentation manquant" `
                -Description "Le fichier de documentation '$file' est manquant." `
                -Severity "Info" `
                -FilePath $file `
                -Solution "Créer le fichier de documentation manquant."
            continue
        }
        
        $content = Get-Content -Path $file -Raw
        
        # Vérifier si le fichier est vide ou presque vide
        if ([string]::IsNullOrWhiteSpace($content) -or $content.Length -lt 100) {
            $issues += Add-Issue -Title "Documentation insuffisante" `
                -Description "Le fichier de documentation '$file' est vide ou contient très peu d'informations." `
                -Severity "Warning" `
                -FilePath $file `
                -Solution "Compléter la documentation avec des informations pertinentes."
        }
        
        # Vérifier la date de dernière modification
        $lastModified = (Get-Item -Path $file).LastWriteTime
        $daysSinceModified = (Get-Date) - $lastModified
        
        if ($daysSinceModified.Days -gt 90) {
            $issues += Add-Issue -Title "Documentation potentiellement obsolète" `
                -Description "Le fichier de documentation '$file' n'a pas été mis à jour depuis $($daysSinceModified.Days) jours." `
                -Severity "Info" `
                -FilePath $file `
                -Solution "Réviser et mettre à jour la documentation si nécessaire."
        }
        
        # Vérifier les références à des fichiers ou répertoires
        $fileReferences = [regex]::Matches($content, '`([^`]+\.[a-zA-Z0-9]+)`|"([^"]+\.[a-zA-Z0-9]+)"|\'([^\']+\.[a-zA-Z0-9]+)\'')
        
        foreach ($match in $fileReferences) {
            $reference = $match.Groups[1].Value
            if ([string]::IsNullOrEmpty($reference)) {
                $reference = $match.Groups[2].Value
            }
            if ([string]::IsNullOrEmpty($reference)) {
                $reference = $match.Groups[3].Value
            }
            
            # Ignorer les références qui ne semblent pas être des chemins de fichiers
            if ($reference -like "http*://*" -or $reference -like "#*" -or $reference.Length -lt 3) {
                continue
            }
            
            # Vérifier si le fichier référencé existe
            if (-not (Test-Path -Path $reference -PathType Leaf) -and -not (Test-Path -Path $reference -PathType Container)) {
                $issues += Add-Issue -Title "Référence à un fichier inexistant dans la documentation" `
                    -Description "Dans le fichier '$file', référence à '$reference' qui n'existe pas." `
                    -Severity "Info" `
                    -FilePath $file `
                    -Solution "Mettre à jour la référence ou créer le fichier manquant."
            }
        }
    }
    
    # Vérifier si les fichiers README.md existent dans les sous-répertoires importants
    $importantDirs = @(
        "src",
        "scripts",
        "site",
        "ressources"
    )
    
    foreach ($dir in $importantDirs) {
        if (Test-Path -Path $dir -PathType Container) {
            $readmePath = Join-Path -Path $dir -ChildPath "README.md"
            if (-not (Test-Path -Path $readmePath -PathType Leaf)) {
                $issues += Add-Issue -Title "README.md manquant dans un répertoire important" `
                    -Description "Le fichier README.md est manquant dans le répertoire '$dir'." `
                    -Severity "Info" `
                    -FilePath "$dir/README.md" `
                    -Solution "Créer un fichier README.md pour documenter le contenu et l'utilisation du répertoire."
            }
        }
    }
    
    $recommendations = @(
        "Assurez-vous que tous les fichiers de documentation sont à jour et contiennent des informations pertinentes.",
        "Créez des fichiers README.md dans tous les répertoires importants pour documenter leur contenu et leur utilisation.",
        "Mettez à jour régulièrement la documentation pour refléter les changements dans le projet."
    )
    
    Add-ReportSection -Title "Documentation" `
        -Description "Vérification de la présence et de la qualité de la documentation." `
        -Issues $issues `
        -Recommendations $recommendations
}

function Test-GitRepository {
    Write-ColorOutput "Vérification du dépôt Git..." -ForegroundColor Cyan
    
    $issues = @()
    
    # Vérifier si le répertoire est un dépôt Git
    if (-not (Test-Path -Path ".git" -PathType Container)) {
        $issues += Add-Issue -Title "Pas un dépôt Git" `
            -Description "Le répertoire courant n'est pas un dépôt Git." `
            -Severity "Critical" `
            -Solution "Initialiser un dépôt Git avec 'git init' ou cloner le dépôt existant."
        
        Add-ReportSection -Title "Dépôt Git" `
            -Description "Vérification de l'état du dépôt Git." `
            -Issues $issues `
            -Recommendations @("Initialiser un dépôt Git pour suivre les modifications.")
        
        return
    }
    
    # Vérifier s'il y a des modifications non commitées
    try {
        $status = git status --porcelain
        if ($status) {
            $issues += Add-Issue -Title "Modifications non commitées" `
                -Description "Il y a des modifications non commitées dans le dépôt." `
                -Severity "Warning" `
                -Solution "Commiter les modifications ou les ignorer avec .gitignore."
        }
        
        # Vérifier s'il y a des fichiers non suivis
        $untrackedFiles = git ls-files --others --exclude-standard
        if ($untrackedFiles) {
            $issues += Add-Issue -Title "Fichiers non suivis" `
                -Description "Il y a des fichiers non suivis dans le dépôt." `
                -Severity "Info" `
                -Solution "Ajouter les fichiers avec 'git add' ou les ignorer avec .gitignore."
        }
        
        # Vérifier si .gitignore existe
        if (-not (Test-Path -Path ".gitignore" -PathType Leaf)) {
            $issues += Add-Issue -Title ".gitignore manquant" `
                -Description "Le fichier .gitignore est manquant." `
                -Severity "Warning" `
                -FilePath ".gitignore" `
                -Solution "Créer un fichier .gitignore pour ignorer les fichiers générés et temporaires."
        }
    }
    catch {
        $issues += Add-Issue -Title "Erreur lors de la vérification du dépôt Git" `
            -Description "Une erreur s'est produite lors de la vérification du dépôt Git: $_" `
            -Severity "Critical" `
            -Solution "Vérifier l'installation de Git et l'état du dépôt manuellement."
    }
    
    $recommendations = @(
        "Commiter régulièrement les modifications pour suivre l'évolution du projet.",
        "Utiliser des branches pour développer de nouvelles fonctionnalités sans affecter la branche principale.",
        "Configurer un fichier .gitignore pour éviter de suivre les fichiers générés et temporaires."
    )
    
    Add-ReportSection -Title "Dépôt Git" `
        -Description "Vérification de l'état du dépôt Git." `
        -Issues $issues `
        -Recommendations $recommendations
}

#endregion

#region Génération du rapport HTML

function Generate-HtmlReport {
    param (
        [string]$OutputFile
    )
    
    $html = @"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rapport de Santé du Dépôt Malvinaland</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        h1, h2, h3 {
            color: #2c3e50;
        }
        .summary {
            background-color: #f8f9fa;
            border-left: 4px solid #4CAF50;
            padding: 15px;
            margin-bottom: 20px;
        }
        .critical {
            color: #fff;
            background-color: #dc3545;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 0.8em;
        }
        .warning {
            color: #212529;
            background-color: #ffc107;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 0.8em;
        }
        .info {
            color: #fff;
            background-color: #17a2b8;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 0.8em;
        }
        .section {
            margin-bottom: 30px;
            border: 1px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
        }
        .section-header {
            padding: 10px 15px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .section-header h2 {
            margin: 0;
        }
        .section-content {
            padding: 15px;
        }
        .issue {
            margin-bottom: 15px;
            padding: 10px;
            border-left: 4px solid #ddd;
        }
        .issue.critical {
            border-left-color: #dc3545;
            background-color: rgba(220, 53, 69, 0.1);
            color: #333;
        }
        .issue.warning {
            border-left-color: #ffc107;
            background-color: rgba(255, 193, 7, 0.1);
            color: #333;
        }
        .issue.info {
            border-left-color: #17a2b8;
            background-color: rgba(23, 162, 184, 0.1);
            color: #333;
        }
        .issue h3 {
            margin-top: 0;
            display: flex;
            justify-content: space-between;
        }
        .issue-badge {
            font-weight: normal;
        }
        .recommendations {
            background-color: #f8f9fa;
            padding: 15px;
            margin-top: 20px;
            border-left: 4px solid #007bff;
        }
        .recommendations h3 {
            margin-top: 0;
            color: #007bff;
        }
        .recommendations ul {
            margin-bottom: 0;
        }
        .no-issues {
            color: #28a745;
            font-weight: bold;
        }
        .timestamp {
            color: #6c757d;
            font-size: 0.9em;
            margin-bottom: 20px;
        }
        .solution {
            background-color: #e9ecef;
            padding: 10px;
            margin-top: 10px;
            border-radius: 4px;
        }
        .solution strong {
            color: #28a745;
        }
        .file-path {
            font-family: monospace;
            background-color: #f8f9fa;
            padding: 2px 4px;
            border-radius: 2px;
        }
        .badge-count {
            display: inline-block;
            padding: 3px 7px;
            font-size: 12px;
            font-weight: 700;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 10px;
            background-color: #6c757d;
            color: #fff;
        }
        .badge-count.critical {
            background-color: #dc3545;
        }
        .badge-count.warning {
            background-color: #ffc107;
            color: #212529;
        }
        .badge-count.info {
            background-color: #17a2b8;
        }
        .collapsible {
            cursor: pointer;
        }
        .section-content {
            display: block;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <h1>Rapport de Santé du Dépôt Malvinaland</h1>
    <div class="timestamp">
        Généré le $(Get-Date -Format "dd/MM/yyyy à HH:mm:ss")
    </div>
    
    <div class="summary">
        <h2>Résumé</h2>
        <p>
            <strong>Problèmes détectés:</strong> $($script:HealthReport.Summary.TotalIssues) 
            (<span class="critical">$($script:HealthReport.Summary.CriticalIssues) critiques</span>, 
            <span class="warning">$($script:HealthReport.Summary.WarningIssues) avertissements</span>, 
            <span class="info">$($script:HealthReport.Summary.InfoIssues) informations</span>)
        </p>
        <p>
            <strong>État général:</strong> 
"@

    # Déterminer l'état général en fonction du nombre de problèmes critiques
    if ($script:HealthReport.Summary.CriticalIssues -gt 0) {
        $html += "<span style='color: #dc3545; font-weight: bold;'>Critique - Des problèmes majeurs nécessitent une attention immédiate</span>"
    }
    elseif ($script:HealthReport.Summary.WarningIssues -gt 0) {
        $html += "<span style='color: #ffc107; font-weight: bold;'>Attention - Des problèmes mineurs ont été détectés</span>"
    }
    elseif ($script:HealthReport.Summary.TotalIssues -gt 0) {
        $html += "<span style='color: #17a2b8; font-weight: bold;'>Bon - Quelques points d'information à considérer</span>"
    }
    else {
        $html += "<span style='color: #28a745; font-weight: bold;'>Excellent - Aucun problème détecté</span>"
    }

    $html += @"
        </p>
    </div>
    
    <script>
        function toggleSection(sectionId) {
            var content = document.getElementById(sectionId);
            if (content.classList.contains('hidden')) {
                content.classList.remove('hidden');
            } else {
                content.classList.add('hidden');
            }
        }
    </script>
"@

    # Générer le contenu pour chaque section
    for ($i = 0; $i -lt $script:HealthReport.Sections.Count; $i++) {
        $section = $script:HealthReport.Sections[$i]
        $sectionId = "section-$i"
        
        $html += @"
    <div class="section">
        <div class="section-header collapsible" onclick="toggleSection('$sectionId')">
            <h2>$($section.Title)</h2>
            <div>
"@

        # Ajouter des badges pour le nombre de problèmes par sévérité
        $criticalCount = ($section.Issues | Where-Object { $_.Severity -eq "Critical" }).Count
        $warningCount = ($section.Issues | Where-Object { $_.Severity -eq "Warning" }).Count
        $infoCount = ($section.Issues | Where-Object { $_.Severity -eq "Info" }).Count
        
        if ($criticalCount -gt 0) {
            $html += "<span class='badge-count critical'>$criticalCount</span> "
        }
        if ($warningCount -gt 0) {
            $html += "<span class='badge-count warning'>$warningCount</span> "
        }
        if ($infoCount -gt 0) {
            $html += "<span class='badge-count info'>$infoCount</span> "
        }
        
        $html += @"
            </div>
        </div>
        <div id="$sectionId" class="section-content">
            <p>$($section.Description)</p>
"@

        if ($section.Issues.Count -eq 0) {
            $html += "<p class='no-issues'>Aucun problème détecté.</p>"
        }
        else {
            foreach ($issue in $section.Issues) {
                $html += @"
            <div class="issue $($issue.Severity.ToLower())">
                <h3>
                    $($issue.Title)
                    <span class="issue-badge $($issue.Severity.ToLower())">$($issue.Severity)</span>
                </h3>
                <p>$($issue.Description)</p>
"@

                if ($issue.FilePath) {
                    $html += "<p>Fichier: <span class='file-path'>$($issue.FilePath)</span></p>"
                }
                
                if ($issue.Solution) {
                    $html += "<div class='solution'><strong>Solution:</strong> $($issue.Solution)</div>"
                }
                
                $html += "</div>"
            }
        }
        
        if ($section.Recommendations.Count -gt 0) {
            $html += @"
            <div class="recommendations">
                <h3>Recommandations</h3>
                <ul>
"@
            
            foreach ($recommendation in $section.Recommendations) {
                $html += "                <li>$recommendation</li>`n"
            }
            
            $html += @"
                </ul>
            </div>
"@
        }
        
        $html += @"
        </div>
    </div>
"@
    }
    
    $html += @"
</body>
</html>
"@
    
    $html | Out-File -FilePath $OutputFile -Encoding UTF8
    
    return $OutputFile
}

#endregion

#region Exécution principale

# Afficher un message de bienvenue
Write-ColorOutput "=== Vérification de l'état du dépôt Git de Malvinaland ===" -ForegroundColor Green
Write-ColorOutput "Date: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" -ForegroundColor Green
Write-ColorOutput "Répertoire: $(Get-Location)" -ForegroundColor Green
Write-ColorOutput "Fichier de rapport: $OutputFile" -ForegroundColor Green
Write-ColorOutput "Mode de correction: $($FixIssues -eq $true ? 'Activé' : 'Désactivé')" -ForegroundColor Green
Write-ColorOutput "=================================================" -ForegroundColor Green

# Exécuter les vérifications
Test-EssentialFiles
Test-DuplicateFiles
Test-HtmlReferences
Test-SiteGeneration
Test-Documentation
Test-GitRepository

# Mettre à jour l'heure de fin
$script:HealthReport.EndTime = Get-Date

# Générer le rapport HTML
$reportPath = Generate-HtmlReport -OutputFile $OutputFile

# Afficher un résumé
Write-ColorOutput "`nRésumé des problèmes détectés:" -ForegroundColor Yellow
Write-ColorOutput "- Total: $($script:HealthReport.Summary.TotalIssues)" -ForegroundColor White
Write-ColorOutput "- Critiques: $($script:HealthReport.Summary.CriticalIssues)" -ForegroundColor Red
Write-ColorOutput "- Avertissements: $($script:HealthReport.Summary.WarningIssues)" -ForegroundColor Yellow
Write-ColorOutput "- Informations: $($script:HealthReport.Summary.InfoIssues)" -ForegroundColor Cyan

Write-ColorOutput "`nRapport généré: $reportPath" -ForegroundColor Green

# Ouvrir le rapport dans le navigateur par défaut si demandé
if ($OpenReport) {
    Start-Process $reportPath
}

#endregion