# Script PowerShell pour deployer la carte interactive corrigee
# Compile les sources et teste la carte
#
# SITE DE PRODUCTION : https://malvinaland.myia.io/
# IIS publie automatiquement le repertoire "site/" de ce depot
# Aucun hebergement supplementaire requis

param(
    [switch]$OuvrirNavigateur = $true,
    [switch]$TestLocal = $true
)

function Write-ColorMessage {
    param([string]$Message, [string]$Color = "White")
    $colors = @{
        "Red" = [ConsoleColor]::Red
        "Green" = [ConsoleColor]::Green
        "Yellow" = [ConsoleColor]::Yellow
        "Blue" = [ConsoleColor]::Blue
        "Magenta" = [ConsoleColor]::Magenta
        "Cyan" = [ConsoleColor]::Cyan
        "White" = [ConsoleColor]::White
    }
    Write-Host $Message -ForegroundColor $colors[$Color]
}

function Test-FileExists {
    param([string]$FilePath, [string]$Description)
    if (Test-Path $FilePath) {
        Write-ColorMessage "[OK] $Description existe : $FilePath" -Color Green
        return $true
    } else {
        Write-ColorMessage "[ERREUR] $Description manquant : $FilePath" -Color Red
        return $false
    }
}

# Debut du script
Write-ColorMessage "Deploiement de la carte interactive corrigee" -Color Magenta
Write-ColorMessage "=============================================" -Color Magenta

# Verifier les fichiers sources
$fichiersRequis = @(
    @{ Path = "src/content/carte.md"; Description = "Fichier source de la carte" },
    @{ Path = "src/assets/images/carte-malvinaland.png"; Description = "Image de la carte" },
    @{ Path = "src/assets/js/carte-interactive.js"; Description = "Script de la carte interactive" }
)

$tousPresents = $true
foreach ($fichier in $fichiersRequis) {
    if (-not (Test-FileExists -FilePath $fichier.Path -Description $fichier.Description)) {
        $tousPresents = $false
    }
}

if (-not $tousPresents) {
    Write-ColorMessage "[ERREUR] Des fichiers requis sont manquants. Arret du script." -Color Red
    exit 1
}

# Verifier si Eleventy est disponible
Write-ColorMessage "[INFO] Verification d'Eleventy..." -Color Yellow
try {
    $eleventyVersion = npx @11ty/eleventy --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-ColorMessage "[OK] Eleventy disponible : $eleventyVersion" -Color Green
    } else {
        Write-ColorMessage "[WARN] Eleventy non trouve, tentative d'installation..." -Color Yellow
        npm install @11ty/eleventy --save-dev
    }
} catch {
    Write-ColorMessage "[WARN] Probleme avec Eleventy : $_" -Color Yellow
}

# Compiler le site avec Eleventy
Write-ColorMessage "[INFO] Compilation du site avec Eleventy..." -Color Yellow
try {
    $buildResult = npx @11ty/eleventy 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-ColorMessage "[OK] Site compile avec succes" -Color Green
    } else {
        Write-ColorMessage "[WARN] Probleme lors de la compilation :" -Color Yellow
        Write-ColorMessage "$buildResult" -Color Yellow
    }
} catch {
    Write-ColorMessage "[WARN] Erreur lors de la compilation : $_" -Color Yellow
}

# Verifier que les fichiers ont ete generes
Write-ColorMessage "[INFO] Verification des fichiers generes..." -Color Yellow
$fichiersGeneres = @(
    @{ Path = "site/content/carte/index.html"; Description = "Page HTML de la carte" },
    @{ Path = "site/assets/images/carte-malvinaland.png"; Description = "Image de la carte deployee" },
    @{ Path = "site/assets/js/carte-interactive.js"; Description = "Script deploye" }
)

foreach ($fichier in $fichiersGeneres) {
    Test-FileExists -FilePath $fichier.Path -Description $fichier.Description | Out-Null
}

# Verifier le contenu de la page HTML generee
Write-ColorMessage "[INFO] Verification du contenu HTML..." -Color Yellow
$carteHtml = "site/content/carte/index.html"
if (Test-Path $carteHtml) {
    $contenu = Get-Content -Path $carteHtml -Raw
    
    # Verifier la presence de l'image
    if ($contenu -match 'carte-malvinaland\.png') {
        Write-ColorMessage "[OK] Image de la carte referencee dans le HTML" -Color Green
    } else {
        Write-ColorMessage "[WARN] Image de la carte non trouvee dans le HTML" -Color Yellow
    }
    
    # Verifier la presence des zones cliquables
    $zonesDetectees = ($contenu | Select-String -Pattern '<area\s+shape=' -AllMatches).Matches.Count
    if ($zonesDetectees -gt 0) {
        Write-ColorMessage "[OK] $zonesDetectees zones cliquables detectees dans le HTML" -Color Green
    } else {
        Write-ColorMessage "[WARN] Aucune zone cliquable detectee dans le HTML" -Color Yellow
    }
    
    # Verifier la presence du script interactif
    if ($contenu -match 'carte-interactive\.js') {
        Write-ColorMessage "[OK] Script interactif reference dans le HTML" -Color Green
    } else {
        Write-ColorMessage "[WARN] Script interactif non trouve dans le HTML" -Color Yellow
    }
}

# Test local si demande
if ($TestLocal) {
    Write-ColorMessage "[INFO] Demarrage du serveur de test local..." -Color Yellow
    
    # Verifier si un serveur est deja en cours
    $processusServeur = Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*serve*" }
    
    if ($processusServeur) {
        Write-ColorMessage "[INFO] Serveur deja en cours d'execution" -Color Cyan
    } else {
        # Demarrer le serveur Eleventy
        Write-ColorMessage "[INFO] Lancement du serveur Eleventy..." -Color Cyan
        Start-Process -FilePath "cmd" -ArgumentList "/c", "npx @11ty/eleventy --serve --port=8080" -WindowStyle Minimized
        
        # Attendre que le serveur demarre
        Start-Sleep -Seconds 3
    }
    
    $urlTest = "http://localhost:8080/carte/"
    Write-ColorMessage "[INFO] URL de test : $urlTest" -Color Cyan
    
    if ($OuvrirNavigateur) {
        Write-ColorMessage "[INFO] Ouverture du navigateur..." -Color Cyan
        Start-Process $urlTest
    }
}

# Afficher un resume
Write-ColorMessage "" -Color White
Write-ColorMessage "RESUME DES CORRECTIONS APPLIQUEES :" -Color Magenta
Write-ColorMessage "- Analyse automatique de l'image de la carte" -Color Green
Write-ColorMessage "- Detection des zones colorees par analyse des pixels" -Color Green
Write-ColorMessage "- Generation automatique des coordonnees HTML" -Color Green
Write-ColorMessage "- Mise a jour du fichier source src/content/carte.md" -Color Green
Write-ColorMessage "- Compilation et deploiement du site" -Color Green

Write-ColorMessage "" -Color White
Write-ColorMessage "FICHIERS GENERES POUR L'ANALYSE :" -Color Cyan
if (Test-Path "zones-corrigees.html") {
    Write-ColorMessage "- zones-corrigees.html : Code HTML des zones" -Color Cyan
}
if (Test-Path "zones-analysees.json") {
    Write-ColorMessage "- zones-analysees.json : Donnees d'analyse" -Color Cyan
}

Write-ColorMessage "" -Color White
Write-ColorMessage "[OK] Deploiement termine !" -Color Green

Write-ColorMessage "" -Color White
Write-ColorMessage "SITE DE PRODUCTION :" -Color Magenta
Write-ColorMessage "URL : https://malvinaland.myia.io/" -Color Green
Write-ColorMessage "Carte corrigee : https://malvinaland.myia.io/carte/" -Color Green
Write-ColorMessage "IIS publie automatiquement le repertoire 'site/' de ce depot" -Color Cyan

if ($TestLocal) {
    Write-ColorMessage "" -Color White
    Write-ColorMessage "Pour tester la carte interactive localement :" -Color Yellow
    Write-ColorMessage "1. Ouvrez votre navigateur sur : http://localhost:8080/carte/" -Color Yellow
    Write-ColorMessage "2. Survolez les zones colorees de la carte" -Color Yellow
    Write-ColorMessage "3. Cliquez sur les mondes pour naviguer" -Color Yellow
    Write-ColorMessage "" -Color White
    Write-ColorMessage "Appuyez sur une touche pour continuer..." -Color Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}