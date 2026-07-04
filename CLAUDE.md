# CLAUDE.md — Malvinaland (jeu de piste immersif)

> Instructions projet pour Claude Code. Rédigé le 2026-07-04 après audit complet du workspace, du dépôt et du déploiement IIS. Objectif immédiat : **remettre le site en état pour une réédition du jeu (nombreux joueurs) prévue ~mi-juillet 2026**.

---

## 1. Ce qu'est le projet

Site web d'un **jeu de piste immersif** joué dans la maison de campagne de Sabres. Les joueurs et les organisateurs suivent l'aventure **sur mobile en se déplaçant** dans les lieux (jardin, bâtiments). Univers découpé en **11 « mondes »** (Assemblée, Grange, Jeux, Rêves, Damier, Linge, Verger, Zob, Élysée, Karibu, Sphinx).

- **Prod publique :** https://malvinaland.myia.io/ (HTTP→HTTPS forcé)
- **GitHub :** https://github.com/jsboige/malvinaland (branche `main`)
- **Techno du site :** générateur statique **Eleventy (11ty) v2** + PWA (service worker, manifest). Contenu en **Markdown** dans `src/content/`.

---

## 2. ⚠️ Topologie — TROIS copies (à ne jamais confondre)

| Copie | Chemin | Rôle | git |
|-------|--------|------|-----|
| **Dev / Google Drive** | `g:\Mon Drive\Loisirs\Jeux de piste\Les mondes de Malvinha` | Workspace ouvert dans l'éditeur (celui-ci) | clone `main` |
| **Production (servie par IIS)** | `D:\Production\malvinaland\` | Ce qu'IIS publie réellement | clone `main` |
| **Origin** | github.com/jsboige/malvinaland | Source de vérité distante | `main` |

**IIS ne sert PAS la copie Google Drive.** Site IIS `Malvinaland` (id:31) → **physicalPath `D:\Production\malvinaland\site`**, bindings `http:80` + `https:443` sur `malvinaland.myia.io`, app pool `DefaultAppPool`. Toute mise à jour du site public passe par `D:\Production\malvinaland`, **pas** par le Google Drive.

Au 2026-07-04, les deux clones locaux sont sur le même commit que le remote (`ecd1ea8`), mais **leurs working trees sont sales** (voir §5).

---

## 3. Architecture du dépôt

```
src/                       # SOURCE (édité à la main)
  content/                 # Markdown : index, carte, mondes/*, organisateurs/*, narration, personnages
  assets/                  # js (auth, carte-interactive, image-loader, navigation, register-sw), css, images
  _includes/ _data/        # templates & data Eleventy
site/                      # SORTIE DE BUILD Eleventy (voir §4) — servie par IIS
scripts/ outils-techniques/  # PowerShell de maintenance/déploiement
ressources/                # images haute résolution
docs/ documentation/ guides/  # docs (partiellement périmées, cf. §6)
.eleventy.js               # config build : input=src, output=site
package.json               # scripts npm
```

---

## 4. Build & déploiement

**Build (Eleventy) :** `input: "src"` → `output: "site"` (défini dans `.eleventy.js`).

```powershell
npm install                 # une fois (node_modules gitignored)
npm run build               # version JOUEURS uniquement  (eleventy)
npm run build:all           # version COMPLÈTE joueurs + organisateurs (INCLUDE_ORGANISATEURS=true)
npm run dev                 # serveur local http://localhost:8080
```

Le contenu `organisateurs-only` (solutions des énigmes) est **réellement retiré** du HTML des pages joueurs à la compilation quand `INCLUDE_ORGANISATEURS != "true"` — via une règle `md.core.ruler` dans `.eleventy.js` (ajoutée le 2026-07-04 : le conteneur markdown-it seul ne filtrait PAS, il enrobait le secret dans un `<div>` non masqué → fuite, cf. §6). `build:all` (`INCLUDE_ORGANISATEURS=true`) réinclut tout. **Conséquence :** build joueurs et build orga sont deux sorties différentes — attention à ce qu'on publie.

**Routage des URL = permalinks Eleventy** (pas de réécriture IIS pour les pages joueurs). Chaque monde a `permalink: /mondes/<slug>/` (via `src/content/mondes/mondes.11tydata.js`) ; carte/personnages/narration/login/index ont un `permalink` en front-matter. Le `web.config` IIS est **émis par Eleventy** (passthrough de `src/web.config`) : il ne garde qu'une réécriture `organisateurs/ → content/organisateurs/` + la redirection HTTP→HTTPS + une redirection legacy `content/* → /`. **Ne PAS réintroduire les réécritures `mondes/ → content/mondes/`** (c'était la cause de la fuite, §6).

**Déploiement :** IIS sert `D:\Production\malvinaland\site` **directement depuis le disque**. Pour publier : mettre à jour ce dossier `site/`, puis IIS le sert immédiatement. En pratique : `git pull` + rebuild dans `D:\Production\malvinaland` (`npx @11ty/eleventy`), puis **copie chirurgicale** des pages régénérées vers `site/` en **préservant `site/assets/images/`** (les photos jpg sont gitignored et n'existent QUE dans `site/`, pas dans `src/`).

**⚠️ Il n'y a PAS de CI** (aucun `.github/workflows`). Les docs qui parlent de « déploiement automatique via GitHub Actions » sont **fausses/aspirationnelles**. Rien ne se déploie tout seul : la publication est manuelle.

**Vérifier la prod :**
```powershell
Invoke-WebRequest https://malvinaland.myia.io/ -UseBasicParsing | Select StatusCode
# config IIS : & "$env:windir\System32\inetsrv\appcmd.exe" list site "Malvinaland"
```

---

## 5. Pièges d'environnement (IMPORTANT)

- **Google Drive ↔ git = guerre des fins de ligne.** Le workspace est SUR Google Drive ; le démon Drive réécrit les fichiers checkout par git → des centaines de fichiers apparaissent « modifiés » alors que le diff est **100 % whitespace/CRLF** (`git diff --ignore-all-space --stat` = vide). Ce bruit n'est pas de vraies modifs. Il n'y a pas de `.gitattributes` et `core.autocrlf=false`. **À traiter** (cf. §7).
- **Collision de casse `Site/` vs `site/`.** git suit le build sous `Site/…` (S majuscule) ; Eleventy écrit dans `site/` (minuscule) ; sur Windows (FS insensible à la casse) c'est le même dossier → l'index git et la sortie de build se marchent dessus. Le `site/` (build) est **tracké**, ce qui est une mauvaise pratique (on versionne un artefact généré).
- **Dossiers obsolètes verrouillés.** Après resync, d'anciens dossiers (`Core/`, ex-structure de mai 2025) peuvent rester non supprimables (`Permission denied`, lock Drive).
- **Prod avec du travail non commité.** `D:\Production\malvinaland` a ~141 fichiers modifiés dont de **vraies modifs** (ex. `src/assets/js/carte-interactive.js`, `src/content/carte.md`) : quelqu'un était en plein travail. **Ne rien écraser sans comprendre/préserver.**

---

## 6. Cause racine réelle & correctifs (2026-07-04)

Le diagnostic initial (« 403 des mondes / décalage de préfixe ») était **faux**. La vraie histoire, découverte en inspectant `site/web.config` :

1. **🔴 FUITE DE SÉCURITÉ (corrigée).** `web.config` réécrivait `^mondes/(.*)` → `content/mondes/{R:1}`. Donc `/mondes/grange/` servait l'ancien `content/mondes/grange/index.html` (build de mai 2025) — qui contenait **les solutions des énigmes en clair** (blocs `organisateurs-only`). Le site public **fuitait toutes les solutions depuis mai 2025.**
   - Double cause : (a) la réécriture IIS servait `content/` ; (b) le conteneur `organisateurs-only` de `.eleventy.js` n'enlevait PAS le contenu (il l'enrobait dans un `<div>` que les pages monde ne masquent même pas — elles chargent `monde.css`, pas `organisateur.css`).
   - **Fix (durable) :** règle `md.core.ruler` dans `.eleventy.js` qui **supprime** les tokens `organisateurs-only` en build joueurs. Vérifié : 0 solution servie sur `/mondes/*`.
2. **🔴 Décalage nav/URL (corrigé).** La nav pointait vers `/mondes/…`, `/carte/`, etc. ; ces URL n'existaient que via la réécriture IIS vers `content/`. **Fix :** permalinks Eleventy natifs (`/mondes/<slug>/`, etc.) + `web.config` nettoyé (réécritures `content/` retirées, sauf `organisateurs/`). `/content/*` redirige désormais 301 vers l'URL propre (ferme le chemin de fuite).
3. **Carte interactive intégrée.** Reprise du WIP prod (image-map 11 zones cliquables) avec hrefs corrigés `/content/mondes/` → `/mondes/`.
4. **`site/` de prod = empilement de builds jamais nettoyés.** Cohabitent d'anciens `monde-xxx/`, `content/…`, et les nouveaux `/mondes/…`. Les anciens ne sont plus servis (réécritures retirées / 301) mais restent sur le disque. **Ménage à faire** (cf. §7).
5. **Docs incohérentes.** WORKFLOW.md parle de sortie `dist/` (c'est `site/`) et de CI (inexistant). README/HEBERGEMENT plus fiables.

**État prod vérifié après fix (2026-07-04) :** `/`, `/carte/`, `/mondes/*` (11), `/personnages/`, `/narration/`, `/login/`, `/organisateurs/*`, `manifest.json`, `service-worker.js`, images → tous **200**, **aucune solution servie**. Backup pré-déploiement : `D:\Production\malvinaland\_backup-<timestamp>\`.

---

## 7. Plan de remise en ordre

**Fait le 2026-07-04 :** fuite de sécurité fermée, permalinks + strip organisateurs, carte intégrée, `web.config` nettoyé + émis par Eleventy, déploiement chirurgical prod vérifié (§6). `.gitattributes` ajouté.

**Reste à faire (ménage délibéré, pas dans l'urgence) :**
1. **Neutraliser le bruit CRLF** : `.gitattributes` est en place ; reste à renormaliser une fois (`git add --renormalize .`) et committer proprement, hors des commits de contenu.
2. **QA mobile complète** : parcours joueur (mondes, carte cliquable, énigmes) + parcours orga, sur téléphone réel, avant l'événement.
3. **Décommissionner `site/` du versionnement** (artefact généré : le régénérer, pas le committer) et **purger la collision de casse `Site/` vs `site/`**.
4. **Purger les empilements de builds** dans `D:\Production\malvinaland\site` (anciens `monde-xxx/`, `content/…`) — après vérif qu'ils ne sont plus référencés.
5. **Consolider les scripts de déploiement** (~8 variantes `deploy*.ps1`, dont des legacy pré-Eleventy qui déploient `Site/Mondes/Core`) en un seul script fiable pour l'architecture Eleventy actuelle.
6. **Espace organisateurs** : décider d'un vrai déploiement protégé (`build:all` derrière auth) — aujourd'hui `/organisateurs/*` sert `content/organisateurs/` (pages orga, « protégées » seulement côté client).
7. **Nettoyer les docs périmées** (WORKFLOW.md : `dist/`, CI inexistant).

---

## 8. Conventions

- **Langue :** utilisateur = français ; commits/docs = français OK (le dépôt est en français).
- **Commits :** messages clairs et descriptifs. Ne rien committer de cassé. Committer + push AVANT d'annoncer un travail fait.
- **Sécurité prod :** le site est **live** et un **événement approche** — toute modif de `D:\Production\malvinaland` ou d'IIS est une action de production : confirmer avant, préférer le réversible, sauvegarder avant d'écraser.
- **Ne jamais supprimer sans preuve de préservation** (règle globale utilisateur).
- **Encodage :** UTF-8 **sans BOM** (PowerShell : `-Encoding utf8NoBOM` ou `[IO.File]::WriteAllText` avec `UTF8Encoding($false)`).
