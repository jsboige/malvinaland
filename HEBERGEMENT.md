# Hébergement du Site Malvinaland

## 🌐 Informations de Production

**URL du site :** https://malvinaland.myia.io/  
**Serveur :** IIS (Internet Information Services)  
**Répertoire publié :** `site/` de ce dépôt Git  
**Déploiement :** Automatique via IIS

## Architecture de Déploiement

### Principe de Fonctionnement
- **IIS publie directement le répertoire `site/`** de ce dépôt
- **Aucun hébergement supplémentaire requis**
- **Aucune configuration complexe nécessaire**
- **Mise à jour automatique** lors des modifications du répertoire `site/`

### Structure de Déploiement
```
d:/Production/malvinaland/
├── src/                    # Sources (Eleventy)
├── site/                   # ← PUBLIÉ PAR IIS
│   ├── index.html
│   ├── content/
│   │   ├── carte/
│   │   └── mondes/
│   ├── assets/
│   └── ...
├── scripts/                # Scripts de maintenance
└── outils-techniques/      # Outils de développement
```

## URLs Principales

| Page | URL de Production |
|------|-------------------|
| **Accueil** | https://malvinaland.myia.io/ |
| **Carte Interactive** | https://malvinaland.myia.io/carte/ |
| **Mondes** | https://malvinaland.myia.io/mondes/ |
| **Organisateurs** | https://malvinaland.myia.io/organisateurs/ |
| **Documentation** | https://malvinaland.myia.io/documentation/ |

## Processus de Mise à Jour

### 1. Développement Local
```powershell
# Modifier les sources dans src/
# Compiler avec Eleventy
npx @11ty/eleventy

# Tester localement
npx @11ty/eleventy --serve
```

### 2. Déploiement Automatique
- Les modifications dans `site/` sont **automatiquement publiées par IIS**
- **Aucune action manuelle requise**
- **Prise en compte immédiate** des changements

### 3. Validation
- Vérifier sur https://malvinaland.myia.io/
- Tester les fonctionnalités modifiées
- Valider la carte interactive corrigée

## Configuration IIS

### Paramètres Actuels
- **Répertoire racine :** `d:/Production/malvinaland/site/`
- **Pool d'applications :** Configuration standard
- **Authentification :** Anonyme
- **Modules requis :** URL Rewrite (pour les routes propres)

### Fichiers de Configuration
- `site/web.config` : Configuration IIS spécifique
- Gestion des erreurs 404
- Règles de réécriture d'URL
- Configuration du cache

## Avantages de cette Architecture

### ✅ Simplicité
- **Pas de serveur supplémentaire** à maintenir
- **Pas de processus de déploiement complexe**
- **Mise à jour directe** des fichiers

### ✅ Fiabilité
- **IIS gère automatiquement** la publication
- **Pas de point de défaillance** supplémentaire
- **Performance optimale** avec IIS

### ✅ Maintenance
- **Modifications directes** dans le dépôt
- **Historique Git complet** des changements
- **Rollback facile** en cas de problème

## Surveillance et Maintenance

### Monitoring
- **URL principale :** https://malvinaland.myia.io/
- **Carte interactive :** https://malvinaland.myia.io/carte/
- **Vérification automatique** via scripts PowerShell

### Logs
- **Logs IIS :** Disponibles dans les logs standard IIS
- **Erreurs 404 :** Gérées par `web.config`
- **Performance :** Monitoring via IIS Manager

### Maintenance Préventive
```powershell
# Vérifier l'état du site
scripts/test-iis-deployment.ps1

# Nettoyer les fichiers temporaires
scripts/clean-temp-files.ps1

# Valider la carte interactive
outils-techniques/deployer-carte-corrigee.ps1
```

## Sécurité

### Accès
- **Lecture seule** pour les visiteurs
- **Pas d'authentification** requise pour le contenu public
- **Section organisateurs** protégée si nécessaire

### Fichiers Sensibles
- **Scripts PowerShell** non accessibles via web
- **Sources `src/`** non publiées
- **Configuration** sécurisée dans `web.config`

## Support et Dépannage

### Problèmes Courants
1. **Site inaccessible :** Vérifier l'état d'IIS
2. **Erreurs 404 :** Contrôler `web.config` et les routes
3. **Cache :** Vider le cache navigateur et IIS
4. **Carte interactive :** Utiliser les outils de correction automatique

### Contacts
- **Administration système :** Responsable IIS
- **Développement :** Équipe Malvinaland
- **URL de test :** https://malvinaland.myia.io/

---

**Dernière mise à jour :** 26 mai 2025  
**Version :** Production avec carte interactive corrigée  
**Statut :** ✅ Opérationnel