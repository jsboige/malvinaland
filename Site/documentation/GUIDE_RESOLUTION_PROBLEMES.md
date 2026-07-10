# Guide de Résolution de Problèmes - Malvinaland

## 📋 Table des Matières

1. [Introduction](#introduction)
2. [Problèmes du Site Web](#problèmes-du-site-web)
3. [Problèmes de Contenu](#problèmes-de-contenu)
4. [Problèmes de Déploiement](#problèmes-de-déploiement)
5. [Problèmes PNJ et Accès](#problèmes-pnj-et-accès)
6. [Problèmes de Performance](#problèmes-de-performance)
7. [Problèmes de Préparation Physique](#problèmes-de-préparation-physique)
8. [Diagnostic et Outils](#diagnostic-et-outils)
9. [Escalade et Contacts](#escalade-et-contacts)

---

## Introduction

Ce guide centralise toutes les solutions aux problèmes courants rencontrés avec Malvinaland. Il est organisé par type de problème avec des solutions progressives du plus simple au plus complexe.

### 🎯 Comment Utiliser ce Guide
1. **Identifier le type de problème** dans la table des matières
2. **Suivre les solutions** dans l'ordre proposé
3. **Documenter** ce qui a fonctionné pour les prochaines fois
4. **Escalader** si aucune solution ne fonctionne

### 🚨 Niveaux d'Urgence
- 🔴 **Critique** : Site inaccessible, sécurité compromise
- 🟡 **Important** : Fonctionnalités dégradées, PNJ bloqués
- 🟢 **Mineur** : Problèmes cosmétiques, optimisations

---

## Problèmes du Site Web

### 🔴 Site Complètement Inaccessible

#### Symptômes
- Erreur 404 "Page non trouvée"
- Erreur 500 "Erreur serveur interne"
- Timeout de connexion
- Page blanche

#### Solutions Progressives

**1. Vérification Rapide (2 min)**
```powershell
# Vérifier l'état du site
.\outils-techniques\verify-simple.ps1
```

**2. Redéploiement Simple (5 min)**
```powershell
# Redéployer le site
.\outils-techniques\deploy-iis-simple.ps1
```

**3. Redémarrage IIS (si droits admin)**
```powershell
# Redémarrer IIS
iisreset
```

**4. Vérification Approfondie**
```powershell
# Diagnostic complet
.\outils-techniques\verify-repository-health.ps1
```

#### Si Rien ne Fonctionne
- **Contacter immédiatement** l'équipe technique
- **Noter l'heure** exacte du problème
- **Documenter** les messages d'erreur

### 🟡 Pages Spécifiques Inaccessibles

#### Symptômes
- Certaines pages fonctionnent, d'autres non
- Erreurs 404 sur des mondes spécifiques
- Navigation cassée

#### Solutions

**1. Vérifier les Fichiers**
```powershell
# Identifier les fichiers manquants
.\scripts\identify-missing-images.ps1
```

**2. Régénérer le Site**
```powershell
# Régénération complète
.\outils-techniques\deploy-site-simple.ps1
```

**3. Vérifier le Contenu Source**
- Ouvrir le fichier `.md` correspondant dans `contenu/`
- Vérifier la syntaxe Markdown
- Contrôler les balises `---` en début de fichier

### 🟢 Problèmes d'Affichage

#### Symptômes
- Mise en page cassée
- CSS qui ne se charge pas
- Images déformées

#### Solutions

**1. Vider le Cache**
- **Navigateur** : Ctrl+F5 (Windows) ou Cmd+Shift+R (Mac)
- **Tester sur un autre navigateur**

**2. Optimiser les Ressources**
```powershell
# Optimiser les images
node .\scripts\optimize-images.js
```

**3. Redéployer**
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

---

## Problèmes de Contenu

### 🟡 Modifications qui ne s'Affichent Pas

#### Symptômes
- Contenu modifié mais ancien contenu visible
- Nouvelles pages non accessibles
- Images qui ne se mettent pas à jour

#### Solutions

**1. Vérification du Fichier Source**
- Ouvrir le fichier dans `contenu/`
- Vérifier que les modifications sont bien sauvegardées
- Contrôler la syntaxe Markdown

**2. Régénération Forcée**
```powershell
# Nettoyer et régénérer
.\outils-techniques\clean-repository-simple.ps1
.\outils-techniques\deploy-site-simple.ps1
```

**3. Redéploiement Complet**
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

### 🟢 Erreurs de Syntaxe Markdown

#### Symptômes
- Page qui ne s'affiche pas correctement
- Formatage cassé
- Erreurs de génération

#### Solutions

**1. Vérifier la Syntaxe de Base**
```markdown
# Vérifier ces éléments :
- Balises --- en début et fin de front matter
- Guillemets fermés dans le front matter
- Syntaxe Markdown correcte
- Chemins d'images valides
```

**2. Utiliser les Templates**
- Copier la structure depuis `templates/nouveau-monde.md`
- Vérifier avec un fichier qui fonctionne

**3. Outils de Validation**
- Utiliser un éditeur avec prévisualisation Markdown
- Tester avec un validateur en ligne

### 🟡 Images Manquantes ou Cassées

#### Symptômes
- Icônes cassées (□ avec X)
- Espaces vides à la place des images
- Erreurs 404 sur les images

#### Solutions

**1. Vérifier les Chemins**
```markdown
# Format correct pour les images :
![Description](../../../ressources/nom-image.jpg)
```

**2. Identifier les Images Manquantes**
```powershell
.\scripts\identify-missing-images.ps1
```

**3. Optimiser et Redéployer**
```powershell
node .\scripts\optimize-images.js
.\outils-techniques\deploy-iis-simple.ps1
```

---

## Problèmes de Déploiement

### 🔴 Échec de Déploiement

#### Symptômes
- Scripts de déploiement qui échouent
- Messages d'erreur PowerShell
- Permissions refusées

#### Solutions

**1. Vérifier les Droits**
- Exécuter PowerShell en tant qu'administrateur
- Vérifier les droits d'écriture sur le serveur

**2. Utiliser le Déploiement Admin**
```powershell
# Déploiement avec droits élevés
.\scripts\deploy-iis-admin.ps1
```

**3. Déploiement Manuel**
- Copier manuellement le contenu de `site/` vers le serveur
- Vérifier les permissions des dossiers

### 🟡 Déploiement Lent ou Qui Traîne

#### Symptômes
- Scripts qui prennent très longtemps
- Processus qui semble bloqué
- Timeouts

#### Solutions

**1. Nettoyer Avant Déploiement**
```powershell
.\outils-techniques\clean-repository-simple.ps1
```

**2. Optimiser les Ressources**
```powershell
node .\scripts\optimize-images.js
```

**3. Déploiement par Étapes**
- Déployer d'abord en local pour tester
- Puis déployer sur le serveur

---

## Problèmes PNJ et Accès

### 🔴 PNJ ne Peuvent pas se Connecter

#### Symptômes
- Erreur de connexion sur l'interface PNJ
- Page de login qui ne répond pas
- Identifiants refusés

#### Solutions

**1. Vérifier les Identifiants**
- **URL** : `https://malvinaland.myia.io/organisateurs/`
- **Login** : `orga-malvina`
- **Mot de passe** : `Malvina2026`

**2. Tester avec les Identifiants Admin**
- **Login** : `orga-malvina`
- **Mot de passe** : `Malvina2026`

**3. Redéployer le Site**
```powershell
.\outils-techniques\deploy-iis-simple.ps1
```

### 🟡 Interface PNJ Lente ou Bugguée

#### Symptômes
- Chargement très lent des pages
- Fonctionnalités qui ne répondent pas
- Affichage incorrect sur mobile

#### Solutions

**1. Optimisation Mobile**
- Vider le cache du navigateur mobile
- Redémarrer l'application navigateur
- Tester sur un autre appareil

**2. Optimisation Serveur**
```powershell
.\scripts\optimize-iis-config.ps1
```

### 🟢 Contenu PNJ Manquant

#### Symptômes
- Fiches PNJ vides ou incomplètes
- Sections organisateurs non visibles
- Informations manquantes

#### Solutions

**1. Vérifier le Contenu Source**
- Contrôler `contenu/organisateurs/pnj/`
- Vérifier les balises `<div class="organisateurs-only">`

**2. Vérifier la Connexion**
- S'assurer d'être connecté avec les bons identifiants
- Tester la visibilité du contenu organisateur

---

## Problèmes de Performance

### 🟡 Site Très Lent

#### Symptômes
- Chargement > 5 secondes
- Timeouts fréquents
- Navigation difficile

#### Solutions

**1. Optimisation des Images**
```powershell
node .\scripts\optimize-images.js
```

**2. Nettoyage Complet**
```powershell
.\outils-techniques\clean-repository-simple.ps1
```

**3. Optimisation Serveur**
```powershell
.\scripts\optimize-iis-config.ps1
```

### 🟢 Consommation Excessive d'Espace

#### Symptômes
- Disque plein
- Avertissements d'espace
- Performances dégradées

#### Solutions

**1. Nettoyage Périodique**
```powershell
.\scripts\clean-repository-periodic.ps1
```

**2. Vérifier l'Espace Disque**
```powershell
Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}
```

---

## Problèmes de Préparation Physique

### 🟡 Matériel Manquant ou Défaillant

#### Symptômes
- Énigmes qui ne fonctionnent pas
- Matériel cassé ou perdu
- Installation impossible

#### Solutions par Type d'Énigme

**Énigmes Mécaniques**
- **Plan B** : Version manuelle simplifiée
- **Réparation** : Outils de base disponibles
- **Remplacement** : Matériel de secours prévu

**Énigmes Électroniques**
- **Reset** : Redémarrage des appareils
- **Mode dégradé** : Fonctionnement sans électronique
- **Batterie de secours** : Toujours prévoir

**Énigmes avec Cartes/Papier**
- **Plastification** : Protection contre l'humidité
- **Exemplaires de secours** : Toujours prévoir
- **Version simplifiée** : Réduction du nombre d'éléments

### 🟢 Problèmes d'Ambiance

#### Symptômes
- Décor qui ne tient pas
- Éclairage insuffisant
- Ambiance pas immersive

#### Solutions

**Décor**
- **Fixation renforcée** : Vis, colle, sangles
- **Matériaux résistants** : Prévoir l'usure
- **Plan B déco** : Version simplifiée

**Éclairage**
- **Batteries de secours** : Pour l'éclairage LED
- **Éclairage naturel** : Optimiser selon l'heure
- **Éclairage de secours** : Lampes de poche

---

## Diagnostic et Outils

### 🔧 Outils de Diagnostic

#### Vérification Rapide
```powershell
# État général du système
.\outils-techniques\verify-simple.ps1
```

#### Diagnostic Complet
```powershell
# Santé complète du repository
.\outils-techniques\verify-repository-health.ps1
```

#### Identification des Problèmes
```powershell
# Images manquantes
.\scripts\identify-missing-images.ps1

# Vérification minimale
.\outils-techniques\verify-minimal.ps1
```

### 📊 Surveillance Continue

#### Indicateurs à Surveiller
- **Temps de réponse** : < 3 secondes
- **Disponibilité** : 99%+
- **Espace disque** : > 20% libre
- **Accès PNJ** : Fonctionnel 24h/24

#### Alertes Automatiques
```powershell
# Script de surveillance (à programmer)
# Vérification toutes les heures
.\scripts\monitor-health.ps1
```

---

## Escalade et Contacts

### 🚨 Quand Escalader

#### Escalade Immédiate (< 15 min)
- **Sécurité compromise** : Accès non autorisé
- **Site complètement down** : > 30 minutes
- **Perte de données** : Fichiers corrompus
- **Urgence médicale** : Pendant un événement

#### Escalade Rapide (< 2h)
- **Fonctionnalités critiques** : PNJ bloqués
- **Performance dégradée** : Site très lent
- **Problèmes récurrents** : Échecs répétés

#### Escalade Normale (< 24h)
- **Améliorations** : Nouvelles fonctionnalités
- **Optimisations** : Performance générale
- **Formation** : Besoin d'aide

### 📞 Contacts d'Urgence

#### Équipe Technique
- **Responsable technique** : [À compléter]
- **Développeur principal** : [À compléter]
- **Support système** : [À compléter]

#### Équipe Organisation
- **Coordinateur général** : [À compléter]
- **Responsable PNJ** : [À compléter]
- **Responsable logistique** : [À compléter]

#### Services Externes
- **Hébergeur** : [Contacts support]
- **Fournisseur internet** : [Support technique]
- **Secours** : 15 (SAMU), 18 (Pompiers), 17 (Police)

### 📝 Informations à Fournir

#### Lors de l'Escalade
1. **Nature exacte du problème**
2. **Heure d'apparition**
3. **Actions déjà tentées**
4. **Messages d'erreur** (captures d'écran)
5. **Impact sur les utilisateurs**
6. **Urgence** (critique/important/mineur)

#### Documentation à Conserver
- **Logs des scripts** exécutés
- **Captures d'écran** des erreurs
- **Historique** des actions récentes
- **Configuration** actuelle du système

---

## 📚 Ressources Complémentaires

### 📖 Documentation Associée
- **[Manuel Administrateur](MANUEL_ADMINISTRATEUR.md)** - Procédures complètes
- **[Guide de Maintenance Simplifié](GUIDE_MAINTENANCE_SIMPLIFIE.md)** - Maintenance courante
- **[Guide PNJ Complet](GUIDE_PNJ_COMPLET.md)** - Problèmes spécifiques PNJ

### 🛠️ Outils Utiles
- **PowerShell ISE** : Environnement de script avancé
- **Notepad++** : Éditeur pour fichiers de configuration
- **Process Monitor** : Surveillance des processus système
- **Navigateurs multiples** : Test de compatibilité

### 📋 Templates de Rapport

#### Rapport d'Incident
```
RAPPORT D'INCIDENT - [DATE/HEURE]

🚨 PROBLÈME :
- Description : [Description précise]
- Gravité : [Critique/Important/Mineur]
- Impact : [Nombre d'utilisateurs affectés]

🔍 DIAGNOSTIC :
- Symptômes observés : [Liste]
- Tests effectués : [Liste des vérifications]
- Résultats : [Ce qui a été trouvé]

🔧 ACTIONS CORRECTIVES :
- Solutions tentées : [Liste chronologique]
- Solution efficace : [Ce qui a fonctionné]
- Temps de résolution : [Durée]

📝 SUIVI :
- Actions préventives : [Pour éviter la récurrence]
- Documentation mise à jour : [Oui/Non]
- Formation nécessaire : [Si applicable]

Responsable : [Nom]
Validé par : [Nom du superviseur]
```

---

## 🎯 Checklist de Résolution

### ✅ Avant de Commencer
- [ ] Identifier précisément le problème
- [ ] Évaluer l'urgence et l'impact
- [ ] Sauvegarder si nécessaire
- [ ] Noter l'heure de début

### ✅ Pendant la Résolution
- [ ] Suivre les solutions dans l'ordre
- [ ] Documenter chaque action
- [ ] Tester après chaque étape
- [ ] Escalader si nécessaire

### ✅ Après la Résolution
- [ ] Vérifier que tout fonctionne
- [ ] Documenter la solution efficace
- [ ] Mettre à jour ce guide si nécessaire
- [ ] Informer l'équipe de la résolution

---

*Guide de résolution de problèmes mis à jour le 24/05/2025 - Version complète*

**Rappel Important** : En cas de doute, il vaut mieux escalader rapidement que de risquer d'aggraver le problème. L'équipe technique est là pour vous aider !