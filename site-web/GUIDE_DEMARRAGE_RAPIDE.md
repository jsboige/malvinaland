# Guide de Démarrage Rapide pour Malvinaland

Chère Malvina,

Ce guide vous aidera à démarrer rapidement avec le site Malvinaland. Il contient les informations essentielles pour naviguer, gérer et maintenir le site.

## 🚀 Comment accéder au site

### En local (sur votre ordinateur)

1. Ouvrez PowerShell (clic droit sur le menu Démarrer > Windows PowerShell)
2. Naviguez jusqu'au dossier du projet: `cd d:\Production\malvinaland`
3. Exécutez le script: `.\temp-deploy-site-web.ps1`
4. Le site s'ouvrira automatiquement dans votre navigateur à l'adresse: `http://localhost:8080`

### En ligne

Le site est accessible à l'adresse: `https://malvinaland.myia.io/`

## 🔑 Identifiants de test

Pour vous connecter en tant qu'administrateur:
- Nom d'utilisateur: `admin_malvina`
- Mot de passe: `Malv1n@2025!`

Pour plus d'identifiants de test, consultez le fichier: `/content/organisateurs/identifiants-test.md`

## 🗺️ Structure du site

- **Page d'accueil**: `/index.html`
- **Carte interactive**: `/content/carte/index.html`
- **Mondes**: `/content/mondes/[nom-du-monde]/index.html`
- **Narration**: `/content/narration/index.html`
- **Personnages**: `/content/personnages/index.html`
- **Organisateurs**: `/content/organisateurs/index.html`
- **PNJ**: `/content/organisateurs/pnj/index.html`

## 📱 Fonctionnalités principales

### Carte interactive

La carte interactive permet aux joueurs de naviguer entre les différents mondes. Pour y accéder, cliquez sur "🗺️ Carte" dans le menu de navigation.

### Navigation entre les mondes

Chaque monde est connecté à plusieurs autres mondes. Les liens vers les mondes voisins sont disponibles en bas de chaque page de monde.

### Authentification

- Les organisateurs peuvent se connecter via la page de connexion: `/content/login/index.html`
- Une fois connecté, vous aurez accès à des fonctionnalités supplémentaires

## 🛠️ Maintenance courante

### Mise à jour du contenu

Pour modifier le contenu d'un monde:
1. Naviguez jusqu'au fichier correspondant dans le dossier `/content/mondes/[nom-du-monde]/index.html`
2. Modifiez le contenu selon vos besoins
3. Enregistrez le fichier

### Ajout d'images

Pour ajouter de nouvelles images:
1. Placez les images dans le dossier approprié: `/assets/images/mondes/[nom-du-monde]/`
2. Référencez-les dans les fichiers HTML avec le chemin: `/assets/images/mondes/[nom-du-monde]/[nom-image]`

### Résolution des problèmes courants

#### Menu mobile ne fonctionne pas
- Vérifiez que le script `/assets/js/fix-mobile-menu.js` est bien inclus dans la page
- Assurez-vous que les styles CSS pour le menu mobile sont correctement chargés

#### Carte interactive ne répond pas aux clics
- Vérifiez que le script `/assets/js/map-activator.js` est bien inclus dans la page de la carte
- Assurez-vous que les chemins dans les balises `<area>` sont corrects

#### Images manquantes
- Vérifiez que les images existent dans le bon dossier
- Assurez-vous que les chemins vers les images sont corrects dans les fichiers HTML

## 📞 Support

En cas de problème technique:
- Consultez la documentation dans le dossier `/docs/`
- Contactez l'administrateur technique à l'adresse: admin@malvinaland.myia.io

---

Nous espérons que ce guide vous aidera à démarrer rapidement avec Malvinaland. N'hésitez pas à explorer le site et à vous familiariser avec ses fonctionnalités.

Bonne exploration des mondes de Malvinaland!