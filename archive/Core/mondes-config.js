/**
 * Configuration des mondes de Malvinaland
 *
 * Ce fichier centralise les informations de base sur chaque monde du site.
 * Il définit les propriétés suivantes pour chaque monde :
 * - id : Identifiant unique utilisé dans les URLs et les références
 * - nom : Nom complet du monde affiché à l'utilisateur
 * - couleur : Code couleur hexadécimal associé au monde
 * - icone : Emoji ou caractère représentant le monde
 * - description : Brève description du monde
 * - position : Informations sur la position du monde sur la carte et ses voisins
 *
 * Cette configuration est utilisée par le système de navigation et d'autres
 * composants du site pour générer dynamiquement le contenu et les liens.
 */

/**
 * Configuration globale des mondes
 * @type {Object.<string, {id: string, nom: string, couleur: string, icone: string, description: string, position: {carte: string, voisins: string[]}}>}
 */
const mondesConfig = {
    /**
     * Monde de l'Assemblée
     * Point central de rassemblement et lieu de convergence
     */
    "monde-assemblee": {
        id: "monde-assemblee",
        nom: "Le Monde de l'Assemblée",
        couleur: "#e74c3c", // Rouge
        icone: "🔥",
        description: "Un lieu mystique avec deux cercles d'assemblée qui semblent suspendus hors du temps.",
        position: {
            carte: "rouge",
            voisins: ["monde-jeux", "monde-zob", "monde-karibu"] // Connexions avec d'autres mondes
        }
    },
    
    // Monde de la Grange
    "monde-grange": {
        id: "monde-grange",
        nom: "Le Monde de la Grange",
        couleur: "#2ecc71", // Vert
        icone: "🌍",
        description: "Un bâtiment longitudinal avec quatre façades distinctives et un espace végétalisé.",
        position: {
            carte: "vert",
            voisins: []
        }
    },
    
    // Monde des Jeux
    "monde-jeux": {
        id: "monde-jeux",
        nom: "Le Monde des Jeux",
        couleur: "#3498db", // Bleu
        icone: "🌍",
        description: "Le Royaume de l'Enfance Éternelle, avec un grand trampoline octogonal au centre.",
        position: {
            carte: "bleu",
            voisins: ["monde-assemblee", "monde-reves"]
        }
    },
    
    // Monde des Rêves
    "monde-reves": {
        id: "monde-reves",
        nom: "Le Monde des Rêves",
        couleur: "#9b59b6", // Violet
        icone: "🌙",
        description: "Un point de convergence mystique entre les différents mondes de Malvinaland.",
        position: {
            carte: "violet",
            voisins: ["monde-jeux"]
        }
    },
    
    // Monde du Damier
    "monde-damier": {
        id: "monde-damier",
        nom: "Le Monde du Damier",
        couleur: "#87CEEB", // Bleu clair
        icone: "🌍",
        description: "Un lieu dominé par un imposant panneau solaire photovoltaïque.",
        position: {
            carte: "bleu clair",
            voisins: []
        }
    },
    
    // Monde du Linge
    "monde-linge": {
        id: "monde-linge",
        nom: "Le Monde du Linge",
        couleur: "#f1c40f", // Jaune
        icone: "🌍",
        description: "Un jardin avec une longue corde à linge bleue tendue entre deux arbres imposants.",
        position: {
            carte: "jaune",
            voisins: ["monde-sphinx"]
        }
    },
    
    // Monde du Verger
    "monde-verger": {
        id: "monde-verger",
        nom: "Le Monde du Verger",
        couleur: "#27ae60", // Vert foncé
        icone: "🌍",
        description: "Un sanctuaire naturel dominé par un verger d'arbres fruitiers variés.",
        position: {
            carte: "vert foncé",
            voisins: []
        }
    },
    
    // Monde du Zob
    "monde-zob": {
        id: "monde-zob",
        nom: "Le Monde du Zob",
        couleur: "#e67e22", // Orange
        icone: "🌍",
        description: "Une yourte distinctive entourée d'une végétation luxuriante.",
        position: {
            carte: "orange",
            voisins: ["monde-assemblee"]
        }
    },
    
    // Monde Elysée
    "monde-elysee": {
        id: "monde-elysee",
        nom: "Le Monde Elysée",
        couleur: "#95a5a6", // Gris
        icone: "🌍",
        description: "Deux caravanes résidentielles à l'entrée de la propriété.",
        position: {
            carte: "gris",
            voisins: []
        }
    },
    
    // Monde Karibu
    "monde-karibu": {
        id: "monde-karibu",
        nom: "Le Monde Karibu",
        couleur: "#d35400", // Orange foncé
        icone: "🌍",
        description: "Une cuisine d'été rustique au cœur du domaine de Malvinaland.",
        position: {
            carte: "orange foncé",
            voisins: ["monde-assemblee"]
        }
    },
    
    // Monde orange des Sphinx
    "monde-sphinx": {
        id: "monde-sphinx",
        nom: "Le Monde Orange des Sphinx",
        couleur: "#f39c12", // Orange clair
        icone: "🌍",
        description: "Un monde mystérieux avec des énigmes à résoudre.",
        position: {
            carte: "orange clair",
            voisins: ["monde-linge"]
        }
    }
};

/**
 * Exporter la configuration pour une utilisation dans d'autres scripts
 * Cette condition permet d'utiliser ce fichier à la fois dans un environnement
 * navigateur (inclusion directe via <script>) et dans un environnement Node.js
 * (importation via require())
 */
if (typeof module !== 'undefined' && module.exports) {
    module.exports = mondesConfig;
}