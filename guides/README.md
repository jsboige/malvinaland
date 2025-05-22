# 🌍 Malvinaland - Jeu de Piste Immersif

Bienvenue dans le dépôt du jeu de piste immersif "Malvinaland", conçu pour la maison de campagne à Sabres. Cette aventure narrative et ludique propose un parcours d'énigmes à travers le jardin, les bâtiments et les espaces décorés de la propriété.

## 🎮 L'univers de Malvinaland

Malvinaland est un univers parallèle composé de plusieurs mondes interconnectés, chacun avec ses propres règles, habitants et défis. Ces mondes étaient autrefois en parfaite harmonie, reliés par des passages magiques permettant aux habitants de voyager librement entre eux. Cependant, un événement mystérieux a perturbé cet équilibre, isolant chaque monde et effaçant partiellement la mémoire collective.

Les participants incarnent des "Voyageurs", des êtres dotés de la capacité rare de traverser les frontières entre les mondes. Leur mission est de restaurer les connexions entre les différents mondes de Malvinaland en résolvant des énigmes et en accomplissant des quêtes spécifiques dans chaque royaume.

### 🧩 Concept du jeu

Le jeu propose une expérience immersive où les joueurs explorent physiquement différents espaces (les "mondes") de la propriété, interagissent avec des personnages non-joueurs (PNJ), et résolvent des énigmes pour progresser dans l'histoire. Chaque monde possède sa propre ambiance, son histoire locale et ses défis uniques.

Au fur et à mesure de leur progression, les joueurs collectent des "Fragments d'Unité" qui leur permettent de reconstituer l'histoire complète de Malvinaland et de restaurer les connexions entre les mondes.

## 🗺️ Les mondes de Malvinaland

Malvinaland est composé de 11 mondes distincts, chacun avec son propre thème et son ambiance unique :

- **🔥 Le Monde de l'Assemblée** - Un lieu mystique avec deux cercles d'assemblée qui semblent suspendus hors du temps.
- **🌍 Le Monde de la Grange** - Un bâtiment longitudinal avec quatre façades distinctives et un espace végétalisé.
- **🌍 Le Monde des Jeux** - Le Royaume de l'Enfance Éternelle, avec un grand trampoline octogonal au centre.
- **🌙 Le Monde des Rêves** - Un point de convergence mystique entre les différents mondes de Malvinaland.
- **🌞 Le Monde du Damier** - Un lieu dominé par un imposant panneau solaire photovoltaïque, symbole de l'énergie et de la précision mathématique.
- **🧵 Le Monde du Linge** - Un sanctuaire des traditions du lavage et de l'entretien du linge, avec une corde à linge bleue comme élément central.
- **🌳 Le Monde du Verger** - Un sanctuaire naturel abritant un modeste verger de jeunes arbres fruitiers variés.
- **🧘 Le Monde du Zob** - Un espace de contemplation centré autour d'une yourte octogonale avec une ouverture en forme d'étoile au sommet.
- **🏛️ Le Monde Elysée** - Un monde d'accueil constitué de deux caravanes résidentielles aux styles contrastés, symbolisant la diplomatie et le passage.
- **🔥 Le Monde Karibu** - Une cuisine d'été rustique incarnant l'hospitalité et l'accueil, point culminant de l'aventure.
- **🐱 Le Monde Orange des Sphinx** - Un domaine mystérieux dominé par une bâtisse aux murs orange vif, gardé par des sphinx félins.

## 👥 Les personnages

Le jeu met en scène plusieurs personnages non-joueurs (PNJ) qui guident, défient ou aident les joueurs dans leur quête. Parmi eux :

- **Le Gardien des Mondes** - Une figure mystérieuse qui possède une connaissance profonde de Malvinaland et guide les Voyageurs.
- **Le Collectionneur d'Âmes** - Une entité énigmatique qui aurait orchestré la séparation des mondes.
- **La Princesse Malvina** - Un personnage central qui contient en elle la Flamme Éternelle, essentielle à l'équilibre des mondes.

D'autres personnages peuplent les différents mondes, chacun avec sa propre histoire et ses motivations.

## 📋 Trame narrative

L'aventure se déroule en plusieurs actes :

1. **Prologue : L'appel des Voyageurs** - Les participants découvrent leur mission : restaurer l'harmonie entre les mondes.
2. **Acte I : La découverte des mondes** - Exploration des premiers mondes et collecte des premiers Fragments d'Unité.
3. **Acte II : La révélation** - Découverte que la séparation des mondes était délibérée.
4. **Acte III : La confrontation** - Accès au monde Karibu et confrontation avec le Collectionneur d'Âmes.
5. **Épilogue : L'équilibre retrouvé** - Utilisation des Fragments d'Unité pour établir un nouvel équilibre dans Malvinaland.

---

## 🛠️ Informations techniques

### Structure du dépôt

Le dépôt est organisé de la manière suivante:

#### Dossiers principaux

- **src/** - Contient la version principale du site web Malvinaland basée sur 11ty (Eleventy)
  - **_data/** - Données utilisées par 11ty (configurations des mondes, etc.)
  - **_includes/** - Layouts et composants réutilisables
  - **assets/** - Ressources statiques (CSS, JavaScript, etc.)
  - **content/** - Contenu principal du site en Markdown
    - **mondes/** - Pages spécifiques à chaque monde
    - **organisateurs/** - Pages réservées aux organisateurs
- **archive/** - Versions précédentes du site
- **ressources/** - Ressources utilisées par le site
  - **images/** - Images des différents mondes
- **scripts/** - Scripts utilitaires pour le déploiement et la maintenance

### Accès au site

**IMPORTANT** : Le site Malvinaland est accessible UNIQUEMENT via le domaine **https://malvinaland.myia.io/**.

Ce domaine pointe directement vers le répertoire `site` de ce dépôt via la configuration IIS. Il n'y a pas besoin de déploiement supplémentaire. Il suffit d'alimenter le répertoire `site` et IIS le servira automatiquement via le nom de domaine.

### Installation et développement

#### Prérequis

- Node.js (version recommandée: 16.x ou supérieure)
- npm (inclus avec Node.js)

#### Installation

1. Cloner le dépôt
2. Installer les dépendances:
   ```
   npm install
   ```

#### Développement local

Pour lancer le serveur de développement 11ty:

```
npm run dev
```

Le site sera accessible à l'adresse http://localhost:8080 (uniquement pour le développement local).

**Note** : Le développement local est uniquement destiné aux tests. Le site final est accessible via **https://malvinaland.myia.io/**.

#### Construction du site

Pour construire le site (version joueurs uniquement):

```
npm run build
```

Pour construire le site complet (joueurs et organisateurs):

```
npm run build:all
```

Le site généré se trouvera dans le dossier `dist/`.

### Déploiement

**IMPORTANT** : Le site est déjà configuré pour être servi via IIS à l'adresse **https://malvinaland.myia.io/**.

Le déploiement consiste simplement à mettre à jour le contenu du répertoire `site` :

1. Construire le site avec `npm run build` ou `npm run build:all`
2. Le contenu généré dans `dist/` est automatiquement copié dans le répertoire `site/`
3. IIS sert automatiquement le contenu mis à jour via **https://malvinaland.myia.io/**

### Maintenance

Des scripts utilitaires sont disponibles dans le dossier `scripts/` pour faciliter la maintenance du site:

- **clean-repository.ps1** - Nettoie les fichiers temporaires
- **identify-missing-images.ps1** - Identifie les images manquantes
- **optimize-images.js** - Optimise les images pour le web
- **prepare-commit.ps1** - Prépare les fichiers pour un commit

## 📝 Édition du contenu

Le contenu du site est stocké sous forme de fichiers Markdown dans le dossier `src/content/`. Cette approche offre plusieurs avantages:

- **Source unique de vérité** - Tout le contenu est stocké dans des fichiers Markdown faciles à éditer
- **Séparation du contenu et de la présentation** - Le contenu est indépendant du HTML et du CSS
- **Gestion des versions** - Les modifications du contenu sont facilement suivies avec Git
- **Contenu conditionnel** - Certaines parties du contenu peuvent être visibles uniquement pour les organisateurs

### Structure du contenu

- **src/content/index.md** - Page d'accueil
- **src/content/carte.md** - Page de la carte
- **src/content/narration.md** - Page de narration
- **src/content/personnages.md** - Page des personnages
- **src/content/mondes/** - Pages des différents mondes
- **src/content/organisateurs/** - Pages réservées aux organisateurs

### Syntaxe spéciale

Pour marquer du contenu comme visible uniquement pour les organisateurs:

```markdown
::: organisateurs-only
Ce contenu ne sera visible que pour les organisateurs.
:::
```

## 📄 Licence

Ce projet est sous licence propriétaire. Tous droits réservés.