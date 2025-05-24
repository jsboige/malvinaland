# Guide de Démarrage Rapide Malvinaland

## 🚀 Bienvenue !

Ce guide vous permettra de commencer rapidement avec Malvinaland, que vous soyez nouvel organisateur, administrateur ou préparateur d'événement.

## ⏱️ En 5 Minutes : Les Essentiels

### 1. 📁 Localiser le Contenu
Le contenu que vous modifierez se trouve dans :
```
📁 contenu/
├── index.md              # Page d'accueil
├── carte.md              # Carte interactive
├── narration.md          # Histoire générale
└── mondes/               # Contenu des mondes
    ├── assemblee/
    ├── damier/
    ├── elysee/
    └── ...
```

### 2. ✏️ Modifier du Contenu
1. **Ouvrir** le fichier `.md` avec un éditeur de texte
2. **Modifier** le contenu en Markdown
3. **Sauvegarder** le fichier

### 3. 👀 Voir les Modifications
```powershell
.\outils-techniques\deploy-site-simple.ps1
```
Puis ouvrir `http://localhost:8080` dans votre navigateur.

### 4. 🌐 Publier sur le Site
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

## 🎯 Selon Votre Rôle

### 👩‍💼 Organisateur/Administrateur
**Vous voulez modifier le contenu du site**

1. **Lire** : [Manuel Administrateur](MANUEL_ADMINISTRATEUR.md) - Section "Mise à jour du contenu"
2. **Modifier** : Les fichiers dans `contenu/`
3. **Tester** : `.\outils-techniques\deploy-site-simple.ps1`
4. **Publier** : `.\outils-techniques\deploy-iis-simple.ps1`

### 🏗️ Préparateur d'Événement
**Vous préparez les énigmes et lieux physiques**

1. **Consulter** : [Guides de Préparation par Monde](guides-preparation/)
2. **Choisir** : Le guide du monde que vous préparez
3. **Suivre** : Les instructions de matériel et installation

### 🎭 Animateur PNJ
**Vous jouez un personnage non-joueur**

1. **Se connecter** : `https://malvinaland.myia.io`
   - Identifiant : `pnj`
   - Mot de passe : `malvina2025`
2. **Consulter** : Votre fiche PNJ dans le dashboard
3. **Lire** : [Guide PNJ Complet](GUIDE_PNJ_COMPLET.md)

## 📝 Syntaxe Markdown de Base

### Titres
```markdown
# Titre Principal
## Sous-titre
### Sous-sous-titre
```

### Mise en Forme
```markdown
**Gras**
*Italique*
`Code`
```

### Listes
```markdown
- Élément 1
- Élément 2

1. Premier
2. Deuxième
```

### Liens et Images
```markdown
[Texte du lien](https://exemple.com)
![Description](chemin/vers/image.jpg)
```

### Contenu Organisateurs
```markdown
<div class="organisateurs-only">
Ce contenu n'est visible que par les organisateurs connectés
</div>
```

## 🛠️ Commandes Essentielles

### Voir le Site en Local
```powershell
.\outils-techniques\deploy-site-simple.ps1
```

### Publier sur le Serveur
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

### Nettoyer le Projet
```powershell
.\outils-techniques\clean-repository-simple.ps1
```

### Vérifier la Santé du Projet
```powershell
.\outils-techniques\verify-simple.ps1
```

## 🏰 Structure d'un Monde

Chaque monde suit cette structure dans `contenu/mondes/[nom-monde]/index.md` :

```markdown
---
title: "Nom du Monde"
description: "Description courte"
layout: "monde"
---

# Nom du Monde

## Introduction
Description pour les joueurs...

## Ambiance et Atmosphère
Ambiance du lieu...

## Histoire et Contexte
Contexte narratif...

<div class="organisateurs-only">

## Notes pour les Organisateurs
Informations réservées...

### Énigmes

#### Énigme 1 : Nom
**Objectif :** Ce que les joueurs doivent faire
**Matériel :** Liste du matériel nécessaire
**Mise en place :** Instructions d'installation
**Indices :** Indices à donner si besoin
**Solution :** Solution complète

</div>
```

## 🎯 Tâches Courantes

### Modifier un Monde Existant
1. Ouvrir `contenu/mondes/[nom-monde]/index.md`
2. Modifier le contenu
3. Sauvegarder
4. Tester : `.\outils-techniques\deploy-site-simple.ps1`
5. Publier : `.\outils-techniques\deploy-iis-simple.ps1`

### Ajouter une Énigme
1. Ouvrir le fichier du monde
2. Copier la structure d'énigme depuis `templates/nouvelle-enigme.md`
3. Ajouter dans la section `<div class="organisateurs-only">`
4. Remplir toutes les sections
5. Tester et publier

### Ajouter un Nouveau Monde
1. Créer `contenu/mondes/[nouveau-monde]/index.md`
2. Copier le contenu de `templates/nouveau-monde.md`
3. Remplir toutes les sections
4. Ajouter le monde dans `src/_data/mondes.js`
5. Tester et publier

## ⚠️ Points d'Attention

### ✅ À Faire
- **Toujours tester** en local avant de publier
- **Sauvegarder** régulièrement le dossier `contenu/`
- **Utiliser** la syntaxe Markdown correcte
- **Respecter** la structure des fichiers

### ❌ À Éviter
- **Ne pas modifier** directement les fichiers dans `src/` ou `site/`
- **Ne pas supprimer** les balises `---` en début de fichier
- **Ne pas oublier** les balises `<div class="organisateurs-only">`
- **Ne pas publier** sans tester

## 🆘 Aide Rapide

### Problème : Le site ne se charge pas
```powershell
.\outils-techniques\deploy-site-simple.ps1
```
Puis vérifier `http://localhost:8080`

### Problème : Les modifications ne s'affichent pas
1. Vider le cache du navigateur (Ctrl+F5)
2. Redéployer :
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

### Problème : Erreur dans un fichier
1. Vérifier la syntaxe Markdown
2. Vérifier les balises `---` en début de fichier
3. Consulter `templates/` pour la structure correcte

## 📚 Pour Aller Plus Loin

- **[Manuel Administrateur Complet](MANUEL_ADMINISTRATEUR.md)** - Documentation complète
- **[Guides de Préparation](guides-preparation/)** - Préparation physique des mondes
- **[Guide PNJ](GUIDE_PNJ_COMPLET.md)** - Gestion des personnages
- **[Maintenance](GUIDE_MAINTENANCE_SIMPLIFIE.md)** - Maintenance courante

## 🎉 Prêt à Commencer !

Vous avez maintenant les bases pour commencer avec Malvinaland. N'hésitez pas à consulter la documentation complète pour des informations plus détaillées.

**Conseil** : Commencez par modifier un petit élément dans un monde existant pour vous familiariser avec le processus !

---

*Guide mis à jour le 24/05/2025 - Version débutant*