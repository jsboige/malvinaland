// Script pour le monde des jeux
document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le monde des jeux!');
    
    // Initialisation des fonctionnalités interactives
    initAnimations();
    initEnigmeInteractions();
    initNavigationSmooth();
    initImagePlaceholders();
});

/**
 * Initialise les animations pour les éléments du monde des jeux
 */
function initAnimations() {
    // Ajouter des classes d'animation aux éléments appropriés
    const trampolineElements = document.querySelectorAll('.enigme h3:contains("Saut Céleste")');
    trampolineElements.forEach(el => {
        el.classList.add('trampoline-animation');
    });
    
    const balancoireElements = document.querySelectorAll('.enigme h3:contains("Pendule des Souvenirs")');
    balancoireElements.forEach(el => {
        el.classList.add('balancoire-animation');
    });
}

/**
 * Initialise les interactions liées aux énigmes
 */
function initEnigmeInteractions() {
    // Rendre les énigmes cliquables pour afficher plus de détails
    const enigmes = document.querySelectorAll('.enigme');
    
    enigmes.forEach(enigme => {
        const title = enigme.querySelector('h3');
        const details = enigme.querySelectorAll('.enigme-details, .enigme-materiel, .enigme-solution');
        
        // Ajouter une classe interactive au titre
        title.classList.add('interactive-element');
        
        // Cacher initialement les détails de la solution
        const solution = enigme.querySelector('.enigme-solution');
        if (solution) {
            solution.style.display = 'none';
        }
        
        // Ajouter un événement de clic pour afficher/masquer les détails
        title.addEventListener('click', () => {
            details.forEach(detail => {
                if (detail.style.display === 'none') {
                    detail.style.display = 'block';
                    detail.style.animation = 'fadeIn 0.5s ease';
                } else {
                    detail.style.display = 'none';
                }
            });
        });
        
        // Ajouter un bouton pour révéler la solution
        const solutionBtn = document.createElement('button');
        solutionBtn.textContent = 'Révéler la solution';
        solutionBtn.classList.add('solution-btn');
        
        if (solution) {
            enigme.appendChild(solutionBtn);
            
            solutionBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                if (solution.style.display === 'none') {
                    solution.style.display = 'block';
                    solution.style.animation = 'fadeIn 0.5s ease';
                    solutionBtn.textContent = 'Cacher la solution';
                } else {
                    solution.style.display = 'none';
                    solutionBtn.textContent = 'Révéler la solution';
                }
            });
        }
    });
}

/**
 * Initialise la navigation fluide entre les sections
 */
function initNavigationSmooth() {
    const navLinks = document.querySelectorAll('nav a');
    
    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            
            const targetId = link.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                window.scrollTo({
                    top: targetSection.offsetTop - 70, // Ajuster pour l'en-tête fixe
                    behavior: 'smooth'
                });
            }
        });
    });
}

/**
 * Initialise les placeholders d'images avec des interactions
 */
function initImagePlaceholders() {
    const placeholders = document.querySelectorAll('.image-placeholder');
    
    placeholders.forEach(placeholder => {
        // Ajouter une classe interactive
        placeholder.classList.add('interactive-element');
        
        // Ajouter un événement de clic pour simuler le chargement d'une image
        placeholder.addEventListener('click', () => {
            // Simuler un chargement
            placeholder.innerHTML = '<div class="placeholder-text">Chargement...</div>';
            
            // Après un délai, afficher un message
            setTimeout(() => {
                placeholder.innerHTML = '<div class="placeholder-text">Les images seront disponibles prochainement</div>';
            }, 1500);
        });
    });
}

/**
 * Fonction utilitaire pour vérifier si un élément contient un texte spécifique
 */
Element.prototype.contains = function(text) {
    return this.textContent.includes(text);
};

/**
 * Animation de fondu pour les éléments
 */
document.head.insertAdjacentHTML('beforeend', `
    <style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .solution-btn {
            background-color: #4a86e8;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.3s ease;
        }
        
        .solution-btn:hover {
            background-color: #3a76d8;
        }
    </style>
`);