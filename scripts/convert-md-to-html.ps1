# Script PowerShell pour convertir les fichiers Markdown en HTML
# Utilise un template HTML cohérent avec le style du site

param(
    [string]$SourceDir = "site/documentation",
    [switch]$Recursive = $true
)

# Template HTML de base
$htmlTemplate = @"
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{TITLE}} - Malvinaland</title>
  <link rel="stylesheet" href="/assets/css/main.css">
  <style>
    .doc-content {
      max-width: 800px;
      margin: 2rem auto;
      padding: 0 1rem;
      line-height: 1.6;
    }
    
    .doc-content h1 {
      color: var(--primary-color);
      border-bottom: 3px solid var(--primary-color);
      padding-bottom: 0.5rem;
      margin-bottom: 2rem;
    }
    
    .doc-content h2 {
      color: var(--secondary-color);
      margin-top: 2rem;
      margin-bottom: 1rem;
      border-left: 4px solid var(--primary-color);
      padding-left: 1rem;
    }
    
    .doc-content h3 {
      color: var(--primary-color);
      margin-top: 1.5rem;
      margin-bottom: 0.75rem;
    }
    
    .doc-content pre {
      background: #f8f9fa;
      border: 1px solid #e9ecef;
      border-radius: 4px;
      padding: 1rem;
      overflow-x: auto;
      margin: 1rem 0;
    }
    
    .doc-content code {
      background: #f8f9fa;
      padding: 0.2rem 0.4rem;
      border-radius: 3px;
      font-family: 'Courier New', monospace;
    }
    
    .doc-content blockquote {
      border-left: 4px solid var(--primary-color);
      margin: 1rem 0;
      padding: 0.5rem 1rem;
      background: #f8f9fa;
      font-style: italic;
    }
    
    .doc-content table {
      width: 100%;
      border-collapse: collapse;
      margin: 1rem 0;
    }
    
    .doc-content th,
    .doc-content td {
      border: 1px solid #ddd;
      padding: 0.75rem;
      text-align: left;
    }
    
    .doc-content th {
      background: var(--primary-color);
      color: white;
    }
    
    .doc-content ul,
    .doc-content ol {
      margin: 1rem 0;
      padding-left: 2rem;
    }
    
    .doc-content li {
      margin: 0.5rem 0;
    }
    
    .back-link {
      display: inline-block;
      margin-bottom: 2rem;
      padding: 0.5rem 1rem;
      background: var(--primary-color);
      color: white;
      text-decoration: none;
      border-radius: 4px;
      font-weight: bold;
    }
    
    .back-link:hover {
      background: var(--link-hover-color);
    }
  </style>
</head>
<body>
  <header class="site-header">
    <div class="container">
      <h1 class="site-title"><a href="/">Malvinaland</a></h1>
      <nav class="main-navigation" id="desktop-nav">
        <ul>
          <li><a href="/">🏠 Accueil</a></li>
          <li><a href="/content/carte/">🗺️ Carte</a></li>
          <li><a href="/documentation/" class="active">📖 Documentation</a></li>
          <li><a href="/content/narration/">📚 Narration</a></li>
          <li><a href="/content/personnages/">👥 Personnages</a></li>
          <li class="auth-links">
            <a href="/content/login/" class="auth-link login-link">🔑 Connexion</a>
            <a href="#" id="logout-button" class="auth-link logout-link">🚪 Déconnexion</a>
          </li>
        </ul>
      </nav>
      
      <!-- Menu mobile -->
      <button id="mobile-nav-toggle" aria-expanded="false" aria-label="Menu de navigation">
        <span class="bar"></span>
        <span class="bar"></span>
        <span class="bar"></span>
      </button>
      
      <nav id="mobile-nav" aria-hidden="true">
        <ul>
          <li><a href="/">🏠 Accueil</a></li>
          <li><a href="/content/carte/">🗺️ Carte</a></li>
          <li><a href="/documentation/" class="active">📖 Documentation</a></li>
          <li><a href="/content/narration/">📚 Narration</a></li>
          <li><a href="/content/personnages/">👥 Personnages</a></li>
          <li class="auth-links">
            <a href="/content/login/" class="auth-link login-link">🔑 Connexion</a>
            <a href="#" id="logout-button" class="auth-link logout-link">🚪 Déconnexion</a>
          </li>
        </ul>
      </nav>
    </div>
  </header>

  <main class="site-content">
    <div class="container">
      <div class="doc-content">
        <a href="/documentation/" class="back-link">← Retour à la documentation</a>
        {{CONTENT}}
      </div>
    </div>
  </main>

  <footer class="site-footer">
    <div class="container">
      <p>&copy; 2025 Malvinaland - Documentation</p>
      <div class="footer-navigation">
        <a href="/">Accueil</a> |
        <a href="/content/carte/">Carte</a> |
        <a href="/documentation/">Documentation</a> |
        <a href="/content/narration/">Narration</a>
      </div>
    </div>
  </footer>

  <script src="/assets/js/navigation.js" defer></script>
  <script src="/assets/js/auth.js" defer></script>
</body>
</html>
"@

# Fonction pour convertir le Markdown en HTML basique
function Convert-MarkdownToHtml {
    param(
        [string]$MarkdownContent,
        [string]$Title
    )
    
    # Conversion basique du Markdown en HTML
    $htmlContent = $MarkdownContent
    
    # Titres
    $htmlContent = $htmlContent -replace '^# (.+)$', '<h1>$1</h1>' -replace '^## (.+)$', '<h2>$1</h2>' -replace '^### (.+)$', '<h3>$1</h3>' -replace '^#### (.+)$', '<h4>$1</h4>'
    
    # Liens
    $htmlContent = $htmlContent -replace '\[([^\]]+)\]\(([^)]+)\)', '<a href="$2">$1</a>'
    
    # Gras et italique
    $htmlContent = $htmlContent -replace '\*\*([^*]+)\*\*', '<strong>$1</strong>'
    $htmlContent = $htmlContent -replace '\*([^*]+)\*', '<em>$1</em>'
    
    # Code inline
    $htmlContent = $htmlContent -replace '`([^`]+)`', '<code>$1</code>'
    
    # Listes
    $lines = $htmlContent -split "`n"
    $inList = $false
    $processedLines = @()
    
    foreach ($line in $lines) {
        if ($line -match '^- (.+)$' -or $line -match '^\* (.+)$') {
            if (-not $inList) {
                $processedLines += '<ul>'
                $inList = $true
            }
            $processedLines += "<li>$($matches[1])</li>"
        } elseif ($line -match '^\d+\. (.+)$') {
            if (-not $inList) {
                $processedLines += '<ol>'
                $inList = $true
            }
            $processedLines += "<li>$($matches[1])</li>"
        } else {
            if ($inList) {
                if ($line -match '^- ' -or $line -match '^\* ' -or $line -match '^\d+\. ') {
                    # Continue dans la liste
                } else {
                    $processedLines += '</ul>'
                    $inList = $false
                }
            }
            
            if ($line.Trim() -eq '') {
                $processedLines += '<br>'
            } elseif ($line -match '^```') {
                if ($line -match '^```$') {
                    $processedLines += '</pre>'
                } else {
                    $processedLines += '<pre>'
                }
            } elseif (-not ($line -match '^#')) {
                $processedLines += "<p>$line</p>"
            } else {
                $processedLines += $line
            }
        }
    }
    
    if ($inList) {
        $processedLines += '</ul>'
    }
    
    return ($processedLines -join "`n")
}

# Fonction principale de conversion
function Convert-MdFiles {
    param(
        [string]$Directory
    )
    
    Write-Host "🔄 Conversion des fichiers Markdown en HTML dans : $Directory" -ForegroundColor Green
    
    # Obtenir tous les fichiers .md
    if ($Recursive) {
        $mdFiles = Get-ChildItem -Path $Directory -Filter "*.md" -Recurse
    } else {
        $mdFiles = Get-ChildItem -Path $Directory -Filter "*.md"
    }
    
    $convertedCount = 0
    
    foreach ($mdFile in $mdFiles) {
        try {
            Write-Host "📄 Conversion de : $($mdFile.Name)" -ForegroundColor Yellow
            
            # Lire le contenu Markdown
            $markdownContent = Get-Content -Path $mdFile.FullName -Raw -Encoding UTF8
            
            # Extraire le titre du premier # ou utiliser le nom du fichier
            $title = $mdFile.BaseName
            if ($markdownContent -match '^# (.+)$') {
                $title = $matches[1]
            }
            
            # Convertir en HTML
            $htmlContent = Convert-MarkdownToHtml -MarkdownContent $markdownContent -Title $title
            
            # Créer le fichier HTML final
            $finalHtml = $htmlTemplate -replace '{{TITLE}}', $title -replace '{{CONTENT}}', $htmlContent
            
            # Chemin de sortie
            $outputPath = $mdFile.FullName -replace '\.md$', '.html'
            
            # Écrire le fichier HTML
            $finalHtml | Out-File -FilePath $outputPath -Encoding UTF8
            
            Write-Host "✅ Créé : $outputPath" -ForegroundColor Green
            $convertedCount++
            
        } catch {
            Write-Host "❌ Erreur lors de la conversion de $($mdFile.Name) : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host "`n🎉 Conversion terminée ! $convertedCount fichiers convertis." -ForegroundColor Green
}

# Exécution du script
if (Test-Path $SourceDir) {
    Convert-MdFiles -Directory $SourceDir
} else {
    Write-Host "❌ Le répertoire $SourceDir n'existe pas !" -ForegroundColor Red
    exit 1
}