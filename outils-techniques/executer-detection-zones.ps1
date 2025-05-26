# Script PowerShell pour executer la detection des zones de la carte interactive
# Installe les dependances Python et lance l'analyse

param(
    [string]$CheminImage = "src/assets/images/carte-malvinaland.png",
    [string]$Sortie = "zones-detectees-auto",
    [switch]$Visualiser = $true,
    [switch]$ForceInstall = $false
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

function Test-PythonInstalled {
    try {
        $pythonVersion = python --version 2>&1
        if ($pythonVersion -match "Python (\d+\.\d+)") {
            Write-ColorMessage "[OK] Python detecte : $pythonVersion" -Color Green
            return $true
        }
    } catch {
        Write-ColorMessage "[ERREUR] Python n'est pas installe ou pas dans le PATH" -Color Red
        return $false
    }
    return $false
}

function Install-PythonPackages {
    param([string[]]$Packages)
    
    Write-ColorMessage "[INFO] Installation des packages Python..." -Color Yellow
    
    foreach ($package in $Packages) {
        Write-ColorMessage "  Installation de $package..." -Color Cyan
        try {
            $result = pip install $package 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-ColorMessage "    [OK] $package installe avec succes" -Color Green
            } else {
                Write-ColorMessage "    [WARN] Probleme lors de l'installation de $package" -Color Yellow
                Write-ColorMessage "    $result" -Color Yellow
            }
        } catch {
            Write-ColorMessage "    [ERREUR] Erreur lors de l'installation de $package : $_" -Color Red
        }
    }
}

function Test-PackageInstalled {
    param([string]$PackageName)
    try {
        $result = python -c "import $PackageName; print('OK')" 2>&1
        return $result -eq "OK"
    } catch {
        return $false
    }
}

# Debut du script principal
Write-ColorMessage "Detecteur de zones pour la carte interactive de Malvinaland" -Color Magenta
Write-ColorMessage "============================================================" -Color Magenta

# Verifier que Python est installe
if (-not (Test-PythonInstalled)) {
    Write-ColorMessage "[ERREUR] Python est requis pour ce script." -Color Red
    Write-ColorMessage "   Veuillez installer Python depuis https://python.org" -Color Yellow
    exit 1
}

# Verifier que l'image existe
if (-not (Test-Path $CheminImage)) {
    Write-ColorMessage "[ERREUR] Image non trouvee : $CheminImage" -Color Red
    exit 1
}

Write-ColorMessage "[OK] Image trouvee : $CheminImage" -Color Green

# Liste des packages Python requis
$packagesRequis = @(
    "opencv-python",
    "pillow",
    "numpy",
    "matplotlib",
    "scikit-learn"
)

# Verifier et installer les packages si necessaire
$packagesAInstaller = @()
foreach ($package in $packagesRequis) {
    $packageImport = $package -replace "-", "_"
    if ($packageImport -eq "opencv_python") { $packageImport = "cv2" }
    if ($packageImport -eq "pillow") { $packageImport = "PIL" }
    if ($packageImport -eq "scikit_learn") { $packageImport = "sklearn" }
    
    if ($ForceInstall -or -not (Test-PackageInstalled $packageImport)) {
        $packagesAInstaller += $package
        Write-ColorMessage "[INFO] $package sera installe" -Color Yellow
    } else {
        Write-ColorMessage "[OK] $package deja installe" -Color Green
    }
}

if ($packagesAInstaller.Count -gt 0) {
    Install-PythonPackages $packagesAInstaller
    Write-ColorMessage "" -Color White
}

# Construire la commande Python
$scriptPython = "outils-techniques/detecteur-zones-carte.py"
$commande = "python `"$scriptPython`" `"$CheminImage`" --sortie `"$Sortie`""

if ($Visualiser) {
    $commande += " --visualiser"
}

Write-ColorMessage "[INFO] Lancement de la detection des zones..." -Color Yellow
Write-ColorMessage "Commande : $commande" -Color Cyan
Write-ColorMessage "" -Color White

# Executer le script Python
try {
    Invoke-Expression $commande
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        Write-ColorMessage "" -Color White
        Write-ColorMessage "[OK] Detection terminee avec succes !" -Color Green
        
        # Afficher les fichiers generes
        $fichiersGeneres = @(
            "$Sortie.json",
            "$Sortie.html"
        )
        
        if ($Visualiser) {
            $fichiersGeneres += "$Sortie.png"
        }
        
        Write-ColorMessage "[INFO] Fichiers generes :" -Color Green
        foreach ($fichier in $fichiersGeneres) {
            if (Test-Path $fichier) {
                $taille = (Get-Item $fichier).Length
                Write-ColorMessage "  [OK] $fichier ($taille octets)" -Color Green
            } else {
                Write-ColorMessage "  [ERREUR] $fichier (non trouve)" -Color Red
            }
        }
        
        # Proposer d'ouvrir les resultats
        Write-ColorMessage "" -Color White
        Write-ColorMessage "[INFO] Voulez-vous ouvrir les resultats ? (O/N)" -Color Yellow
        $reponse = Read-Host
        
        if ($reponse -match "^[OoYy]") {
            if (Test-Path "$Sortie.html") {
                Write-ColorMessage "[INFO] Ouverture du fichier HTML..." -Color Cyan
                Start-Process "$Sortie.html"
            }
            
            if ($Visualiser -and (Test-Path "$Sortie.png")) {
                Write-ColorMessage "[INFO] Ouverture de la visualisation..." -Color Cyan
                Start-Process "$Sortie.png"
            }
            
            if (Test-Path "$Sortie.json") {
                Write-ColorMessage "[INFO] Ouverture des donnees JSON..." -Color Cyan
                Start-Process "notepad.exe" -ArgumentList "$Sortie.json"
            }
        }
        
    } else {
        Write-ColorMessage "[ERREUR] Erreur lors de l'execution (code de sortie : $exitCode)" -Color Red
    }
    
} catch {
    Write-ColorMessage "[ERREUR] Erreur lors de l'execution du script Python : $_" -Color Red
    exit 1
}

Write-ColorMessage "" -Color White
Write-ColorMessage "[INFO] Script termine." -Color Magenta