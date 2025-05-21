# Prompts pour le développement du site "Les mondes de Malvinha"

## Prompt pour le développement du module Core
- **Tâches** : Améliorer la structure de base, la navigation et les fonctionnalités communes.
  - Exemple : Refactoriser le système de navigation pour améliorer l'accessibilité et la réactivité.
- **Instructions** : Maintenir la cohérence avec les autres modules en suivant les standards de codage et les conventions de nommage.
  - Détail : Utiliser des conventions de nommage uniformes pour les classes CSS et les identifiants JavaScript.
- **Intégration** : Assurez-vous que les modifications s'intègrent harmonieusement dans l'architecture globale du site.
  - Conseil : Vérifier la compatibilité avec les modules Mondes et Services.
- **Tests** : Testez les modifications en utilisant des outils de test automatisés et manuels.
  - Exemple de test : Utiliser Jest pour les tests unitaires et Cypress pour les tests d'intégration.
- **Outils** : Utilisez quickfiles pour visualiser plusieurs textes à la fois et un navigateur pour exploiter les fonctionnalités de vision de Claude sur les images.
  - Suggestion : Intégrer ESLint pour maintenir la qualité du code.
- **Fonctionnalités suggérées** : Implémenter un système de gestion des utilisateurs avec authentification.

## Prompt pour le développement des modules Mondes
- **Tâches** : Créer et intégrer le contenu spécifique à chaque monde.
  - Exemple : Développer des animations interactives pour le monde des rêves.
- **Instructions** : Adaptez ce prompt pour chaque monde en tenant compte de ses particularités.
  - Détail : Utiliser des palettes de couleurs et des typographies spécifiques à chaque monde.
- **Cohérence** : Maintenez une cohérence visuelle et fonctionnelle avec le reste du site.
  - Conseil : Harmoniser les éléments graphiques avec le module Core.
- **Intégration** : Assurez-vous que chaque monde s'intègre bien dans l'architecture globale.
  - Conseil : Tester l'intégration avec le module Services pour les fonctionnalités dynamiques.
- **Tests** : Testez les modifications en utilisant des outils de test automatisés et manuels.
  - Exemple de test : Utiliser Puppeteer pour simuler des interactions utilisateur.
- **Outils** : Utilisez quickfiles pour visualiser plusieurs textes à la fois et un navigateur pour exploiter les fonctionnalités de vision de Claude sur les images.
  - Suggestion : Utiliser Figma pour prototyper les interfaces.
- **Fonctionnalités suggérées** : Ajouter des mini-jeux éducatifs pour chaque monde.

## Prompt pour le développement du module Services
- **Tâches** : Améliorer les fonctionnalités techniques (service worker, API, etc.).
  - Exemple : Optimiser le service worker pour une meilleure gestion du cache.
- **Instructions** : Assurez la compatibilité avec les autres modules en suivant les standards de codage.
  - Détail : Implémenter des API RESTful conformes aux normes HTTP.
- **Intégration** : Vérifiez que les services s'intègrent bien dans l'architecture globale.
  - Conseil : Tester l'interopérabilité avec le module Core.
- **Tests** : Testez les modifications en utilisant des outils de test automatisés et manuels.
  - Exemple de test : Utiliser Postman pour tester les endpoints API.
- **Outils** : Utilisez quickfiles pour visualiser plusieurs textes à la fois et un navigateur pour exploiter les fonctionnalités de vision de Claude sur les images.
  - Suggestion : Intégrer Swagger pour documenter les API.
- **Fonctionnalités suggérées** : Ajouter des notifications push pour les mises à jour importantes.

## Prompt pour le développement du module Composants
- **Tâches** : Créer et améliorer les éléments d'interface réutilisables.
  - Exemple : Développer une bibliothèque de composants UI pour les formulaires.
- **Instructions** : Maintenir une cohérence visuelle et fonctionnelle avec le reste du site.
  - Détail : Utiliser des systèmes de design comme Material Design ou Bootstrap.
- **Intégration** : Assurez-vous que les composants s'intègrent bien dans l'architecture globale.
  - Conseil : Vérifier la compatibilité avec les modules Mondes et Core.
- **Tests** : Testez les modifications en utilisant des outils de test automatisés et manuels.
  - Exemple de test : Utiliser Storybook pour documenter et tester les composants.
- **Outils** : Utilisez quickfiles pour visualiser plusieurs textes à la fois et un navigateur pour exploiter les fonctionnalités de vision de Claude sur les images.
  - Suggestion : Intégrer des outils de gestion de versions pour les composants.
- **Fonctionnalités suggérées** : Ajouter des thèmes personnalisables pour les composants.