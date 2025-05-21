/**
 * Configuration des mondes de Malvinaland
 * Ce fichier centralise les informations de base sur chaque monde du site.
 */

module.exports = {
  "assemblee": {
    id: "assemblee",
    nom: "Le Monde de l'Assemblée",
    couleur: "#e74c3c", // Rouge
    icone: "🔥",
    description: "Un lieu mystique avec deux cercles d'assemblée qui semblent suspendus hors du temps.",
    position: {
      carte: "rouge",
      voisins: ["jeux", "zob", "karibu"] // Connexions avec d'autres mondes
    }
  },
  
  "grange": {
    id: "grange",
    nom: "Le Monde de la Grange",
    couleur: "#2ecc71", // Vert
    icone: "🌍",
    description: "Un bâtiment longitudinal avec quatre façades distinctives et un espace végétalisé.",
    position: {
      carte: "vert",
      voisins: []
    }
  },
  
  "jeux": {
    id: "jeux",
    nom: "Le Monde des Jeux",
    couleur: "#3498db", // Bleu
    icone: "🌍",
    description: "Le Royaume de l'Enfance Éternelle, avec un grand trampoline octogonal au centre.",
    position: {
      carte: "bleu",
      voisins: ["assemblee", "reves"]
    }
  },
  
  "reves": {
    id: "reves",
    nom: "Le Monde des Rêves",
    couleur: "#9b59b6", // Violet
    icone: "🌙",
    description: "Un point de convergence mystique entre les différents mondes de Malvinaland.",
    position: {
      carte: "violet",
      voisins: ["jeux"]
    }
  },
  "damier": {
    id: "damier",
    nom: "Le Monde du Damier",
    couleur: "#87CEEB", // Bleu clair
    icone: "🌞",
    description: "Un lieu dominé par un imposant panneau solaire photovoltaïque, symbole de l'énergie et de la précision mathématique.",
    position: {
      carte: "bleu clair",
      voisins: ["verger", "zob"]
    }
  },
  
  "linge": {
    id: "linge",
    nom: "Le Monde du Linge",
    couleur: "#9370DB", // Violet moyen
    icone: "🧵",
    description: "Un sanctuaire des traditions du lavage et de l'entretien du linge, avec une corde à linge bleue comme élément central.",
    position: {
      carte: "violet",
      voisins: ["sphinx"]
    }
  },
  
  "verger": {
    id: "verger",
    nom: "Le Monde du Verger",
    couleur: "#FFC0CB", // Rose
    icone: "🌳",
    description: "Un sanctuaire naturel abritant un modeste verger de jeunes arbres fruitiers variés.",
    position: {
      carte: "rose",
      voisins: ["damier", "karibu", "zob", "reves"]
    }
  },
  
  "zob": {
    id: "zob",
    nom: "Le Monde du Zob",
    couleur: "#FF7F50", // Corail
    icone: "🧘",
    description: "Un espace de contemplation centré autour d'une yourte octogonale avec une ouverture en forme d'étoile au sommet.",
    position: {
      carte: "corail",
      voisins: ["assemblee", "damier", "verger"]
    }
  },
  
  "elysee": {
    id: "elysee",
    nom: "Le Monde Elysée",
    couleur: "#FFFFFF", // Blanc
    icone: "🏛️",
    description: "Un monde d'accueil constitué de deux caravanes résidentielles aux styles contrastés, symbolisant la diplomatie et le passage.",
    position: {
      carte: "blanc",
      voisins: []
    }
  },
  
  "karibu": {
    id: "karibu",
    nom: "Le Monde Karibu",
    couleur: "#FFA500", // Orange
    icone: "🔥",
    description: "Une cuisine d'été rustique incarnant l'hospitalité et l'accueil, point culminant de l'aventure.",
    position: {
      carte: "orange",
      voisins: ["assemblee", "verger"]
    }
  },
  
  "sphinx": {
    id: "sphinx",
    nom: "Le Monde Orange des Sphinx",
    couleur: "#FF4500", // Orange rouge
    icone: "🐱",
    description: "Un domaine mystérieux dominé par une bâtisse aux murs orange vif, gardé par des sphinx félins.",
    position: {
      carte: "orange rouge",
      voisins: ["linge"]
    }
  }
};