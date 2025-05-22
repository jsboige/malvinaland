# Ressources de Malvinaland

Ce dossier contient toutes les ressources statiques utilisées par le site Malvinaland, notamment les fichiers CSS, JavaScript et les images.

## Structure du dossier

```
assets/
├── css/             # Feuilles de style CSS
│   ├── main.css     # Styles principaux du site
│   ├── monde.css    # Styles spécifiques aux pages de mondes
│   └── organisateur.css # Styles pour les pages organisateurs
│
├── js/              # Scripts JavaScript
│   ├── auth.js      # Gestion de l'authentification
│   ├── image-loader.js # Chargement optimisé des images
│   └── navigation.js # Gestion de la navigation
│
└── images/          # Images du site
    ├── mondes/      # Images des différents mondes
    │   ├── assemblee/
    │   ├── damier/
    │   └── ...
    ├── pnj/         # Images des personnages non-joueurs
    └── ui/          # Images de l'interface utilisateur
```

## Comment ajouter ou modifier des ressources

### Ajouter des images

1. **Pour un monde**:
   - Placez les images dans le dossier correspondant: `images/mondes/[nom-du-monde]/`
   - Utilisez des noms de fichiers descriptifs et en minuscules
   - Optimisez les images pour le web (taille et poids raisonnables)

2. **Pour un PNJ**:
   - Placez les images dans le dossier `images/pnj/`
   - Nommez l'image avec le nom du PNJ (en minuscules, sans espaces)

### Référencer des images dans le contenu Markdown

Pour afficher une image dans un fichier Markdown:

```markdown
![Texte alternatif](/assets/images/mondes/nom-du-monde/nom-image.jpg)
```

Pour créer une galerie d'images:

```markdown
<div class="monde-gallery">
  <img src="/assets/images/mondes/nom-du-monde/image1.jpg" data-high-res="/assets/images/mondes/nom-du-monde/image1.jpg" alt="Description de l'image">
  <img src="/assets/images/mondes/nom-du-monde/image2.jpg" data-high-res="/assets/images/mondes/nom-du-monde/image2.jpg" alt="Description de l'image">
</div>
```

### Modifier les styles CSS

Les fichiers CSS sont organisés selon leur fonction:

- **main.css**: Styles globaux du site (header, footer, navigation, etc.)
- **monde.css**: Styles spécifiques aux pages de mondes
- **organisateur.css**: Styles pour les pages réservées aux organisateurs

Si vous devez modifier l'apparence du site:

1. Identifiez le fichier CSS approprié
2. Effectuez vos modifications
3. Testez les changements en local avant de les déployer

### Modifier les scripts JavaScript

Les scripts JavaScript gèrent les fonctionnalités interactives du site:

- **auth.js**: Gestion de l'authentification des organisateurs
- **image-loader.js**: Chargement optimisé des images et galeries
- **navigation.js**: Gestion de la navigation et des transitions

Si vous devez modifier le comportement du site:

1. Identifiez le script JavaScript approprié
2. Effectuez vos modifications
3. Testez les changements en local avant de les déployer

## Bonnes pratiques

### Pour les images

- **Optimisez les images** avant de les ajouter (utilisez des outils comme ImageOptim, TinyPNG, etc.)
- **Utilisez des formats adaptés**: JPG pour les photos, PNG pour les images avec transparence, SVG pour les icônes
- **Dimensions raisonnables**: Évitez les images trop grandes (max 1920px de large)
- **Nommez clairement** vos fichiers avec des noms descriptifs
- **Ajoutez toujours un texte alternatif** pour l'accessibilité

### Pour le CSS

- **Respectez l'organisation** existante des styles
- **Commentez vos modifications** pour faciliter la maintenance
- **Testez sur différents appareils** (desktop, tablette, mobile)

### Pour le JavaScript

- **Documentez votre code** avec des commentaires
- **Testez vos modifications** sur différents navigateurs
- **Évitez de modifier** les fonctionnalités critiques sans comprendre leur fonctionnement

## Optimisation des images

Pour optimiser les images avant de les ajouter au projet, vous pouvez utiliser le script `scripts/optimize-images.js`:

```
node scripts/optimize-images.js chemin/vers/votre/image.jpg
```

Ce script redimensionnera et compressera automatiquement l'image pour une utilisation optimale sur le web.

## Ressources utiles

- [Guide d'optimisation des images](https://web.dev/fast/#optimize-your-images)
- [Documentation CSS MDN](https://developer.mozilla.org/fr/docs/Web/CSS)
- [Documentation JavaScript MDN](https://developer.mozilla.org/fr/docs/Web/JavaScript)

Pour plus d'informations sur la modification du contenu, consultez le fichier `COMMENT_MODIFIER.md` à la racine du projet.