# Structure du contenu de Malvinaland

Ce document explique l'organisation des fichiers de contenu dans le projet Malvinaland, la syntaxe Markdown utilisée, et comment ajouter ou modifier du contenu pour les mondes et les personnages non-joueurs (PNJ).

## Organisation des fichiers Markdown

Tout le contenu du site est stocké sous forme de fichiers Markdown (`.md`) dans le dossier `src/content/`. Cette approche permet une édition facile et un suivi des modifications via GitHub.

### Structure des dossiers

```
src/content/
│
├── index.md                 # Page d'accueil
├── carte.md                 # Page de la carte
├── narration.md             # Page de narration
├── login.md                 # Page de connexion
│
├── mondes/                  # Dossier contenant tous les mondes
│   ├── assemblee/           # Un monde spécifique
│   │   └── index.md         # Contenu du monde
│   ├── damier/
│   ├── elysee/
│   ├── grange/
│   ├── jeux/
│   ├── karibu/
│   ├── linge/
│   ├── reves/
│   ├── sphinx/
│   ├── verger/
│   └── zob/
│
└── organisateurs/           # Contenu réservé aux organisateurs
    ├── index.md             # Page principale des organisateurs
    └── pnj/                 # Personnages non-joueurs
        ├── index.md         # Liste des PNJ
        ├── celestine/       # Dossier pour un PNJ spécifique
        ├── lili/
        ├── gardien-verger/
        ├── collectionneur/
        └── princesse/
```

## Structure d'un fichier Markdown de monde

Chaque monde est décrit dans un fichier `index.md` situé dans son propre dossier. Voici la structure typique d'un tel fichier:

```markdown
---
layout: layouts/monde.njk
title: Nom du Monde
monde: identifiant-du-monde
---

## 🏞️ Introduction et description du lieu

Description détaillée du lieu physique...

<div class="monde-gallery">
  <img src="/assets/images/mondes/nom-du-monde/image1.jpg" data-high-res="/assets/images/mondes/nom-du-monde/image1.jpg" alt="Description de l'image">
  <img src="/assets/images/mondes/nom-du-monde/image2.jpg" data-high-res="/assets/images/mondes/nom-du-monde/image2.jpg" alt="Description de l'image">
</div>

## 🎭 Ambiance et atmosphère

Description de l'ambiance et des sensations...

## 📚 Histoire locale

Histoire et légendes du lieu...

::: organisateurs-only
### Notes pour les organisateurs

Informations réservées aux organisateurs...
:::

## 🧩 Énigmes proposées dans ce monde

### 🔐 Énigme 1 – Titre de l'énigme

Description de l'énigme...

> *"Texte de l'énigme tel qu'il est présenté aux joueurs..."*

::: organisateurs-only
#### Solution de l'énigme 1

Explication détaillée de la solution...
:::
```

## Structure d'un fichier Markdown de PNJ

Les personnages non-joueurs sont décrits dans des fichiers situés dans le dossier `src/content/organisateurs/pnj/`. Voici la structure typique:

```markdown
---
layout: layouts/organisateur.njk
title: Nom du PNJ - Malvinaland
---

# Nom du PNJ

![Nom du PNJ](/assets/images/pnj/image-du-pnj.jpg)

**Rôle** : Description du rôle dans le jeu
**Âge** : Âge du personnage
**Apparence** : Description physique
**Voix** : Caractéristiques de la voix
**Gestuelle** : Description des mouvements et attitudes

**Accessoires caractéristiques** :
- Accessoire 1
- Accessoire 2
- Accessoire 3

**Traits de personnalité** : Description du caractère et de la personnalité

**Phrases récurrentes** :
- "Phrase typique 1"
- "Phrase typique 2"
- "Phrase typique 3"

**Présence dans les mondes** : Liste des mondes où ce PNJ peut apparaître

## Interactions avec les joueurs

Description des interactions possibles...

## Connaissances et indices

Liste des informations que le PNJ peut partager...

## Dialogues spécifiques aux énigmes

### Énigme du Monde X

Dialogues liés à cette énigme...
```

## Syntaxe Markdown de base

Markdown est un langage de balisage léger qui permet de formater du texte de manière simple. Voici les éléments de syntaxe les plus courants:

### Titres

```markdown
# Titre principal (H1)
## Titre secondaire (H2)
### Titre tertiaire (H3)
#### Titre quaternaire (H4)
```

### Formatage de texte

```markdown
**Texte en gras**
*Texte en italique*
***Texte en gras et italique***
~~Texte barré~~
```

### Listes

```markdown
- Élément de liste à puces
- Autre élément
  - Sous-élément (indenter avec 2 espaces)

1. Élément de liste numérotée
2. Deuxième élément
   1. Sous-élément numéroté
```

### Liens et images

```markdown
[Texte du lien](https://www.exemple.com)

![Texte alternatif de l'image](/chemin/vers/image.jpg)
```

### Citations

```markdown
> Ceci est une citation.
> Elle peut s'étendre sur plusieurs lignes.
```

### Contenu réservé aux organisateurs

Pour marquer du contenu comme visible uniquement pour les organisateurs:

```markdown
::: organisateurs-only
Ce contenu ne sera visible que pour les organisateurs.
:::
```

### Galeries d'images

Pour créer une galerie d'images dans un monde:

```markdown
<div class="monde-gallery">
  <img src="/assets/images/mondes/nom-du-monde/image1.jpg" data-high-res="/assets/images/mondes/nom-du-monde/image1.jpg" alt="Description de l'image">
  <img src="/assets/images/mondes/nom-du-monde/image2.jpg" data-high-res="/assets/images/mondes/nom-du-monde/image2.jpg" alt="Description de l'image">
</div>
```

## Comment ajouter/modifier du contenu pour les mondes

### Modifier un monde existant

1. Naviguez vers le dossier du monde dans `src/content/mondes/[nom-du-monde]/`
2. Ouvrez le fichier `index.md`
3. Modifiez le contenu en respectant la structure existante
4. Validez vos modifications (commit)

### Ajouter un nouveau monde

1. Créez un nouveau dossier dans `src/content/mondes/` avec le nom du monde (en minuscules, sans espaces)
2. Créez un fichier `index.md` dans ce dossier
3. Utilisez le modèle de monde disponible dans `templates/nouveau-monde.md`
4. Remplissez les informations du monde
5. Ajoutez les images du monde dans le dossier `assets/images/mondes/[nom-du-monde]/`
6. Mettez à jour le fichier `src/_data/mondes.js` pour inclure le nouveau monde dans la navigation

## Comment ajouter/modifier du contenu pour les PNJ

### Modifier un PNJ existant

1. Naviguez vers le dossier du PNJ dans `src/content/organisateurs/pnj/[nom-du-pnj]/`
2. Ouvrez le fichier `index.md`
3. Modifiez le contenu en respectant la structure existante
4. Validez vos modifications (commit)

### Ajouter un nouveau PNJ

1. Créez un nouveau dossier dans `src/content/organisateurs/pnj/` avec le nom du PNJ (en minuscules, sans espaces)
2. Créez un fichier `index.md` dans ce dossier
3. Utilisez le modèle de PNJ disponible dans `templates/nouveau-pnj.md`
4. Remplissez les informations du PNJ
5. Ajoutez l'image du PNJ dans le dossier `assets/images/pnj/`
6. Mettez à jour le fichier `src/content/organisateurs/pnj/index.md` pour inclure le nouveau PNJ dans la liste

## Conseils pour la rédaction du contenu

- **Soyez cohérent** : Assurez-vous que le contenu que vous ajoutez est cohérent avec l'univers existant
- **Utilisez des émojis** : Les émojis en début de section aident à la navigation visuelle
- **Pensez aux joueurs** : Rédigez le contenu de manière à guider les joueurs sans tout leur révéler
- **Séparez clairement** : Utilisez les balises `organisateurs-only` pour le contenu réservé
- **Optimisez les images** : Assurez-vous que les images sont optimisées pour le web (taille raisonnable)
- **Testez vos modifications** : Après avoir modifié du contenu, vérifiez que le site s'affiche correctement

Pour plus d'informations sur la génération du site et le déploiement, consultez le fichier `WORKFLOW.md`.