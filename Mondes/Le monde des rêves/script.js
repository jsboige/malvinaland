// Script pour le monde des rêves

document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le Royaume des Songes Éternels!');
    
    // Initialisation des fonctionnalités
    initNavigation();
    initEnigmes();
    initDreamEffects();
    initImageGallery();
});

/**
 * Initialise la navigation principale
 */
function initNavigation() {
    const mainNavigation = document.getElementById('main-navigation');
    
    if (mainNavigation) {
        // Liste des mondes disponibles
        const mondes = [
            { id: 'assemblee', name: '🔥 Monde de l\'Assemblée', url: '../Le monde de l\'assemblée/index.html' },
            { id: 'grange', name: '🌍 Monde de la Grange', url: '../Le monde de la grange/index.html' },
            { id: 'jeux', name: '🎮 Monde des Jeux', url: '../Le monde des jeux/index.html' },
            { id: 'damier', name: '🏁 Monde du Damier', url: '../Le monde du damier/index.html' },
            { id: 'linge', name: '👕 Monde du Linge', url: '../Le monde du linge/index.html' },
            { id: 'verger', name: '🌳 Monde du Verger', url: '../Le monde du verger/index.html' },
            { id: 'zob', name: '🔍 Monde du Zob', url: '../Le monde du Zob/index.html' },
            { id: 'elysee', name: '👑 Monde Elysée', url: '../Le monde Elysée/index.html' },
            { id: 'karibu', name: '🏠 Monde Karibu', url: '../Le monde Karibu/index.html' },
            { id: 'sphinx', name: '🧩 Monde Orange des Sphinx', url: '../Le monde orange des Sphinx/index.html' }
        ];
        
        // Création des liens de navigation
        mondes.forEach(monde => {
            if (monde.id !== 'reves') { // Ne pas inclure le monde actuel
                const li = document.createElement('li');
                const a = document.createElement('a');
                a.href = monde.url;
                a.textContent = monde.name;
                li.appendChild(a);
                mainNavigation.appendChild(li);
            }
        });
        
        // Ajout d'un lien vers l'accueil
        const homeLi = document.createElement('li');
        const homeLink = document.createElement('a');
        homeLink.href = '../../index.html';
        homeLink.textContent = '🏠 Accueil';
        homeLi.appendChild(homeLink);
        mainNavigation.appendChild(homeLi);
    }
}

/**
 * Initialise les interactions avec les énigmes
 */
function initEnigmes() {
    const enigmeContainers = document.querySelectorAll('.enigme-container');
    
    enigmeContainers.forEach(container => {
        const title = container.querySelector('h3');
        const indice = container.querySelector('.enigme-indice');
        
        if (title && indice) {
            // Ajouter un effet de clic pour afficher/masquer l'indice
            title.addEventListener('click', () => {
                if (indice.style.display === 'none' || indice.style.display === '') {
                    indice.style.display = 'block';
                    // Animation d'apparition
                    indice.style.opacity = '0';
                    indice.style.transform = 'translateY(-10px)';
                    setTimeout(() => {
                        indice.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                        indice.style.opacity = '1';
                        indice.style.transform = 'translateY(0)';
                    }, 10);
                } else {
                    // Animation de disparition
                    indice.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    indice.style.opacity = '0';
                    indice.style.transform = 'translateY(-10px)';
                    setTimeout(() => {
                        indice.style.display = 'none';
                    }, 500);
                }
            });
            
            // Masquer les indices par défaut
            indice.style.display = 'none';
            
            // Ajouter un indicateur visuel que le titre est cliquable
            title.style.cursor = 'pointer';
            title.style.position = 'relative';
            title.style.paddingRight = '30px';
            
            const indicator = document.createElement('span');
            indicator.textContent = '▼';
            indicator.style.position = 'absolute';
            indicator.style.right = '10px';
            indicator.style.top = '50%';
            indicator.style.transform = 'translateY(-50%)';
            indicator.style.fontSize = '0.8em';
            indicator.style.opacity = '0.7';
            indicator.style.transition = 'transform 0.3s ease';
            title.appendChild(indicator);
            
            // Rotation de l'indicateur lors du clic
            title.addEventListener('click', () => {
                if (indice.style.display === 'block') {
                    indicator.style.transform = 'translateY(-50%) rotate(180deg)';
                } else {
                    indicator.style.transform = 'translateY(-50%) rotate(0)';
                }
            });
        }
    });
}

/**
 * Ajoute des effets visuels oniriques à la page
 */
function initDreamEffects() {
    // Effet de particules flottantes
    createDreamParticles();
    
    // Effet de distorsion subtile sur les images
    const images = document.querySelectorAll('.gallery-image');
    images.forEach(img => {
        img.addEventListener('mouseover', () => {
            img.style.filter = 'hue-rotate(15deg) brightness(1.1)';
        });
        img.addEventListener('mouseout', () => {
            img.style.filter = 'none';
        });
    });
    
    // Effet de texte qui scintille
    const headings = document.querySelectorAll('h2, h3');
    headings.forEach(heading => {
        heading.addEventListener('mouseover', () => {
            heading.style.textShadow = '0 0 15px rgba(192, 179, 225, 0.8), 0 0 25px rgba(192, 179, 225, 0.5)';
        });
        heading.addEventListener('mouseout', () => {
            heading.style.textShadow = '0 0 10px rgba(192, 179, 225, 0.5)';
        });
    });
}

/**
 * Crée des particules flottantes pour l'effet onirique
 */
function createDreamParticles() {
    const container = document.createElement('div');
    container.className = 'dream-particles';
    container.style.position = 'fixed';
    container.style.top = '0';
    container.style.left = '0';
    container.style.width = '100%';
    container.style.height = '100%';
    container.style.pointerEvents = 'none';
    container.style.zIndex = '1';
    document.body.appendChild(container);
    
    // Créer des particules
    for (let i = 0; i < 50; i++) {
        createParticle(container);
    }
}

/**
 * Crée une particule individuelle
 */
function createParticle(container) {
    const particle = document.createElement('div');
    particle.className = 'dream-particle';
    
    // Style de base
    particle.style.position = 'absolute';
    particle.style.width = Math.random() * 5 + 2 + 'px';
    particle.style.height = particle.style.width;
    particle.style.backgroundColor = getRandomDreamColor();
    particle.style.borderRadius = '50%';
    particle.style.opacity = Math.random() * 0.5 + 0.2;
    particle.style.pointerEvents = 'none';
    
    // Position initiale aléatoire
    particle.style.left = Math.random() * 100 + 'vw';
    particle.style.top = Math.random() * 100 + 'vh';
    
    container.appendChild(particle);
    
    // Animation
    animateParticle(particle);
}

/**
 * Anime une particule avec un mouvement flottant
 */
function animateParticle(particle) {
    const duration = Math.random() * 15 + 10; // 10-25 secondes
    const xMovement = Math.random() * 10 - 5; // -5 à 5 vw
    const yMovement = -Math.random() * 20 - 10; // -10 à -30 vh (toujours vers le haut)
    
    particle.style.transition = `transform ${duration}s linear, opacity ${duration}s ease-in`;
    particle.style.transform = `translate(${xMovement}vw, ${yMovement}vh)`;
    particle.style.opacity = '0';
    
    // Recréer la particule une fois l'animation terminée
    setTimeout(() => {
        if (particle.parentNode) {
            particle.parentNode.removeChild(particle);
            if (container = document.querySelector('.dream-particles')) {
                createParticle(container);
            }
        }
    }, duration * 1000);
}

/**
 * Retourne une couleur aléatoire dans la palette onirique
 */
function getRandomDreamColor() {
    const colors = [
        'rgba(91, 75, 138, 0.7)', // Violet
        'rgba(138, 118, 201, 0.7)', // Lavande
        'rgba(192, 179, 225, 0.7)', // Lilas
        'rgba(233, 228, 245, 0.7)', // Blanc violacé
        'rgba(44, 35, 71, 0.7)' // Violet foncé
    ];
    
    return colors[Math.floor(Math.random() * colors.length)];
}

/**
 * Initialise la galerie d'images avec effets de zoom
 */
function initImageGallery() {
    const galleryImages = document.querySelectorAll('.gallery-image');
    
    galleryImages.forEach(image => {
        // Ajouter un effet de zoom au clic
        image.addEventListener('click', () => {
            // Créer une vue agrandie de l'image
            const overlay = document.createElement('div');
            overlay.className = 'image-overlay';
            overlay.style.position = 'fixed';
            overlay.style.top = '0';
            overlay.style.left = '0';
            overlay.style.width = '100%';
            overlay.style.height = '100%';
            overlay.style.backgroundColor = 'rgba(44, 35, 71, 0.9)';
            overlay.style.display = 'flex';
            overlay.style.justifyContent = 'center';
            overlay.style.alignItems = 'center';
            overlay.style.zIndex = '1000';
            
            const enlargedImg = document.createElement('img');
            enlargedImg.src = image.src;
            enlargedImg.style.maxWidth = '90%';
            enlargedImg.style.maxHeight = '90%';
            enlargedImg.style.objectFit = 'contain';
            enlargedImg.style.border = '3px solid var(--reves-accent)';
            enlargedImg.style.boxShadow = '0 0 30px rgba(192, 179, 225, 0.7)';
            enlargedImg.style.transition = 'transform 0.3s ease';
            
            overlay.appendChild(enlargedImg);
            document.body.appendChild(overlay);
            
            // Animation d'entrée
            enlargedImg.style.transform = 'scale(0.9)';
            setTimeout(() => {
                enlargedImg.style.transform = 'scale(1)';
            }, 10);
            
            // Fermer l'overlay au clic
            overlay.addEventListener('click', () => {
                // Animation de sortie
                enlargedImg.style.transform = 'scale(0.9)';
                overlay.style.opacity = '0';
                setTimeout(() => {
                    document.body.removeChild(overlay);
                }, 300);
            });
        });
    });
}