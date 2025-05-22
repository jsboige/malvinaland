# 🖼️ Besoins en images pour Malvinaland

Ce document détaille les besoins en images pour chaque monde de Malvinaland. Il servira de guide pour l'agent chargé de générer les images manquantes.

## 📋 Vue d'ensemble

La nouvelle architecture de Malvinaland utilise des images pour illustrer les différents mondes. Ces images sont référencées dans les fichiers Markdown et sont affichées sur le site web généré. Pour que le site soit complet, il est nécessaire de générer des images pour chaque référence manquante.

### Structure des images

Les images sont organisées selon la structure suivante :

```
src/
└── assets/
    └── images/
        └── mondes/
            ├── assemblee/
            ├── grange/
            ├── jeux/
            └── reves/
```

## 🌍 Mondes migrés

Les mondes suivants ont été migrés vers la nouvelle architecture :

1. **Le Monde de l'Assemblée** (assemblee)
2. **Le Monde de la Grange** (grange)
3. **Le Monde des Jeux** (jeux)
4. **Le Monde des Rêves** (reves)

## 📷 Besoins spécifiques par monde

### Le Monde de l'Assemblée

Ce monde est caractérisé par deux cercles d'assemblée qui semblent suspendus hors du temps. Il est identifiable par sa couleur rouge sur la carte.

#### Images nécessaires :

1. **Le petit cercle d'assemblée**
   - Description : Un cercle modeste délimité par des rondins horizontaux posés au sol, formant un diamètre d'environ 5-6 mètres. À l'intérieur, 4-5 bancs rustiques et tables en bois brut sont disposés de manière irrégulière.
   - Chemin : `/assets/images/mondes/assemblee/cercle-petit.jpg`

2. **Structure aérienne avec toile blanche**
   - Description : Une structure aérienne légère, formée de perches verticales supportant une toile blanche tendue, offrant un abri partiel contre les éléments tout en laissant filtrer la lumière.
   - Chemin : `/assets/images/mondes/assemblee/structure-aerienne.jpg`

3. **Le grand cercle avec vasque**
   - Description : Un cercle plus imposant, constitué de 12 à 15 rondins de différentes tailles (entre 30 et 50 cm de hauteur) disposés en cercle autour d'une grande vasque métallique circulaire d'environ 1 mètre de diamètre, de couleur rouille/cuivrée, destinée aux feux.
   - Chemin : `/assets/images/mondes/assemblee/cercle-grand.jpg`

### Le Monde de la Grange

Ce monde est centré autour d'un bâtiment longitudinal avec quatre façades distinctives et un espace végétalisé. Il est identifiable par sa couleur verte sur la carte.

#### Images nécessaires :

1. **Vue extérieure de la grange**
   - Description : Un bâtiment longitudinal avec quatre façades distinctives, montrant l'architecture rustique et traditionnelle de la grange.
   - Chemin : `/assets/images/mondes/grange/exterieur-grange.jpg`

2. **Espace végétalisé**
   - Description : L'espace végétalisé autour de la grange, avec des plantes locales et des aménagements paysagers.
   - Chemin : `/assets/images/mondes/grange/espace-vegetalise.jpg`

3. **Intérieur de la grange**
   - Description : L'intérieur de la grange, montrant la structure en bois, les poutres apparentes et l'aménagement intérieur.
   - Chemin : `/assets/images/mondes/grange/interieur-grange.jpg`

### Le Monde des Jeux

Ce monde est décrit comme le Royaume de l'Enfance Éternelle, avec un grand trampoline octogonal au centre. Il est identifiable par sa couleur bleue sur la carte.

#### Images nécessaires :

1. **Trampoline octogonal**
   - Description : Un grand trampoline octogonal au centre du monde des jeux, entouré d'un espace dégagé.
   - Chemin : `/assets/images/mondes/jeux/trampoline.jpg`

2. **Zone de jeux**
   - Description : Une zone avec divers jeux et activités pour enfants, comme des balançoires, des toboggans, etc.
   - Chemin : `/assets/images/mondes/jeux/zone-jeux.jpg`

3. **Espace de détente**
   - Description : Un espace de détente à proximité de la zone de jeux, avec des bancs ou des chaises pour les adultes qui surveillent les enfants.
   - Chemin : `/assets/images/mondes/jeux/espace-detente.jpg`

### Le Monde des Rêves

Ce monde est un point de convergence mystique entre les différents mondes de Malvinhaland. Il est identifiable par sa couleur violette sur la carte.

#### Images nécessaires :

1. **Portail des rêves**
   - Description : Une structure ou un élément naturel qui évoque un portail ou un passage vers d'autres dimensions ou mondes.
   - Chemin : `/assets/images/mondes/reves/portail.jpg`

2. **Espace méditatif**
   - Description : Un espace propice à la méditation et à la réflexion, peut-être avec des éléments comme des pierres disposées en cercle, des symboles gravés, etc.
   - Chemin : `/assets/images/mondes/reves/espace-meditatif.jpg`

3. **Symboles mystiques**
   - Description : Des symboles ou des inscriptions mystiques qui pourraient être gravés sur des pierres, des arbres ou d'autres éléments naturels.
   - Chemin : `/assets/images/mondes/reves/symboles.jpg`

## 🎨 Style et cohérence

Pour assurer une cohérence visuelle entre les différentes images, voici quelques recommandations :

1. **Style artistique** : Les images devraient avoir un style cohérent, idéalement photographique ou réaliste, mais avec une touche mystique ou féerique qui correspond à l'univers de Malvinaland.

2. **Palette de couleurs** : Chaque monde a sa couleur dominante (rouge pour l'Assemblée, vert pour la Grange, bleu pour les Jeux, violet pour les Rêves). Cette couleur devrait être présente ou suggérée dans les images correspondantes.

3. **Ambiance** : L'ambiance générale devrait être mystérieuse et invitante, suggérant un univers riche en histoires et en énigmes.

4. **Résolution** : Les images devraient être de haute résolution (au moins 1200x800 pixels) pour permettre un affichage de qualité sur le site.

## 📋 Processus de génération

Pour générer les images manquantes, suivez ces étapes :

1. **Exécuter le script d'identification des images manquantes**
   ```powershell
   .\scripts\identify-missing-images.ps1 -GeneratePlaceholders
   ```

2. **Consulter le rapport généré** (`missing-images-report.md`) qui liste toutes les images manquantes

3. **Générer les images** en suivant les descriptions fournies dans ce document et dans le rapport

4. **Placer les images** dans les dossiers correspondants selon les chemins indiqués

5. **Optimiser les images** en exécutant le script d'optimisation
   ```bash
   npm run optimize-images
   ```

## 🔄 Mise à jour du document

Ce document sera mis à jour au fur et à mesure que de nouveaux besoins en images seront identifiés. Si vous avez des questions ou des suggestions concernant les images, n'hésitez pas à contacter l'équipe de développement.