// Script pour le monde orange des Sphinx

document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le Monde Orange des Sphinx!');
    
    // Initialisation des fonctionnalités
    initNavigation();
    initEnigmes();
    initSphinxEffects();
    initImageGallery();
    initDamier();
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
            { id: 'reves', name: '🌙 Monde des Rêves', url: '../Le monde des rêves/index.html' },
            { id: 'damier', name: '🏁 Monde du Damier', url: '../Le monde du damier/index.html' },
            { id: 'linge', name: '👕 Monde du Linge', url: '../Le monde du linge/index.html' },
            { id: 'verger', name: '🌳 Monde du Verger', url: '../Le monde du verger/index.html' },
            { id: 'zob', name: '🔍 Monde du Zob', url: '../Le monde du Zob/index.html' },
            { id: 'elysee', name: '👑 Monde Elysée', url: '../Le monde Elysée/index.html' },
            { id: 'karibu', name: '🏠 Monde Karibu', url: '../Le monde Karibu/index.html' }
        ];
        
        // Création des liens de navigation
        mondes.forEach(monde => {
            if (monde.id !== 'sphinx') { // Ne pas inclure le monde actuel
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
 * Ajoute des effets visuels spécifiques au monde des Sphinx
 */
function initSphinxEffects() {
    // Créer des figures de sphinx qui suivent le curseur
    createSphinxFigures();
    
    // Effet de chaleur sur les images
    const images = document.querySelectorAll('.gallery-image');
    images.forEach(img => {
        img.addEventListener('mouseover', () => {
            img.style.filter = 'sepia(30%) brightness(1.1)';
        });
        img.addEventListener('mouseout', () => {
            img.style.filter = 'none';
        });
    });
    
    // Effet de texte qui brille
    const headings = document.querySelectorAll('h2, h3');
    headings.forEach(heading => {
        heading.addEventListener('mouseover', () => {
            heading.style.textShadow = '0 0 15px rgba(243, 156, 18, 0.8), 0 0 25px rgba(243, 156, 18, 0.5)';
        });
        heading.addEventListener('mouseout', () => {
            heading.style.textShadow = '0 0 10px rgba(243, 156, 18, 0.5)';
        });
    });
}

/**
 * Crée des figures de sphinx qui suivent subtilement le curseur
 */
function createSphinxFigures() {
    // Créer un conteneur pour les sphinx
    const container = document.createElement('div');
    container.className = 'sphinx-watchers';
    container.style.position = 'fixed';
    container.style.top = '0';
    container.style.left = '0';
    container.style.width = '100%';
    container.style.height = '100%';
    container.style.pointerEvents = 'none';
    container.style.zIndex = '1';
    document.body.appendChild(container);
    
    // Créer quelques sphinx
    for (let i = 0; i < 3; i++) {
        createSphinxFigure(container, i);
    }
    
    // Suivre le curseur
    document.addEventListener('mousemove', (e) => {
        const sphinxes = document.querySelectorAll('.sphinx-figure');
        sphinxes.forEach((sphinx, index) => {
            // Chaque sphinx suit le curseur avec un délai différent
            setTimeout(() => {
                const rect = sphinx.getBoundingClientRect();
                const centerX = rect.left + rect.width / 2;
                const centerY = rect.top + rect.height / 2;
                
                // Calculer l'angle entre le sphinx et le curseur
                const angle = Math.atan2(e.clientY - centerY, e.clientX - centerX);
                
                // Rotation subtile vers le curseur
                sphinx.style.transform = `rotate(${angle * (180 / Math.PI)}deg)`;
                
                // Faire briller les yeux quand le curseur est proche
                const distance = Math.sqrt(Math.pow(e.clientX - centerX, 2) + Math.pow(e.clientY - centerY, 2));
                const eyes = sphinx.querySelectorAll('.sphinx-eye');
                eyes.forEach(eye => {
                    if (distance < 300) {
                        eye.style.boxShadow = `0 0 ${20 - distance / 30}px rgba(243, 156, 18, 0.8)`;
                    } else {
                        eye.style.boxShadow = '0 0 5px rgba(243, 156, 18, 0.5)';
                    }
                });
            }, index * 100); // Délai progressif pour chaque sphinx
        });
    });
}

/**
 * Crée une figure de sphinx individuelle
 */
function createSphinxFigure(container, index) {
    const sphinx = document.createElement('div');
    sphinx.className = 'sphinx-figure';
    
    // Style de base
    sphinx.style.position = 'fixed';
    sphinx.style.width = '50px';
    sphinx.style.height = '30px';
    sphinx.style.backgroundColor = 'rgba(230, 126, 34, 0.2)';
    sphinx.style.borderRadius = '5px';
    sphinx.style.pointerEvents = 'none';
    sphinx.style.transition = 'transform 1s ease';
    
    // Position initiale selon l'index
    switch (index) {
        case 0:
            sphinx.style.top = '20px';
            sphinx.style.right = '20px';
            break;
        case 1:
            sphinx.style.bottom = '20px';
            sphinx.style.left = '20px';
            break;
        case 2:
            sphinx.style.top = '50%';
            sphinx.style.right = '50px';
            break;
    }
    
    // Ajouter les yeux
    for (let i = 0; i < 2; i++) {
        const eye = document.createElement('div');
        eye.className = 'sphinx-eye';
        eye.style.position = 'absolute';
        eye.style.width = '8px';
        eye.style.height = '8px';
        eye.style.backgroundColor = 'var(--sphinx-accent)';
        eye.style.borderRadius = '50%';
        eye.style.top = '10px';
        eye.style.left = i === 0 ? '10px' : '30px';
        eye.style.boxShadow = '0 0 5px rgba(243, 156, 18, 0.5)';
        sphinx.appendChild(eye);
    }
    
    container.appendChild(sphinx);
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
            overlay.style.backgroundColor = 'rgba(125, 71, 9, 0.9)';
            overlay.style.display = 'flex';
            overlay.style.justifyContent = 'center';
            overlay.style.alignItems = 'center';
            overlay.style.zIndex = '1000';
            
            const enlargedImg = document.createElement('img');
            enlargedImg.src = image.src;
            enlargedImg.style.maxWidth = '90%';
            enlargedImg.style.maxHeight = '90%';
            enlargedImg.style.objectFit = 'contain';
            enlargedImg.style.border = '3px solid var(--sphinx-accent)';
            enlargedImg.style.boxShadow = '0 0 30px rgba(243, 156, 18, 0.7)';
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
 * Initialise le damier interactif pour l'énigme du damier félin
 */
function initDamier() {
    // Vérifier si la section énigmes existe
    const enigmesSection = document.getElementById('enigmes');
    
    if (enigmesSection) {
        // Créer le conteneur du damier
        const damierContainer = document.createElement('div');
        damierContainer.className = 'damier-container';
        
        // Créer le damier 9x9
        const damier = document.createElement('div');
        damier.className = 'damier';
        damier.style.display = 'grid';
        damier.style.gridTemplateColumns = 'repeat(9, 1fr)';
        damier.style.gridTemplateRows = 'repeat(9, 1fr)';
        damier.style.width = '100%';
        damier.style.maxWidth = '450px';
        damier.style.aspectRatio = '1/1';
        damier.style.margin = '2rem auto';
        damier.style.border = '2px solid var(--sphinx-accent)';
        
        // Créer les cellules du damier
        for (let i = 0; i < 9; i++) {
            for (let j = 0; j < 9; j++) {
                const cell = document.createElement('div');
                cell.className = 'damier-cell';
                cell.dataset.row = i;
                cell.dataset.col = j;
                cell.style.border = '1px solid var(--sphinx-secondary)';
                cell.style.cursor = 'pointer';
                
                // Ajouter un événement de clic pour placer une pierre
                cell.addEventListener('click', () => {
                    // Vérifier si la cellule est déjà occupée
                    if (!cell.classList.contains('black') && !cell.classList.contains('white')) {
                        // Déterminer la couleur de la pierre à placer (alternance)
                        const currentColor = document.querySelector('.damier').dataset.currentColor || 'black';
                        
                        // Placer la pierre
                        cell.classList.add(currentColor);
                        
                        // Changer la couleur pour le prochain coup
                        document.querySelector('.damier').dataset.currentColor = currentColor === 'black' ? 'white' : 'black';
                        
                        // Vérifier si le motif est correct
                        checkDamierPattern();
                    }
                });
                
                damier.appendChild(cell);
            }
        }
        
        damierContainer.appendChild(damier);
        
        // Ajouter des boutons de contrôle
        const controls = document.createElement('div');
        controls.className = 'damier-controls';
        controls.style.display = 'flex';
        controls.style.justifyContent = 'center';
        controls.style.gap = '1rem';
        controls.style.margin = '1rem 0';
        
        // Bouton pour effacer le damier
        const clearButton = document.createElement('button');
        clearButton.textContent = 'Effacer le damier';
        clearButton.style.padding = '0.5rem 1rem';
        clearButton.style.backgroundColor = 'var(--sphinx-primary)';
        clearButton.style.color = 'white';
        clearButton.style.border = 'none';
        clearButton.style.borderRadius = '5px';
        clearButton.style.cursor = 'pointer';
        
        clearButton.addEventListener('click', () => {
            const cells = document.querySelectorAll('.damier-cell');
            cells.forEach(cell => {
                cell.classList.remove('black', 'white');
            });
            document.querySelector('.damier').dataset.currentColor = 'black';
        });
        
        controls.appendChild(clearButton);
        
        // Bouton pour vérifier le motif
        const checkButton = document.createElement('button');
        checkButton.textContent = 'Vérifier le motif';
        checkButton.style.padding = '0.5rem 1rem';
        checkButton.style.backgroundColor = 'var(--sphinx-accent)';
        checkButton.style.color = 'white';
        checkButton.style.border = 'none';
        checkButton.style.borderRadius = '5px';
        checkButton.style.cursor = 'pointer';
        
        checkButton.addEventListener('click', () => {
            checkDamierPattern();
        });
        
        controls.appendChild(checkButton);
        
        damierContainer.appendChild(controls);
        
        // Ajouter le damier à la première énigme
        const firstEnigme = enigmesSection.querySelector('.enigme-container');
        if (firstEnigme) {
            firstEnigme.appendChild(damierContainer);
        }
    }
}

/**
 * Vérifie si le motif du damier correspond au motif attendu
 */
function checkDamierPattern() {
    // Cette fonction serait implémentée avec le motif félin attendu
    // Pour l'instant, elle affiche simplement un message
    console.log('Vérification du motif du damier...');
    
    // Exemple de vérification simple (à adapter selon le motif réel)
    let blackCount = document.querySelectorAll('.damier-cell.black').length;
    let whiteCount = document.querySelectorAll('.damier-cell.white').length;
    
    if (blackCount >= 15 && whiteCount >= 10) {
        // Afficher un message de succès
        const message = document.createElement('div');
        message.textContent = 'Félicitations ! Vous avez découvert le motif félin. Regardez-le dans un miroir pour révéler le mot "VÉRITÉ".';
        message.style.padding = '1rem';
        message.style.backgroundColor = 'rgba(243, 156, 18, 0.2)';
        message.style.border = '1px solid var(--sphinx-accent)';
        message.style.borderRadius = '5px';
        message.style.marginTop = '1rem';
        message.style.textAlign = 'center';
        
        // Remplacer le message existant s'il y en a un
        const existingMessage = document.querySelector('.damier-container > div:last-child:not(.damier-controls)');
        if (existingMessage) {
            existingMessage.remove();
        }
        
        document.querySelector('.damier-container').appendChild(message);
    }
}