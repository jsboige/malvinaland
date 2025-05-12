/**
 * Configuration centralisée des mondes de Malvinha
 * Ce fichier contient la liste de tous les mondes disponibles avec leurs informations
 */

const MONDES_CONFIG = [
    { 
        id: 'assemblee', 
        name: '🔥 Monde de l\'Assemblée', 
        url: 'Mondes/Le monde de l\'assemblée/index.html',
        color: '#a83232', // Rouge
        description: 'Le monde des cercles et des rassemblements'
    },
    { 
        id: 'grange', 
        name: '🌍 Monde de la Grange', 
        url: 'Mondes/Le monde de la grange/index.html',
        color: '#4CAF50', // Vert
        description: 'Le monde du bâtiment longitudinal aux quatre façades'
    },
    { 
        id: 'jeux', 
        name: '🌍 Monde des Jeux', 
        url: 'Mondes/Le monde des jeux/index.html',
        color: '#2196F3', // Bleu
        description: 'Le royaume de l\'enfance éternelle'
    },
    { 
        id: 'reves', 
        name: '🌙 Monde des Rêves', 
        url: 'Mondes/Le monde des rêves/index.html',
        color: '#FFC107', // Jaune
        description: 'Le monde central avec son arche en bois'
    },
    { 
        id: 'damier', 
        name: '🌍 Monde du Damier', 
        url: 'Mondes/Le monde du damier/index.html',
        color: '#03A9F4', // Bleu clair
        description: 'Le monde du panneau solaire aux 48×20 dalles'
    },
    { 
        id: 'linge', 
        name: '🌍 Monde du Linge', 
        url: 'Mondes/Le monde du linge/index.html',
        color: '#9C27B0', // Violet
        description: 'Le monde de la corde à linge et des pinces colorées'
    },
    { 
        id: 'verger', 
        name: '🌍 Monde du Verger', 
        url: 'Mondes/Le monde du verger/index.html',
        color: '#E91E63', // Rose
        description: 'Le monde des arbres fruitiers et de la cabane à oiseaux'
    },
    { 
        id: 'zob', 
        name: '🌍 Monde du Zob', 
        url: 'Mondes/Le monde du Zob/index.html',
        color: '#9E9E9E', // Gris
        description: 'Le monde de la yourte et de la bambouseraie'
    },
    { 
        id: 'elysee', 
        name: '🌍 Monde Elysée', 
        url: 'Mondes/Le monde Elysée/index.html',
        color: '#FFFFFF', // Blanc
        description: 'Le monde extérieur avec les caravanes'
    },
    { 
        id: 'karibu', 
        name: '🌍 Monde Karibu', 
        url: 'Mondes/Le monde Karibu/index.html',
        color: '#795548', // Marron
        description: 'La cuisine d\'été au cœur du domaine'
    },
    { 
        id: 'sphinx', 
        name: '🌍 Monde Orange des Sphinx', 
        url: 'Mondes/Le monde orange des Sphinx/index.html',
        color: '#FF9800', // Orange
        description: 'La bâtisse orange où réside la propriétaire avec ses chats'
    }
];

// Exporter la configuration pour une utilisation dans d'autres fichiers
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { MONDES_CONFIG };
}