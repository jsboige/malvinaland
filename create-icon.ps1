$svgContent = @'
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
  <circle cx="256" cy="256" r="256" fill="#3f51b5"/>
  <path d="M128 160 L192 352 L256 160 L320 352 L384 160 L384 352 L336 352 L336 240 L288 384 L224 240 L176 384 L128 240 Z" 
        fill="white" stroke="white" stroke-width="8"/>
</svg>
'@

# Créer le répertoire s'il n'existe pas
$iconDir = "src\assets\icons"
if (-not (Test-Path $iconDir)) {
    New-Item -Path $iconDir -ItemType Directory -Force | Out-Null
}

# Écrire le fichier SVG
Set-Content -Path "$iconDir\icon-base.svg" -Value $svgContent

Write-Host "Fichier SVG créé avec succès : $iconDir\icon-base.svg"