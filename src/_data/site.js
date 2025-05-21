/**
 * Configuration globale du site Malvinaland
 */

module.exports = {
  title: "Malvinaland",
  description: "Jeu de piste immersif dans les mondes de Malvinaland",
  url: "https://malvinaland.myia.io",
  author: "Équipe Malvinaland",
  buildTime: new Date(),
  environment: process.env.ELEVENTY_ENV || "development",
  includeOrganisateurs: process.env.INCLUDE_ORGANISATEURS === "true",
  navigation: [
    {
      text: "Accueil",
      url: "/",
      icon: "🏠"
    },
    {
      text: "Carte",
      url: "/carte/",
      icon: "🗺️"
    },
    {
      text: "Narration",
      url: "/narration/",
      icon: "📚"
    },
    {
      text: "Personnages",
      url: "/personnages/",
      icon: "👥"
    }
  ],
  organisateursNavigation: [
    {
      text: "Espace Organisateurs",
      url: "/organisateurs/",
      icon: "🔒",
      class: "orga-link"
    },
    {
      text: "PNJ",
      url: "/organisateurs/pnj/",
      icon: "🎭",
      class: "orga-link"
    },
    {
      text: "Notes",
      url: "/organisateurs/notes/",
      icon: "📝",
      class: "orga-link"
    }
  ]
};