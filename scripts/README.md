# Scripts utilitaires de Malvinaland

Ce dossier contient des scripts utilitaires pour faciliter le déploiement et la maintenance du site Malvinaland. Ces scripts sont principalement destinés aux administrateurs techniques du projet.

**IMPORTANT** : Le site Malvinaland est accessible UNIQUEMENT via le domaine **https://malvinaland.myia.io/**. Ce domaine pointe directement vers le répertoire `site` de ce dépôt via la configuration IIS. Les scripts de déploiement servent uniquement à configurer IIS correctement, et non à déployer le site sur un autre serveur.

## Liste des scripts disponibles

### Scripts de déploiement

- **deploy.ps1** - Script principal de déploiement du site
- **deploy-iis-simple.ps1** - Déploiement simplifié vers IIS
- **deploy-iis-improved.ps1** - Déploiement amélioré vers IIS avec options supplémentaires
- **deploy-iis-admin.ps1** - Déploiement avec droits administrateur
- **fix-iis-deployment.ps1** - Correction des problèmes courants de déploiement IIS

### Scripts de maintenance

- **clean-repository.ps1** - Nettoie les fichiers temporaires et les caches
- **identify-missing-images.ps1** - Identifie les images référencées mais manquantes
- **optimize-images.js** - Optimise les images pour le web
- **prepare-commit.ps1** - Prépare les fichiers pour un commit (vérifications, formatage, etc.)

## Comment utiliser ces scripts

### Prérequis

- **PowerShell** pour les scripts .ps1
- **Node.js** pour les scripts .js

### Exécution d'un script PowerShell

1. Ouvrez PowerShell en tant qu'administrateur
2. Naviguez vers le dossier du projet
3. Exécutez le script avec la commande:
   ```powershell
   .\scripts\nom-du-script.ps1
   ```

### Exécution d'un script Node.js

1. Ouvrez un terminal
2. Naviguez vers le dossier du projet
3. Exécutez le script avec la commande:
   ```
   node scripts/nom-du-script.js
   ```

## Description détaillée des scripts

### deploy.ps1

Script principal de déploiement qui génère le site et configure IIS pour servir le contenu du répertoire `site` via **https://malvinaland.myia.io/**.

**Utilisation:**
```powershell
.\scripts\deploy.ps1 [-Environment <dev|prod>] [-SkipBuild]
```

**Paramètres:**
- `-Environment`: Environnement cible (dev ou prod, par défaut: dev)
- `-SkipBuild`: Ignore l'étape de construction du site

### deploy-iis-simple.ps1

Version simplifiée du déploiement vers IIS, idéale pour les déploiements rapides.

**Utilisation:**
```powershell
.\scripts\deploy-iis-simple.ps1
```

### deploy-iis-improved.ps1

Version améliorée du déploiement vers IIS avec des options supplémentaires.

**Utilisation:**
```powershell
.\scripts\deploy-iis-improved.ps1 [-SiteName <nom>] [-AppPoolName <nom>] [-Port <port>]
```

**Paramètres:**
- `-SiteName`: Nom du site IIS (par défaut: Malvinaland)
- `-AppPoolName`: Nom du pool d'applications (par défaut: MalvinalandAppPool)
- `-Port`: Port d'écoute (par défaut: 80)

### deploy-iis-admin.ps1

Déploiement avec droits administrateur, à utiliser lorsque des permissions élevées sont nécessaires.

**Utilisation:**
```powershell
.\scripts\deploy-iis-admin.ps1
```

### fix-iis-deployment.ps1

Corrige les problèmes courants de déploiement IIS (permissions, bindings, etc.) pour assurer que le site soit correctement accessible via **https://malvinaland.myia.io/**.

**Utilisation:**
```powershell
.\scripts\fix-iis-deployment.ps1
```

### clean-repository.ps1

Nettoie les fichiers temporaires, les caches et autres fichiers non nécessaires.

**Utilisation:**
```powershell
.\scripts\clean-repository.ps1 [-Deep]
```

**Paramètres:**
- `-Deep`: Effectue un nettoyage plus approfondi (supprime node_modules, etc.)

### identify-missing-images.ps1

Analyse le contenu du site pour identifier les images référencées mais manquantes.

**Utilisation:**
```powershell
.\scripts\identify-missing-images.ps1 [-OutputFile <chemin>]
```

**Paramètres:**
- `-OutputFile`: Chemin du fichier de sortie pour le rapport (par défaut: missing-images.txt)

### optimize-images.js

Optimise les images pour le web en réduisant leur taille sans perte de qualité visible.

**Utilisation:**
```
node scripts/optimize-images.js [chemin/vers/image.jpg] [options]
```

**Options:**
- `--quality=<0-100>`: Qualité de compression (par défaut: 80)
- `--max-width=<pixels>`: Largeur maximale (par défaut: 1920)
- `--output=<dossier>`: Dossier de sortie

### prepare-commit.ps1

Prépare les fichiers pour un commit en effectuant diverses vérifications et formatages.

**Utilisation:**
```powershell
.\scripts\prepare-commit.ps1
```

## Bonnes pratiques

- **Sauvegardez toujours** avant d'exécuter des scripts de déploiement
- **Testez d'abord** sur un environnement de développement
- **Vérifiez les logs** après l'exécution pour détecter d'éventuelles erreurs
- **Ne modifiez pas** les scripts sans comprendre leur fonctionnement
- **Documentez** toute modification apportée aux scripts

## Dépannage

### Problèmes courants

1. **Erreur "Accès refusé"**
   - Exécutez PowerShell en tant qu'administrateur
   - Vérifiez les permissions sur les dossiers concernés

2. **Erreur "Le terme '...' n'est pas reconnu"**
   - Vérifiez que les prérequis sont installés
   - Vérifiez que vous êtes dans le bon dossier

3. **Le déploiement échoue**
   - Vérifiez les logs dans le dossier `logs/`
   - Exécutez `fix-iis-deployment.ps1` pour corriger les problèmes courants
   - Vérifiez que le site est accessible via **https://malvinaland.myia.io/**

## Ressources supplémentaires

- [Documentation IIS](https://docs.microsoft.com/fr-fr/iis/)
- [Documentation PowerShell](https://docs.microsoft.com/fr-fr/powershell/)
- [Documentation Node.js](https://nodejs.org/fr/docs/)

Pour plus d'informations sur le processus complet de déploiement, consultez le fichier `WORKFLOW.md` à la racine du projet.