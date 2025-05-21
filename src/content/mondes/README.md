# Mondes de Malvinaland

Ce dossier contient tous les mondes de Malvinaland. Chaque monde est représenté par un sous-dossier contenant au minimum un fichier `index.md` qui décrit le monde.

## Liste des mondes actuels

- **assemblee/** - Le Monde de l'Assemblée
- **damier/** - Le Monde du Damier
- **elysee/** - Le Monde Elysée
- **grange/** - Le Monde de la Grange
- **jeux/** - Le Monde des Jeux
- **karibu/** - Le Monde Karibu
- **linge/** - Le Monde du Linge
- **reves/** - Le Monde des Rêves
- **sphinx/** - Le Monde Orange des Sphinx
- **verger/** - Le Monde du Verger
- **zob/** - Le Monde du Zob

## Structure d'un monde

Chaque monde est organisé de la même façon:

```
mondes/
└── [nom-du-monde]/
    ├── index.md         # Description principale du monde
    └── [autres-fichiers] # Fichiers supplémentaires si nécessaire
```

Le fichier `index.md` contient toutes les informations sur le monde:
- Description du lieu
- Ambiance et atmosphère
- Histoire locale
- Énigmes proposées
- Notes pour les organisateurs (visibles uniquement par les organisateurs)

## Comment modifier un monde existant

1. Naviguez vers le dossier du monde que vous souhaitez modifier
2. Ouvrez le fichier `index.md`
3. Effectuez vos modifications en respectant la structure existante
4. Validez vos modifications (commit)

### Sections typiques d'un monde

Les mondes suivent généralement cette structure:

```markdown
---
layout: layouts/monde.njk
title: Nom du Monde
monde: identifiant-du-monde
---

## 🏞️ Introduction et description du lieu
...

## 🎭 Ambiance et atmosphère
...

## 📚 Histoire locale
...

::: organisateurs-only
### Notes pour les organisateurs
...
:::

## 🧩 Énigmes proposées dans ce monde

### 🔐 Énigme 1 – Titre de l'énigme
...

::: organisateurs-only
#### Solution de l'énigme 1
...
:::
```

## Comment ajouter un nouveau monde

1. Créez un nouveau dossier dans `mondes/` avec le nom du monde (en minuscules, sans espaces)
2. Créez un fichier `index.md` dans ce dossier en utilisant le modèle disponible dans `templates/nouveau-monde.md`
3. Remplissez toutes les sections du modèle avec vos propres informations
4. Ajoutez les images du monde dans le dossier `assets/images/mondes/[nom-du-monde]/`
5. Mettez à jour le fichier `src/_data/mondes.js` pour inclure le nouveau monde dans la navigation

### Mise à jour du fichier mondes.js

Pour ajouter votre monde à la navigation, vous devez modifier le fichier `src/_data/mondes.js`:

```javascript
module.exports = [
  // ... autres mondes ...
  {
    name: "Nom du Monde",
    slug: "nom-du-monde",
    color: "#HEXCODE", // Code couleur pour la carte
    position: { x: 123, y: 456 }, // Position sur la carte
    description: "Brève description du monde"
  },
  // ... autres mondes ...
];
```

## Conseils pour la création et la modification des mondes

- **Soyez cohérent** avec l'univers global de Malvinaland
- **Utilisez des émojis** en début de section pour améliorer la lisibilité
- **Incluez des images** pour illustrer le monde
- **Détaillez les énigmes** avec leurs solutions dans les sections organisateurs-only
- **Pensez aux connexions** avec les autres mondes
- **Respectez le ton** et l'ambiance générale du jeu

## Ressources utiles

- [Modèle de nouveau monde](../../../templates/nouveau-monde.md)
- [Modèle de nouvelle énigme](../../../templates/nouvelle-enigme.md)
- [Guide de syntaxe Markdown](https://www.markdownguide.org/basic-syntax/)

Pour plus d'informations sur la modification du contenu, consultez le fichier `COMMENT_MODIFIER.md` à la racine du projet.