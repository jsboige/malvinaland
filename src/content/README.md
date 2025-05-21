# Contenu de Malvinaland

Ce dossier contient tout le contenu du site Malvinaland sous forme de fichiers Markdown. C'est ici que vous effectuerez la plupart de vos modifications lorsque vous souhaiterez mettre à jour le contenu du site.

## Structure du dossier

- **index.md** - Page d'accueil du site
- **carte.md** - Page de la carte interactive
- **narration.md** - Page de narration globale
- **login.md** - Page de connexion pour les organisateurs
- **mondes/** - Dossier contenant tous les mondes de Malvinaland
- **organisateurs/** - Contenu réservé aux organisateurs

## Comment modifier le contenu

### Pages principales

Les fichiers à la racine de ce dossier (`index.md`, `carte.md`, etc.) correspondent aux pages principales du site. Pour les modifier:

1. Ouvrez le fichier correspondant à la page que vous souhaitez modifier
2. Effectuez vos modifications en respectant la syntaxe Markdown
3. Validez vos modifications (commit)

### Mondes

Chaque monde a son propre dossier dans `mondes/`. Pour modifier un monde existant:

1. Naviguez vers le dossier du monde dans `mondes/[nom-du-monde]/`
2. Ouvrez le fichier `index.md`
3. Modifiez le contenu en respectant la structure existante

Pour ajouter un nouveau monde:

1. Créez un nouveau dossier dans `mondes/` avec le nom du monde (en minuscules, sans espaces)
2. Créez un fichier `index.md` dans ce dossier en utilisant le modèle disponible dans `templates/nouveau-monde.md`
3. Ajoutez les images du monde dans le dossier `assets/images/mondes/[nom-du-monde]/`
4. Mettez à jour le fichier `src/_data/mondes.js` pour inclure le nouveau monde dans la navigation

### Contenu pour les organisateurs

Le dossier `organisateurs/` contient du contenu réservé aux organisateurs, comme les informations sur les PNJ. Ce contenu n'est visible que lorsqu'un organisateur est connecté.

## Conseils pour la rédaction du contenu

- **Utilisez la syntaxe Markdown** pour formater votre texte (voir `STRUCTURE_CONTENU.md` pour plus d'informations)
- **Incluez des images** pour rendre le contenu plus attrayant
- **Structurez votre contenu** avec des titres et sous-titres
- **Soyez cohérent** avec le reste du contenu
- **Utilisez les balises organisateurs-only** pour le contenu réservé aux organisateurs:

```markdown
::: organisateurs-only
Ce contenu ne sera visible que pour les organisateurs.
:::
```

## Ressources utiles

- [Guide de syntaxe Markdown](https://www.markdownguide.org/basic-syntax/)
- [Documentation Eleventy](https://www.11ty.dev/docs/)
- [Templates pour nouveau contenu](../../templates/)

Pour plus d'informations sur la modification du contenu, consultez le fichier `COMMENT_MODIFIER.md` à la racine du projet.