# Guide de Développement pour Malvinaland

Ce guide explique les procédures de développement pour le projet Malvinaland, notamment comment ajouter un nouveau monde, modifier la carte, mettre à jour le contenu existant et les conventions de code à suivre.

## Table des matières

1. [Comment ajouter un nouveau monde](#comment-ajouter-un-nouveau-monde)
2. [Comment modifier la carte](#comment-modifier-la-carte)
3. [Comment mettre à jour le contenu existant](#comment-mettre-à-jour-le-contenu-existant)
4. [Conventions de code à suivre](#conventions-de-code-à-suivre)

## Comment ajouter un nouveau monde

L'ajout d'un nouveau monde à Malvinaland implique plusieurs étapes, de la création des fichiers nécessaires à la configuration du monde dans le système.

### Étape 1 : Créer la structure de dossiers

1. Créez un nouveau dossier dans `Mondes/` avec le nom du monde (par exemple, `Le monde du jardin`)
2. Créez les fichiers de base suivants dans ce dossier :
   - `index.html` : Page principale du monde
   - `script.js` : Scripts spécifiques au monde
   - `styles.css` : Styles spécifiques au monde
   - `README.md` : Documentation du monde (énigmes, histoire, etc.)

### Étape 2 : Créer le contenu HTML

Créez le fichier `index.html` en utilisant la structure suivante comme modèle :

```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Le monde du [Nom] - Les mondes de Malvinha</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="../../Core/styles.css">
    <script src="script.js" defer></script>
    <script src="../../Core/navigation.js" defer></script>
    <script src="../../Core/image-loader.js" defer></script>
</head>
<body>
    <header>
        <h1>Le monde du [Nom]</h1>
        <nav id="desktop-nav">
            <ul>
                <li><a href="../../index.html">Accueil</a></li>
                <li><a href="../../carte.html">Carte</a></li>
                <li><a href="#description">Description</a></li>
                <li><a href="#enigmes">Énigmes</a></li>
                <li><a href="#histoire">Histoire</a></li>
            </ul>
        </nav>
        
        <!-- Menu mobile -->
        <button id="mobile-nav-toggle" aria-expanded="false" aria-label="Menu de navigation">
            <span class="bar"></span>
            <span class="bar"></span>
            <span class="bar"></span>
        </button>
        
        <nav id="mobile-nav" aria-hidden="true">
            <ul>
                <li><a href="../../index.html">Accueil</a></li>
                <li><a href="../../carte.html">Carte</a></li>
                <li><a href="#description">Description</a></li>
                <li><a href="#enigmes">Énigmes</a></li>
                <li><a href="#histoire">Histoire</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <section id="description">
            <h2>Description du lieu</h2>
            <p>Description détaillée du monde...</p>
            
            <div class="gallery">
                <!-- Les images seront ajoutées ici -->
            </div>
        </section>
        
        <section id="enigmes">
            <h2>Énigmes</h2>
            <ul>
                <li>Énigme 1 - [Nom de l'énigme]</li>
                <li>Énigme 2 - [Nom de l'énigme]</li>
                <li>Énigme 3 - [Nom de l'énigme]</li>
            </ul>
        </section>
        
        <section id="histoire">
            <h2>Histoire locale</h2>
            <p>Histoire du monde...</p>
        </section>
    </main>
    <footer>
        <p>&copy; 2025 Les mondes de Malvinha</p>
        <div class="footer-navigation">
            <a href="../../index.html">Accueil</a> |
            <a href="../../carte.html">Carte</a>
        </div>
    </footer>
</body>
</html>
```

### Étape 3 : Créer les styles CSS

Créez le fichier `styles.css` avec les styles spécifiques au monde :

```css
/* Styles spécifiques au monde */
:root {
    --monde-color: #HEXCODE; /* Couleur spécifique au monde */
}

body {
    background-color: var(--monde-color, #f5f5f5);
    background-image: linear-gradient(to bottom, rgba(255, 255, 255, 0.9), rgba(255, 255, 255, 0.7));
}

.gallery {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 20px;
    margin: 30px 0;
}

.gallery-image {
    width: 100%;
    height: auto;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease;
}

.gallery-image:hover {
    transform: scale(1.05);
}

/* Styles spécifiques aux sections */
#description {
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.8);
    border-radius: 10px;
    margin-bottom: 30px;
}

#enigmes {
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.8);
    border-radius: 10px;
    margin-bottom: 30px;
}

#histoire {
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.8);
    border-radius: 10px;
}
```

### Étape 4 : Créer le script JavaScript

Créez le fichier `script.js` avec les fonctionnalités spécifiques au monde :

```javascript
/**
 * Script spécifique au monde du [Nom]
 */
document.addEventListener('DOMContentLoaded', function() {
    // Initialisation spécifique au monde
    console.log('Monde du [Nom] chargé');
    
    // Exemple : Ajouter des interactions spécifiques aux éléments du monde
    const elements = document.querySelectorAll('.interactive-element');
    elements.forEach(element => {
        element.addEventListener('click', function() {
            // Action spécifique
        });
    });
});
```

### Étape 5 : Ajouter le monde à la configuration

Modifiez le fichier `Core/mondes-config.js` pour ajouter le nouveau monde :

```javascript
// Ajouter cette configuration à la liste des mondes
"monde-[id]": {
    id: "monde-[id]",
    nom: "Le Monde du [Nom]",
    couleur: "#HEXCODE", // Code couleur hexadécimal
    icone: "🌍", // Emoji représentatif
    description: "Description brève du monde.",
    position: {
        carte: "couleur",
        voisins: ["monde-voisin1", "monde-voisin2"] // Connexions avec d'autres mondes
    }
}
```

### Étape 6 : Ajouter le monde à la page d'accueil

Modifiez le fichier `Core/index.html` pour ajouter le nouveau monde à la liste des mondes dans la navigation et dans la section "Aperçu des mondes".

Dans la navigation :
```html
<li><a href="#monde-[id]">Monde du [Nom]</a></li>
```

Dans la section "Aperçu des mondes" :
```html
<div class="monde-card" onclick="location.href='#monde-[id]'">
    <h3>🌍 Le Monde du [Nom]</h3>
    <p>Description brève du monde.</p>
</div>
```

Ajoutez également une section complète pour le monde :
```html
<section id="monde-[id]">
    <h2>🌍 Le Monde du [Nom]</h2>
    <h3>🏞 Description du lieu</h3>
    <p>Description détaillée du monde...</p>
    <h3>🎭 Ambiance / inspiration</h3>
    <p>Description de l'ambiance...</p>
    <h3>📚 Histoire locale</h3>
    <p>Histoire du monde...</p>
    <h3>🧩 Énigmes proposées dans ce monde</h3>
    <ul>
        <li>🔐 Énigme 1 – [Nom ou court résumé]</li>
        <li>🔐 Énigme 2 – [Nom ou court résumé]</li>
        <li>🔐 Énigme 3 – [Nom ou court résumé]</li>
    </ul>
</section>
```

### Étape 7 : Ajouter le monde à la carte

Modifiez le fichier `carte.html` pour ajouter le nouveau monde à la carte interactive (voir la section [Comment modifier la carte](#comment-modifier-la-carte) pour plus de détails).

### Étape 8 : Ajouter des images

1. Créez un dossier `assets` dans le dossier du monde pour stocker les images originales
2. Placez les images haute résolution dans ce dossier
3. Exécutez le script `deploy.ps1` pour générer les miniatures et mettre à jour les références

### Étape 9 : Tester le nouveau monde

1. Ouvrez le site localement pour vérifier que le nouveau monde s'affiche correctement
2. Testez la navigation vers et depuis le nouveau monde
3. Vérifiez que les images s'affichent correctement
4. Testez les fonctionnalités spécifiques au monde

### Étape 10 : Déployer les modifications

Suivez la procédure de déploiement décrite dans la [Documentation principale](DOCUMENTATION.md#processus-de-déploiement-sur-iis) pour déployer les modifications sur le serveur.

## Comment modifier la carte

La carte de Malvinaland est un élément central du site qui permet aux utilisateurs de naviguer entre les différents mondes. Voici comment la modifier :

### Modification de l'image de la carte

1. La carte principale est stockée dans `Mondes/Carte de Malvinaland stylisée.png`
2. Pour modifier l'image de la carte :
   - Créez une nouvelle version de l'image avec un logiciel d'édition d'image
   - Assurez-vous de conserver les mêmes dimensions que l'image originale
   - Remplacez l'image existante par la nouvelle version
   - Exécutez le script `deploy.ps1` pour mettre à jour les références

### Modification des zones cliquables

La carte interactive utilise des zones cliquables (image map) définies dans le fichier `carte.html`. Pour modifier ces zones :

1. Ouvrez le fichier `carte.html`
2. Localisez la balise `<map name="carte-map">`
3. Modifiez les coordonnées des zones cliquables ou ajoutez-en de nouvelles :

```html
<area shape="poly" coords="x1,y1,x2,y2,x3,y3,..." alt="Nom du monde" href="Mondes/Le monde du [Nom]/index.html" data-monde="monde-[id]">
```

Pour déterminer les coordonnées d'une nouvelle zone :
1. Ouvrez l'image de la carte dans un éditeur d'image
2. Notez les coordonnées (x,y) des points qui définissent le polygone de la zone
3. Utilisez ces coordonnées dans l'attribut `coords` de la balise `<area>`

### Mise à jour des liens entre les mondes

Pour mettre à jour les connexions entre les mondes sur la carte :

1. Modifiez le fichier `Core/mondes-config.js`
2. Pour chaque monde, mettez à jour la propriété `voisins` dans l'objet `position` :

```javascript
position: {
    carte: "couleur",
    voisins: ["monde-voisin1", "monde-voisin2", "nouveau-monde-voisin"]
}
```

3. Ces connexions seront utilisées pour générer les liens de navigation entre les mondes

## Comment mettre à jour le contenu existant

### Mise à jour du contenu d'un monde

1. **Modifier le contenu HTML** :
   - Ouvrez le fichier `Mondes/Le monde du [Nom]/index.html`
   - Modifiez le contenu HTML selon vos besoins
   - Assurez-vous de respecter la structure existante

2. **Modifier les styles CSS** :
   - Ouvrez le fichier `Mondes/Le monde du [Nom]/styles.css`
   - Modifiez les styles selon vos besoins
   - Évitez de modifier les styles qui affectent la navigation ou la structure globale

3. **Modifier les scripts JavaScript** :
   - Ouvrez le fichier `Mondes/Le monde du [Nom]/script.js`
   - Modifiez les scripts selon vos besoins
   - Assurez-vous de ne pas interférer avec les fonctionnalités globales du site

### Ajout ou modification d'images

1. **Ajouter de nouvelles images** :
   - Placez les images haute résolution dans le dossier `Mondes/Le monde du [Nom]/assets/`
   - Exécutez le script `deploy.ps1` pour générer les miniatures
   - Mettez à jour les références dans les fichiers HTML

2. **Modifier des images existantes** :
   - Remplacez les images existantes dans le dossier `Mondes/Le monde du [Nom]/assets/`
   - Exécutez le script `deploy.ps1` pour régénérer les miniatures
   - Les références dans les fichiers HTML n'ont pas besoin d'être modifiées si les noms de fichiers restent les mêmes

3. **Ajouter des images à la galerie** :
   - Ouvrez le fichier `Mondes/Le monde du [Nom]/index.html`
   - Localisez la section `<div class="gallery">`
   - Ajoutez de nouvelles images en utilisant la structure suivante :

```html
<img src="thumbnails/image.jpg" data-high-res="../../ressources/images/Le monde du [Nom]/image.jpg" alt="Description de l'image" class="gallery-image">
```

### Mise à jour de la configuration des mondes

1. Ouvrez le fichier `Core/mondes-config.js`
2. Localisez l'objet correspondant au monde que vous souhaitez modifier
3. Mettez à jour les propriétés selon vos besoins :
   - `nom` : Nom complet du monde
   - `couleur` : Code couleur hexadécimal
   - `icone` : Emoji ou caractère représentant le monde
   - `description` : Brève description du monde
   - `position` : Informations sur la position du monde sur la carte et ses voisins

### Mise à jour de la page d'accueil

1. Ouvrez le fichier `Core/index.html`
2. Localisez la section correspondant au monde que vous souhaitez modifier
3. Mettez à jour le contenu selon vos besoins
4. Si vous modifiez la navigation, assurez-vous de mettre à jour à la fois la navigation desktop et mobile

### Déploiement des modifications

Après avoir effectué toutes les modifications nécessaires :

1. Testez les modifications localement pour vous assurer qu'elles fonctionnent correctement
2. Exécutez le script `deploy.ps1` pour mettre à jour la structure du site
3. Suivez la procédure de déploiement décrite dans la [Documentation principale](DOCUMENTATION.md#processus-de-déploiement-sur-iis) pour déployer les modifications sur le serveur

## Conventions de code à suivre

Pour maintenir la cohérence et la qualité du code dans le projet Malvinaland, veuillez suivre ces conventions de code :

### Conventions générales

1. **Indentation** : Utilisez 4 espaces pour l'indentation (pas de tabulations)
2. **Encodage** : Utilisez UTF-8 pour tous les fichiers
3. **Fins de ligne** : Utilisez LF (Unix-style) pour les fins de ligne
4. **Longueur de ligne** : Limitez les lignes à 120 caractères maximum
5. **Commentaires** : Commentez votre code de manière claire et concise
6. **Nommage des fichiers** : Utilisez des noms descriptifs en minuscules avec des tirets pour séparer les mots (par exemple, `monde-commun.js`)

### HTML

1. **Doctype** : Utilisez le doctype HTML5 (`<!DOCTYPE html>`)
2. **Langue** : Spécifiez toujours la langue avec l'attribut `lang` sur la balise `<html>`
3. **Métadonnées** : Incluez toujours les métadonnées essentielles (`charset`, `viewport`, `description`)
4. **Sémantique** : Utilisez des balises sémantiques appropriées (`<header>`, `<nav>`, `<main>`, `<section>`, `<footer>`, etc.)
5. **Accessibilité** : Incluez des attributs ARIA lorsque nécessaire et assurez-vous que le site est accessible
6. **Images** : Incluez toujours l'attribut `alt` pour les images
7. **Structure** :
   ```html
   <!DOCTYPE html>
   <html lang="fr">
   <head>
       <!-- Métadonnées -->
   </head>
   <body>
       <header>
           <!-- En-tête et navigation -->
       </header>
       <main>
           <!-- Contenu principal -->
       </main>
       <footer>
           <!-- Pied de page -->
       </footer>
   </body>
   </html>
   ```

### CSS

1. **Sélecteurs** : Utilisez des sélecteurs spécifiques mais évitez la sur-spécification
2. **Variables CSS** : Utilisez des variables CSS pour les couleurs, les tailles et autres valeurs réutilisables
3. **Media queries** : Utilisez des media queries pour rendre le site responsive
4. **Commentaires** : Commentez les sections principales du CSS
5. **Organisation** : Organisez le CSS par composants ou sections
6. **Préfixes** : Évitez les préfixes vendeurs inutiles (utilisez Autoprefixer si nécessaire)
7. **Structure** :
   ```css
   /* Variables globales */
   :root {
       --primary-color: #hexcode;
       --secondary-color: #hexcode;
   }

   /* Styles de base */
   body {
       /* ... */
   }

   /* Composants */
   .component {
       /* ... */
   }

   /* Media queries */
   @media (max-width: 768px) {
       /* ... */
   }
   ```

### JavaScript

1. **Strict mode** : Utilisez toujours le mode strict (`'use strict';`)
2. **Variables** : Utilisez `const` par défaut, `let` si nécessaire, évitez `var`
3. **Fonctions** : Préférez les fonctions fléchées pour les fonctions anonymes
4. **Événements** : Utilisez `addEventListener` plutôt que des attributs `on*` dans le HTML
5. **Commentaires** : Utilisez JSDoc pour documenter les fonctions
6. **Modules** : Organisez le code en modules lorsque c'est possible
7. **Structure** :
   ```javascript
   /**
    * Description de la fonction
    * @param {Type} paramName - Description du paramètre
    * @returns {Type} Description de la valeur de retour
    */
   function functionName(paramName) {
       'use strict';
       // Code...
       return result;
   }

   // Événements
   document.addEventListener('DOMContentLoaded', function() {
       // Initialisation...
   });
   ```

### Images

1. **Format** : Utilisez le format approprié selon le type d'image :
   - JPEG pour les photos
   - PNG pour les images avec transparence
   - SVG pour les icônes et illustrations vectorielles
   - WebP lorsque la compatibilité le permet
2. **Taille** : Optimisez les images pour le web (compression, dimensions appropriées)
3. **Nommage** : Utilisez des noms descriptifs en minuscules avec des tirets (par exemple, `monde-assemblee-cercle.jpg`)
4. **Organisation** : Stockez les images dans le dossier `assets/` de chaque monde

### Gestion des dépendances

1. **Bibliothèques externes** : Minimisez l'utilisation de bibliothèques externes
2. **Versions** : Spécifiez toujours une version précise pour les dépendances
3. **Documentation** : Documentez toutes les dépendances utilisées

### Tests

1. **Compatibilité** : Testez le site sur différents navigateurs et appareils
2. **Accessibilité** : Vérifiez l'accessibilité du site avec des outils comme WAVE ou Lighthouse
3. **Performance** : Optimisez les performances du site (temps de chargement, taille des fichiers, etc.)

### Gestion de version

1. **Commits** : Faites des commits atomiques avec des messages clairs et descriptifs
2. **Branches** : Utilisez des branches pour les nouvelles fonctionnalités ou corrections
3. **Pull requests** : Utilisez des pull requests pour la revue de code avant de fusionner dans la branche principale
4. **Versionnage** : Utilisez le versionnage sémantique pour les versions du site