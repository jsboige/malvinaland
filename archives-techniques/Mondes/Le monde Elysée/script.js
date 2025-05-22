// Script pour le monde Elysée
document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le monde Elysée!');
    
    // Gestion des boutons d'indices et de solutions
    const indiceButtons = document.querySelectorAll('.indice-btn');
    const solutionButtons = document.querySelectorAll('.solution-btn');
    
    // Fonction pour afficher/masquer les indices
    indiceButtons.forEach(button => {
        button.addEventListener('click', () => {
            const indiceNumber = button.getAttribute('data-indice');
            const indiceElement = document.querySelector(`.indice-${indiceNumber}`);
            
            if (indiceElement.classList.contains('hidden')) {
                // Masquer tous les indices d'abord
                document.querySelectorAll('.indice').forEach(indice => {
                    indice.classList.add('hidden');
                });
                
                // Afficher l'indice sélectionné
                indiceElement.classList.remove('hidden');
                
                // Changer le texte du bouton
                button.textContent = `Masquer l'indice ${indiceNumber.split('-')[0]}`;
            } else {
                // Masquer l'indice
                indiceElement.classList.add('hidden');
                
                // Restaurer le texte du bouton
                button.textContent = `Indice ${indiceNumber.split('-')[0]}`;
            }
        });
    });
    
    // Fonction pour afficher/masquer les solutions
    solutionButtons.forEach(button => {
        button.addEventListener('click', () => {
            const solutionId = button.getAttribute('data-solution');
            const solutionElement = document.querySelector(`.solution-${solutionId}`);
            
            if (solutionElement.classList.contains('hidden')) {
                // Masquer toutes les solutions d'abord
                document.querySelectorAll('.solution').forEach(solution => {
                    solution.classList.add('hidden');
                });
                
                // Afficher la solution sélectionnée
                solutionElement.classList.remove('hidden');
                
                // Changer le texte du bouton
                button.textContent = 'Masquer la solution';
            } else {
                // Masquer la solution
                solutionElement.classList.add('hidden');
                
                // Restaurer le texte du bouton
                button.textContent = 'Solution';
            }
        });
    });
    
    // Animation subtile pour les images au survol
    const images = document.querySelectorAll('.epreuve-img, .gallery-image');
    
    images.forEach(image => {
        image.addEventListener('mouseenter', () => {
            image.style.transition = 'transform 0.3s ease';
            image.style.transform = 'scale(1.02)';
        });
        
        image.addEventListener('mouseleave', () => {
            image.style.transform = 'scale(1)';
        });
    });
    
    // Fonction pour vérifier si un élément est visible dans la fenêtre
    function isElementInViewport(el) {
        const rect = el.getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }
    
    // Animation d'apparition au défilement
    function handleScrollAnimation() {
        const epreuves = document.querySelectorAll('.epreuve');
        
        epreuves.forEach(epreuve => {
            if (isElementInViewport(epreuve) && !epreuve.classList.contains('animated')) {
                epreuve.style.animation = 'fadeIn 1s ease forwards';
                epreuve.classList.add('animated');
            }
        });
    }
    
    // Ajouter l'animation CSS
    const style = document.createElement('style');
    style.innerHTML = `
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .epreuve {
            opacity: 0;
        }
        
        .epreuve.animated {
            opacity: 1;
        }
    `;
    document.head.appendChild(style);
    
    // Déclencher l'animation au chargement et au défilement
    handleScrollAnimation();
    window.addEventListener('scroll', handleScrollAnimation);
});