/**
 * Système de navigation pour Les Mondes de Malvinha
 * Ce fichier gère la navigation entre les différents mondes
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log('Système de navigation des Mondes de Malvinha chargé');
    
    // Initialisation du système de navigation
    initNavigation();
});

/**
 * Initialise le système de navigation
 */
function initNavigation() {
    // Liste des mondes disponibles
    const mondes = [
        {
            id: 'assemblee',
            nom: 'Le Monde de l\'Assemblée',
            couleur: '#e74c3c',
            description: 'Un lieu mystique avec deux cercles d\'assemblée qui semblent suspendus hors du temps.',
            path: 'Mondes/Le monde de l\'assemblée/index.html'
        },
        {
            id: 'grange',
            nom: 'Le Monde de la Grange',
            couleur: '#2ecc71',
            description: 'Un bâtiment longitudinal avec quatre façades distinctes et un espace végétalisé.',
            path: 'Mondes/Le monde de la grange/index.html'
        },
        {
            id: 'jeux',
            nom: 'Le Monde des Jeux',
            couleur: '#3498db',
            description: 'Le Royaume de l\'Enfance Éternelle, avec un grand trampoline octogonal au centre.',
            path: 'Mondes/Le monde des jeux/index.html'
        },
        {
            id: 'reves',
            nom: 'Le Monde des Rêves',
            couleur: '#9b59b6',
            description: 'Un point de convergence mystique entre les différents mondes de Malvinhaland.',
            path: 'Mondes/Le monde des rêves/index.html'
        },
        {
            id: 'damier',
            nom: 'Le Monde du Damier',
            couleur: '#4d8bc9',
            description: 'Un lieu dominé par un imposant panneau solaire photovoltaïque formant un damier de 48×20 cellules.',
            path: 'Mondes/Le monde du damier/index.html'
        },
        {
            id: 'linge',
            nom: 'Le Monde du Linge',
            couleur: '#f1c40f',
            description: 'Un jardin enchanteur avec une longue corde à linge bleue tendue entre deux arbres.',
            path: 'Mondes/Le monde du linge/index.html'
        },
        {
            id: 'zob',
            nom: 'Le Monde du Zob',
            couleur: '#e67e22',
            description: 'Une yourte distinctive entourée d\'une végétation luxuriante.',
            path: 'Mondes/Le monde du Zob/index.html'
        },
        {
            id: 'elysee',
            nom: 'Le Monde Elysée',
            couleur: '#95a5a6',
            description: 'L\'espace d\'accueil avec deux caravanes résidentielles, "l\'Elysée" et "le Bedouin".',
            path: 'Mondes/Le monde Elysée/index.html'
        },
        {
            id: 'karibu',
            nom: 'Le Monde Karibu',
            couleur: '#d35400',
            description: 'Une cuisine d\'été rustique au cœur du domaine de Malvinha.',
            path: 'Mondes/Le monde Karibu/index.html'
        },
        {
            id: 'sphinx',
            nom: 'Le Monde Orange des Sphinx',
            couleur: '#f39c12',
            description: 'Un monde mystérieux gardé par des sphinx.',
            path: 'Mondes/Le monde orange des Sphinx/index.html'
        }
    ];
    
    // Génération du menu de navigation
    generateNavigationMenu(mondes);
    
    // Mise en évidence du monde actuel
    highlightCurrentWorld(mondes);
    
    // Gestion des événements de navigation
    setupNavigationEvents();
}

/**
 * Génère le menu de navigation à partir de la liste des mondes
 */
function generateNavigationMenu(mondes) {
    const navContainer = document.querySelector('.navigation-mondes');
    if (!navContainer) return;
    
    const navList = navContainer.querySelector('ul') || document.createElement('ul');
    navList.className = 'mondes-list';
    
    // Vider la liste existante
    navList.innerHTML = '';
    
    // Ajouter chaque monde à la liste
    mondes.forEach(monde => {
        const listItem = document.createElement('li');
        const link = document.createElement('a');
        
        link.href = `../../${monde.path}`;
        link.textContent = monde.nom;
        link.dataset.mondeId = monde.id;
        link.style.borderLeft = `4px solid ${monde.couleur}`;
        
        listItem.appendChild(link);
        navList.appendChild(listItem);
    });
    
    // Ajouter la liste au conteneur si elle n'y est pas déjà
    if (!navContainer.querySelector('ul')) {
        navContainer.appendChild(navList);
    }
}

/**
 * Met en évidence le monde actuel dans le menu de navigation
 */
function highlightCurrentWorld(mondes) {
    const currentPath = window.location.pathname;
    
    // Trouver le monde correspondant au chemin actuel
    const currentMonde = mondes.find(monde => {
        const mondePath = monde.path.replace(/\\/g, '/');
        return currentPath.includes(mondePath);
    });
    
    if (currentMonde) {
        const currentLink = document.querySelector(`.mondes-list a[data-monde-id="${currentMonde.id}"]`);
        if (currentLink) {
            currentLink.classList.add('active-monde');
            currentLink.style.backgroundColor = currentMonde.couleur;
            currentLink.style.color = '#ffffff';
        }
    }
}

/**
 * Configure les événements pour la navigation
 */
function setupNavigationEvents() {
    const navLinks = document.querySelectorAll('.mondes-list a');
    
    navLinks.forEach(link => {
        link.addEventListener('mouseenter', () => {
            const mondeId = link.dataset.mondeId;
            showMondePreview(mondeId);
        });
        
        link.addEventListener('mouseleave', () => {
            hideMondePreview();
        });
    });
}

/**
 * Affiche un aperçu du monde au survol
 */
function showMondePreview(mondeId) {
    // Implémentation future : afficher une info-bulle ou une prévisualisation du monde
    console.log(`Aperçu du monde : ${mondeId}`);
}

/**
 * Cache l'aperçu du monde
 */
function hideMondePreview() {
    // Implémentation future : cacher l'info-bulle ou la prévisualisation
}

/**
 * Fonction utilitaire pour naviguer vers un monde spécifique
 */
function navigateToWorld(mondeId) {
    const mondes = document.querySelectorAll('.mondes-list a');
    const targetMonde = Array.from(mondes).find(monde => monde.dataset.mondeId === mondeId);
    
    if (targetMonde) {
        window.location.href = targetMonde.href;
    }
}

// Exposer les fonctions de navigation globalement
window.MalvinhaNavigation = {
    navigateToWorld
};