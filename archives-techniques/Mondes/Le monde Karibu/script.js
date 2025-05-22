// Script pour le monde Karibu

document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le monde Karibu!');
    
    // Système pour afficher/masquer les détails des énigmes
    setupEnigmeToggles();
    
    // Animation douce pour la navigation interne
    setupSmoothScrolling();
    
    // Effet de parallaxe simple pour l'en-tête
    setupParallaxEffect();
    
    // Mise en évidence de la section active lors du défilement
    setupScrollSpy();
});

/**
 * Configure les boutons pour afficher/masquer les détails des énigmes
 */
function setupEnigmeToggles() {
    const toggleButtons = document.querySelectorAll('.toggle-btn');
    
    toggleButtons.forEach(button => {
        button.addEventListener('click', () => {
            // Récupérer l'ID du contenu à afficher/masquer
            const targetId = button.getAttribute('data-target');
            const targetContent = document.getElementById(targetId);
            
            // Basculer la classe active pour afficher/masquer le contenu
            targetContent.classList.toggle('active');
            
            // Changer le texte du bouton en fonction de l'état
            if (targetContent.classList.contains('active')) {
                button.textContent = 'Masquer les détails';
            } else {
                button.textContent = 'Afficher les détails';
            }
        });
    });
}

/**
 * Configure le défilement doux pour la navigation interne
 */
function setupSmoothScrolling() {
    const navLinks = document.querySelectorAll('.main-nav a');
    
    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            
            // Récupérer l'ID de la section cible
            const targetId = link.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            // Faire défiler jusqu'à la section cible avec une animation douce
            window.scrollTo({
                top: targetSection.offsetTop - 20,
                behavior: 'smooth'
            });
            
            // Mettre à jour l'URL sans recharger la page
            history.pushState(null, null, targetId);
        });
    });
}

/**
 * Ajoute un effet de parallaxe simple à l'en-tête
 */
function setupParallaxEffect() {
    const header = document.querySelector('header');
    
    window.addEventListener('scroll', () => {
        const scrollPosition = window.scrollY;
        
        // Appliquer un effet de parallaxe subtil à l'en-tête
        if (scrollPosition < 500) {
            header.style.backgroundPosition = `center ${scrollPosition * 0.4}px`;
        }
    });
}

/**
 * Met en évidence la section active lors du défilement
 */
function setupScrollSpy() {
    const sections = document.querySelectorAll('.section');
    const navLinks = document.querySelectorAll('.main-nav a');
    
    window.addEventListener('scroll', () => {
        let current = '';
        const scrollPosition = window.scrollY;
        
        // Déterminer la section actuellement visible
        sections.forEach(section => {
            const sectionTop = section.offsetTop - 100;
            const sectionHeight = section.offsetHeight;
            
            if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
                current = '#' + section.getAttribute('id');
            }
        });
        
        // Mettre à jour la classe active dans la navigation
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === current) {
                link.classList.add('active');
            }
        });
    });
}

/**
 * Fonction pour révéler progressivement les éléments lors du défilement
 * Cette fonction est appelée automatiquement lors du défilement
 */
window.addEventListener('scroll', () => {
    const revealElements = document.querySelectorAll('.subsection, .enigme');
    const windowHeight = window.innerHeight;
    
    revealElements.forEach(element => {
        const elementTop = element.getBoundingClientRect().top;
        const elementVisible = 150;
        
        if (elementTop < windowHeight - elementVisible) {
            element.classList.add('visible');
        }
    });
});

// Ajouter une classe pour les animations de révélation
document.addEventListener('DOMContentLoaded', () => {
    const subsections = document.querySelectorAll('.subsection');
    const enigmes = document.querySelectorAll('.enigme');
    
    // Ajouter la classe 'reveal' aux éléments pour l'animation
    subsections.forEach((subsection, index) => {
        subsection.classList.add('reveal');
        subsection.style.animationDelay = `${index * 0.2}s`;
    });
    
    enigmes.forEach((enigme, index) => {
        enigme.classList.add('reveal');
        enigme.style.animationDelay = `${index * 0.2}s`;
    });
});