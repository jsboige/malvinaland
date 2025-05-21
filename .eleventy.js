const { DateTime } = require("luxon");
const markdownIt = require("markdown-it");
const markdownItContainer = require("markdown-it-container");
const fs = require("fs");
const path = require("path");

module.exports = function(eleventyConfig) {
  // Copier les fichiers statiques
  eleventyConfig.addPassthroughCopy("src/assets");
  
  // Configuration du Markdown
  const mdOptions = {
    html: true,
    breaks: true,
    linkify: true
  };
  
  // Créer une instance de markdown-it
  const md = markdownIt(mdOptions)
    // Plugin pour les conteneurs personnalisés
    .use(markdownItContainer, "organisateurs-only", {
      validate: function(params) {
        return params.trim() === "organisateurs-only";
      },
      render: function(tokens, idx) {
        if (tokens[idx].nesting === 1) {
          return '<div class="organisateurs-only">\n';
        } else {
          return '</div>\n';
        }
      }
    });
  
  eleventyConfig.setLibrary("md", md);
  
  // Filtres personnalisés
  eleventyConfig.addFilter("readableDate", dateObj => {
    return DateTime.fromJSDate(dateObj, {zone: 'utc'}).toFormat("dd/MM/yyyy");
  });
  
  // Filtre pour vérifier si un contenu est visible pour un rôle
  eleventyConfig.addFilter("isVisibleForRole", (visibility, role) => {
    if (!visibility) return true; // Si pas de visibilité définie, visible pour tous
    if (Array.isArray(visibility)) {
      return visibility.includes(role);
    }
    return visibility === role;
  });
  
  // Collections personnalisées
  eleventyConfig.addCollection("mondes", function(collectionApi) {
    return collectionApi.getFilteredByGlob("src/content/mondes/*/index.md");
  });
  
  eleventyConfig.addCollection("organisateurs", function(collectionApi) {
    return collectionApi.getFilteredByGlob("src/content/organisateurs/**/*.md");
  });
  
  // Middleware pour filtrer le contenu en fonction du rôle
  eleventyConfig.addGlobalData("includeOrganisateurs", () => {
    return process.env.INCLUDE_ORGANISATEURS === "true";
  });
  
  // Fonction pour vérifier si un fichier doit être généré
  eleventyConfig.addGlobalData("shouldGenerate", () => {
    return function(data) {
      const includeOrganisateurs = process.env.INCLUDE_ORGANISATEURS === "true";
      
      // Si pas de visibilité définie, générer pour tous
      if (!data.visibility) return true;
      
      // Si on inclut le contenu organisateurs, générer tous les fichiers
      if (includeOrganisateurs) return true;
      
      // Sinon, générer uniquement les fichiers visibles pour les joueurs
      if (Array.isArray(data.visibility)) {
        return data.visibility.includes("joueurs");
      }
      
      return data.visibility === "joueurs";
    };
  });
  
  // Configuration de base
  return {
    dir: {
      input: "src",
      output: "site",
      includes: "_includes",
      data: "_data"
    },
    templateFormats: ["md", "njk", "html"],
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
    dataTemplateEngine: "njk"
  };
};