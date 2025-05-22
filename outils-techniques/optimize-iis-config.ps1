# Script d'optimisation de la configuration IIS pour Malvinaland

# Configuration
$rootPath = Split-Path -Parent $PSScriptRoot
$siteWebConfig = Join-Path -Path $rootPath -ChildPath "site\web.config"

# Fonction pour afficher les messages
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

# Afficher l'en-tête
Write-ColorMessage "=== Optimisation de la configuration IIS pour Malvinaland ===" -Color Cyan
Write-ColorMessage "Date: $(Get-Date)" -Color Cyan
Write-ColorMessage ""

# Vérifier si le fichier web.config existe
if (-not (Test-Path $siteWebConfig)) {
    Write-ColorMessage "Le fichier web.config n'existe pas dans le dossier site." -Color Red
    exit
}

# Lire le contenu du fichier web.config
$webConfigContent = Get-Content -Path $siteWebConfig -Raw

# Vérifier si la section staticContent existe
if ($webConfigContent -notmatch '<staticContent>') {
    Write-ColorMessage "Ajout de la section staticContent..." -Color Yellow
    
    # Créer la section staticContent
    $staticContentSection = @"
        <staticContent>
            <clientCache cacheControlMode="UseMaxAge" cacheControlMaxAge="7.00:00:00" />
            <!-- Types MIME nécessaires pour le bon fonctionnement du site -->
            <remove fileExtension=".json" />
            <remove fileExtension=".webp" />
            <remove fileExtension=".woff" />
            <remove fileExtension=".woff2" />
            <mimeMap fileExtension=".json" mimeType="application/json" />
            <mimeMap fileExtension=".webp" mimeType="image/webp" />
            <mimeMap fileExtension=".woff" mimeType="application/font-woff" />
            <mimeMap fileExtension=".woff2" mimeType="application/font-woff2" />
        </staticContent>
"@
    
    # Insérer la section staticContent avant la fermeture de system.webServer
    $webConfigContent = $webConfigContent -replace '</system\.webServer>', "$staticContentSection`n    </system.webServer>"
    
    # Écrire le contenu mis à jour dans le fichier web.config
    Set-Content -Path $siteWebConfig -Value $webConfigContent
    
    Write-ColorMessage "Section staticContent ajoutée avec succès." -Color Green
} else {
    Write-ColorMessage "La section staticContent existe déjà." -Color Green
}

# Vérifier si les règles de réécriture pour les mondes sont présentes
if ($webConfigContent -notmatch '<rule name="Redirect mondes paths"') {
    Write-ColorMessage "Ajout des règles de réécriture pour les mondes..." -Color Yellow
    
    # Créer les règles de réécriture pour les mondes
    $mondesRules = @"
                <rule name="Redirect mondes paths" stopProcessing="true">
                    <match url="^mondes/(.*)$" />
                    <action type="Rewrite" url="content/mondes/{R:1}" />
                </rule>
                <rule name="Redirect organisateurs paths" stopProcessing="true">
                    <match url="^organisateurs/(.*)$" />
                    <action type="Rewrite" url="content/organisateurs/{R:1}" />
                </rule>
                <rule name="Redirect root to content - carte" stopProcessing="true">
                    <match url="^carte/?$" />
                    <action type="Rewrite" url="content/carte/index.html" />
                </rule>
                <rule name="Redirect root to content - narration" stopProcessing="true">
                    <match url="^narration/?$" />
                    <action type="Rewrite" url="content/narration/index.html" />
                </rule>
                <rule name="Redirect root to content - personnages" stopProcessing="true">
                    <match url="^personnages/?$" />
                    <action type="Rewrite" url="content/personnages/index.html" />
                </rule>
                <rule name="Redirect root to content - login" stopProcessing="true">
                    <match url="^login/?$" />
                    <action type="Rewrite" url="content/login/index.html" />
                </rule>
                <rule name="Redirect content to root" stopProcessing="true">
                    <match url="^content/(.*)" />
                    <action type="Redirect" url="/{R:1}" redirectType="Permanent" />
                </rule>
"@
    
    # Insérer les règles de réécriture avant la fermeture de rules
    $webConfigContent = $webConfigContent -replace '</rules>', "$mondesRules`n            </rules>"
    
    # Écrire le contenu mis à jour dans le fichier web.config
    Set-Content -Path $siteWebConfig -Value $webConfigContent
    
    Write-ColorMessage "Règles de réécriture pour les mondes ajoutées avec succès." -Color Green
} else {
    Write-ColorMessage "Les règles de réécriture pour les mondes existent déjà." -Color Green
}

# Vérifier si la compression est activée pour les fichiers SVG
if ($webConfigContent -notmatch '<add mimeType="image/svg\+xml" enabled="true" />') {
    Write-ColorMessage "Ajout de la compression pour les fichiers SVG..." -Color Yellow
    
    # Ajouter la compression pour les fichiers SVG
    $webConfigContent = $webConfigContent -replace '<staticTypes>', '<staticTypes>`n                <add mimeType="image/svg+xml" enabled="true" />'
    
    # Écrire le contenu mis à jour dans le fichier web.config
    Set-Content -Path $siteWebConfig -Value $webConfigContent
    
    Write-ColorMessage "Compression pour les fichiers SVG ajoutée avec succès." -Color Green
} else {
    Write-ColorMessage "La compression pour les fichiers SVG est déjà activée." -Color Green
}

# Vérifier si la sécurité CSP est configurée
if ($webConfigContent -notmatch 'Content-Security-Policy') {
    Write-ColorMessage "Ajout de la politique de sécurité du contenu (CSP)..." -Color Yellow
    
    # Ajouter la politique de sécurité du contenu
    $cspHeader = @"
                <add name="Content-Security-Policy" value="default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self';" />
"@
    
    # Insérer la politique de sécurité du contenu avant la fermeture de customHeaders
    $webConfigContent = $webConfigContent -replace '</customHeaders>', "$cspHeader`n            </customHeaders>"
    
    # Écrire le contenu mis à jour dans le fichier web.config
    Set-Content -Path $siteWebConfig -Value $webConfigContent
    
    Write-ColorMessage "Politique de sécurité du contenu (CSP) ajoutée avec succès." -Color Green
} else {
    Write-ColorMessage "La politique de sécurité du contenu (CSP) est déjà configurée." -Color Green
}

Write-ColorMessage ""
Write-ColorMessage "=== Optimisation terminée ===" -Color Cyan
Write-ColorMessage "La configuration IIS a été optimisée avec succès." -Color Green