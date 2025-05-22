# Guide de déploiement IIS pour Malvinaland

Ce guide explique comment déployer le site Malvinaland sur un serveur IIS (Internet Information Services).

## Prérequis

- Windows Server avec IIS installé (version 8.0 ou supérieure)
- Module URL Rewrite pour IIS installé
- .NET Framework 4.7.2 ou supérieur
- Droits d'administrateur sur le serveur

## Installation des prérequis

### Installation d'IIS

Si IIS n'est pas déjà installé, vous pouvez l'installer via le Gestionnaire de serveur :

1. Ouvrez le Gestionnaire de serveur
2. Cliquez sur "Ajouter des rôles et fonctionnalités"
3. Sélectionnez "Installation basée sur un rôle ou une fonctionnalité"
4. Sélectionnez votre serveur
5. Cochez "Serveur Web (IIS)"
6. Suivez les instructions pour terminer l'installation

### Installation du module URL Rewrite

1. Téléchargez le module URL Rewrite depuis le site de Microsoft : [URL Rewrite](https://www.iis.net/downloads/microsoft/url-rewrite)
2. Exécutez le programme d'installation
3. Suivez les instructions pour terminer l'installation

## Déploiement manuel

### Étape 1 : Préparation des fichiers

1. Assurez-vous que tous les fichiers du site sont prêts dans le dossier `site`
2. Vérifiez que le fichier `web.config` est correctement configuré

### Étape 2 : Copie des fichiers

1. Créez un dossier pour le site dans `C:\inetpub\wwwroot\` (par exemple, `C:\inetpub\wwwroot\malvinaland`)
2. Copiez tous les fichiers du dossier `site` vers ce dossier

### Étape 3 : Configuration d'IIS

1. Ouvrez le Gestionnaire des services Internet (IIS)
2. Cliquez avec le bouton droit sur "Sites" et sélectionnez "Ajouter un site Web"
3. Configurez le site :
   - Nom du site : Malvinaland
   - Chemin physique : `C:\inetpub\wwwroot\malvinaland`
   - Liaison : HTTP, port 80, nom d'hôte : malvinaland.myia.io (ou votre nom d'hôte)
4. Cliquez sur OK pour créer le site

### Étape 4 : Configuration des autorisations

1. Accédez au dossier `C:\inetpub\wwwroot\malvinaland`
2. Cliquez avec le bouton droit et sélectionnez "Propriétés"
3. Allez dans l'onglet "Sécurité"
4. Cliquez sur "Modifier" puis sur "Ajouter"
5. Ajoutez l'utilisateur `IIS_IUSRS` avec les autorisations de lecture et d'exécution
6. Cliquez sur OK pour appliquer les modifications

### Étape 5 : Configuration HTTPS (recommandé)

1. Obtenez un certificat SSL pour votre domaine
2. Dans le Gestionnaire IIS, sélectionnez votre site
3. Dans le panneau "Actions" à droite, cliquez sur "Liaisons"
4. Cliquez sur "Ajouter" et configurez une liaison HTTPS avec votre certificat
5. Cliquez sur OK pour appliquer les modifications

## Déploiement automatisé

Pour un déploiement automatisé, utilisez le script PowerShell fourni :

```powershell
.\scripts\deploy-iis-improved.ps1
```

Ce script effectue les opérations suivantes :
1. Corrige les chemins de fichiers dans les fichiers HTML
2. Corrige les problèmes de menu mobile
3. Crée des fichiers README.md pour résoudre les erreurs 404
4. Corrige le README.md principal
5. Déploie les fichiers sur IIS
6. Vide le cache IIS et redémarre le service

## Vérification du déploiement

Après le déploiement, vérifiez que le site fonctionne correctement :

1. Ouvrez un navigateur et accédez à votre site (http://malvinaland.myia.io ou https://malvinaland.myia.io)
2. Vérifiez que la page d'accueil s'affiche correctement
3. Naviguez vers différentes sections du site pour vous assurer qu'elles fonctionnent
4. Vérifiez les journaux d'erreurs IIS si vous rencontrez des problèmes

## Résolution des problèmes courants

### Erreur 500.19 - Internal Server Error

Cette erreur est souvent liée à des problèmes de configuration dans le fichier `web.config`.

**Solution** : Vérifiez que le module URL Rewrite est correctement installé et que le fichier `web.config` est valide.

### Erreur 404 - Page Not Found

Cette erreur peut être due à des problèmes de réécriture d'URL ou à des fichiers manquants.

**Solution** : Vérifiez les règles de réécriture dans le fichier `web.config` et assurez-vous que tous les fichiers nécessaires sont présents.

### Problèmes de menu mobile

Si le menu mobile ne fonctionne pas correctement, cela peut être dû à des problèmes de scripts JavaScript.

**Solution** : Exécutez le script `fix-mobile-menu.ps1` pour corriger les problèmes de menu mobile.

### Problèmes de performance

Si le site est lent, cela peut être dû à une mauvaise configuration de la compression ou du cache.

**Solution** : Vérifiez la configuration de la compression et du cache dans le fichier `web.config` et optimisez-la si nécessaire.

## Maintenance

Pour maintenir le site en bon état de fonctionnement :

1. Videz régulièrement le cache IIS
2. Surveillez les journaux d'erreurs
3. Mettez à jour les certificats SSL avant leur expiration
4. Effectuez des sauvegardes régulières du site

## Ressources supplémentaires

- [Documentation officielle IIS](https://docs.microsoft.com/fr-fr/iis/)
- [Documentation URL Rewrite](https://docs.microsoft.com/fr-fr/iis/extensions/url-rewrite-module/using-the-url-rewrite-module)
- [Guide de sécurisation d'IIS](https://docs.microsoft.com/fr-fr/iis/manage/configuring-security/how-to-set-up-ssl-on-iis)