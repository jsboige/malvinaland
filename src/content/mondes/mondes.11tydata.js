/**
 * Données de répertoire Eleventy pour les pages de mondes.
 *
 * Sans permalink, Eleventy sort src/content/mondes/<id>/index.md vers
 * /content/mondes/<id>/ — or la navigation et la carte pointent vers
 * /mondes/<id>/. Ce fichier force l'URL propre /mondes/<id>/ pour toutes
 * les pages de mondes d'un seul coup (cascade de données de répertoire).
 *
 * Les fichiers du dossier sans champ front-matter `monde` (ex. README.md)
 * ne sont pas publiés (permalink: false).
 */
module.exports = {
  eleventyComputed: {
    permalink: (data) => (data.monde ? `/mondes/${data.monde}/` : false)
  }
};
