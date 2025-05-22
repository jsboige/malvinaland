# Guide d'organisation des commits pour la nouvelle structure simplifiée

Ce document explique comment organiser les commits pour la nouvelle structure simplifiée du projet Malvinaland.

## Vue d'ensemble

La nouvelle structure simplifiée du projet Malvinaland comprend les dossiers suivants:

- **contenu/** - Pour modifier le contenu du site
  - **mondes/** - Les différents mondes de Malvinaland
  - **personnages/** - Les personnages du jeu
  - **carte/** - La carte interactive
  - **organisateurs/** - Les informations pour les organisateurs

- **guides/** - Documentation simplifiée
  - **consultation/** - Comment consulter le site
  - **modification/** - Comment modifier le contenu
  - **structure/** - Comment comprendre la structure du projet

- **tableau-de-bord/** - Interface simplifiée pour gérer le site

- **outils-techniques/** - Scripts et outils simplifiés
  - Scripts de déploiement simplifiés
  - Scripts de nettoyage simplifiés
  - Scripts d'organisation simplifiés

- **archives-techniques/** - Anciens fichiers techniques

- **site-web/** - Version déployable du site

## Scripts disponibles

Deux scripts ont été créés pour faciliter l'organisation des commits:

1. **execute-commits-new-structure.ps1** - Exécute les commits selon la nouvelle structure simplifiée
2. **verify-after-commits-new-structure.ps1** - Vérifie que tout fonctionne correctement après les commits

## Plan des commits

Les commits sont organisés en 8 groupes logiques:

1. **Archivage de l'ancienne structure**
   - Suppression des fichiers de l'ancienne structure qui ont été archivés
   - Préparation pour la nouvelle structure simplifiée

2. **Mise en place de la nouvelle structure simplifiée**
   - Ajout du README simplifié expliquant la nouvelle organisation
   - Ajout du tableau de bord pour faciliter la gestion du site

3. **Ajout du contenu**
   - Ajout des fichiers de contenu pour les mondes
   - Ajout des fichiers de contenu pour les personnages
   - Ajout des fichiers de contenu pour la carte
   - Ajout des fichiers de contenu pour les organisateurs

4. **Ajout des guides**
   - Ajout des guides de consultation
   - Ajout des guides de modification
   - Ajout des guides de structure

5. **Ajout des outils techniques**
   - Scripts de déploiement simplifiés
   - Scripts de nettoyage simplifiés
   - Scripts d'organisation simplifiés
   - Scripts de vérification simplifiés

6. **Ajout du site web**
   - Ajout des fichiers HTML générés
   - Ajout des assets (CSS, JavaScript, images)
   - Ajout des fichiers de configuration pour le déploiement
   - Ajout des dossiers pour les mondes

7. **Ajout des archives techniques**
   - Conservation des fichiers techniques importants
   - Organisation des archives pour référence future

8. **Ajout du script de déploiement temporaire**
   - Script pour déployer le site web localement
   - Basé sur le script deploy-site-simple.ps1 mais utilisant site-web au lieu de site

## Utilisation des scripts

### 1. Exécution des commits

Pour exécuter les commits selon la nouvelle structure simplifiée, exécutez:

```powershell
.\execute-commits-new-structure.ps1
```

Ce script:
- Vérifie l'état du dépôt Git
- Demande confirmation avant d'exécuter les commits
- Exécute chaque commit en ajoutant les fichiers appropriés
- Demande confirmation avant de pousser les commits vers le dépôt distant
- Met à jour le JOURNAL_MODIFICATIONS.md avec un résumé des commits effectués

### 2. Vérification après les commits

Pour vérifier que tout fonctionne correctement après les commits, exécutez:

```powershell
.\verify-after-commits-new-structure.ps1
```

Ce script vérifie:
- La structure simplifiée (dossiers et fichiers requis)
- Les mondes (dans contenu/ et site-web/)
- Le tableau de bord (liens vers les sections importantes)
- Le script de déploiement temporaire (éléments nécessaires)
- Le site web (fichiers requis)

Si toutes les vérifications réussissent, le script propose de lancer le script de déploiement temporaire.

## Recommandations

1. **Avant d'exécuter les commits**:
   - Assurez-vous que tous les fichiers sont correctement organisés selon la nouvelle structure
   - Vérifiez que le tableau de bord fonctionne correctement
   - Vérifiez que les liens dans les guides sont corrects

2. **Après les commits**:
   - Exécutez le script de vérification pour vous assurer que tout fonctionne correctement
   - Testez le site manuellement pour vérifier les fonctionnalités clés
   - Mettez à jour la documentation si nécessaire

3. **En cas de problème**:
   - Consultez le JOURNAL_MODIFICATIONS.md pour comprendre les modifications effectuées
   - Utilisez les scripts de vérification pour identifier les problèmes
   - Corrigez les problèmes et créez des commits supplémentaires si nécessaire

## Notes importantes

- La nouvelle structure est conçue pour être plus intuitive et plus facile à utiliser
- Le tableau de bord facilite la navigation et la gestion du site
- Les guides fournissent une documentation claire et accessible
- Les outils techniques sont simplifiés pour être plus faciles à utiliser
- Les archives techniques conservent les fichiers importants pour référence future
