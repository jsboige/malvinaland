// Script spécifique pour le monde du linge
document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le monde du linge!');
    
    // Initialisation des fonctionnalités
    initSmoothScrolling();
    initEnigmeInteractions();
    createCordeLinge();
    initGalerieImages();
    
    // Animation subtile pour les éléments de la page
    animatePageElements();
});

/**
 * Initialise le défilement fluide pour les liens de navigation
 */
function initSmoothScrolling() {
    const links = document.querySelectorAll('nav ul li a');
    
    links.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = link.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                window.scrollTo({
                    top: targetSection.offsetTop - 20,
                    behavior: 'smooth'
                });
            }
        });
    });
}

/**
 * Initialise les interactions pour les sections d'énigmes
 */
function initEnigmeInteractions() {
    const enigmes = document.querySelectorAll('.enigme');
    
    enigmes.forEach(enigme => {
        const title = enigme.querySelector('h3');
        const details = enigme.querySelector('.enigme-details');
        
        // Ajouter un indicateur visuel pour montrer que les détails peuvent être affichés/masqués
        title.innerHTML += ' <span class="toggle-indicator">▼</span>';
        title.style.cursor = 'pointer';
        
        // Masquer les détails par défaut
        if (details) {
            details.style.display = 'none';
        }
        
        // Ajouter l'événement de clic pour afficher/masquer les détails
        title.addEventListener('click', () => {
            if (details) {
                const isHidden = details.style.display === 'none';
                details.style.display = isHidden ? 'block' : 'none';
                
                // Mettre à jour l'indicateur
                const indicator = title.querySelector('.toggle-indicator');
                if (indicator) {
                    indicator.textContent = isHidden ? '▲' : '▼';
                }
                
                // Animation simple pour l'affichage
                if (isHidden) {
                    details.style.opacity = '0';
                    setTimeout(() => {
                        details.style.transition = 'opacity 0.5s ease';
                        details.style.opacity = '1';
                    }, 10);
                }
            }
        });
    });
}

/**
 * Crée une représentation visuelle de la corde à linge avec des pinces colorées
 */
function createCordeLinge() {
    // Vérifier si la section de description existe
    const descriptionSection = document.querySelector('#description .content');
    if (!descriptionSection) return;
    
    // Créer l'élément de corde à linge
    const cordeContainer = document.createElement('div');
    cordeContainer.className = 'corde-container';
    cordeContainer.style.position = 'relative';
    cordeContainer.style.height = '150px';
    cordeContainer.style.margin = '30px 0';
    cordeContainer.style.overflow = 'hidden';
    
    // Ajouter la corde
    const corde = document.createElement('div');
    corde.className = 'corde-linge';
    corde.style.position = 'absolute';
    corde.style.top = '75px';
    corde.style.width = '100%';
    
    cordeContainer.appendChild(corde);
    
    // Définir les positions des pinces (Do=rouge, Ré=orange, Mi=jaune, Fa=vert, Sol=bleu, La=indigo, Si=violet)
    const pinces = [
        { color: 'orange', position: 20, offset: 10 },  // Ré
        { color: 'orange', position: 60, offset: 10 },  // Ré
        { color: 'jaune', position: 100, offset: 5 },   // Mi
        { color: 'orange', position: 140, offset: 10 }, // Ré
        { color: 'bleu', position: 180, offset: -5 },   // Sol
        { color: 'vert', position: 220, offset: 0 },    // Fa
        { color: 'orange', position: 260, offset: 10 }, // Ré
        { color: 'orange', position: 300, offset: 10 }, // Ré
        { color: 'jaune', position: 340, offset: 5 },   // Mi
        { color: 'orange', position: 380, offset: 10 }, // Ré
        { color: 'indigo', position: 420, offset: -10 },// La
        { color: 'bleu', position: 460, offset: -5 },   // Sol
        { color: 'rouge', position: 500, offset: -15 }, // Do
        { color: 'bleu', position: 540, offset: -5 },   // Sol
        { color: 'vert', position: 580, offset: 0 },    // Fa
        { color: 'jaune', position: 620, offset: 5 },   // Mi
        { color: 'orange', position: 660, offset: 10 }, // Ré
        { color: 'bleu', position: 700, offset: -5 },   // Sol
        { color: 'rouge', position: 740, offset: -15 }, // Do
        { color: 'orange', position: 780, offset: 10 }  // Ré
    ];
    
    // Ajouter les pinces à la corde
    pinces.forEach(pince => {
        const pinceElement = document.createElement('div');
        pinceElement.className = `pince pince-${pince.color}`;
        pinceElement.style.left = `${pince.position}px`;
        pinceElement.style.top = `${75 + pince.offset}px`;
        
        // Ajouter une légère animation
        pinceElement.style.transition = 'transform 0.5s ease';
        pinceElement.addEventListener('mouseover', () => {
            pinceElement.style.transform = 'scale(1.2)';
        });
        pinceElement.addEventListener('mouseout', () => {
            pinceElement.style.transform = 'scale(1)';
        });
        
        cordeContainer.appendChild(pinceElement);
    });
    
    // Ajouter le panier de pinces
    const panier = document.createElement('div');
    panier.className = 'panier';
    panier.style.position = 'absolute';
    panier.style.width = '40px';
    panier.style.height = '30px';
    panier.style.backgroundColor = 'white';
    panier.style.border = '1px solid #ccc';
    panier.style.borderRadius = '5px';
    panier.style.left = '400px';
    panier.style.top = '45px';
    
    cordeContainer.appendChild(panier);
    
    // Insérer la corde à linge après le premier paragraphe
    const firstParagraph = descriptionSection.querySelector('p');
    if (firstParagraph) {
        firstParagraph.parentNode.insertBefore(cordeContainer, firstParagraph.nextSibling);
    } else {
        descriptionSection.appendChild(cordeContainer);
    }
}

/**
 * Anime les éléments de la page pour une expérience plus dynamique
 */
function animatePageElements() {
    // Animation d'entrée pour les sections
    const sections = document.querySelectorAll('.section');
    
    sections.forEach((section, index) => {
        // Appliquer un délai croissant pour chaque section
        const delay = 100 + (index * 150);
        
        // Configurer l'animation
        section.style.opacity = '0';
        section.style.transform = 'translateY(20px)';
        section.style.transition = `opacity 0.5s ease ${delay}ms, transform 0.5s ease ${delay}ms`;
        
        // Déclencher l'animation après un court délai
        setTimeout(() => {
            section.style.opacity = '1';
            section.style.transform = 'translateY(0)';
        }, 10);
    });
    
    // Animation pour les personnages
    const personnages = document.querySelectorAll('.personnage');
    
    personnages.forEach(personnage => {
        const blockquote = personnage.querySelector('blockquote');
        if (blockquote) {
            blockquote.style.maxHeight = '100px';
            blockquote.style.overflow = 'hidden';
            blockquote.style.transition = 'max-height 0.5s ease';
            blockquote.style.cursor = 'pointer';
            
            // Ajouter un indicateur "Lire plus"
            const indicator = document.createElement('div');
            indicator.className = 'read-more';
            indicator.textContent = 'Lire la suite...';
            indicator.style.color = '#6a4c93';
            indicator.style.fontWeight = 'bold';
            indicator.style.marginTop = '5px';
            indicator.style.cursor = 'pointer';
            
            blockquote.parentNode.insertBefore(indicator, blockquote.nextSibling);
            
            // Fonction pour basculer l'affichage complet
            const toggleFullText = () => {
                if (blockquote.style.maxHeight === '100px') {
                    blockquote.style.maxHeight = '1000px';
                    indicator.textContent = 'Réduire';
                } else {
                    blockquote.style.maxHeight = '100px';
                    indicator.textContent = 'Lire la suite...';
                }
            };
            
            // Ajouter les événements de clic
            blockquote.addEventListener('click', toggleFullText);
            indicator.addEventListener('click', toggleFullText);
        }
    });
}

/**
 * Initialise les fonctionnalités de la galerie d'images
 */
function initGalerieImages() {
    // Récupérer toutes les images de la galerie
    const images = document.querySelectorAll('.galerie-image');
    
    // Ajouter un effet de zoom au clic sur chaque image
    images.forEach(image => {
        image.addEventListener('click', () => {
            // Créer un overlay pour afficher l'image en grand
            const overlay = document.createElement('div');
            overlay.className = 'image-overlay';
            overlay.style.position = 'fixed';
            overlay.style.top = '0';
            overlay.style.left = '0';
            overlay.style.width = '100%';
            overlay.style.height = '100%';
            overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.9)';
            overlay.style.display = 'flex';
            overlay.style.justifyContent = 'center';
            overlay.style.alignItems = 'center';
            overlay.style.zIndex = '1000';
            overlay.style.cursor = 'pointer';
            
            // Créer l'élément image agrandie
            const enlargedImg = document.createElement('img');
            enlargedImg.src = image.src;
            enlargedImg.style.maxWidth = '90%';
            enlargedImg.style.maxHeight = '90%';
            enlargedImg.style.border = '3px solid white';
            enlargedImg.style.boxShadow = '0 0 20px rgba(0, 0, 0, 0.5)';
            
            // Ajouter un message pour fermer
            const closeMessage = document.createElement('div');
            closeMessage.textContent = 'Cliquez n\'importe où pour fermer';
            closeMessage.style.position = 'absolute';
            closeMessage.style.bottom = '20px';
            closeMessage.style.color = 'white';
            closeMessage.style.textAlign = 'center';
            closeMessage.style.width = '100%';
            
            // Ajouter les éléments à l'overlay
            overlay.appendChild(enlargedImg);
            overlay.appendChild(closeMessage);
            document.body.appendChild(overlay);
            
            // Fermer l'overlay au clic
            overlay.addEventListener('click', () => {
                document.body.removeChild(overlay);
            });
        });
    });
    
    // Ajouter un effet de lazy loading pour les images
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.style.opacity = '0';
                    img.style.transition = 'opacity 0.5s ease';
                    
                    // Simuler un chargement progressif
                    setTimeout(() => {
                        img.style.opacity = '1';
                    }, 100);
                    
                    // Arrêter d'observer une fois chargée
                    observer.unobserve(img);
                }
            });
        });
        
        // Observer toutes les images de la galerie complète
        const galerieCompleteImages = document.querySelectorAll('.galerie-complete .galerie-image');
        galerieCompleteImages.forEach(img => {
            imageObserver.observe(img);
        });
    }
}