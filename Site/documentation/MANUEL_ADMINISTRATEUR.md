# Manuel Administrateur/Organisateur Malvinaland

## 📋 Table des Matières

1. [Introduction](#introduction)
2. [Structure du Projet](#structure-du-projet)
3. [Mise à Jour du Contenu](#mise-à-jour-du-contenu)
4. [Génération et Déploiement](#génération-et-déploiement)
5. [Gestion des PNJ](#gestion-des-pnj)
6. [Maintenance Courante](#maintenance-courante)
7. [Résolution de Problèmes](#résolution-de-problèmes)

---

## Introduction

Ce manuel s'adresse aux administrateurs et organisateurs de Malvinaland qui souhaitent gérer le contenu du site, déployer les mises à jour et maintenir le système. Il est conçu pour être accessible aux personnes non-techniques tout en fournissant les informations nécessaires pour une gestion autonome.

### 🎯 Objectifs de ce Manuel
- Comprendre la structure du projet
- Modifier et ajouter du contenu (mondes, énigmes, personnages)
- Déployer le site sur le serveur
- Gérer les accès PNJ
- Effectuer la maintenance de base

### 🟢 Niveau de Difficulté
Ce manuel est conçu pour être accessible aux débutants. Les sections avancées sont clairement marquées.

---

## Structure du Projet

### 📁 Vue d'Ensemble des Dossiers

Le projet Malvinaland est organisé en plusieurs dossiers principaux :

```
malvinaland/
├── 📁 contenu/              # ✏️ CONTENU À MODIFIER
│   ├── index.md             # Page d'accueil
│   ├── carte.md             # Page de la carte
│   ├── narration.md         # Narration générale
│   ├── login.md             # Page de connexion
│   └── mondes/              # Contenu des mondes
│       ├── assemblee/
│       ├── damier/
│       └── ...
├── 📁 documentation/        # 📚 CETTE DOCUMENTATION
├── 📁 guides/              # 📖 Guides simplifiés
├── 📁 outils-techniques/   # 🔧 Scripts simplifiés
├── 📁 scripts/             # ⚙️ Scripts avancés
├── 📁 src/                 # 🏗️ Code source (généré automatiquement)
├── 📁 site/                # 🌐 Site final (généré automatiquement)
├── 📁 ressources/          # 🖼️ Images haute résolution
└── 📁 templates/           # 📝 Modèles pour nouveau contenu
```

### 🎯 Dossiers Importants pour les Administrateurs

#### 📁 `contenu/` - **LE PLUS IMPORTANT**
C'est ici que vous modifiez tout le contenu visible sur le site :
- **Pages principales** : `index.md`, `carte.md`, `narration.md`
- **Mondes** : `contenu/mondes/[nom-du-monde]/index.md`
- **Contenu organisateurs** : `contenu/organisateurs/`

#### 📁 `templates/`
Modèles pour créer du nouveau contenu :
- `nouveau-monde.md` - Structure pour un nouveau monde
- `nouvelle-enigme.md` - Structure pour une nouvelle énigme

#### 📁 `outils-techniques/`
Scripts simplifiés pour les tâches courantes :
- `deploy-site-simple.ps1` - Voir le site en local
- `clean-repository-simple.ps1` - Nettoyer le projet

#### 📁 `ressources/`
Images en haute résolution pour le site.

### 🔍 Fichiers de Configuration Clés

- **`src/_data/mondes.js`** - Liste des mondes disponibles (à modifier lors d'ajout de monde)
- **`src/_data/site.js`** - Configuration générale du site

---

## Mise à Jour du Contenu

### 🟢 Modifier le Contenu Existant

#### Modifier un Monde
1. **Localiser le fichier** : `contenu/mondes/[nom-du-monde]/index.md`
2. **Ouvrir avec un éditeur de texte** (Notepad++, VS Code, ou même Bloc-notes)
3. **Modifier le contenu** en respectant la structure Markdown
4. **Sauvegarder le fichier**

#### Structure d'un Fichier de Monde
```markdown
---
title: "Nom du Monde"
description: "Description courte"
layout: "monde"
---

# Nom du Monde

## Introduction
Description générale du monde...

## Ambiance et Atmosphère
Description de l'ambiance...

## Histoire et Contexte
Contexte narratif...

<div class="organisateurs-only">

## Notes pour les Organisateurs
Informations réservées aux organisateurs...

### Énigmes

#### Énigme 1 : Nom de l'énigme
**Objectif :** ...
**Matériel :** ...
**Mise en place :** ...
**Solution :** ...

</div>
```

#### Modifier les Pages Principales
- **Page d'accueil** : `contenu/index.md`
- **Carte interactive** : `contenu/carte.md`
- **Narration générale** : `contenu/narration.md`

### 🟡 Ajouter du Nouveau Contenu

#### Ajouter un Nouveau Monde

1. **Créer le dossier** : `contenu/mondes/[nouveau-monde]/`
2. **Copier le template** : Copier `templates/nouveau-monde.md` vers `contenu/mondes/[nouveau-monde]/index.md`
3. **Remplir le contenu** selon la structure fournie
4. **Mettre à jour la liste des mondes** dans `src/_data/mondes.js` :

```javascript
// Ajouter votre monde à la liste
{
  id: 'nouveau-monde',
  title: 'Nom du Nouveau Monde',
  description: 'Description courte',
  path: '/mondes/nouveau-monde/'
}
```

#### Ajouter une Énigme à un Monde Existant

1. **Ouvrir le fichier du monde** : `contenu/mondes/[nom-du-monde]/index.md`
2. **Utiliser le template d'énigme** de `templates/nouvelle-enigme.md`
3. **Ajouter l'énigme** dans la section `<div class="organisateurs-only">`

### 🖼️ Gestion des Images

#### Ajouter des Images
1. **Placer l'image** dans le dossier `ressources/`
2. **Référencer dans le Markdown** :
```markdown
![Description de l'image](../../../ressources/nom-image.jpg)
```

#### Optimisation des Images
- Utilisez des formats web (JPG, PNG, WebP)
- Taille recommandée : maximum 1920px de largeur
- Pour optimiser automatiquement : exécutez `outils-techniques/optimize-images.js`

### ✍️ Syntaxe Markdown Essentielle

```markdown
# Titre Principal
## Sous-titre
### Sous-sous-titre

**Texte en gras**
*Texte en italique*

- Liste à puces
- Élément 2

1. Liste numérotée
2. Élément 2

[Lien](https://exemple.com)

![Image](chemin/vers/image.jpg)

> Citation ou note importante

`Code ou commande`

<div class="organisateurs-only">
Contenu visible uniquement par les organisateurs
</div>
```

---

## Génération et Déploiement

### 🔄 Comprendre le Processus

Le site Malvinaland fonctionne en deux étapes :
1. **Génération** : Le contenu de `contenu/` et `src/` est transformé en site web dans `site/`
2. **Déploiement** : Le contenu de `site/` est copié sur le serveur IIS

### 🟢 Voir le Site en Local (Test)

Pour tester vos modifications avant de les publier :

1. **Ouvrir PowerShell** dans le dossier du projet
2. **Exécuter** :
```powershell
.\outils-techniques\deploy-site-simple.ps1
```
3. **Ouvrir le navigateur** à l'adresse indiquée (généralement `http://localhost:8080`)

### 🟡 Déployer sur le Serveur IIS

#### Déploiement Automatique (Recommandé)
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

#### Vérification Post-Déploiement
1. **Vérifier que le site fonctionne** en visitant l'URL de production
2. **Tester la connexion PNJ** avec les identifiants habituels
3. **Vérifier quelques pages de mondes**

### 🔴 Déploiement Avancé

Pour les utilisateurs expérimentés, des scripts plus avancés sont disponibles :
- `scripts/deploy-iis-improved.ps1` - Déploiement avec vérifications
- `scripts/deploy-iis-admin.ps1` - Déploiement avec droits administrateur

### ⚠️ Que Faire en Cas de Problème

1. **Vérifier les fichiers** : Assurez-vous que tous les fichiers sont présents dans `site/`
2. **Redémarrer IIS** (si vous avez les droits) :
```powershell
iisreset
```
3. **Vider le cache du navigateur**
4. **Consulter les logs** dans le gestionnaire IIS

---

## Gestion des PNJ

### 🎭 Interface PNJ

Les PNJ (Personnages Non-Joueurs) ont accès à une interface spéciale pour consulter les informations organisateurs.

#### Accès PNJ
- **URL** : `https://malvinaland.myia.io/organisateurs/`
- **Identifiant** : `orga-malvina`
- **Mot de passe** : `Malvina2026`

#### Fonctionnalités PNJ
- **Dashboard** : Vue d'ensemble des mondes et énigmes
- **Fiches détaillées** : Informations spécifiques pour chaque PNJ
- **Mode urgence** : Accès rapide aux informations critiques
- **Recherche** : Filtrage par monde, énigme ou mot-clé

### 🔧 Gestion des Fiches PNJ

#### Modifier les Fiches PNJ
Les fiches PNJ sont stockées dans `contenu/organisateurs/pnj/`

#### Ajouter une Nouvelle Fiche PNJ
1. **Créer un fichier** : `contenu/organisateurs/pnj/[nom-pnj].md`
2. **Utiliser la structure** :
```markdown
---
title: "Nom du PNJ"
role: "Rôle du personnage"
monde: "monde-associe"
---

# Nom du PNJ

## Rôle et Objectifs
Description du rôle...

## Informations Clés
- Information 1
- Information 2

## Interactions avec les Joueurs
Instructions pour les interactions...

## Phrases et Répliques Types
- "Phrase d'accueil"
- "Phrase d'aide"

## Matériel et Accessoires
Liste du matériel nécessaire...
```

### 🔐 Gestion des Accès

#### Identifiants de Test
Pour tester l'interface administrateur :
- **Identifiant** : `orga-malvina`
- **Mot de passe** : `Malvina2026`

#### Modifier les Identifiants
Les identifiants sont configurés dans le code source. Pour les modifier, contactez l'équipe technique.

---

## Maintenance Courante

### 🧹 Nettoyage Régulier

#### Nettoyage Simple (Recommandé chaque semaine)
```powershell
.\outils-techniques\clean-repository-simple.ps1
```

Cette commande :
- Supprime les fichiers temporaires
- Nettoie les caches
- Organise les fichiers

#### Nettoyage Périodique (Recommandé chaque mois)
```powershell
.\scripts\clean-repository-periodic.ps1
```

### 🔍 Vérifications de Routine

#### Vérification de la Santé du Projet
```powershell
.\outils-techniques\verify-simple.ps1
```

#### Vérification des Images Manquantes
```powershell
.\scripts\identify-missing-images.ps1
```

### 📊 Optimisation

#### Optimisation des Images
```powershell
node .\scripts\optimize-images.js
```

#### Optimisation de la Configuration IIS
```powershell
.\scripts\optimize-iis-config.ps1
```

### 📝 Bonnes Pratiques

1. **Sauvegarde régulière** : Sauvegardez le dossier `contenu/` régulièrement
2. **Test avant déploiement** : Toujours tester en local avant de déployer
3. **Nettoyage périodique** : Exécutez les scripts de nettoyage régulièrement
4. **Vérification post-modification** : Vérifiez que le site fonctionne après chaque modification importante

---

## Résolution de Problèmes

### 🚨 Problèmes Courants

#### Le Site ne se Charge Pas
1. **Vérifier IIS** : Le service IIS est-il démarré ?
2. **Vérifier les fichiers** : Les fichiers sont-ils présents dans `site/` ?
3. **Redémarrer IIS** :
```powershell
iisreset
```

#### Les Modifications ne s'Affichent Pas
1. **Régénérer le site** :
```powershell
.\outils-techniques\deploy-site-simple.ps1
```
2. **Vider le cache du navigateur** (Ctrl+F5)
3. **Redéployer** :
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

#### Erreur lors du Déploiement
1. **Vérifier les droits** : Avez-vous les droits d'écriture sur le serveur ?
2. **Vérifier l'espace disque** : Y a-t-il suffisamment d'espace ?
3. **Utiliser le déploiement admin** :
```powershell
.\scripts\deploy-iis-admin.ps1
```

#### Les PNJ ne Peuvent pas se Connecter
1. **Vérifier les identifiants** : `orga-malvina` / `Malvina2026`
2. **Vérifier l'URL** : `https://malvinaland.myia.io`
3. **Tester avec les identifiants admin** : `orga-malvina` / `Malvina2026`

### 🆘 Contacts d'Urgence

En cas de problème majeur :
1. **Consulter** le [Guide de Maintenance Avancé](../GUIDE_MAINTENANCE.md)
2. **Contacter** l'équipe technique
3. **Documenter** le problème pour améliorer ce guide

### 📞 Support Technique

Pour obtenir de l'aide :
- **Documentation avancée** : Consultez `GUIDE_MAINTENANCE.md`
- **Scripts de diagnostic** : Utilisez `verify-repository-health.ps1`
- **Logs système** : Consultez les logs IIS pour plus de détails

---

## 📚 Ressources Supplémentaires

- **[Guide de Démarrage Rapide](GUIDE_DEMARRAGE_RAPIDE.md)** - Pour commencer rapidement
- **[Guides de Préparation](guides-preparation/)** - Préparation physique des mondes
- **[Guide PNJ Complet](GUIDE_PNJ_COMPLET.md)** - Gestion détaillée des PNJ
- **[Guide de Maintenance Avancé](../GUIDE_MAINTENANCE.md)** - Maintenance technique

---

*Ce manuel est maintenu par l'équipe Malvinaland. Version mise à jour le 24/05/2025.*