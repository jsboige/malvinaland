# Guide simplifié pour modifier le contenu de Malvinaland

Ce guide vous explique comment modifier facilement le contenu du site Malvinaland, même si vous n'avez pas de connaissances techniques avancées.

## Avant de commencer

Pour modifier le contenu de Malvinaland, vous aurez besoin:
- D'un compte GitHub (gratuit)
- D'un navigateur web (Chrome, Firefox, Edge, Safari...)
- De connaissances basiques en Markdown (expliquées dans ce guide)

## Accéder aux fichiers à modifier

### 1. Accéder au dépôt GitHub

1. Ouvrez votre navigateur et allez sur GitHub (https://github.com)
2. Connectez-vous à votre compte
3. Accédez au dépôt Malvinaland (l'URL exacte vous sera communiquée par l'administrateur)

### 2. Naviguer vers les fichiers de contenu

Le contenu que vous pouvez modifier se trouve principalement dans le dossier `contenu`:

1. Cliquez sur le dossier `contenu` dans la liste des fichiers
2. Puis naviguez vers:
   - `mondes/` pour modifier les différents mondes
   - `personnages/` pour modifier les personnages
   - `carte/` pour modifier la carte

## Modifier un monde

### 1. Accéder au fichier du monde

1. Dans le dossier `contenu/mondes/`, cliquez sur le dossier du monde que vous souhaitez modifier (par exemple `assemblee`)
2. Cliquez sur le fichier `index.md` pour l'ouvrir

### 2. Modifier le contenu

1. Cliquez sur l'icône en forme de crayon (✏️) en haut à droite du contenu du fichier
2. Vous êtes maintenant dans l'éditeur de texte GitHub où vous pouvez modifier le contenu

### 3. Comprendre la structure du fichier

Chaque fichier de monde est structuré comme suit:

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

**Important**: 
- Ne modifiez pas la partie entre `---` au début du fichier
- Respectez les titres avec les symboles (par exemple `## 🏞️ Introduction`)
- Ne supprimez pas les sections existantes

### 4. Enregistrer vos modifications

1. Après avoir effectué vos modifications, faites défiler vers le bas de la page
2. Dans la section "Commit changes":
   - Ajoutez un titre court décrivant vos modifications (par exemple: "Mise à jour de la description du Monde de l'Assemblée")
   - Optionnellement, ajoutez une description plus détaillée
3. Sélectionnez l'option "Commit directly to the main branch"
4. Cliquez sur le bouton "Commit changes"

## Syntaxe Markdown de base

Le contenu des mondes est écrit en Markdown, un langage de balisage simple:

### Titres

```markdown
# Titre principal
## Titre de section
### Sous-section
```

### Texte formaté

```markdown
**Texte en gras**
*Texte en italique*
~~Texte barré~~
```

### Listes

```markdown
- Élément de liste à puces
- Autre élément

1. Élément de liste numérotée
2. Autre élément
```

### Liens

```markdown
[Texte du lien](https://www.exemple.com)
```

### Images

```markdown
![Texte alternatif](chemin/vers/image.jpg)
```

## Ajouter une énigme à un monde

Pour ajouter une nouvelle énigme à un monde:

1. Ouvrez le fichier du monde à modifier
2. Trouvez la section "Énigmes proposées dans ce monde"
3. Ajoutez votre nouvelle énigme à la suite des énigmes existantes:

```markdown
### 🔐 Énigme X – Titre de votre énigme

Description de votre énigme...

**Indice**: Un indice pour aider les joueurs...

**Solution**: La solution de l'énigme (cette partie sera visible uniquement par les organisateurs)
```

## Modifier la carte

La carte est un élément central de Malvinaland. Pour la modifier:

1. Accédez au fichier `contenu/carte/carte.md`
2. Suivez les instructions spécifiques dans le fichier pour modifier les descriptions des zones

## Vérifier vos modifications

Après avoir enregistré vos modifications:

1. Attendez quelques minutes pour que le site soit mis à jour
2. Visitez le site Malvinaland (https://malvinaland.myia.io/) pour voir vos modifications
3. Naviguez jusqu'à la page que vous avez modifiée pour vérifier que tout s'affiche correctement

## Bonnes pratiques

- **Faites des modifications régulières et petites** plutôt que de grandes modifications en une seule fois
- **Vérifiez toujours vos modifications** après les avoir publiées
- **Respectez le style et le ton** des contenus existants
- **N'hésitez pas à demander de l'aide** si vous n'êtes pas sûr de comment procéder

## Besoin d'aide?

Si vous rencontrez des difficultés pour modifier le contenu ou si vous avez des questions, n'hésitez pas à contacter l'administrateur du site à l'adresse suivante: **admin@malvinaland.myia.io**