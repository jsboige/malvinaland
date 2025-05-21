# Modèles pour Malvinaland

Ce dossier contient des modèles (templates) pour faciliter la création de nouveaux contenus pour Malvinaland. Ces modèles sont conçus pour être faciles à utiliser, même pour les personnes non-techniciennes.

## Modèles disponibles

### 1. Nouveau monde (`nouveau-monde.md`)

Ce modèle vous aide à créer un nouveau monde pour Malvinaland avec toutes les sections nécessaires:
- Introduction et description du lieu
- Ambiance et atmosphère
- Histoire locale
- Énigmes proposées
- Notes pour les organisateurs

### 2. Nouveau PNJ (`nouveau-pnj.md`)

Ce modèle vous aide à créer un nouveau Personnage Non-Joueur (PNJ) avec:
- Caractéristiques principales (rôle, âge, apparence)
- Traits de personnalité
- Phrases récurrentes
- Interactions avec les joueurs
- Dialogues spécifiques aux énigmes

### 3. Nouvelle énigme (`nouvelle-enigme.md`)

Ce modèle vous aide à concevoir une nouvelle énigme avec:
- Description pour les joueurs
- Mise en place
- Indices progressifs
- Solution complète
- Intégration narrative

## Comment utiliser ces modèles

### Méthode 1: Via l'interface GitHub (recommandée pour les non-techniciens)

1. Accédez au dépôt GitHub de Malvinaland
2. Naviguez jusqu'au dossier où vous souhaitez créer votre nouveau contenu (par exemple `src/content/mondes/` pour un nouveau monde)
3. Cliquez sur "Add file" puis "Create new file"
4. Nommez votre fichier (par exemple `nouveau-monde/index.md` pour un nouveau monde)
5. Ouvrez le modèle correspondant dans un autre onglet
6. Copiez le contenu du modèle et collez-le dans votre nouveau fichier
7. Remplacez tous les textes entre crochets `[...]` par vos propres informations
8. Cliquez sur "Commit new file" pour valider

### Méthode 2: En local (pour les utilisateurs avancés)

1. Clonez le dépôt sur votre ordinateur
2. Copiez le modèle approprié dans le dossier de destination
3. Renommez-le selon vos besoins
4. Éditez le fichier avec votre éditeur de texte préféré
5. Remplacez tous les textes entre crochets `[...]` par vos propres informations
6. Validez et poussez vos modifications

## Conseils pour l'utilisation des modèles

- **Remplacez tous les textes entre crochets** `[...]` par vos propres informations
- **Conservez la structure** des fichiers pour maintenir la cohérence du site
- **N'hésitez pas à supprimer** les sections qui ne s'appliquent pas à votre cas
- **Ajoutez des sections supplémentaires** si nécessaire
- **Respectez la syntaxe Markdown** pour le formatage (voir `STRUCTURE_CONTENU.md` pour plus d'informations)

## Après avoir créé un nouveau contenu

### Pour un nouveau monde

1. Ajoutez les images du monde dans le dossier `assets/images/mondes/[nom-du-monde]/`
2. Mettez à jour le fichier `src/_data/mondes.js` pour inclure le nouveau monde dans la navigation

### Pour un nouveau PNJ

1. Ajoutez l'image du PNJ dans le dossier `assets/images/pnj/`
2. Mettez à jour le fichier `src/content/organisateurs/pnj/index.md` pour inclure le nouveau PNJ dans la liste

### Pour une nouvelle énigme

1. Intégrez l'énigme dans le monde correspondant
2. Préparez le matériel physique nécessaire
3. Informez les autres organisateurs de cette nouvelle énigme

## Besoin d'aide?

Si vous avez des questions ou rencontrez des difficultés, n'hésitez pas à consulter les autres fichiers de documentation:
- `COMMENT_MODIFIER.md` pour des instructions détaillées sur la modification des fichiers
- `STRUCTURE_CONTENU.md` pour des informations sur la structure du contenu
- `WORKFLOW.md` pour comprendre le processus complet