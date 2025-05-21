# Guide de maintenance du dépôt Git de Malvinaland

## Table des matières

1. [Introduction](#introduction)
2. [Utilisation du script execute-cleanup-plan.ps1](#utilisation-du-script-execute-cleanup-planps1)
   - [Présentation du script](#présentation-du-script)
   - [Options et paramètres](#options-et-paramètres)
   - [Exemples d'utilisation](#exemples-dutilisation)
   - [Comprendre le plan de commits](#comprendre-le-plan-de-commits)
3. [Maintenance régulière du dépôt](#maintenance-régulière-du-dépôt)
   - [Nettoyage périodique](#nettoyage-périodique)
   - [Gestion des fichiers temporaires](#gestion-des-fichiers-temporaires)
   - [Optimisation des images](#optimisation-des-images)
   - [Vérification de la cohérence des chemins](#vérification-de-la-cohérence-des-chemins)
4. [Bonnes pratiques pour la gestion des commits et des branches](#bonnes-pratiques-pour-la-gestion-des-commits-et-des-branches)
   - [Structure des messages de commit](#structure-des-messages-de-commit)
   - [Organisation des branches](#organisation-des-branches)
   - [Stratégie de fusion](#stratégie-de-fusion)
   - [Gestion des tags](#gestion-des-tags)
5. [Procédure de déploiement du site](#procédure-de-déploiement-du-site)
   - [Déploiement local](#déploiement-local)
   - [Déploiement sur IIS](#déploiement-sur-iis)
   - [Vérification post-déploiement](#vérification-post-déploiement)
6. [Résolution des problèmes courants](#résolution-des-problèmes-courants)
   - [Problèmes de références incohérentes](#problèmes-de-références-incohérentes)
   - [Conflits de fusion](#conflits-de-fusion)
   - [Problèmes d'images manquantes](#problèmes-dimages-manquantes)
   - [Erreurs de déploiement](#erreurs-de-déploiement)
7. [Annexes](#annexes)
   - [Glossaire](#glossaire)
   - [Ressources utiles](#ressources-utiles)

## Introduction

Ce guide a pour objectif de vous aider à maintenir le dépôt Git de Malvinaland propre et organisé. Il explique comment utiliser les scripts de nettoyage, comment gérer les commits et les branches, et comment déployer le site après des modifications.

Le dépôt de Malvinaland utilise une architecture basée sur Eleventy pour générer le site statique à partir de fichiers source. La structure du projet est organisée comme suit :

- `src/` : Contient les fichiers source pour la génération du site
- `site/` : Contient les fichiers générés pour le déploiement
- `scripts/` : Contient les scripts de maintenance, de déploiement et d'optimisation
- `archive/` : Contient les anciens fichiers archivés

Une maintenance régulière du dépôt est essentielle pour garantir la qualité du code, faciliter la collaboration et assurer un déploiement sans problème.

## Utilisation du script execute-cleanup-plan.ps1

### Présentation du script

Le script `execute-cleanup-plan.ps1` est un outil puissant pour nettoyer et organiser le dépôt Git de Malvinaland. Il permet d'exécuter un plan de commits prédéfini pour restructurer le projet, corriger des problèmes et améliorer l'organisation générale du dépôt.

Ce script offre plusieurs fonctionnalités :
- Affichage du plan de commits sans exécution
- Exécution de toutes les étapes du plan ou d'une étape spécifique
- Création de sauvegardes avant les modifications
- Restauration à partir d'une sauvegarde en cas de problème
- Journalisation détaillée des opérations effectuées

### Options et paramètres

Le script `execute-cleanup-plan.ps1` accepte les paramètres suivants :

| Paramètre | Description |
|-----------|-------------|
| `-ShowPlan` | Affiche le plan de commits sans exécuter d'actions |
| `-ExecuteAll` | Exécute toutes les étapes du plan de commits |
| `-ExecuteStep <n>` | Exécute uniquement l'étape spécifiée du plan de commits |
| `-CreateBackup` | Crée une sauvegarde du dépôt avant toute modification |
| `-Rollback` | Restaure le dépôt à partir de la dernière sauvegarde |
| `-SkipConfirmation` | Ignore les demandes de confirmation |
| `-DryRun` | Simule l'exécution sans effectuer de modifications |
| `-Help` | Affiche l'aide détaillée |

### Exemples d'utilisation

Voici quelques exemples d'utilisation du script `execute-cleanup-plan.ps1` :

**Afficher le plan de commits sans exécuter d'actions :**
```powershell
.\execute-cleanup-plan.ps1 -ShowPlan
```

**Créer une sauvegarde du dépôt :**
```powershell
.\execute-cleanup-plan.ps1 -CreateBackup
```

**Exécuter une étape spécifique du plan de commits :**
```powershell
.\execute-cleanup-plan.ps1 -ExecuteStep 3
```

**Exécuter toutes les étapes du plan de commits :**
```powershell
.\execute-cleanup-plan.ps1 -ExecuteAll
```

**Restaurer le dépôt à partir de la dernière sauvegarde :**
```powershell
.\execute-cleanup-plan.ps1 -Rollback
```

**Simuler l'exécution sans effectuer de modifications :**
```powershell
.\execute-cleanup-plan.ps1 -ExecuteAll -DryRun
```

### Comprendre le plan de commits

Le plan de commits défini dans le script `execute-cleanup-plan.ps1` comprend plusieurs étapes :

1. **Archivage de l'ancienne structure** : Déplace l'ancienne structure du projet vers le répertoire `archive/`
2. **Mise en place de la nouvelle structure** : Ajoute les fichiers de configuration et de structure pour la nouvelle architecture
3. **Ajout des fichiers source** : Ajoute les fichiers source pour la génération du site
4. **Ajout des fichiers générés** : Ajoute les fichiers générés pour le site déployé
5. **Ajout des scripts et outils** : Ajoute les scripts PowerShell et autres outils pour la maintenance du site
6. **Ajout de la documentation** : Ajoute les fichiers de documentation pour le projet
7. **Correction des problèmes d'images et de scripts** : Corrige les problèmes d'images et de scripts identifiés

Chaque étape du plan comprend :
- Une liste de fichiers concernés
- Un message de commit détaillé
- Des vérifications préalables et postérieures pour s'assurer que l'étape est correctement exécutée

## Maintenance régulière du dépôt

### Nettoyage périodique

Pour maintenir le dépôt propre et organisé, il est recommandé d'exécuter régulièrement le script `clean-repository-periodic.ps1`. Ce script effectue plusieurs opérations de nettoyage :

1. Recherche et suppression des fichiers temporaires ou de sauvegarde
2. Archivage des fichiers de log volumineux
3. Suppression des dossiers vides
4. Vérification de la cohérence des chemins de fichiers

Pour exécuter le script en mode simulation (sans effectuer de modifications) :
```powershell
.\scripts\clean-repository-periodic.ps1
```

Pour exécuter le script et appliquer les modifications :
```powershell
.\scripts\clean-repository-periodic.ps1 -Execute
```

Il est recommandé d'exécuter ce script au moins une fois par mois, ou après des périodes de développement intensif.

### Gestion des fichiers temporaires

Les fichiers temporaires et de sauvegarde peuvent s'accumuler dans le dépôt et le rendre moins lisible. Voici quelques bonnes pratiques pour gérer ces fichiers :

1. **Ajouter les extensions de fichiers temporaires au `.gitignore`** :
   ```
   *.tmp
   *.temp
   *.bak
   *.old
   *.orig
   *.save
   *.backup
   *.copy
   *.log.*
   ```

2. **Nettoyer régulièrement les fichiers temporaires** :
   ```powershell
   .\scripts\clean-repository-periodic.ps1 -Execute
   ```

3. **Éviter de committer des fichiers temporaires** : Vérifiez toujours les fichiers que vous ajoutez à un commit pour vous assurer qu'ils ne contiennent pas de fichiers temporaires.

### Optimisation des images

Les images peuvent occuper beaucoup d'espace dans le dépôt. Le script `scripts/optimize-images.js` permet d'optimiser les images pour réduire leur taille sans perte significative de qualité.

Pour optimiser les images :
```powershell
node scripts/optimize-images.js
```

Ce script parcourt les répertoires d'images et optimise les fichiers PNG, JPEG, GIF et SVG.

### Vérification de la cohérence des chemins

La cohérence des chemins de fichiers est essentielle pour le bon fonctionnement du site. Le script `clean-repository-periodic.ps1` vérifie la cohérence des chemins dans les fichiers HTML et signale les problèmes.

Pour vérifier la cohérence des chemins :
```powershell
.\scripts\clean-repository-periodic.ps1
```

Les problèmes courants incluent :
- Références à des fichiers JavaScript inexistants
- Références à des fichiers CSS inexistants
- Références à des images inexistantes

## Bonnes pratiques pour la gestion des commits et des branches

### Structure des messages de commit

Un bon message de commit doit être clair, concis et informatif. Voici la structure recommandée pour les messages de commit :

```
Titre court et descriptif (moins de 50 caractères)

Description détaillée des modifications apportées.
- Point 1
- Point 2
- Point 3

Références aux problèmes résolus ou aux tâches associées.
```

Exemple :
```
Correction des chemins d'images dans la carte de Malvinaland

- Mise à jour des chemins relatifs pour les images de la carte
- Ajout d'un paramètre de version pour contourner le cache du navigateur
- Standardisation des noms de fichiers d'images

Résout le problème #42
```

### Organisation des branches

Pour une gestion efficace du dépôt, il est recommandé d'utiliser la structure de branches suivante :

- `main` : Branche principale contenant le code de production
- `develop` : Branche de développement pour les fonctionnalités en cours
- `feature/nom-fonctionnalite` : Branches pour le développement de nouvelles fonctionnalités
- `fix/nom-correction` : Branches pour la correction de bugs
- `release/version` : Branches pour la préparation des versions

Exemple de création d'une branche pour une nouvelle fonctionnalité :
```powershell
git checkout develop
git pull
git checkout -b feature/nouvelle-carte
```

### Stratégie de fusion

Pour fusionner des branches, il est recommandé d'utiliser la stratégie suivante :

1. **Fusion des branches de fonctionnalité dans `develop`** :
   ```powershell
   git checkout develop
   git pull
   git merge --no-ff feature/nouvelle-carte
   git push origin develop
   ```

2. **Fusion de `develop` dans `main` pour les versions** :
   ```powershell
   git checkout main
   git pull
   git merge --no-ff develop
   git tag -a v1.2.3 -m "Version 1.2.3"
   git push origin main --tags
   ```

L'option `--no-ff` (no fast-forward) permet de conserver l'historique des branches fusionnées.

### Gestion des tags

Les tags sont utilisés pour marquer les versions importantes du projet. Il est recommandé d'utiliser le versionnement sémantique (SemVer) pour les tags :

- `v1.0.0` : Version majeure
- `v1.1.0` : Version mineure
- `v1.1.1` : Correctif

Pour créer un tag :
```powershell
git tag -a v1.2.3 -m "Version 1.2.3"
git push origin --tags
```

Pour lister les tags existants :
```powershell
git tag
```

## Procédure de déploiement du site

### Déploiement local

Pour déployer le site localement et le tester avant de le mettre en production, utilisez le script `scripts/deploy-site-local.ps1` :

```powershell
.\scripts\deploy-site-local.ps1
```

Ce script effectue les opérations suivantes :
1. Génère les fichiers du site à partir des sources
2. Copie les fichiers générés dans le répertoire `site/`
3. Lance un serveur local pour tester le site

### Déploiement sur IIS

Pour déployer le site sur un serveur IIS, utilisez le script `scripts/deploy-iis-improved.ps1` :

```powershell
.\scripts\deploy-iis-improved.ps1
```

Ce script effectue les opérations suivantes :
1. Génère les fichiers du site à partir des sources
2. Copie les fichiers générés sur le serveur IIS
3. Configure les paramètres nécessaires pour le bon fonctionnement du site

Pour un déploiement avec des droits administratifs (nécessaire pour certaines configurations) :
```powershell
.\scripts\deploy-iis-admin.ps1
```

### Vérification post-déploiement

Après le déploiement, il est important de vérifier que le site fonctionne correctement. Le script `scripts/verify-after-commits.ps1` permet de vérifier les points suivants :

```powershell
.\scripts\verify-after-commits.ps1
```

Ce script vérifie :
1. L'accessibilité des pages principales
2. Le chargement correct des images
3. Le fonctionnement des scripts JavaScript
4. La cohérence des liens internes

## Résolution des problèmes courants

### Problèmes de références incohérentes

Si vous rencontrez des problèmes de références incohérentes (chemins incorrects, fichiers manquants), vous pouvez utiliser le script `clean-repository-improved.ps1` pour les identifier et les corriger :

```powershell
.\scripts\clean-repository-improved.ps1
```

Pour appliquer les corrections :
```powershell
.\scripts\clean-repository-improved.ps1 -Execute
```

Les problèmes courants incluent :
- Références à des fichiers JavaScript dans des chemins incorrects
- Doubles inclusions de scripts
- Chemins relatifs incorrects pour les images

### Conflits de fusion

En cas de conflit lors d'une fusion de branches, suivez ces étapes :

1. **Identifier les fichiers en conflit** :
   ```powershell
   git status
   ```

2. **Ouvrir les fichiers en conflit et résoudre les conflits** :
   Les conflits sont marqués dans les fichiers comme suit :
   ```
   <<<<<<< HEAD
   Code de la branche courante
   =======
   Code de la branche à fusionner
   >>>>>>> feature/nouvelle-fonctionnalite
   ```

3. **Marquer les conflits comme résolus** :
   ```powershell
   git add fichier-en-conflit.ext
   ```

4. **Terminer la fusion** :
   ```powershell
   git commit
   ```

### Problèmes d'images manquantes

Si des images sont manquantes ou ne s'affichent pas correctement :

1. **Vérifier les chemins des images** :
   ```powershell
   .\scripts\clean-repository-periodic.ps1
   ```

2. **Identifier les images manquantes** :
   ```powershell
   .\scripts\identify-missing-images.ps1
   ```

3. **Copier les images manquantes depuis les mondes** :
   ```powershell
   .\scripts\copy-monde-images.ps1
   ```

### Erreurs de déploiement

En cas d'erreur lors du déploiement sur IIS :

1. **Vérifier les logs d'erreur** :
   ```powershell
   Get-Content -Path "cleanup-logs\deploy-*.log"
   ```

2. **Corriger les problèmes de configuration IIS** :
   ```powershell
   .\scripts\fix-iis-deployment.ps1
   ```

3. **Tester le déploiement localement avant de réessayer** :
   ```powershell
   .\scripts\deploy-site-local.ps1
   ```

## Annexes

### Glossaire

- **Commit** : Enregistrement des modifications dans le dépôt Git
- **Branch** (Branche) : Ligne de développement indépendante
- **Merge** (Fusion) : Combinaison des modifications de différentes branches
- **Tag** (Étiquette) : Marqueur pour une version spécifique du dépôt
- **Pull** : Récupération des modifications depuis un dépôt distant
- **Push** : Envoi des modifications vers un dépôt distant
- **Checkout** : Changement de branche ou restauration de fichiers
- **Rebase** : Réapplication des commits sur une autre base
- **Stash** : Mise de côté temporaire des modifications non commitées
- **Working Directory** : Répertoire de travail contenant les fichiers du projet
- **Staging Area** : Zone intermédiaire pour préparer les commits
- **Repository** (Dépôt) : Stockage des fichiers et de l'historique du projet

### Ressources utiles

- [Documentation Git officielle](https://git-scm.com/doc)
- [Guide Eleventy](https://www.11ty.dev/docs/)
- [Documentation PowerShell](https://docs.microsoft.com/fr-fr/powershell/)
- [Guide IIS](https://docs.microsoft.com/fr-fr/iis/get-started/introduction-to-iis/iis-web-server-overview)