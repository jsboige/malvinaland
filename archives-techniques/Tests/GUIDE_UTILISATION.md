# Guide d'utilisation des outils de test pour Malvinaland

Ce guide explique comment utiliser les outils de test mis en place pour optimiser le site Malvinaland de manière itérative.

## Prérequis

- Node.js (v14 ou supérieur)
- npm (v6 ou supérieur)

## Installation

1. Ouvrez un terminal dans le dossier `Tests`
2. Installez les dépendances nécessaires :

```bash
npm run install-deps
```

## Structure des outils de test

Les outils de test sont organisés comme suit :

- `browser-tests/` : Tests visuels avec le navigateur
  - `visual-test.js` : Tests d'ergonomie mobile et d'apparence visuelle
  - `offline-test.js` : Tests du mode hors ligne (service worker)
- `content-tests/` : Analyse de contenu textuel
  - `content-analyzer.js` : Analyse du contenu des pages
- `jinavigator-tests/` : Analyse avec jinavigator
  - `jina-analyzer.js` : Analyse avancée du contenu avec jinavigator
- `checklists/` : Listes de vérification
  - `test-checklist.md` : Liste complète des éléments à vérifier
- `reports/` : Dossier où sont générés les rapports (créé automatiquement)
  - `screenshots/` : Captures d'écran des tests visuels
  - `offline-tests/` : Captures d'écran des tests hors ligne
  - `content/` : Rapports d'analyse de contenu
  - `jina-analysis/` : Rapports d'analyse jinavigator

## Exécution des tests

### Exécuter tous les tests

Pour exécuter tous les tests et générer un rapport combiné :

```bash
npm test
```

### Exécuter des tests spécifiques

Pour exécuter uniquement les tests visuels :

```bash
npm run test:visual
```

Pour exécuter uniquement les tests du mode hors ligne :

```bash
npm run test:offline
```

Pour exécuter uniquement l'analyse de contenu :

```bash
npm run test:content
```

Pour exécuter uniquement l'analyse avec jinavigator :

```bash
npm run test:jina
```

## Processus d'optimisation itératif

Pour optimiser le site Malvinaland de manière itérative, suivez ce processus :

1. **Exécuter les tests initiaux**
   - Exécutez tous les tests pour établir une base de référence
   - Consultez les rapports générés dans le dossier `reports/`

2. **Identifier les problèmes**
   - Utilisez la liste de vérification (`checklists/test-checklist.md`)
   - Analysez les captures d'écran et les rapports d'analyse
   - Priorisez les problèmes à résoudre

3. **Apporter des améliorations**
   - Modifiez le code du site pour résoudre les problèmes identifiés
   - Concentrez-vous sur un aspect à la fois (ergonomie mobile, contenu, etc.)

4. **Tester à nouveau**
   - Exécutez les tests pertinents pour vérifier vos améliorations
   - Comparez les nouveaux résultats avec les précédents

5. **Documenter les améliorations**
   - Notez les changements effectués et leur impact
   - Mettez à jour la liste de vérification avec les éléments résolus

6. **Répéter le processus**
   - Continuez à identifier les problèmes, apporter des améliorations et tester

## Utilisation des rapports

### Rapport visuel

Le rapport visuel contient des captures d'écran du site à différentes tailles d'écran. Utilisez-le pour :
- Vérifier l'apparence visuelle du site
- Identifier les problèmes d'ergonomie mobile
- Vérifier la cohérence visuelle entre les différentes pages

### Rapport de mode hors ligne

Le rapport de mode hors ligne compare l'apparence du site en mode connecté et hors ligne. Utilisez-le pour :
- Vérifier que le site fonctionne correctement sans connexion internet
- Identifier les ressources qui ne sont pas mises en cache
- Améliorer la stratégie de mise en cache du service worker

### Rapport d'analyse de contenu

Le rapport d'analyse de contenu évalue la qualité du contenu textuel. Utilisez-le pour :
- Identifier les pages qui manquent d'éléments narratifs
- Vérifier la présence et la clarté des énigmes
- Améliorer la structure et la cohérence du contenu

### Rapport d'analyse jinavigator

Le rapport d'analyse jinavigator fournit une analyse plus approfondie du contenu. Utilisez-le pour :
- Analyser la lisibilité et le sentiment du contenu
- Identifier les sujets clés de chaque page
- Générer des résumés du contenu pour une vue d'ensemble rapide

## Personnalisation des tests

### Modifier les pages testées

Pour modifier la liste des pages testées, éditez la configuration dans les fichiers de test correspondants :
- `browser-tests/visual-test.js`
- `browser-tests/offline-test.js`
- `content-tests/content-analyzer.js`
- `jinavigator-tests/jina-analyzer.js`

### Ajouter de nouveaux tests

Pour ajouter de nouveaux tests, créez un nouveau fichier dans le dossier approprié et mettez à jour le script principal (`run-tests.js`) pour inclure votre nouveau test.

### Modifier la liste de vérification

La liste de vérification (`checklists/test-checklist.md`) peut être modifiée pour ajouter ou supprimer des éléments à vérifier selon vos besoins.

## Intégration avec jinavigator

L'outil jinavigator est utilisé pour analyser le contenu textuel du site. Pour l'utiliser efficacement :

1. Assurez-vous que le serveur MCP jinavigator est connecté
2. Exécutez l'analyse avec `npm run test:jina`
3. Consultez les rapports générés dans `reports/jina-analysis/`

## Conseils pour l'optimisation

### Ergonomie mobile

- Assurez-vous que tous les éléments interactifs ont une taille minimale de 44x44px
- Vérifiez que le menu mobile fonctionne correctement
- Testez la lisibilité du texte sur différentes tailles d'écran

### Contenu narratif

- Chaque monde doit avoir une description, une ambiance et une histoire locale
- Les énigmes doivent être clairement structurées et compréhensibles
- Le contenu doit être cohérent entre les différents mondes

### Mode hors ligne

- Toutes les ressources essentielles doivent être mises en cache
- Le site doit être utilisable sans connexion internet
- Les mises à jour du contenu doivent être gérées correctement

### Performance

- Les images doivent être optimisées pour un chargement rapide
- Les scripts doivent être minifiés
- Le temps de chargement doit être raisonnable sur tous les appareils

## Conclusion

Ces outils de test vous permettent d'optimiser le site Malvinaland de manière itérative en combinant des tests visuels avec le navigateur et une analyse de contenu avec jinavigator. En suivant le processus d'optimisation décrit, vous pourrez améliorer progressivement tous les aspects du site.