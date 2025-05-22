# Personnages Non-Joueurs (PNJ) de Malvinaland

Ce dossier contient les informations sur les Personnages Non-Joueurs (PNJ) de Malvinaland. Ces personnages sont essentiels pour guider les joueurs, enrichir l'histoire et faciliter la résolution des énigmes.

## Liste des PNJ actuels

- **celestine/** - Madame Célestine de Lunargent (Interprète des Rêves)
- **lili/** - Liliane "Lili" Cœur-de-Lumière (Voyageuse Onirique)
- **gardien-verger/** - Le Gardien du Verger
- **collectionneur/** - Le Collectionneur d'Âmes
- **princesse/** - La Princesse Malvina

## Structure d'un PNJ

Chaque PNJ est organisé de la même façon:

```
pnj/
└── [nom-du-pnj]/
    └── index.md         # Description complète du PNJ
```

Le fichier `index.md` contient toutes les informations sur le PNJ:
- Caractéristiques principales (rôle, âge, apparence)
- Traits de personnalité
- Phrases récurrentes
- Interactions avec les joueurs
- Dialogues spécifiques aux énigmes

## Comment modifier un PNJ existant

1. Naviguez vers le dossier du PNJ que vous souhaitez modifier
2. Ouvrez le fichier `index.md`
3. Effectuez vos modifications en respectant la structure existante
4. Validez vos modifications (commit)

### Sections typiques d'un PNJ

Les fiches de PNJ suivent généralement cette structure:

```markdown
---
layout: layouts/organisateur.njk
title: Nom du PNJ - Malvinaland
---

# Nom du PNJ

![Nom du PNJ](/assets/images/pnj/image-du-pnj.jpg)

**Rôle** : Description du rôle
**Âge** : Âge du personnage
**Apparence** : Description physique
**Voix** : Caractéristiques de la voix
**Gestuelle** : Description des mouvements

**Accessoires caractéristiques** :
- Accessoire 1
- Accessoire 2
- Accessoire 3

**Traits de personnalité** : Description du caractère

**Phrases récurrentes** :
- "Phrase typique 1"
- "Phrase typique 2"
- "Phrase typique 3"

**Présence dans les mondes** : Liste des mondes où ce PNJ apparaît

## Interactions avec les joueurs
...

## Connaissances et indices
...

## Dialogues spécifiques aux énigmes
...
```

## Comment ajouter un nouveau PNJ

1. Créez un nouveau dossier dans `pnj/` avec le nom du PNJ (en minuscules, sans espaces)
2. Créez un fichier `index.md` dans ce dossier en utilisant le modèle disponible dans `templates/nouveau-pnj.md`
3. Remplissez toutes les sections du modèle avec vos propres informations
4. Ajoutez l'image du PNJ dans le dossier `assets/images/pnj/`
5. Mettez à jour le fichier `index.md` à la racine du dossier `pnj/` pour inclure le nouveau PNJ dans la liste

### Mise à jour de la liste des PNJ

Pour ajouter votre PNJ à la liste principale, vous devez modifier le fichier `index.md` à la racine du dossier `pnj/` en ajoutant un lien vers votre nouveau PNJ:

```markdown
## Fiches détaillées

Pour accéder aux fiches complètes de chaque PNJ, incluant les dialogues spécifiques pour chaque énigme et les variations selon les groupes d'âge, cliquez sur les liens ci-dessous :

- [Madame Célestine de Lunargent](/organisateurs/pnj/celestine/)
- [Liliane "Lili" Cœur-de-Lumière](/organisateurs/pnj/lili/)
- [Le Gardien du Verger](/organisateurs/pnj/gardien-verger/)
- [Le Collectionneur d'Âmes](/organisateurs/pnj/collectionneur/)
- [La Princesse Malvina](/organisateurs/pnj/princesse/)
- [Nom de votre nouveau PNJ](/organisateurs/pnj/nom-du-nouveau-pnj/)
```

## Conseils pour la création et la modification des PNJ

- **Créez des personnages mémorables** avec des traits distinctifs
- **Définissez des phrases caractéristiques** qui aident à identifier le personnage
- **Prévoyez des interactions** avec les différentes énigmes
- **Assurez la cohérence** avec l'univers global de Malvinaland
- **Pensez aux accessoires** qui aideront la personne incarnant le PNJ
- **Détaillez les connaissances** que le PNJ peut partager avec les joueurs
- **Incluez des conseils d'interprétation** pour aider les organisateurs

## Conseils pour l'interprétation des PNJ

### Préparation

1. **Familiarisez-vous avec l'histoire** : Connaissez bien le background et les motivations de votre personnage
2. **Pratiquez les phrases clés** : Maîtrisez les expressions caractéristiques pour les utiliser naturellement
3. **Préparez les accessoires** : Rassemblez tous les éléments nécessaires à votre costume
4. **Anticipez les questions** : Préparez des réponses aux questions probables des joueurs

### Pendant le jeu

1. **Restez dans le personnage** : Maintenez la voix, la gestuelle et l'attitude de votre PNJ
2. **Adaptez-vous aux joueurs** : Ajustez vos indices selon la progression et les difficultés rencontrées
3. **Guidez subtilement** : Aidez les joueurs sans résoudre les énigmes à leur place
4. **Créez des moments mémorables** : Utilisez des révélations dramatiques ou des moments d'émotion

## Ressources utiles

- [Modèle de nouveau PNJ](../../../../templates/nouveau-pnj.md)
- [Guide de syntaxe Markdown](https://www.markdownguide.org/basic-syntax/)

Pour plus d'informations sur la modification du contenu, consultez le fichier `COMMENT_MODIFIER.md` à la racine du projet.