# Guide de Maintenance Simplifié - Malvinaland

## 📋 Table des Matières

1. [Introduction](#introduction)
2. [Maintenance Quotidienne](#maintenance-quotidienne)
3. [Maintenance Hebdomadaire](#maintenance-hebdomadaire)
4. [Maintenance Mensuelle](#maintenance-mensuelle)
5. [Commandes Essentielles](#commandes-essentielles)
6. [Surveillance du Site](#surveillance-du-site)
7. [Résolution de Problèmes Courants](#résolution-de-problèmes-courants)
8. [Quand Faire Appel à l'Équipe Technique](#quand-faire-appel-à-léquipe-technique)

---

## Introduction

Ce guide présente les tâches de maintenance de base que peut effectuer un administrateur non-technique pour maintenir Malvinaland en bon état de fonctionnement.

### 🎯 Objectifs de la Maintenance
- **Maintenir les performances** du site
- **Prévenir les problèmes** avant qu'ils surviennent
- **Assurer la disponibilité** pour les joueurs et PNJ
- **Préserver l'intégrité** du contenu

### 🟢 Niveau de Difficulté
Ce guide est conçu pour être accessible aux débutants. Toutes les commandes sont expliquées étape par étape.

### ⚠️ Règles de Sécurité
- **Toujours sauvegarder** avant toute opération
- **Tester en local** avant de déployer
- **Ne jamais modifier** directement les fichiers dans `src/` ou `site/`
- **Demander de l'aide** en cas de doute

---

## Maintenance Quotidienne

### 🌅 Chaque Matin (5 minutes)

#### 1. Vérification du Site
```powershell
# Ouvrir PowerShell et naviguer vers le projet
cd d:\Production\malvinaland

# Vérifier que le site fonctionne
.\outils-techniques\verify-simple.ps1
```

**Ce que fait cette commande :**
- Vérifie que tous les fichiers importants sont présents
- Contrôle que le site se charge correctement
- Signale les problèmes éventuels

#### 2. Contrôle des Accès PNJ
1. **Ouvrir le navigateur** : `https://malvinaland.myia.io`
2. **Tester la connexion PNJ** :
   - Identifiant : `pnj`
   - Mot de passe : `malvina2025`
3. **Vérifier l'accès** au dashboard
4. **Se déconnecter** après vérification

#### 3. Vérification Rapide du Contenu
- **Parcourir 2-3 mondes** au hasard
- **Vérifier que les images** se chargent
- **Contrôler que les sections organisateurs** sont accessibles avec les bons identifiants

### 🌆 Chaque Soir (3 minutes)

#### Nettoyage Léger
```powershell
# Nettoyer les fichiers temporaires
.\outils-techniques\clean-temp-files.ps1
```

**Ce que fait cette commande :**
- Supprime les fichiers temporaires
- Libère de l'espace disque
- Prépare le système pour le lendemain

---

## Maintenance Hebdomadaire

### 📅 Chaque Lundi (15 minutes)

#### 1. Nettoyage Complet
```powershell
# Nettoyage complet du projet
.\outils-techniques\clean-repository-simple.ps1
```

**Ce que fait cette commande :**
- Nettoie tous les fichiers temporaires
- Organise les fichiers
- Optimise l'espace de stockage
- Vérifie la cohérence du projet

#### 2. Vérification de Santé Complète
```powershell
# Vérification approfondie
.\outils-techniques\verify-repository-health.ps1
```

**Ce que fait cette commande :**
- Contrôle l'intégrité de tous les fichiers
- Vérifie les liens entre les pages
- Identifie les images manquantes
- Génère un rapport de santé

#### 3. Test de Déploiement
```powershell
# Tester le déploiement local
.\outils-techniques\deploy-site-simple.ps1
```

**Puis :**
1. **Ouvrir** `http://localhost:8080`
2. **Tester** 3-4 mondes différents
3. **Vérifier** la navigation
4. **Fermer** le navigateur de test

### 📊 Rapport Hebdomadaire

#### Créer un Rapport Simple
Notez dans un fichier texte :
- **Date** de la maintenance
- **Problèmes détectés** (s'il y en a)
- **Actions effectuées**
- **Observations** sur les performances

**Exemple :**
```
Maintenance du 24/05/2025
- Nettoyage : OK
- Vérification santé : OK
- Test déploiement : OK
- Observations : Site rapide, pas de problème détecté
```

---

## Maintenance Mensuelle

### 📅 Premier Lundi du Mois (30 minutes)

#### 1. Nettoyage Périodique Avancé
```powershell
# Nettoyage périodique complet
.\scripts\clean-repository-periodic.ps1
```

**Ce que fait cette commande :**
- Nettoyage approfondi de tous les dossiers
- Suppression des anciens fichiers de sauvegarde
- Optimisation de la structure des fichiers
- Préparation pour les mises à jour

#### 2. Optimisation des Images
```powershell
# Optimiser toutes les images
node .\scripts\optimize-images.js
```

**Ce que fait cette commande :**
- Compresse les images pour améliorer les performances
- Convertit les formats si nécessaire
- Réduit la taille des fichiers
- Améliore la vitesse de chargement

#### 3. Sauvegarde Complète
```powershell
# Créer une sauvegarde du dossier contenu
xcopy "contenu" "sauvegarde-contenu-$(Get-Date -Format 'yyyy-MM-dd')" /E /I
```

**Ce que fait cette commande :**
- Crée une copie complète du dossier `contenu/`
- Nomme la sauvegarde avec la date
- Permet de restaurer en cas de problème

#### 4. Test de Déploiement Complet
```powershell
# Déploiement de test complet
.\outils-techniques\deploy-iis-simple.ps1
```

**Puis vérifier :**
- **Tous les mondes** fonctionnent
- **Toutes les images** se chargent
- **Les accès PNJ** sont opérationnels
- **La navigation** est fluide

---

## Commandes Essentielles

### 🔧 Commandes de Base

#### Voir le Site en Local
```powershell
.\outils-techniques\deploy-site-simple.ps1
```
**Utilisation :** Tester vos modifications avant publication

#### Publier sur le Serveur
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```
**Utilisation :** Mettre en ligne les modifications

#### Nettoyer le Projet
```powershell
.\outils-techniques\clean-repository-simple.ps1
```
**Utilisation :** Maintenance hebdomadaire

#### Vérifier la Santé
```powershell
.\outils-techniques\verify-simple.ps1
```
**Utilisation :** Contrôle quotidien

### 🆘 Commandes d'Urgence

#### Redémarrage Complet
```powershell
# En cas de problème majeur
.\outils-techniques\deploy-iis-simple.ps1
```

#### Restauration de Sauvegarde
```powershell
# Restaurer le contenu depuis une sauvegarde
xcopy "sauvegarde-contenu-[DATE]" "contenu" /E /Y
```

#### Vérification d'Urgence
```powershell
# Diagnostic rapide
.\outils-techniques\verify-minimal.ps1
```

---

## Surveillance du Site

### 📊 Indicateurs à Surveiller

#### Performance du Site
- **Temps de chargement** : Doit être inférieur à 3 secondes
- **Disponibilité** : Le site doit être accessible 24h/24
- **Images** : Toutes les images doivent s'afficher
- **Navigation** : Tous les liens doivent fonctionner

#### Accès PNJ
- **Connexion** : Les identifiants doivent fonctionner
- **Dashboard** : L'interface doit être responsive
- **Contenu** : Toutes les fiches doivent être accessibles

#### Espace Disque
```powershell
# Vérifier l'espace disque disponible
Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}
```

### 🚨 Alertes à Surveiller

#### Signaux d'Alarme
- **Site inaccessible** : Erreur 404 ou 500
- **Images manquantes** : Icônes cassées
- **Connexion PNJ impossible** : Erreur d'authentification
- **Lenteur excessive** : Chargement > 5 secondes

#### Actions Immédiates
1. **Noter l'heure** et la nature du problème
2. **Tenter un redéploiement** : `.\outils-techniques\deploy-iis-simple.ps1`
3. **Vérifier les fichiers** : `.\outils-techniques\verify-simple.ps1`
4. **Contacter l'équipe technique** si le problème persiste

---

## Résolution de Problèmes Courants

### 🔧 Problèmes Techniques

#### Le Site ne se Charge Pas
**Symptômes :** Erreur 404, page blanche, timeout

**Solutions :**
1. **Redéployer le site** :
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

2. **Vérifier les fichiers** :
```powershell
.\outils-techniques\verify-simple.ps1
```

3. **Redémarrer IIS** (si vous avez les droits) :
```powershell
iisreset
```

#### Les Images ne s'Affichent Pas
**Symptômes :** Icônes cassées, espaces vides

**Solutions :**
1. **Vérifier les images manquantes** :
```powershell
.\scripts\identify-missing-images.ps1
```

2. **Optimiser les images** :
```powershell
node .\scripts\optimize-images.js
```

3. **Redéployer** :
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

#### Les PNJ ne Peuvent pas se Connecter
**Symptômes :** Erreur de connexion, page d'erreur

**Solutions :**
1. **Vérifier les identifiants** : `pnj` / `malvina2025`
2. **Tester avec les identifiants admin** : `admin_malvina` / `Malv1n@2025!`
3. **Redéployer le site** :
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

### 📝 Problèmes de Contenu

#### Modifications qui ne s'Affichent Pas
**Symptômes :** Ancien contenu visible, modifications ignorées

**Solutions :**
1. **Vider le cache du navigateur** : Ctrl+F5
2. **Régénérer le site** :
```powershell
.\outils-techniques\deploy-site-simple.ps1
```
3. **Redéployer** :
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

#### Erreur dans un Fichier Markdown
**Symptômes :** Page qui ne s'affiche pas, erreur de format

**Solutions :**
1. **Vérifier la syntaxe** du fichier modifié
2. **Consulter les templates** dans le dossier `templates/`
3. **Restaurer depuis une sauvegarde** si nécessaire

### 🚀 Problèmes de Performance

#### Site Lent
**Symptômes :** Chargement > 5 secondes, timeouts

**Solutions :**
1. **Optimiser les images** :
```powershell
node .\scripts\optimize-images.js
```

2. **Nettoyer le projet** :
```powershell
.\outils-techniques\clean-repository-simple.ps1
```

3. **Optimiser la configuration IIS** :
```powershell
.\scripts\optimize-iis-config.ps1
```

---

## Quand Faire Appel à l'Équipe Technique

### 🔴 Situations Critiques (Appel Immédiat)

#### Sécurité
- **Site piraté** ou contenu malveillant
- **Accès non autorisé** aux sections administrateur
- **Fuite de données** ou informations sensibles exposées

#### Panne Majeure
- **Site complètement inaccessible** depuis plus de 30 minutes
- **Perte de données** dans le dossier `contenu/`
- **Corruption de fichiers** importante

#### Erreurs Système
- **Erreurs serveur 500** persistantes
- **Problèmes de base de données** (si applicable)
- **Échec de tous les scripts** de déploiement

### 🟡 Situations Non-Critiques (Appel sous 24h)

#### Performance
- **Lenteur persistante** malgré les optimisations
- **Problèmes d'affichage** sur certains navigateurs
- **Erreurs intermittentes** difficiles à reproduire

#### Fonctionnalités
- **Nouvelles fonctionnalités** demandées
- **Modifications importantes** de structure
- **Intégration** de nouveaux outils

### 📞 Informations à Fournir

#### Lors de l'Appel
1. **Description précise** du problème
2. **Heure d'apparition** du problème
3. **Actions effectuées** avant le problème
4. **Messages d'erreur** exacts (capture d'écran)
5. **Impact** sur les utilisateurs

#### Logs à Conserver
- **Résultats des scripts** de vérification
- **Messages d'erreur** PowerShell
- **Captures d'écran** des problèmes
- **Historique** des actions récentes

---

## 📚 Ressources et Documentation

### 📖 Documentation Complémentaire
- **[Manuel Administrateur Complet](MANUEL_ADMINISTRATEUR.md)** - Pour aller plus loin
- **[Guide de Maintenance Avancé](../GUIDE_MAINTENANCE.md)** - Version technique complète
- **[Guide de Démarrage Rapide](GUIDE_DEMARRAGE_RAPIDE.md)** - Pour les bases

### 🛠️ Outils Utiles
- **PowerShell ISE** : Environnement de script plus convivial
- **Notepad++** : Éditeur de texte pour modifier les fichiers
- **Navigateur de test** : Firefox ou Chrome pour les vérifications

### 📝 Modèles de Rapport

#### Rapport de Maintenance Hebdomadaire
```
RAPPORT DE MAINTENANCE - Semaine du [DATE]

✅ TÂCHES EFFECTUÉES :
- Nettoyage hebdomadaire : [OK/PROBLÈME]
- Vérification santé : [OK/PROBLÈME]
- Test déploiement : [OK/PROBLÈME]

⚠️ PROBLÈMES DÉTECTÉS :
- [Description du problème 1]
- [Description du problème 2]

🔧 ACTIONS CORRECTIVES :
- [Action effectuée 1]
- [Action effectuée 2]

📊 OBSERVATIONS :
- Performance générale : [BONNE/MOYENNE/MAUVAISE]
- Disponibilité : [%]
- Commentaires : [Observations libres]

Responsable : [Votre nom]
Date : [Date du rapport]
```

---

## 🎯 Checklist de Maintenance

### ✅ Quotidienne (5 min/jour)
- [ ] Vérification du site avec `verify-simple.ps1`
- [ ] Test de connexion PNJ
- [ ] Contrôle visuel de 2-3 mondes
- [ ] Nettoyage des fichiers temporaires

### ✅ Hebdomadaire (15 min/semaine)
- [ ] Nettoyage complet avec `clean-repository-simple.ps1`
- [ ] Vérification de santé avec `verify-repository-health.ps1`
- [ ] Test de déploiement local
- [ ] Rédaction du rapport hebdomadaire

### ✅ Mensuelle (30 min/mois)
- [ ] Nettoyage périodique avec `clean-repository-periodic.ps1`
- [ ] Optimisation des images
- [ ] Sauvegarde complète du contenu
- [ ] Test de déploiement complet
- [ ] Bilan mensuel des performances

---

*Guide de maintenance simplifié mis à jour le 24/05/2025 - Version non-technique*

**Rappel Important :** En cas de doute, il vaut mieux demander de l'aide que de risquer d'endommager le système. L'équipe technique est là pour vous accompagner !