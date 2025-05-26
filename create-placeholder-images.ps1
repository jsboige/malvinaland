# Script pour créer des images de remplacement SVG pour les mondes de Malvinaland

$mondes = @{
    "assemblee" = @{ color = "#e74c3c"; icon = "🔥"; name = "Assemblée" }
    "damier" = @{ color = "#87CEEB"; icon = "🌞"; name = "Damier" }
    "elysee" = @{ color = "#FFFFFF"; icon = "🏛️"; name = "Elysée" }
    "grange" = @{ color = "#2ecc71"; icon = "🌍"; name = "Grange" }
    "jeux" = @{ color = "#3498db"; icon = "🎮"; name = "Jeux" }
    "karibu" = @{ color = "#FFA500"; icon = "🔥"; name = "Karibu" }
    "linge" = @{ color = "#9370DB"; icon = "🧵"; name = "Linge" }
    "reves" = @{ color = "#9b59b6"; icon = "🌙"; name = "Rêves" }
    "sphinx" = @{ color = "#FF4500"; icon = "🐱"; name = "Sphinx" }
    "verger" = @{ color = "#FFC0CB"; icon = "🌳"; name = "Verger" }
    "zob" = @{ color = "#FF7F50"; icon = "🧘"; name = "Zob" }
}

# Créer le répertoire s'il n'existe pas
$imageDir = "src/assets/images/mondes"
if (!(Test-Path $imageDir)) {
    New-Item -ItemType Directory -Path $imageDir -Force
}

foreach ($monde in $mondes.Keys) {
    $info = $mondes[$monde]
    $svgContent = @"
<svg width="400" height="300" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="grad$monde" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:$($info.color);stop-opacity:0.8" />
      <stop offset="100%" style="stop-color:$($info.color);stop-opacity:0.4" />
    </linearGradient>
  </defs>
  <rect width="400" height="300" fill="url(#grad$monde)" rx="8"/>
  <text x="200" y="120" font-family="Arial, sans-serif" font-size="48" text-anchor="middle" fill="white" opacity="0.9">$($info.icon)</text>
  <text x="200" y="180" font-family="Arial, sans-serif" font-size="24" font-weight="bold" text-anchor="middle" fill="white" opacity="0.9">Monde $($info.name)</text>
  <text x="200" y="220" font-family="Arial, sans-serif" font-size="16" text-anchor="middle" fill="white" opacity="0.7">Malvinaland</text>
</svg>
"@
    
    $filePath = "$imageDir/$monde.svg"
    $svgContent | Out-File -FilePath $filePath -Encoding UTF8
    Write-Host "Créé: $filePath"
}

Write-Host "Images de remplacement créées avec succès!"