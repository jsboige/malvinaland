# Guide de la structure du projet Malvinaland

Ce guide vous explique la structure simplifiée du projet Malvinaland, pour vous aider à comprendre son organisation et à naviguer facilement dans les fichiers.

## Vue d'ensemble

Le projet Malvinaland a été réorganisé pour être plus accessible et intuitif. Voici la nouvelle structure:

```
malvinaland/
├── contenu/               # Contenu modifiable du site
│   ├── mondes/            # Les différents mondes de Malvinaland
│   ├── personnages/       # Les personnages du jeu
│   └── carte/             # La carte interactive
├── site-web/              # Le site web généré (ne pas modifier directement)
├── guides/                # Documentation simplifiée
│   ├── consultation/      # Guide pour consulter le site
│   ├── modification/      # Guide pour modifier le contenu
│   └── structure/         # Ce guide que vous lisez
├── tableau-de-bord/       # Interface simplifiée pour gérer le site
├── outils-techniques/     # Scripts et outils (pour utilisateurs avancés)
└── archives-techniques/   # Anciens fichiers techniques (ne pas modifier)
```

## Le dossier "contenu"

C'est ici que se trouve tout le contenu que vous pouvez modifier. Ce dossier est organisé de manière intuitive:

### contenu/mondes/

Chaque monde de Malvinaland a son propre dossier:

```
contenu/mondes/
├── assemblee/       # Le Monde de l'Assemblée
├── damier/          # Le Monde du Damier
├── elysee/          # Le Monde Elysée
├── grange/          # Le Monde de la Grange
├── jeux/            # Le Monde des Jeux
├── karibu/          # Le Monde Karibu
├── linge/           # Le Monde du Linge
├── reves/           # Le Monde des Rêves
├── sphinx/          # Le Monde Orange des Sphinx
├── verger/          # Le Monde du Verger
└── zob/             # Le Monde du Zob
```

Dans chaque dossier de monde, vous trouverez un fichier `index.md` qui contient le contenu principal du monde.

### contenu/personnages/

Ce dossier contient les informations sur les personnages de Malvinaland.

### contenu/carte/

Ce dossier contient les fichiers liés à la carte interactive de Malvinaland.

## Le dossier "guides"

Ce dossier contient toute la documentation simplifiée pour vous aider à utiliser et gérer Malvinaland:

```
guides/
├── consultation/    # Comment consulter le site
├── modification/    # Comment modifier le contenu
└── structure/       # Comment comprendre la structure du projet
```

## Le dossier "tableau-de-bord"

Ce dossier contient une interface web simplifiée qui vous permet d'accéder facilement aux différentes parties du projet:

- Liste des mondes avec liens directs
- Accès aux guides
- Accès aux outils de base

Pour utiliser le tableau de bord, ouvrez simplement le fichier `tableau-de-bord/index.html` dans votre navigateur web.

## Le dossier "outils-techniques"

Ce dossier contient des scripts et des outils pour la maintenance et le déploiement du site. Ces outils sont principalement destinés aux utilisateurs avancés.

Les scripts les plus utiles sont:

- `deploy-site-local.ps1`: Pour déployer le site localement et le tester
- `clean-repository-simple.ps1`: Pour nettoyer le dépôt de façon simple

## Le dossier "archives-techniques"

Ce dossier contient d'anciens fichiers techniques qui ont été archivés pour ne pas encombrer la structure principale. Vous n'avez généralement pas besoin d'y accéder.

## Fichiers à la racine

À la racine du projet, vous trouverez quelques fichiers importants:

- `README.md`: Une présentation générale du projet
- `index.html`: La page d'accueil du site
- `manifest.json`: Un fichier technique pour le fonctionnement du site
- `service-worker.js`: Un fichier technique pour le fonctionnement du site

## Comment les fichiers sont transformés en site web

Le processus de transformation des fichiers Markdown en site web est géré automatiquement:

1. Vous modifiez les fichiers dans le dossier `contenu/`
2. Un système appelé Eleventy transforme ces fichiers en HTML
3. Les fichiers HTML sont placés dans le dossier `site-web/`
4. Le site web est mis à jour avec vos modifications

Vous n'avez pas besoin de comprendre ce processus technique pour modifier le contenu du site.

## Conseils pour naviguer dans la structure

- Utilisez le tableau de bord (`tableau-de-bord/index.html`) comme point de départ
- Consultez les guides dans le dossier `guides/` si vous avez des questions
- Modifiez uniquement les fichiers dans le dossier `contenu/`
- Ne modifiez pas les fichiers dans les dossiers `site-web/` et `archives-techniques/`

## Besoin d'aide?

Si vous avez des questions sur la structure du projet ou si vous ne trouvez pas un fichier particulier, n'hésitez pas à contacter l'administrateur du site à l'adresse suivante: **admin@malvinaland.myia.io**