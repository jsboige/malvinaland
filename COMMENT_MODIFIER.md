# Guide simplifié pour modifier Malvinaland

Ce guide vous explique comment modifier facilement le contenu du site Malvinaland directement depuis l'interface GitHub, sans avoir besoin de connaissances techniques avancées.

## 1. Accéder au dépôt GitHub

1. Ouvrez votre navigateur et allez sur GitHub (https://github.com)
2. Connectez-vous à votre compte (ou créez-en un si nécessaire)
3. Accédez au dépôt Malvinaland (l'URL exacte vous sera communiquée par l'administrateur)

![Accès au dépôt GitHub](https://docs.github.com/assets/cb-25535/mw-1440/images/help/repository/repo-header.webp)

## 2. Naviguer dans le dépôt

Le contenu principal que vous pourriez vouloir modifier se trouve dans le dossier `src/content/`:

1. Cliquez sur le dossier `src` dans la liste des fichiers
2. Puis cliquez sur le dossier `content`
3. À partir de là, vous pouvez naviguer vers:
   - `mondes/` pour modifier les différents mondes
   - `organisateurs/pnj/` pour modifier les personnages non-joueurs
   - Les autres fichiers comme `index.md`, `carte.md`, etc.

![Navigation dans les dossiers](https://docs.github.com/assets/cb-19595/mw-1440/images/help/repository/navigate-code.webp)

## 3. Modifier un fichier Markdown

Pour modifier un fichier:

1. Naviguez jusqu'au fichier que vous souhaitez modifier (par exemple `src/content/mondes/verger/index.md`)
2. Cliquez sur le nom du fichier pour l'ouvrir
3. Cliquez sur l'icône en forme de crayon (✏️) en haut à droite du contenu du fichier

![Bouton d'édition](https://docs.github.com/assets/cb-118903/mw-1440/images/help/repository/edit-file-edit-button.webp)

4. Vous êtes maintenant dans l'éditeur de texte GitHub où vous pouvez modifier le contenu

### Structure d'un fichier Markdown typique

```markdown
---
layout: layouts/monde.njk
title: Nom du Monde
monde: identifiant-du-monde
---

## 🏞️ Introduction et description du lieu

Texte descriptif du lieu...

## 🎭 Ambiance et atmosphère

Description de l'ambiance...

## 📚 Histoire locale

Histoire du lieu...

::: organisateurs-only
### Notes pour les organisateurs

Informations réservées aux organisateurs...
:::

## 🧩 Énigmes proposées dans ce monde

### 🔐 Énigme 1 – Titre de l'énigme

Description de l'énigme...
```

**Important**: Ne modifiez pas la partie entre `---` au début du fichier, sauf si vous savez exactement ce que vous faites.

## 4. Prévisualiser les changements

1. Après avoir effectué vos modifications, faites défiler vers le bas de la page
2. Cliquez sur l'onglet "Preview" pour voir un aperçu de vos modifications
3. Vérifiez que tout s'affiche correctement

![Prévisualisation des modifications](https://docs.github.com/assets/cb-70869/mw-1440/images/help/repository/edit-readme-preview-changes.webp)

## 5. Valider les modifications (commit)

Une fois que vous êtes satisfait de vos modifications:

1. Faites défiler jusqu'en bas de la page d'édition
2. Dans la section "Commit changes":
   - Ajoutez un titre court décrivant vos modifications (par exemple: "Mise à jour de la description du Monde du Verger")
   - Optionnellement, ajoutez une description plus détaillée
3. Sélectionnez l'option "Commit directly to the main branch" (ou suivez les instructions spécifiques de votre équipe)
4. Cliquez sur le bouton "Commit changes"

![Valider les modifications](https://docs.github.com/assets/cb-87213/mw-1440/images/help/repository/choose-commit-branch.webp)

## 6. Vérifier les modifications

Après avoir validé vos modifications:

1. Retournez à la page principale du dépôt
2. Vous devriez voir votre modification apparaître dans la liste des commits récents
3. Le site sera automatiquement mis à jour (cela peut prendre quelques minutes)
4. Vous pourrez voir vos modifications sur le site à l'adresse **https://malvinaland.myia.io/**

**IMPORTANT** : Le site Malvinaland est accessible UNIQUEMENT via le domaine **https://malvinaland.myia.io/**. N'essayez pas d'accéder au site via d'autres URLs ou de configurer un hébergement alternatif.

## Conseils pratiques

- **Sauvegardez régulièrement**: Validez (commit) vos modifications fréquemment pour éviter de perdre votre travail
- **Soyez descriptif**: Utilisez des titres de commit clairs pour faciliter le suivi des modifications
- **Respectez la structure**: Ne modifiez pas la structure des fichiers Markdown existants
- **Demandez de l'aide**: Si vous n'êtes pas sûr, demandez à un membre de l'équipe technique

## Syntaxe Markdown de base

Markdown est un langage de balisage simple:

- `# Titre` : Crée un titre principal
- `## Sous-titre` : Crée un sous-titre
- `**Texte en gras**` : Met le texte en gras
- `*Texte en italique*` : Met le texte en italique
- `[Texte du lien](URL)` : Crée un lien hypertexte
- `![Texte alternatif](URL-de-l-image)` : Insère une image
- `- Élément de liste` : Crée une liste à puces

Pour plus d'informations sur la syntaxe Markdown, consultez le [Guide Markdown](https://www.markdownguide.org/basic-syntax/).

## Besoin d'aide?

Si vous rencontrez des difficultés ou avez des questions, n'hésitez pas à contacter l'administrateur du dépôt ou à consulter le fichier `STRUCTURE_CONTENU.md` pour plus de détails sur l'organisation du contenu.