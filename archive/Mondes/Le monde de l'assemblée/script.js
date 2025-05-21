// Script pour le monde de l'assemblée

document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le monde de l\'assemblée!');
    
    // Initialisation des fonctionnalités
    // La navigation est maintenant gérée par Core/navigation.js
    initReadMoreButtons();
    initImageGallery();
    initFireEffect();
    initAmbientSounds();
});

/**
 * Initialise les boutons "Lire la suite" pour les documents historiques
 */
function initReadMoreButtons() {
    const readMoreButtons = document.querySelectorAll('.read-more-btn');
    
    readMoreButtons.forEach(button => {
        button.addEventListener('click', () => {
            const targetId = button.getAttribute('data-target');
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                if (targetElement.style.display === 'block') {
                    targetElement.style.display = 'none';
                    button.textContent = 'Lire la suite';
                } else {
                    targetElement.style.display = 'block';
                    button.textContent = 'Réduire';
                }
            }
        });
    });
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
            overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.9)';
            overlay.style.display = 'flex';
            overlay.style.justifyContent = 'center';
            overlay.style.alignItems = 'center';
            overlay.style.zIndex = '1000';
            
            const enlargedImg = document.createElement('img');
            enlargedImg.src = image.src;
            enlargedImg.style.maxWidth = '90%';
            enlargedImg.style.maxHeight = '90%';
            enlargedImg.style.objectFit = 'contain';
            enlargedImg.style.border = '3px solid white';
            enlargedImg.style.boxShadow = '0 0 20px rgba(255, 215, 0, 0.5)';
            
            overlay.appendChild(enlargedImg);
            document.body.appendChild(overlay);
            
            // Fermer l'overlay au clic
            overlay.addEventListener('click', () => {
                document.body.removeChild(overlay);
            });
        });
    });
}

/**
 * Crée un effet de feu animé pour la vasque centrale
 */
function initFireEffect() {
    // Vérifier si la section des énigmes existe
    const enigmesSection = document.getElementById('enigmes');
    
    if (enigmesSection) {
        // Créer l'élément pour l'effet de feu
        const fireContainer = document.createElement('div');
        fireContainer.className = 'fire-container';
        fireContainer.style.textAlign = 'center';
        fireContainer.style.margin = '2rem 0';
        
        const fireEffect = document.createElement('div');
        fireEffect.className = 'fire-effect';
        
        const fireCaption = document.createElement('p');
        fireCaption.textContent = 'La vasque attend le retour de la Flamme Éternelle...';
        fireCaption.style.fontStyle = 'italic';
        fireCaption.style.marginTop = '1rem';
        
        fireContainer.appendChild(fireEffect);
        fireContainer.appendChild(fireCaption);
        
        // Insérer l'effet de feu avant la première énigme
        const firstEnigme = enigmesSection.querySelector('.enigme-container');
        if (firstEnigme) {
            enigmesSection.querySelector('.section-content').insertBefore(fireContainer, firstEnigme);
        }
    }
}

/**
 * Ajoute des sons d'ambiance au monde de l'assemblée
 */
function initAmbientSounds() {
    // Créer un bouton pour activer/désactiver les sons d'ambiance
    const soundButton = document.createElement('button');
    soundButton.id = 'ambient-sound-toggle';
    soundButton.textContent = '🔊 Activer les sons d\'ambiance';
    soundButton.style.position = 'fixed';
    soundButton.style.bottom = '20px';
    soundButton.style.right = '20px';
    soundButton.style.padding = '10px 15px';
    soundButton.style.backgroundColor = 'var(--assemblee-primary)';
    soundButton.style.color = 'white';
    soundButton.style.border = 'none';
    soundButton.style.borderRadius = '5px';
    soundButton.style.cursor = 'pointer';
    soundButton.style.zIndex = '100';
    
    document.body.appendChild(soundButton);
    
    // Créer l'élément audio pour les sons d'ambiance
    const ambientAudio = document.createElement('audio');
    ambientAudio.id = 'ambient-sound';
    ambientAudio.loop = true;
    
    // Commentons la source audio pour éviter les erreurs de chargement
    // Dans une implémentation réelle, vous devriez héberger ce fichier dans le dossier assets
    /*
    ambientAudio.innerHTML = `
        <source src="assets/forest-fire-ambient.mp3" type="audio/mpeg">
        Votre navigateur ne supporte pas l'élément audio.
    `;
    */
    
    // Message indiquant que le son est simulé
    ambientAudio.innerHTML = `
        <p>Son d'ambiance simulé</p>
    `;
    
    document.body.appendChild(ambientAudio);
    
    // Gérer l'activation/désactivation du son
    let soundEnabled = false;
    
    soundButton.addEventListener('click', () => {
        if (soundEnabled) {
            ambientAudio.pause();
            soundButton.textContent = '🔊 Activer les sons d\'ambiance';
            soundEnabled = false;
        } else {
            // Simuler la lecture du son d'ambiance
            try {
                ambientAudio.play().catch(error => {
                    console.log('Simulation du son d\'ambiance (fichier non disponible)');
                });
            } catch (error) {
                console.log('Simulation du son d\'ambiance');
            }
            
            // Afficher une notification pour indiquer que le son est simulé
            const notification = document.createElement('div');
            notification.textContent = 'Sons d\'ambiance simulés (forêt et crépitement de feu)';
            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.padding = '10px 15px';
            notification.style.backgroundColor = 'var(--assemblee-primary)';
            notification.style.color = 'white';
            notification.style.borderRadius = '5px';
            notification.style.zIndex = '1000';
            
            document.body.appendChild(notification);
            
            // Supprimer la notification après 3 secondes
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 3000);
            
            soundButton.textContent = '🔇 Désactiver les sons d\'ambiance';
            soundEnabled = true;
        }
    });
}

/**
 * Fonction pour simuler l'activation de la Flamme Éternelle
 * (Peut être déclenchée par une action spécifique)
 */
function activateEternalFlame() {
    const fireEffect = document.querySelector('.fire-effect');
    
    if (fireEffect) {
        // Animer la flamme pour simuler son activation
        fireEffect.style.animation = 'none';
        setTimeout(() => {
            fireEffect.style.background = 'radial-gradient(circle, #fff 0%, #ffd700 30%, #ff6b00 60%, #a83232 100%)';
            fireEffect.style.boxShadow = '0 0 30px #ffd700, 0 0 50px #ff6b00';
            fireEffect.style.animation = 'pulse 1s infinite alternate';
            
            // Ajouter des particules de feu
            for (let i = 0; i < 20; i++) {
                createFireParticle(fireEffect);
            }
            
            // Mettre à jour le texte
            const fireCaption = fireEffect.nextElementSibling;
            if (fireCaption) {
                fireCaption.textContent = 'La Flamme Éternelle brûle à nouveau!';
                fireCaption.style.color = 'var(--assemblee-primary)';
                fireCaption.style.fontWeight = 'bold';
            }
        }, 50);
    }
}

/**
 * Crée une particule de feu pour l'animation de la Flamme Éternelle
 */
function createFireParticle(parentElement) {
    const particle = document.createElement('div');
    particle.className = 'fire-particle';
    particle.style.position = 'absolute';
    particle.style.width = Math.random() * 10 + 5 + 'px';
    particle.style.height = particle.style.width;
    particle.style.backgroundColor = getRandomFireColor();
    particle.style.borderRadius = '50%';
    particle.style.opacity = Math.random() * 0.5 + 0.5;
    
    // Position initiale au centre
    particle.style.bottom = '50%';
    particle.style.left = '50%';
    particle.style.transform = 'translate(-50%, 50%)';
    
    // Ajouter au parent
    parentElement.appendChild(particle);
    
    // Animer la particule
    const angle = Math.random() * Math.PI * 2;
    const distance = Math.random() * 50 + 20;
    const duration = Math.random() * 2 + 1;
    
    // Animation avec requestAnimationFrame pour de meilleures performances
    const startTime = performance.now();
    
    function animateParticle(currentTime) {
        const elapsed = (currentTime - startTime) / 1000;
        const progress = elapsed / duration;
        
        if (progress < 1) {
            const x = Math.cos(angle) * distance * progress;
            const y = Math.sin(angle) * distance * progress - 50 * progress * progress;
            
            particle.style.transform = `translate(calc(-50% + ${x}px), calc(50% + ${y}px))`;
            particle.style.opacity = Math.max(0, 1 - progress);
            
            requestAnimationFrame(animateParticle);
        } else {
            parentElement.removeChild(particle);
            // Créer une nouvelle particule pour maintenir l'effet
            createFireParticle(parentElement);
        }
    }
    
    requestAnimationFrame(animateParticle);
}

/**
 * Retourne une couleur aléatoire pour les particules de feu
 */
function getRandomFireColor() {
    const colors = [
        '#ff6b00', // Orange
        '#ff9d45', // Orange clair
        '#ffd700', // Or
        '#ff4500', // Rouge-orange
        '#ffff00'  // Jaune
    ];
    
    return colors[Math.floor(Math.random() * colors.length)];
}

// Exposer la fonction d'activation de la flamme pour une utilisation ultérieure
window.activateEternalFlame = activateEternalFlame;