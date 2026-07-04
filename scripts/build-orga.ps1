<#
.SYNOPSIS
    Build Malvinaland : site joueurs (sans solutions) + sous-arbre organisateurs
    (solutions des 11 mondes + PNJ + documentation) assemble sous $TargetDir.

.DESCRIPTION
    L'espace organisateurs est protege cote serveur par Basic Auth IIS via
    <location path="organisateurs"> dans src/web.config. Ce script produit le
    contenu de ce sous-arbre :

    1. Build Eleventy "joueurs" (INCLUDE_ORGANISATEURS non defini) -> $TargetDir.
       Les blocs organisateurs-only sont retires par le ruler markdown-it
       (.eleventy.js). Les pages hub organisateurs/ + pnj/ sont emises ici
       (identiques dans les deux builds, sans solutions).
    2. Build Eleventy "organisateurs" (INCLUDE_ORGANISATEURS=true) -> site-orga-tmp.
       Les pages /mondes/<slug>/ contiennent cette fois les solutions.
    3. Copie des pages mondes "avec solution" vers
       $TargetDir/organisateurs/solutions/<slug>/ avec post-processing :
         - renomme la classe CSS organisateurs-only -> organisateurs-solution
           (sinon auth.js masquerait les solutions meme pour un orga authentifie
           via Basic Auth, qui ne renseigne pas sessionStorage), + style de mise
           en evidence,
         - remappe href="/mondes/<slug>/" -> href="/organisateurs/solutions/<slug>/"
           (la nav "Mondes voisins" reste dans le perimetre solutions).
    4. Copie de la documentation (Site/documentation/**/*.html) ->
       $TargetDir/organisateurs/documentation/ (les .html sont autonomes : CSS
       absolu /assets/css/main.css + styles inline).
    5. Nettoyage du staging site-orga-tmp.

    Eleventy ne nettoie pas l'output par defaut : $TargetDir/assets/images/
    (photos gitignorees, presentes seulement en prod) est preserve.

.PARAMETER TargetDir
    Repertoire de sortie du site assemble. Defaut : "site".

.EXAMPLE
    ./scripts/build-orga.ps1                      # -> ./site
    ./scripts/build-orga.ps1 -TargetDir D:\staging # validation dans un staging
#>
[CmdletBinding()]
param(
    [string]$TargetDir = "site"
)

$ErrorActionPreference = "Stop"
$root = (Get-Location).Path
$stagingOrga = Join-Path $root "site-orga-tmp"
$MONDES = @('grange','sphinx','linge','verger','damier','zob','karibu','assemblee','jeux','elysee','reves')

function Write-Step($m) { Write-Host "`n==> $m" -ForegroundColor Cyan }
function Write-Ok($m)   { Write-Host "    OK  $m" -ForegroundColor Green }
function Write-Warn2($m){ Write-Host "    !   $m" -ForegroundColor Yellow }

# --- 1. Build joueurs -------------------------------------------------------
Write-Step "Build joueurs (solutions retirees) -> $TargetDir"
# S'assurer que INCLUDE_ORGANISATEURS n'est pas positionne dans l'environnement.
Remove-Item Env:\INCLUDE_ORGANISATEURS -ErrorAction SilentlyContinue
& npx @11ty/eleventy --output=$TargetDir
if ($LASTEXITCODE -ne 0) { throw "Build joueurs echoue (exit $LASTEXITCODE)" }
if (-not (Test-Path (Join-Path $TargetDir "organisateurs/index.html"))) {
    throw "Le build joueurs n'a pas emis $TargetDir/organisateurs/index.html (verifier les permalinks orga)."
}
Write-Ok "Hub organisateurs/ emis (derriere future Basic Auth)"

# --- 2. Build organisateurs (avec solutions) --------------------------------
Write-Step "Build organisateurs (INCLUDE_ORGANISATEURS=true) -> $stagingOrga"
$env:INCLUDE_ORGANISATEURS = "true"
try {
    & npx @11ty/eleventy --output=$stagingOrga
    if ($LASTEXITCODE -ne 0) { throw "Build organisateurs echoue (exit $LASTEXITCODE)" }
} finally {
    Remove-Item Env:\INCLUDE_ORGANISATEURS
}
if (-not (Test-Path (Join-Path $stagingOrga "mondes/grange/index.html"))) {
    throw "Le build orga n'a pas emis $stagingOrga/mondes/grange/index.html"
}

# --- 3. Copie + post-processing des pages solutions -------------------------
Write-Step "Assemblage des pages solutions -> $TargetDir/organisateurs/solutions/"
$solRoot = Join-Path $TargetDir "organisateurs/solutions"
New-Item -ItemType Directory -Force -Path $solRoot | Out-Null

$solutionStyle = @'
<style>
.organisateurs-solution{background:#fff8e1;border-left:4px solid #f0ad4e;padding:.75rem 1rem;margin:1rem 0;border-radius:.25rem;}
.organisateurs-solution::before{content:"\1F5DD\xFE0F  Solution (organisateurs)";display:block;font-weight:700;color:#8a6d3b;margin-bottom:.5rem;font-size:.9em;}
</style>
'@

foreach ($slug in $MONDES) {
    $src = Join-Path $stagingOrga "mondes/$slug/index.html"
    $dstDir = Join-Path $solRoot $slug
    $dst = Join-Path $dstDir "index.html"
    New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    if (-not (Test-Path $src)) { Write-Warn2 "page solution manquante: $slug"; continue }
    $html = Get-Content -Raw -LiteralPath $src
    # 3a. Defaire le masquage de auth.js (la classe n'est plus reconnue -> reste visible)
    $html = $html -replace 'class="organisateurs-only"', 'class="organisateurs-solution"'
    # 3b. Style de mise en evidence (injecte avant </head>)
    if ($html -notmatch 'organisateurs-solution') {
        # aucun bloc solution dans cette page : on injecte quand meme le style (inoffensif)
    }
    $html = $html -replace '</head>', "$solutionStyle`n</head>"
    # 3c. Remap liens voisins : href="/mondes/<slug>/" -> href="/organisateurs/solutions/<slug>/"
    $html = $html -replace '(href=")/mondes/([a-z]+)/(")', '$1/organisateurs/solutions/$2/$3'
    [System.IO.File]::WriteAllText($dst, $html, (New-Object System.Text.UTF8Encoding($false)))
    Write-Ok $slug
}

# --- 4. Copie de la documentation ------------------------------------------
Write-Step "Documentation -> $TargetDir/organisateurs/documentation/"
$docDst = Join-Path $TargetDir "organisateurs/documentation"
New-Item -ItemType Directory -Force -Path $docDst | Out-Null
$docSrc = Join-Path $root "Site/documentation"
if (Test-Path $docSrc) {
    $copied = 0
    Get-ChildItem -Path $docSrc -Recurse -Filter *.html -File | ForEach-Object {
        $rel = $_.FullName.Substring($docSrc.Length + 1)
        $dstFile = Join-Path $docDst $rel
        New-Item -ItemType Directory -Force -Path (Split-Path $dstFile) | Out-Null
        Copy-Item -LiteralPath $_.FullName -Destination $dstFile -Force
        $copied++
    }
    Write-Ok "$copied fichiers HTML de documentation"
} else {
    Write-Warn2 "Source documentation introuvable : $docSrc"
}

# --- 5. Nettoyage du staging orga ------------------------------------------
Write-Step "Nettoyage $stagingOrga"
Remove-Item -Recurse -Force -LiteralPath $stagingOrga -ErrorAction SilentlyContinue

Write-Host "`n=== BUILD TERMINE ===" -ForegroundColor Green
Write-Host "Site assemble dans           : $TargetDir" -ForegroundColor Green
Write-Host "Sous-arbre orga (Basic Auth) : $TargetDir/organisateurs/" -ForegroundColor Green
Write-Host "Solutions (11 mondes)        : $TargetDir/organisateurs/solutions/" -ForegroundColor Green
Write-Host "Documentation                : $TargetDir/organisateurs/documentation/" -ForegroundColor Green
