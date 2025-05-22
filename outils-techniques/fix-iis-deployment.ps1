# Script de correction du déploiement IIS pour Malvinaland
# Ce script corrige les problèmes courants de déploiement IIS

Write-Host "Début de la correction du déploiement IIS..." -ForegroundColor Green

# Vérifier si le script est exécuté en tant qu'administrateur
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ Ce script doit être exécuté en tant qu'administrateur!" -ForegroundColor Red
    Write-Host "Veuillez relancer PowerShell en tant qu'administrateur et réexécuter ce script." -ForegroundColor Yellow
    exit 1
}

# Vérifier si le module WebAdministration est disponible
if (-not (Get-Module -ListAvailable -Name WebAdministration)) {
    Write-Host "❌ Le module WebAdministration n'est pas disponible!" -ForegroundColor Red
    Write-Host "Veuillez installer IIS et les outils d'administration IIS." -ForegroundColor Yellow
    exit 1
}

# Importer le module WebAdministration
Import-Module WebAdministration

# Définir les variables
$siteName = "Malvinaland"
$siteUrl = "malvinaland.myia.io"
$sitePath = "D:\Production\malvinaland\site"

# 1. Vérifier si le site existe
if (-not (Get-Website -Name $siteName)) {
    Write-Host "Le site $siteName n'existe pas. Création du site..." -ForegroundColor Yellow
    
    # Créer le site
    New-Website -Name $siteName -PhysicalPath $sitePath -HostHeader $siteUrl -Force
    
    Write-Host "✅ Site créé avec succès!" -ForegroundColor Green
} else {
    Write-Host "Le site $siteName existe déjà. Mise à jour de la configuration..." -ForegroundColor Cyan
    
    # Mettre à jour le chemin physique
    Set-ItemProperty "IIS:\Sites\$siteName" -Name physicalPath -Value $sitePath
    
    Write-Host "✅ Configuration du site mise à jour!" -ForegroundColor Green
}

# 2. Configurer les liaisons HTTPS
$binding = Get-WebBinding -Name $siteName -Protocol "https"
if (-not $binding) {
    Write-Host "Ajout d'une liaison HTTPS pour le site..." -ForegroundColor Yellow
    
    # Vérifier si un certificat SSL est disponible
    $cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*$siteUrl*" } | Select-Object -First 1
    
    if ($cert) {
        # Ajouter la liaison HTTPS avec le certificat
        New-WebBinding -Name $siteName -Protocol "https" -Port 443 -HostHeader $siteUrl -SslFlags 1
        
        # Assigner le certificat à la liaison
        $binding = Get-WebBinding -Name $siteName -Protocol "https"
        $binding.AddSslCertificate($cert.Thumbprint, "My")
        
        Write-Host "✅ Liaison HTTPS configurée avec le certificat!" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Aucun certificat SSL trouvé pour $siteUrl. Veuillez en installer un." -ForegroundColor Yellow
    }
}

# 3. Configurer les types MIME
$mimeTypes = @{
    ".json" = "application/json"
    ".woff" = "application/font-woff"
    ".woff2" = "application/font-woff2"
    ".ttf" = "application/font-sfnt"
    ".svg" = "image/svg+xml"
}

foreach ($mimeType in $mimeTypes.GetEnumerator()) {
    $extension = $mimeType.Key
    $type = $mimeType.Value
    
    $existingMimeType = Get-WebConfigurationProperty -Filter "//staticContent/mimeMap[@fileExtension='$extension']" -Name "." -PSPath "IIS:\sites\$siteName" -ErrorAction SilentlyContinue
    
    if (-not $existingMimeType) {
        Write-Host "Ajout du type MIME: $extension -> $type" -ForegroundColor Yellow
        Add-WebConfigurationProperty -Filter "//staticContent" -Name "." -Value @{fileExtension="$extension"; mimeType="$type"} -PSPath "IIS:\sites\$siteName"
    }
}

Write-Host "✅ Types MIME configurés!" -ForegroundColor Green

# 4. Configurer les règles de réécriture d'URL
$webConfigPath = Join-Path -Path $sitePath -ChildPath "web.config"

if (Test-Path $webConfigPath) {
    $webConfig = [xml](Get-Content $webConfigPath)
    
    # Vérifier si la section rewrite existe
    $rewriteSection = $webConfig.SelectSingleNode("//configuration/system.webServer/rewrite")
    
    if (-not $rewriteSection) {
        Write-Host "Ajout de la section de réécriture d'URL dans web.config..." -ForegroundColor Yellow
        
        # Créer la section rewrite
        $rewriteSection = $webConfig.CreateElement("rewrite")
        $webConfig.configuration."system.webServer".AppendChild($rewriteSection)
        
        # Créer la section rules
        $rulesSection = $webConfig.CreateElement("rules")
        $rewriteSection.AppendChild($rulesSection)
        
        # Ajouter les règles de redirection
        $rules = @(
            @{
                name = "HTTP to HTTPS redirect"
                match = ".*"
                conditions = @(@{input = "{HTTPS}"; pattern = "off"; ignoreCase = "true"})
                action = @{type = "Redirect"; url = "https://{HTTP_HOST}/{R:1}"; redirectType = "Permanent"}
            },
            @{
                name = "Redirect Site/Core to content"
                match = "^Site/Core/(.*)"
                action = @{type = "Redirect"; url = "/content/{R:1}"; redirectType = "Permanent"}
            },
            @{
                name = "Redirect Mondes to content/mondes"
                match = "^Mondes/(.*)"
                action = @{type = "Redirect"; url = "/content/mondes/{R:1}"; redirectType = "Permanent"}
            }
        )
        
        foreach ($rule in $rules) {
            $ruleElement = $webConfig.CreateElement("rule")
            $ruleElement.SetAttribute("name", $rule.name)
            $ruleElement.SetAttribute("stopProcessing", "true")
            
            $matchElement = $webConfig.CreateElement("match")
            $matchElement.SetAttribute("url", $rule.match)
            $ruleElement.AppendChild($matchElement)
            
            if ($rule.conditions) {
                $conditionsElement = $webConfig.CreateElement("conditions")
                
                foreach ($condition in $rule.conditions) {
                    $conditionElement = $webConfig.CreateElement("add")
                    $conditionElement.SetAttribute("input", $condition.input)
                    $conditionElement.SetAttribute("pattern", $condition.pattern)
                    $conditionElement.SetAttribute("ignoreCase", $condition.ignoreCase)
                    $conditionsElement.AppendChild($conditionElement)
                }
                
                $ruleElement.AppendChild($conditionsElement)
            }
            
            $actionElement = $webConfig.CreateElement("action")
            $actionElement.SetAttribute("type", $rule.action.type)
            $actionElement.SetAttribute("url", $rule.action.url)
            $actionElement.SetAttribute("redirectType", $rule.action.redirectType)
            $ruleElement.AppendChild($actionElement)
            
            $rulesSection.AppendChild($ruleElement)
        }
        
        # Sauvegarder le fichier web.config
        $webConfig.Save($webConfigPath)
        
        Write-Host "✅ Règles de réécriture d'URL ajoutées dans web.config!" -ForegroundColor Green
    } else {
        Write-Host "La section de réécriture d'URL existe déjà dans web.config." -ForegroundColor Cyan
    }
} else {
    Write-Host "⚠️ Le fichier web.config n'existe pas à l'emplacement: $webConfigPath" -ForegroundColor Yellow
}

# 5. Redémarrer le site pour appliquer les modifications
Write-Host "Redémarrage du site $siteName..." -ForegroundColor Cyan
Stop-Website -Name $siteName
Start-Website -Name $siteName
Write-Host "✅ Site redémarré avec succès!" -ForegroundColor Green

# 6. Vérifier les permissions du dossier
$acl = Get-Acl -Path $sitePath
$iisAppPoolIdentity = "IIS AppPool\$siteName"

# Vérifier si l'identité du pool d'applications a les permissions nécessaires
$hasPermission = $acl.Access | Where-Object { $_.IdentityReference.Value -eq $iisAppPoolIdentity -and $_.FileSystemRights -match "ReadAndExecute" }

if (-not $hasPermission) {
    Write-Host "Configuration des permissions pour le pool d'applications..." -ForegroundColor Yellow
    
    # Créer une règle d'accès pour le pool d'applications
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($iisAppPoolIdentity, "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
    
    # Ajouter la règle à l'ACL
    $acl.AddAccessRule($accessRule)
    
    # Appliquer l'ACL
    Set-Acl -Path $sitePath -AclObject $acl
    
    Write-Host "✅ Permissions configurées pour le pool d'applications!" -ForegroundColor Green
} else {
    Write-Host "Les permissions sont déjà correctement configurées." -ForegroundColor Cyan
}

Write-Host "Correction du déploiement IIS terminée!" -ForegroundColor Green
Write-Host "Veuillez exécuter le script test-iis-deployment.ps1 pour vérifier que tout fonctionne correctement." -ForegroundColor Yellow