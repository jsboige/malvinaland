# Guide d'utilisation des scripts de gestion des commits

Ce document explique comment utiliser les scripts créés pour la gestion des commits du projet Malvinaland.

## Vue d'ensemble

Trois scripts ont été créés pour faciliter la gestion des commits :

1. **prepare-commits-plan.ps1** : Affiche un plan détaillé des commits à effectuer, organisés de manière logique.
2. **execute-commits.ps1** : Exécute les commits selon le plan défini, avec des vérifications à chaque étape.
3. **verify-after-commits.ps1** : Vérifie que le site fonctionne correctement après les commits.

## Prérequis

- PowerShell 5.1 ou supérieur
- Git installé et configuré
- Accès au dépôt Git du projet Malvinaland

## Utilisation des scripts

### 1. Préparation du plan de commits

Pour afficher le plan détaillé des commits à effectuer, exécutez :

```powershell
.\scripts\prepare-commits-plan.ps1
```

Ce script affichera :
- La liste des 7 groupes de commits
- Les fichiers concernés par chaque commit
- Les messages de commit proposés
- Les commandes Git à exécuter pour chaque commit

Utilisez ce script pour comprendre la structure des commits avant de les exécuter.

### 2. Exécution des commits

Pour exécuter les commits selon le plan défini, exécutez :

```powershell
.\scripts\execute-commits.ps1
```

Ce script :
- Vérifie l'état du dépôt Git
- Demande confirmation avant d'exécuter les commits
- Exécute chaque commit en ajoutant les fichiers appropriés
- Demande confirmation avant de pousser les commits vers le dépôt distant
- Met à jour le JOURNAL_MODIFICATIONS.md avec un résumé des commits effectués

Le script vous guidera à chaque étape et vous demandera confirmation avant d'effectuer des actions importantes.

### 3. Vérification après les commits

Pour vérifier que le site fonctionne correctement après les commits, exécutez :

```powershell
.\scripts\verify-after-commits.ps1
```

Ce script vérifie :
- La structure du projet
- Les fichiers des mondes
- Les images
- Les scripts
- Le fichier web.config
- Le fonctionnement du site en local

Si toutes les vérifications réussissent, le script proposera de lancer le script de déploiement IIS.

## Structure des commits

Les commits sont organisés en 7 groupes logiques :

1. **Archivage de l'ancienne structure**
   - Déplacement de l'ancienne structure vers le répertoire archive/
   - Conservation de l'historique et des fichiers importants

2. **Mise en place de la nouvelle structure du projet**
   - Ajout des fichiers de configuration (.eleventy.js, package.json, etc.)
   - Mise à jour des fichiers principaux (web.config, index.html, README.md)

3. **Ajout des fichiers source (src)**
   - Ajout des fichiers de données, layouts, contenu et assets

4. **Ajout des fichiers générés (site)**
   - Ajout des fichiers HTML générés, assets et configuration pour le déploiement

5. **Ajout des scripts et outils**
   - Scripts de déploiement, test, optimisation d'images, etc.

6. **Ajout de la documentation**
   - Guides d'utilisation, journal des modifications, documentation sur la structure, etc.

7. **Correction des problèmes d'images et de scripts**
   - Correction des problèmes spécifiques identifiés (web.config, chemins d'images, etc.)

## Recommandations

1. **Avant d'exécuter les commits** :
   - Assurez-vous que toutes les modifications sont correctes
   - Vérifiez que l'image de la carte a été générée correctement
   - Vérifiez que les chemins des scripts sont corrects dans les fichiers HTML
   - Vérifiez que le fichier web.config a été correctement modifié

2. **Après les commits** :
   - Exécutez le script de vérification pour vous assurer que tout fonctionne correctement
   - Testez le site manuellement pour vérifier les fonctionnalités clés
   - Mettez à jour la documentation si nécessaire

3. **En cas de problème** :
   - Consultez le JOURNAL_MODIFICATIONS.md pour comprendre les modifications effectuées
   - Utilisez les scripts de test pour identifier les problèmes
   - Corrigez les problèmes et créez des commits supplémentaires si nécessaire

## Notes importantes

- Le répertoire `site` du dépôt est directement mappé sur le nom de domaine https://malvinaland.myia.io/
- Aucun déploiement manuel vers IIS n'est nécessaire, les modifications dans le répertoire `site` sont automatiquement reflétées sur le site web
- Les scripts sont conçus pour être exécutés dans l'ordre : plan → exécution → vérification