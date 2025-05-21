# Workflow de Malvinaland

Ce document explique le processus complet pour modifier le contenu, générer le site et le déployer. Il est conçu pour être accessible aux non-techniciens tout en fournissant suffisamment d'informations pour comprendre le fonctionnement global du projet.

## Vue d'ensemble du processus

Le workflow de Malvinaland se décompose en trois grandes étapes:

1. **Modification du contenu** - Édition des fichiers Markdown
2. **Génération du site** - Transformation des fichiers Markdown en HTML
3. **Déploiement du site** - Publication du site sur le serveur web

## 1. Modification du contenu

### Option A: Modification directe via GitHub (recommandée pour les non-techniciens)

Cette méthode est la plus simple et ne nécessite aucune installation:

1. Accédez au dépôt GitHub de Malvinaland
2. Naviguez jusqu'au fichier que vous souhaitez modifier
3. Cliquez sur l'icône en forme de crayon (✏️) pour éditer
4. Effectuez vos modifications
5. Cliquez sur "Commit changes" pour valider

Pour des instructions détaillées, consultez le fichier `COMMENT_MODIFIER.md`.

### Option B: Modification locale (pour les utilisateurs avancés)

Cette méthode nécessite des connaissances techniques mais offre plus de flexibilité:

1. Clonez le dépôt sur votre ordinateur:
   ```
   git clone [URL-du-dépôt]
   ```

2. Installez les dépendances:
   ```
   npm install
   ```

3. Lancez le serveur de développement:
   ```
   npm run dev
   ```

4. Modifiez les fichiers dans le dossier `src/content/` avec votre éditeur préféré

5. Visualisez vos modifications en temps réel à l'adresse http://localhost:8080

6. Une fois satisfait, validez et poussez vos modifications:
   ```
   git add .
   git commit -m "Description des modifications"
   git push
   ```

## 2. Génération du site

La génération du site est le processus qui transforme les fichiers Markdown en pages HTML. Cette étape est généralement automatique.

### Génération automatique

Lorsque vous validez des modifications sur GitHub (via l'interface web ou en poussant des commits), le site est automatiquement régénéré par le système d'intégration continue. Vous n'avez rien à faire de plus.

### Génération manuelle (pour les utilisateurs avancés)

Si vous souhaitez générer le site manuellement:

1. Assurez-vous d'avoir installé les dépendances (`npm install`)

2. Pour générer la version joueurs uniquement:
   ```
   npm run build
   ```

3. Pour générer la version complète (joueurs et organisateurs):
   ```
   npm run build:all
   ```

4. Le site généré se trouvera dans le dossier `dist/`

## 3. Déploiement du site

Le déploiement est le processus qui publie le site généré sur le serveur web pour le rendre accessible aux visiteurs.

**IMPORTANT** : Le site Malvinaland est accessible UNIQUEMENT via le domaine **https://malvinaland.myia.io/**. Ce domaine pointe directement vers le répertoire `site` de ce dépôt via la configuration IIS. Il n'y a pas besoin de déploiement supplémentaire. Il suffit d'alimenter le répertoire `site` et IIS le servira automatiquement via le nom de domaine.

### Déploiement automatique

Dans la configuration actuelle, le déploiement est automatique après chaque modification validée sur la branche principale. Le délai entre la validation des modifications et leur apparition sur le site public (https://malvinaland.myia.io/) est généralement de quelques minutes.

### Déploiement manuel (pour les administrateurs)

Si un déploiement manuel est nécessaire:

1. Connectez-vous au serveur via SSH ou RDP (selon la configuration)

2. Exécutez le script de déploiement:
   ```
   npm run deploy
   ```

   Ou utilisez l'un des scripts spécifiques dans le dossier `scripts/`:
   ```
   scripts/deploy.ps1
   ```

## Vérification des modifications

Après avoir modifié du contenu et attendu le déploiement:

1. Visitez le site public de Malvinaland à l'adresse **https://malvinaland.myia.io/**
2. Naviguez jusqu'à la page que vous avez modifiée
3. Vérifiez que vos modifications apparaissent correctement
4. Testez la navigation et les fonctionnalités associées

**Note** : N'essayez pas d'accéder au site via d'autres URLs ou de configurer un hébergement alternatif. Le site est configuré pour être accessible uniquement via **https://malvinaland.myia.io/**.

## Gestion des problèmes courants

### Les modifications n'apparaissent pas

1. **Vérifiez le statut du déploiement**: Sur GitHub, allez dans l'onglet "Actions" pour voir si le déploiement est terminé ou s'il y a des erreurs.

2. **Videz le cache de votre navigateur**: Parfois, votre navigateur affiche une version mise en cache du site. Appuyez sur Ctrl+F5 (ou Cmd+Shift+R sur Mac) pour forcer le rechargement complet.

3. **Attendez quelques minutes**: Le déploiement peut prendre un peu de temps.

### Erreurs dans le contenu

1. **Vérifiez la syntaxe Markdown**: Assurez-vous que votre Markdown est correctement formaté. Consultez `STRUCTURE_CONTENU.md` pour des exemples.

2. **Vérifiez les liens et les chemins d'images**: Les chemins doivent être relatifs et commencer par `/` (par exemple: `/assets/images/...`).

3. **Corrigez et recommencez**: Modifiez à nouveau le fichier pour corriger les erreurs et validez les corrections.

## Bonnes pratiques

1. **Faites des modifications ciblées**: Modifiez un seul aspect à la fois pour faciliter le suivi des changements.

2. **Utilisez des messages de commit descriptifs**: Expliquez clairement ce que vous avez modifié.

3. **Testez vos modifications**: Vérifiez toujours que vos modifications s'affichent correctement.

4. **Communiquez avec l'équipe**: Informez les autres membres de l'équipe des modifications importantes.

5. **Sauvegardez régulièrement**: N'attendez pas d'avoir fait de nombreuses modifications avant de les valider.

## Ressources supplémentaires

- **Documentation Eleventy**: [11ty.dev](https://www.11ty.dev/docs/)
- **Guide Markdown**: [markdownguide.org](https://www.markdownguide.org/basic-syntax/)
- **Tutoriels Git**: [git-scm.com](https://git-scm.com/book/fr/v2)

Pour toute question ou assistance, contactez l'administrateur du projet.