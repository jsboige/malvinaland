// Script pour le monde des jeux
document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le monde des jeux!');
    
    // Initialisation des fonctionnalités interactives
    initAnimations();
    initEnigmeInteractions();
    initNavigationSmooth();
    initImagePlaceholders();
    initEnigmeValidation();
    initProgressionSystem();
});

// État global des énigmes
const enigmesState = {
    enigme1: { resolved: false, answer: "OSCILLATION" },
    enigme2: { resolved: false, answer: "RÉSONANCE" },
    enigme3: { resolved: false, answer: "ENFANCE" }
};

/**
 * Initialise les animations pour les éléments du monde des jeux
 */
function initAnimations() {
    // Ajouter des classes d'animation aux éléments appropriés
    const enigmeTitles = document.querySelectorAll('.enigme h3');
    
    enigmeTitles.forEach(el => {
        if (el.textContent.includes('Saut Céleste')) {
            el.classList.add('trampoline-animation');
        } else if (el.textContent.includes('Pendule des Souvenirs')) {
            el.classList.add('balancoire-animation');
        }
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
        const details = enigme.querySelectorAll('.enigme-details, .enigme-materiel, .enigme-indices, .enigme-solution');
        
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
 * Initialise le système de validation des énigmes
 */
function initEnigmeValidation() {
    // Formulaire de validation pour l'énigme 1
    const form1 = document.getElementById('form-enigme1');
    form1.addEventListener('submit', (e) => {
        e.preventDefault();
        validateEnigme('enigme1', document.getElementById('reponse-enigme1').value);
    });
    
    // Formulaire de validation pour l'énigme 2
    const form2 = document.getElementById('form-enigme2');
    form2.addEventListener('submit', (e) => {
        e.preventDefault();
        validateEnigme('enigme2', document.getElementById('reponse-enigme2').value);
    });
    
    // Formulaire de validation pour l'énigme 3
    const form3 = document.getElementById('form-enigme3');
    form3.addEventListener('submit', (e) => {
        e.preventDefault();
        validateEnigme('enigme3', document.getElementById('reponse-enigme3').value);
    });
}

/**
 * Valide la réponse d'une énigme
 * @param {string} enigmeId - L'identifiant de l'énigme
 * @param {string} answer - La réponse fournie par l'utilisateur
 */
function validateEnigme(enigmeId, answer) {
    const enigme = enigmesState[enigmeId];
    const feedback = document.getElementById(`feedback-${enigmeId}`);
    const enigmeElement = document.getElementById(enigmeId);
    
    // Normaliser la réponse (supprimer les accents, mettre en majuscules)
    const normalizedAnswer = normalizeText(answer);
    const correctAnswer = enigme.answer;
    
    if (normalizedAnswer === correctAnswer) {
        // Réponse correcte
        if (!enigme.resolved) {
            enigme.resolved = true;
            
            // Mettre à jour l'interface
            feedback.textContent = "✅ Correct ! Vous avez résolu cette énigme.";
            feedback.className = "validation-feedback feedback-success";
            
            enigmeElement.classList.add('resolue');
            
            // Révéler le mot correspondant dans la phrase
            revealWord(enigmeId);
            
            // Mettre à jour la progression
            updateProgression();
            
            // Vérifier si toutes les énigmes sont résolues
            checkAllEnigmesResolved();
            
            // Animation de succès
            animateSuccess(enigmeElement);
        } else {
            feedback.textContent = "✅ Vous avez déjà résolu cette énigme.";
            feedback.className = "validation-feedback feedback-success";
        }
    } else {
        // Réponse incorrecte
        feedback.textContent = "❌ Incorrect. Essayez encore.";
        feedback.className = "validation-feedback feedback-error";
        
        // Animation d'erreur
        animateError(document.getElementById(`reponse-${enigmeId}`));
    }
}

/**
 * Normalise un texte (supprime les accents, met en majuscules)
 * @param {string} text - Le texte à normaliser
 * @returns {string} - Le texte normalisé
 */
function normalizeText(text) {
    return text.trim()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .toUpperCase();
}

/**
 * Révèle un mot dans la phrase complète
 * @param {string} enigmeId - L'identifiant de l'énigme résolue
 */
function revealWord(enigmeId) {
    let wordId;
    
    switch (enigmeId) {
        case 'enigme1':
            wordId = 'mot1'; // OSCILLATION
            break;
        case 'enigme2':
            wordId = 'mot2'; // RÉSONANCE
            document.getElementById('et').classList.add('visible');
            break;
        case 'enigme3':
            wordId = 'mot3'; // ENFANCE
            document.getElementById('de').classList.add('visible');
            break;
    }
    
    if (wordId) {
        const wordElement = document.getElementById(wordId);
        wordElement.classList.add('visible');
    }
}

/**
 * Met à jour la barre de progression
 */
function updateProgression() {
    const resolvedCount = Object.values(enigmesState).filter(e => e.resolved).length;
    const totalCount = Object.keys(enigmesState).length;
    const progressPercentage = (resolvedCount / totalCount) * 100;
    
    // Mettre à jour la barre de progression
    const progressFill = document.getElementById('progression-fill');
    progressFill.style.width = `${progressPercentage}%`;
    
    // Mettre à jour le texte de progression
    const enigmesResolues = document.getElementById('enigmes-resolues');
    enigmesResolues.textContent = resolvedCount;
}

/**
 * Vérifie si toutes les énigmes sont résolues
 */
function checkAllEnigmesResolved() {
    const allResolved = Object.values(enigmesState).every(e => e.resolved);
    
    if (allResolved) {
        // Débloquer l'indice vers le monde Karibu
        const indiceKaribu = document.getElementById('indice-karibu');
        indiceKaribu.style.display = 'block';
        indiceKaribu.style.animation = 'fadeIn 1s ease';
        
        // Animer la phrase complète
        const phraseComplete = document.getElementById('phrase-complete');
        phraseComplete.style.animation = 'pulse 2s ease';
    }
}

/**
 * Anime un élément pour indiquer une validation réussie
 * @param {HTMLElement} element - L'élément à animer
 */
function animateSuccess(element) {
    element.style.animation = 'none';
    setTimeout(() => {
        element.style.animation = 'successPulse 0.6s ease';
    }, 10);
}

/**
 * Anime un élément pour indiquer une erreur
 * @param {HTMLElement} element - L'élément à animer
 */
function animateError(element) {
    element.style.animation = 'none';
    setTimeout(() => {
        element.style.animation = 'shake 0.5s ease';
    }, 10);
}

/**
 * Initialise le système de progression
 */
function initProgressionSystem() {
    // Cacher initialement tous les mots de la phrase
    document.querySelectorAll('.mot-phrase').forEach(mot => {
        mot.classList.remove('visible');
    });
    
    // Cacher l'indice Karibu
    document.getElementById('indice-karibu').style.display = 'none';
    
    // Initialiser la barre de progression
    updateProgression();
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

// La fonction Element.prototype.contains a été supprimée car elle causait un conflit
// avec la méthode native contains des éléments DOM

/**
 * Animation de fondu pour les éléments
 */
document.head.insertAdjacentHTML('beforeend', `
    <style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes successPulse {
            0% { transform: scale(1); box-shadow: 0 0 0 rgba(76, 175, 80, 0); }
            50% { transform: scale(1.03); box-shadow: 0 0 20px rgba(76, 175, 80, 0.5); }
            100% { transform: scale(1); box-shadow: 0 0 0 rgba(76, 175, 80, 0); }
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-5px); }
            40%, 80% { transform: translateX(5px); }
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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