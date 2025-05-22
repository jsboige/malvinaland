# Site dÃ©ployable "Les mondes de Malvinha"

Ce dossier contient la version dÃ©ployable du site "Les mondes de Malvinha".
Il est conÃ§u pour Ãªtre lÃ©ger et ne contient que les fichiers nÃ©cessaires au fonctionnement du site.

Les images haute rÃ©solution sont stockÃ©es dans le dossier ../ressources/images/.

## Structure du site

- index.html : Page de redirection vers Core/index.html
- web.config : Configuration IIS
- pp.js : Script JavaScript principal
- Core/ : Configuration et navigation communes
- Composants/ : Styles CSS communs
- Mondes/ : Structure lÃ©gÃ¨re des mondes avec miniatures
- Services/ : Service worker pour le fonctionnement hors ligne

## DÃ©ploiement

Pour dÃ©ployer ce site, copiez simplement ce dossier sur votre serveur web.
