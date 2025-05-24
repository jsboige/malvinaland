# Guide de Demarrage Rapide pour Malvinaland

Chere Malvina,

Ce guide vous aidera a demarrer rapidement avec le site Malvinaland. Il contient les informations essentielles pour naviguer, gerer et maintenir le site.

## Table des matieres

1. [Acces au tableau de bord](#acces-au-tableau-de-bord)
2. [Consultation du site web](#consultation-du-site-web)
3. [Modification du contenu](#modification-du-contenu)
4. [Deploiement des modifications](#deploiement-des-modifications)
5. [Resolution des problemes courants](#resolution-des-problemes-courants)
6. [Ameliorations futures](#ameliorations-futures)
7. [Calendrier de maintenance](#calendrier-de-maintenance)
8. [Ressources complementaires](#ressources-complementaires)

## Acces au tableau de bord

Le tableau de bord est votre point d'entree principal pour gerer le site Malvinaland.

1. Ouvrez l'Explorateur de fichiers
2. Naviguez jusqu'au dossier du projet: `d:\Production\malvinaland`
3. Double-cliquez sur le dossier `tableau-de-bord`
4. Ouvrez le fichier `index.html` dans votre navigateur

Le tableau de bord vous donne acces a:
- Les differents mondes de Malvinaland
- La carte interactive
- Les personnages
- Les guides de consultation et de modification
- Les outils de deploiement et de maintenance

## Consultation du site web

### En local (sur votre ordinateur)

1. Ouvrez PowerShell (clic droit sur le menu Demarrer > Windows PowerShell)
2. Naviguez jusqu'au dossier du projet: `cd d:\Production\malvinaland`
3. Executez le script: `.\temp-deploy-site-web.ps1`
4. Le site s'ouvrira automatiquement dans votre navigateur a l'adresse: `http://localhost:8080`

### En ligne

Le site est accessible a l'adresse: `https://malvinaland.myia.io/`

### Identifiants de test

Pour vous connecter en tant qu'administrateur:
- Nom d'utilisateur: `admin_malvina`
- Mot de passe: `Malv1n@2025!`

Pour plus d'identifiants de test, consultez le fichier: `site-web/content/organisateurs/identifiants-test.md`

### Structure du site

- **Page d'accueil**: `/index.html`
- **Carte interactive**: `/content/carte/index.html`
- **Mondes**: `/content/mondes/[nom-du-monde]/index.html`
- **Narration**: `/content/narration/index.html`
- **Personnages**: `/content/personnages/index.html`
- **Organisateurs**: `/content/organisateurs/index.html`
- **PNJ**: `/content/organisateurs/pnj/index.html`

### Fonctionnalites principales

#### Carte interactive

La carte interactive permet aux joueurs de naviguer entre les differents mondes. Pour y acceder, cliquez sur "Carte" dans le menu de navigation.

#### Navigation entre les mondes

Chaque monde est connecte a plusieurs autres mondes. Les liens vers les mondes voisins sont disponibles en bas de chaque page de monde.

#### Authentification

- Les organisateurs peuvent se connecter via la page de connexion: `/content/login/index.html`
- Une fois connecte, vous aurez acces a des fonctionnalites supplementaires

## Modification du contenu

### Utilisation du tableau de bord

Le moyen le plus simple de modifier le contenu est d'utiliser le tableau de bord:

1. Accedez au tableau de bord comme explique precedemment
2. Cliquez sur le monde ou la section que vous souhaitez modifier
3. Le fichier s'ouvrira dans votre editeur de texte par defaut
4. Modifiez le contenu selon vos besoins
5. Enregistrez le fichier

### Modification directe des fichiers

Vous pouvez egalement modifier directement les fichiers:

1. Naviguez jusqu'au dossier `contenu/` pour les fichiers source
2. Ou naviguez jusqu'au dossier `site-web/content/` pour les fichiers deployes
3. Ouvrez le fichier que vous souhaitez modifier dans votre editeur de texte prefere
4. Modifiez le contenu selon vos besoins
5. Enregistrez le fichier

### Format Markdown

La plupart des contenus sont ecrits en Markdown, un format simple a utiliser:

- `# Titre` pour un titre principal
- `## Sous-titre` pour un sous-titre
- `*texte en italique*` pour du texte en italique
- `**texte en gras**` pour du texte en gras
- `[texte du lien](URL)` pour un lien
- `![texte alternatif](chemin/vers/image.jpg)` pour une image

### Ajout d'images

Pour ajouter de nouvelles images:

1. Placez les images dans le dossier approprie: `ressources/images/mondes/[nom-du-monde]/`
2. Referencez-les dans les fichiers Markdown avec le chemin: `![Description](../../../ressources/images/mondes/[nom-du-monde]/[nom-image])`

## Deploiement des modifications

### Deploiement local pour test

Pour tester vos modifications localement avant de les deployer en ligne:

1. Ouvrez PowerShell
2. Naviguez jusqu'au dossier du projet: `cd d:\Production\malvinaland`
3. Executez le script: `.\temp-deploy-site-web.ps1`
4. Verifiez que vos modifications apparaissent correctement dans le navigateur

### Deploiement sur le serveur web

Pour deployer vos modifications sur le serveur web:

1. Ouvrez PowerShell
2. Naviguez jusqu'au dossier du projet: `cd d:\Production\malvinaland`
3. Executez le script: `.\outils-techniques\deploy-iis-simple.ps1`
4. Suivez les instructions a l'ecran
5. Une fois le deploiement termine, verifiez que vos modifications apparaissent correctement sur le site en ligne

## Resolution des problemes courants

### Menu mobile ne fonctionne pas
- Verifiez que le script `site-web/Core/menu-mobile-fix.js` est bien inclus dans la page
- Assurez-vous que les styles CSS pour le menu mobile sont correctement charges

### Carte interactive ne repond pas aux clics
- Verifiez que le script `site-web/assets/js/map-activator.js` est bien inclus dans la page de la carte
- Assurez-vous que les chemins dans les balises `<area>` sont corrects

### Images manquantes
- Verifiez que les images existent dans le bon dossier
- Assurez-vous que les chemins vers les images sont corrects dans les fichiers HTML ou Markdown

### Erreurs 404
- Verifiez que les fichiers existent aux emplacements references
- Assurez-vous que les liens dans les fichiers HTML ou Markdown sont corrects
- Executez le script `.\outils-techniques\verify-repository-health.ps1` pour verifier l'integrite du depot

## Ameliorations futures

Voici quelques suggestions d'ameliorations que vous pourriez envisager pour le site:

### Court terme (1-3 mois)
- Amelioration de l'experience mobile avec des tests sur differents appareils
- Ajout de plus d'images et de descriptions pour chaque monde
- Creation d'une FAQ pour les visiteurs

### Moyen terme (3-6 mois)
- Developpement d'une fonctionnalite de recherche pour faciliter la navigation
- Ajout d'une section "Actualites" pour annoncer les nouveautes
- Integration de medias interactifs (audio, video) pour enrichir l'experience

### Long terme (6-12 mois)
- Creation d'une application mobile dediee
- Developpement d'une experience en realite augmentee pour certains mondes
- Mise en place d'un systeme de commentaires et de partage sur les reseaux sociaux

## Calendrier de maintenance

Pour assurer le bon fonctionnement du site, voici un calendrier de maintenance recommande:

### Hebdomadaire
- Verifier que le site est accessible
- S'assurer que tous les liens fonctionnent correctement
- Executer le script `.\outils-techniques\clean-temp-files.ps1` pour nettoyer les fichiers temporaires

### Mensuel
- Mettre a jour le contenu des mondes avec de nouvelles informations
- Executer le script `.\outils-techniques\verify-repository-health.ps1` pour verifier l'integrite du depot
- Sauvegarder l'ensemble du depot

### Trimestriel
- Executer le script `.\outils-techniques\clean-repository-periodic.ps1` pour un nettoyage approfondi
- Verifier et mettre a jour les dependances du projet
- Tester le site sur differents navigateurs et appareils

### Annuel
- Revision complete du contenu
- Mise a jour majeure de la structure si necessaire
- Planification des nouvelles fonctionnalites pour l'annee a venir

## Ressources complementaires

Pour approfondir vos connaissances sur la gestion du site Malvinaland:

### Documentation interne
- [Guide de maintenance](guides/GUIDE_MAINTENANCE.md) - Informations detaillees sur la maintenance du site
- [Guide des PNJ](guides/GUIDE_PNJ.md) - Guide pour gerer les personnages non-joueurs
- [Guide de structure](guides/structure/GUIDE_STRUCTURE.md) - Comprendre l'organisation des fichiers

### Ressources externes
- [Guide Markdown](https://www.markdownguide.org/basic-syntax/) - Apprendre la syntaxe Markdown
- [HTML & CSS - MDN Web Docs](https://developer.mozilla.org/fr/docs/Web) - Documentation sur HTML et CSS
- [PowerShell Documentation](https://docs.microsoft.com/fr-fr/powershell/) - Documentation officielle PowerShell

### Support technique
En cas de probleme technique:
- Consultez la documentation dans le dossier `docs/`
- Contactez l'administrateur technique a l'adresse: admin@malvinaland.myia.io

---

Nous esperons que ce guide vous aidera a demarrer rapidement avec Malvinaland. N'hesitez pas a explorer le site et a vous familiariser avec ses fonctionnalites.

Bonne exploration des mondes de Malvinaland!
