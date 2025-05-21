// Script pour le monde de la grange

document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le Monde de la Grange!');
    
    // Initialisation des fonctionnalités
    initNavigation();
    initEnigmes();
    initGrangeEffects();
    initImageGallery();
    initTapisSaisons();
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
            { id: 'jeux', name: '🎮 Monde des Jeux', url: '../Le monde des jeux/index.html' },
            { id: 'reves', name: '🌙 Monde des Rêves', url: '../Le monde des rêves/index.html' },
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
            if (monde.id !== 'grange') { // Ne pas inclure le monde actuel
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
 * Ajoute des effets visuels spécifiques au monde de la Grange
 */
function initGrangeEffects() {
    // Effet de croissance sur les images
    const images = document.querySelectorAll('.gallery-image');
    images.forEach(img => {
        img.addEventListener('mouseover', () => {
            img.style.filter = 'brightness(1.1) saturate(1.2)';
        });
        img.addEventListener('mouseout', () => {
            img.style.filter = 'none';
        });
    });
    
    // Effet de texte qui brille
    const headings = document.querySelectorAll('h2, h3');
    headings.forEach(heading => {
        heading.addEventListener('mouseover', () => {
            heading.style.textShadow = '0 0 15px rgba(76, 175, 80, 0.8), 0 0 25px rgba(76, 175, 80, 0.5)';
        });
        heading.addEventListener('mouseout', () => {
            heading.style.textShadow = '0 0 10px rgba(76, 175, 80, 0.5)';
        });
    });
    
    // Ajouter des éléments de nature en arrière-plan
    createNatureElements();
}

/**
 * Crée des éléments de nature en arrière-plan
 */
function createNatureElements() {
    // Créer un conteneur pour les éléments de nature
    const container = document.createElement('div');
    container.className = 'nature-elements';
    container.style.position = 'fixed';
    container.style.top = '0';
    container.style.left = '0';
    container.style.width = '100%';
    container.style.height = '100%';
    container.style.pointerEvents = 'none';
    container.style.zIndex = '1';
    document.body.appendChild(container);
    
    // Créer des feuilles qui tombent
    for (let i = 0; i < 15; i++) {
        createLeaf(container);
    }
    
    // Créer des particules de poussière
    for (let i = 0; i < 30; i++) {
        createDust(container);
    }
}

/**
 * Crée une feuille qui tombe
 */
function createLeaf(container) {
    const leaf = document.createElement('div');
    leaf.className = 'nature-leaf';
    
    // Style de base
    leaf.style.position = 'absolute';
    leaf.style.width = Math.random() * 20 + 10 + 'px';
    leaf.style.height = Math.random() * 10 + 5 + 'px';
    leaf.style.backgroundColor = getRandomGrangeColor();
    leaf.style.borderRadius = '50% 20% 50% 20%';
    leaf.style.opacity = Math.random() * 0.5 + 0.3;
    leaf.style.pointerEvents = 'none';
    leaf.style.zIndex = '1';
    
    // Position initiale aléatoire
    leaf.style.left = Math.random() * 100 + 'vw';
    leaf.style.top = -Math.random() * 20 - 10 + 'px';
    
    container.appendChild(leaf);
    
    // Animation
    animateLeaf(leaf);
}

/**
 * Anime une feuille qui tombe
 */
function animateLeaf(leaf) {
    const duration = Math.random() * 10 + 15; // 15-25 secondes
    const xMovement = Math.random() * 100 - 50; // -50 à 50 vw
    
    leaf.style.transition = `transform ${duration}s linear, top ${duration}s linear, opacity ${duration}s ease-in`;
    leaf.style.transform = `translate(${xMovement}vw, 110vh) rotate(${Math.random() * 720 - 360}deg)`;
    
    // Recréer la feuille une fois l'animation terminée
    setTimeout(() => {
        if (leaf.parentNode) {
            leaf.parentNode.removeChild(leaf);
            if (container = document.querySelector('.nature-elements')) {
                createLeaf(container);
            }
        }
    }, duration * 1000);
}

/**
 * Crée une particule de poussière
 */
function createDust(container) {
    const dust = document.createElement('div');
    dust.className = 'nature-dust';
    
    // Style de base
    dust.style.position = 'absolute';
    dust.style.width = Math.random() * 3 + 1 + 'px';
    dust.style.height = dust.style.width;
    dust.style.backgroundColor = 'rgba(200, 230, 201, 0.7)';
    dust.style.borderRadius = '50%';
    dust.style.opacity = Math.random() * 0.3 + 0.1;
    dust.style.pointerEvents = 'none';
    
    // Position initiale aléatoire
    dust.style.left = Math.random() * 100 + 'vw';
    dust.style.top = Math.random() * 100 + 'vh';
    
    container.appendChild(dust);
    
    // Animation
    animateDust(dust);
}

/**
 * Anime une particule de poussière
 */
function animateDust(dust) {
    const duration = Math.random() * 10 + 10; // 10-20 secondes
    const xMovement = Math.random() * 20 - 10; // -10 à 10 vw
    const yMovement = Math.random() * 20 - 10; // -10 à 10 vh
    
    dust.style.transition = `transform ${duration}s linear, opacity ${duration}s ease-in-out`;
    dust.style.transform = `translate(${xMovement}vw, ${yMovement}vh)`;
    
    // Faire varier l'opacité
    let opacity = 0.1;
    const opacityInterval = setInterval(() => {
        opacity = Math.random() * 0.3 + 0.1;
        dust.style.opacity = opacity.toString();
    }, 2000);
    
    // Recréer la particule une fois l'animation terminée
    setTimeout(() => {
        clearInterval(opacityInterval);
        if (dust.parentNode) {
            dust.parentNode.removeChild(dust);
            if (container = document.querySelector('.nature-elements')) {
                createDust(container);
            }
        }
    }, duration * 1000);
}

/**
 * Retourne une couleur aléatoire dans la palette de la Grange
 */
function getRandomGrangeColor() {
    const colors = [
        'rgba(46, 125, 50, 0.7)', // Vert foncé
        'rgba(76, 175, 80, 0.7)', // Vert moyen
        'rgba(129, 199, 132, 0.7)', // Vert clair
        'rgba(200, 230, 201, 0.7)', // Vert très clair
        'rgba(27, 94, 32, 0.7)' // Vert très foncé
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
            overlay.style.backgroundColor = 'rgba(27, 62, 28, 0.9)';
            overlay.style.display = 'flex';
            overlay.style.justifyContent = 'center';
            overlay.style.alignItems = 'center';
            overlay.style.zIndex = '1000';
            
            const enlargedImg = document.createElement('img');
            enlargedImg.src = image.src;
            enlargedImg.style.maxWidth = '90%';
            enlargedImg.style.maxHeight = '90%';
            enlargedImg.style.objectFit = 'contain';
            enlargedImg.style.border = '3px solid var(--grange-accent)';
            enlargedImg.style.boxShadow = '0 0 30px rgba(76, 175, 80, 0.7)';
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

/**
 * Initialise l'énigme du Tapis des Saisons
 */
function initTapisSaisons() {
    // Vérifier si la section énigmes existe
    const enigmesSection = document.getElementById('enigmes');
    
    if (enigmesSection) {
        // Créer le conteneur du tapis
        const tapisContainer = document.createElement('div');
        tapisContainer.className = 'tapis-container';
        
        // Créer le tapis circulaire
        const tapis = document.createElement('div');
        tapis.className = 'tapis-circulaire';
        
        // Créer les quatre sections du tapis (saisons)
        const saisons = ['printemps', 'ete', 'automne', 'hiver'];
        const objets = {
            'printemps': 'Graine',
            'ete': 'Fleur',
            'automne': 'Fruit',
            'hiver': 'Branche nue'
        };
        
        saisons.forEach(saison => {
            const section = document.createElement('div');
            section.className = `tapis-saison ${saison}`;
            section.dataset.saison = saison;
            section.dataset.objet = objets[saison];
            
            // Ajouter un texte indiquant la saison
            const texte = document.createElement('span');
            texte.textContent = saison.charAt(0).toUpperCase() + saison.slice(1);
            texte.style.color = 'white';
            texte.style.textShadow = '1px 1px 2px rgba(0, 0, 0, 0.7)';
            texte.style.fontWeight = 'bold';
            
            section.appendChild(texte);
            
            // Ajouter un événement de clic pour placer un objet
            section.addEventListener('click', () => {
                // Vérifier si un objet est déjà placé
                if (section.querySelector('.objet-saison')) {
                    // Retirer l'objet
                    section.querySelector('.objet-saison').remove();
                    section.classList.remove('avec-objet');
                } else {
                    // Placer l'objet
                    const objet = document.createElement('div');
                    objet.className = 'objet-saison';
                    objet.textContent = objets[saison];
                    objet.style.backgroundColor = 'rgba(255, 255, 255, 0.7)';
                    objet.style.padding = '5px';
                    objet.style.borderRadius = '5px';
                    objet.style.marginTop = '10px';
                    objet.style.fontSize = '0.8rem';
                    
                    section.appendChild(objet);
                    section.classList.add('avec-objet');
                    
                    // Vérifier si tous les objets sont placés
                    checkTapisPattern();
                }
            });
            
            tapis.appendChild(section);
        });
        
        tapisContainer.appendChild(tapis);
        
        // Ajouter des boutons de contrôle
        const controls = document.createElement('div');
        controls.className = 'tapis-controls';
        controls.style.display = 'flex';
        controls.style.justifyContent = 'center';
        controls.style.gap = '1rem';
        controls.style.margin = '1rem 0';
        
        // Bouton pour réinitialiser le tapis
        const resetButton = document.createElement('button');
        resetButton.textContent = 'Réinitialiser le tapis';
        resetButton.style.padding = '0.5rem 1rem';
        resetButton.style.backgroundColor = 'var(--grange-primary)';
        resetButton.style.color = 'white';
        resetButton.style.border = 'none';
        resetButton.style.borderRadius = '5px';
        resetButton.style.cursor = 'pointer';
        
        resetButton.addEventListener('click', () => {
            const sections = document.querySelectorAll('.tapis-saison');
            sections.forEach(section => {
                const objet = section.querySelector('.objet-saison');
                if (objet) {
                    objet.remove();
                }
                section.classList.remove('avec-objet');
            });
        });
        
        controls.appendChild(resetButton);
        
        // Bouton pour vérifier le tapis
        const checkButton = document.createElement('button');
        checkButton.textContent = 'Vérifier le tapis';
        checkButton.style.padding = '0.5rem 1rem';
        checkButton.style.backgroundColor = 'var(--grange-accent)';
        checkButton.style.color = 'white';
        checkButton.style.border = 'none';
        checkButton.style.borderRadius = '5px';
        checkButton.style.cursor = 'pointer';
        
        checkButton.addEventListener('click', () => {
            checkTapisPattern();
        });
        
        controls.appendChild(checkButton);
        
        tapisContainer.appendChild(controls);
        
        // Ajouter le tapis à la première énigme
        const firstEnigme = enigmesSection.querySelector('.enigme-container');
        if (firstEnigme) {
            firstEnigme.appendChild(tapisContainer);
        }
    }
}

/**
 * Vérifie si les objets sont correctement placés sur le tapis des saisons
 */
function checkTapisPattern() {
    // Vérifier si tous les objets sont placés
    const sections = document.querySelectorAll('.tapis-saison');
    let allPlaced = true;
    
    sections.forEach(section => {
        if (!section.querySelector('.objet-saison')) {
            allPlaced = false;
        }
    });
    
    if (allPlaced) {
        // Afficher un message de succès
        const message = document.createElement('div');
        message.textContent = 'Félicitations ! Vous avez correctement placé les objets selon le cycle des saisons. Soulevez le tapis pour découvrir le mot "ABONDANCE" et un symbole de corne.';
        message.style.padding = '1rem';
        message.style.backgroundColor = 'rgba(76, 175, 80, 0.2)';
        message.style.border = '1px solid var(--grange-accent)';
        message.style.borderRadius = '5px';
        message.style.marginTop = '1rem';
        message.style.textAlign = 'center';
        
        // Remplacer le message existant s'il y en a un
        const existingMessage = document.querySelector('.tapis-container > div:last-child:not(.tapis-controls)');
        if (existingMessage) {
            existingMessage.remove();
        }
        
        document.querySelector('.tapis-container').appendChild(message);
        
        // Ajouter un effet de soulèvement du tapis
        const tapis = document.querySelector('.tapis-circulaire');
        tapis.style.transition = 'transform 1s ease';
        tapis.style.transform = 'translateY(-20px)';
        tapis.style.boxShadow = '0 20px 30px rgba(0, 0, 0, 0.3)';
        
        // Ajouter le mot caché sous le tapis
        setTimeout(() => {
            const motCache = document.createElement('div');
            motCache.textContent = 'ABONDANCE';
            motCache.style.position = 'absolute';
            motCache.style.top = '50%';
            motCache.style.left = '50%';
            motCache.style.transform = 'translate(-50%, -50%)';
            motCache.style.fontSize = '1.5rem';
            motCache.style.fontWeight = 'bold';
            motCache.style.color = 'var(--grange-accent)';
            motCache.style.textShadow = '0 0 10px rgba(76, 175, 80, 0.7)';
            motCache.style.zIndex = '-1';
            
            document.querySelector('.tapis-container').appendChild(motCache);
        }, 1000);
    }
}