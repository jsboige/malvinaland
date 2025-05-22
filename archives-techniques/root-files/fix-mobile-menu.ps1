# Script pour corriger spécifiquement le problème du menu mobile
# Ce script modifie directement les fichiers sur le serveur IIS

# Fonction pour afficher un message coloré
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

# Fonction pour créer un script de menu mobile simplifié
function Create-MobileMenuScript {
    param (
        [string]$OutputPath
    )
    
    $scriptContent = @"
/**
 * Script de menu mobile simplifié pour Malvinaland
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('Menu mobile simplifié chargé');
    
    // Éléments du DOM
    const mobileNavToggle = document.getElementById('mobile-nav-toggle');
    const mobileNav = document.getElementById('mobile-nav');
    
    if (!mobileNavToggle || !mobileNav) {
        console.error('Éléments du menu mobile non trouvés');
        return;
    }
    
    console.log('Éléments du menu mobile trouvés');
    
    // Créer un overlay pour fermer le menu en cliquant à l'extérieur
    const overlay = document.createElement('div');
    overlay.className = 'mobile-menu-overlay';
    overlay.style.position = 'fixed';
    overlay.style.top = '0';
    overlay.style.left = '0';
    overlay.style.width = '100%';
    overlay.style.height = '100%';
    overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
    overlay.style.zIndex = '998';
    overlay.style.display = 'none';
    document.body.appendChild(overlay);
    
    // Styles pour le menu mobile
    const style = document.createElement('style');
    style.textContent = `
        #mobile-nav {
            position: fixed;
            top: 0;
            left: 0;
            width: 80%;
            height: 100%;
            background-color: #3f51b5;
            z-index: 999;
            transform: translateX(-100%);
            transition: transform 0.3s ease;
            overflow-y: auto;
            padding-top: 60px;
        }
        
        #mobile-nav.active {
            transform: translateX(0);
        }
        
        #mobile-nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        #mobile-nav li {
            padding: 0;
            margin: 0;
        }
        
        #mobile-nav a {
            display: block;
            padding: 15px 20px;
            color: white;
            text-decoration: none;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        #mobile-nav a:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        #mobile-nav-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            background: none;
            border: none;
            cursor: pointer;
            padding: 10px;
        }
        
        #mobile-nav-toggle .bar {
            display: block;
            width: 25px;
            height: 3px;
            margin: 5px 0;
            background-color: white;
            transition: all 0.3s ease;
        }
        
        #mobile-nav-toggle.active .bar:nth-child(1) {
            transform: translateY(8px) rotate(45deg);
        }
        
        #mobile-nav-toggle.active .bar:nth-child(2) {
            opacity: 0;
        }
        
        #mobile-nav-toggle.active .bar:nth-child(3) {
            transform: translateY(-8px) rotate(-45deg);
        }
        
        .mobile-menu-overlay {
            display: none;
        }
        
        .mobile-menu-overlay.active {
            display: block;
        }
    `;
    document.head.appendChild(style);
    
    // Fonction pour basculer le menu mobile
    function toggleMobileMenu() {
        console.log('Toggle menu mobile');
        mobileNavToggle.classList.toggle('active');
        mobileNav.classList.toggle('active');
        overlay.classList.toggle('active');
        
        if (mobileNav.classList.contains('active')) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = '';
        }
    }
    
    // Événement pour le bouton hamburger
    mobileNavToggle.addEventListener('click', function(e) {
        console.log('Clic sur le bouton hamburger');
        e.preventDefault();
        toggleMobileMenu();
    });
    
    // Fermer le menu en cliquant sur l'overlay
    overlay.addEventListener('click', function() {
        toggleMobileMenu();
    });
    
    // Fermer le menu en cliquant sur un lien
    const mobileNavLinks = mobileNav.querySelectorAll('a');
    mobileNavLinks.forEach(function(link) {
        link.addEventListener('click', function() {
            toggleMobileMenu();
        });
    });
    
    // Fermer le menu avec la touche Échap
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && mobileNav.classList.contains('active')) {
            toggleMobileMenu();
        }
    });
    
    console.log('Menu mobile simplifié initialisé');
});
"@
    
    Set-Content -Path $OutputPath -Value $scriptContent -Encoding UTF8
    Write-ColorMessage "Script de menu mobile simplifié créé : $OutputPath" -Color Green
}

# Fonction pour mettre à jour les fichiers HTML
function Update-HtmlFiles {
    param (
        [string]$DirectoryPath
    )
    
    Write-ColorMessage "Mise à jour des fichiers HTML dans $DirectoryPath..." -Color Yellow
    
    $htmlFiles = Get-ChildItem -Path $DirectoryPath -Filter "*.html" -Recurse
    
    foreach ($htmlFile in $htmlFiles) {
        Write-ColorMessage "Traitement de $($htmlFile.FullName)..." -Color Yellow
        
        $content = Get-Content -Path $htmlFile.FullName -Raw -Encoding UTF8
        
        # Supprimer tous les scripts de menu mobile existants
        $content = $content -replace '(?s)<script src="Core/menu-mobile-fix.js"[^>]*></script>', ''
        $content = $content -replace '(?s)<script>\s*// Script de correction pour le menu mobile.*?</script>', ''
        $content = $content -replace '(?s)<script>\s*\(function\(\) \{\s*// Attendre que la page soit complètement chargée.*?}\)\(\);\s*</script>', ''
        
        # Ajouter le nouveau script de menu mobile
        $content = $content -replace '(</head>)', '    <script src="Core/mobile-menu.js" defer></script>$1'
        
        # Enregistrer les modifications
        Set-Content -Path $htmlFile.FullName -Value $content -Encoding UTF8
        
        Write-ColorMessage "Fichier HTML mis à jour : $($htmlFile.FullName)" -Color Green
    }
}

# Afficher un en-tête
Write-ColorMessage "=== Correction du menu mobile pour Malvinaland ===" -Color Cyan
Write-ColorMessage "Date: $(Get-Date)" -Color Cyan
Write-ColorMessage ""

# Définir les chemins
$iisPath = "C:\inetpub\wwwroot\malvinaland"
$mobileMenuScriptPath = Join-Path -Path $iisPath -ChildPath "Core\mobile-menu.js"

# Vérifier si le répertoire IIS existe
if (-not (Test-Path -Path $iisPath)) {
    Write-ColorMessage "Le répertoire IIS n'existe pas : $iisPath" -Color Red
    Write-ColorMessage "Veuillez d'abord exécuter le script de déploiement administrateur." -Color Red
    exit
}

# Créer le script de menu mobile simplifié
Create-MobileMenuScript -OutputPath $mobileMenuScriptPath

# Mettre à jour les fichiers HTML
Update-HtmlFiles -DirectoryPath $iisPath

# Redémarrer IIS
Write-ColorMessage "Redémarrage d'IIS..." -Color Yellow
iisreset /noforce
Write-ColorMessage "IIS redémarré" -Color Green

Write-ColorMessage ""
Write-ColorMessage "=== Correction du menu mobile terminée ===" -Color Cyan
Write-ColorMessage "Veuillez tester le menu mobile à l'adresse https://malvinaland.myia.io/" -Color Cyan