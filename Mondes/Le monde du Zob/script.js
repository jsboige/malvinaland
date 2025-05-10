/**
 * Script pour le Monde du Zob
 * Gère les interactions et animations spécifiques à ce monde
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log('Bienvenue dans le Monde du Zob!');
    
    // Initialisation des fonctionnalités
    initNavigation();
    initEnigmes();
    initPNJInteractions();
    initAnimations();
    
    // Notification au système principal que le monde est chargé
    if (window.parent && window.parent.postMessage) {
        window.parent.postMessage({ type: 'MONDE_LOADED', id: 'monde-zob' }, '*');
    }
});

/**
 * Initialise la navigation interne au monde
 */
function initNavigation() {
    // Navigation interne fluide
    const internalLinks = document.querySelectorAll('nav ul li a[href^="#"]');
    internalLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = link.getAttribute('href').substring(1);
            const targetSection = document.getElementById(targetId);
            
            if (targetSection) {
                window.scrollTo({
                    top: targetSection.offsetTop - 80, // Offset pour tenir compte du header
                    behavior: 'smooth'
                });
                
                // Mise en évidence de la section active
                highlightSection(targetSection);
            }
        });
    });
    
    // Détection de la section visible au scroll
    window.addEventListener('scroll', debounce(() => {
        const sections = document.querySelectorAll('main section');
        let currentSection = null;
        let minDistance = Infinity;
        
        sections.forEach(section => {
            const rect = section.getBoundingClientRect();
            const distance = Math.abs(rect.top);
            
            if (distance < minDistance) {
                minDistance = distance;
                currentSection = section;
            }
        });
        
        if (currentSection) {
            highlightSection(currentSection);
        }
    }, 100));
}

/**
 * Met en évidence la section active dans le menu de navigation
 */
function highlightSection(activeSection) {
    const navLinks = document.querySelectorAll('nav ul li a');
    const activeId = activeSection.id;
    
    navLinks.forEach(link => {
        const linkTarget = link.getAttribute('href').substring(1);
        
        if (linkTarget === activeId) {
            link.classList.add('active-link');
        } else {
            link.classList.remove('active-link');
        }
    });
}

/**
 * Initialise les interactions avec les énigmes
 */
function initEnigmes() {
    const enigmes = document.querySelectorAll('.enigme');
    
    enigmes.forEach(enigme => {
        // Ajout d'un bouton pour afficher/masquer les indices
        const enigmeContent = enigme.querySelector('.enigme-content');
        const enigmeTitle = enigme.querySelector('h3');
        
        // Création du bouton d'indice
        const indiceBtn = document.createElement('button');
        indiceBtn.classList.add('indice-btn');
        indiceBtn.textContent = 'Afficher l\'indice';
        enigmeContent.appendChild(indiceBtn);
        
        // Gestion du clic sur le titre de l'énigme (expansion/réduction)
        enigmeTitle.addEventListener('click', () => {
            enigme.classList.toggle('expanded');
            
            if (enigme.classList.contains('expanded')) {
                enigmeContent.style.maxHeight = enigmeContent.scrollHeight + 'px';
            } else {
                enigmeContent.style.maxHeight = null;
            }
        });
        
        // Gestion du clic sur le bouton d'indice
        indiceBtn.addEventListener('click', () => {
            const indice = enigme.querySelector('.enigme-indice');
            const isVisible = indice.style.display === 'block';
            
            if (isVisible) {
                indice.style.display = 'none';
                indiceBtn.textContent = 'Afficher l\'indice';
            } else {
                indice.style.display = 'block';
                indiceBtn.textContent = 'Masquer l\'indice';
                
                // Animation de l'indice
                indice.style.opacity = '0';
                indice.style.transform = 'translateY(10px)';
                
                setTimeout(() => {
                    indice.style.opacity = '1';
                    indice.style.transform = 'translateY(0)';
                }, 10);
            }
        });
        
        // Masquer les indices par défaut
        const indice = enigme.querySelector('.enigme-indice');
        indice.style.display = 'none';
    });
    
    // Ajout d'un système de progression pour les énigmes
    setupEnigmeProgression();
}

/**
 * Configure le système de progression pour les énigmes
 */
function setupEnigmeProgression() {
    // Création d'un compteur de progression
    const enigmesSection = document.getElementById('enigmes');
    const progressContainer = document.createElement('div');
    progressContainer.classList.add('enigmes-progress');
    
    const progressTitle = document.createElement('h4');
    progressTitle.textContent = 'Progression des énigmes';
    
    const progressBar = document.createElement('div');
    progressBar.classList.add('progress-bar');
    
    const progressFill = document.createElement('div');
    progressFill.classList.add('progress-fill');
    progressFill.style.width = '0%';
    
    const progressText = document.createElement('div');
    progressText.classList.add('progress-text');
    progressText.textContent = '0/3 énigmes résolues';
    
    progressBar.appendChild(progressFill);
    progressContainer.appendChild(progressTitle);
    progressContainer.appendChild(progressBar);
    progressContainer.appendChild(progressText);
    
    // Insertion du compteur au début de la section
    const enigmesContainer = enigmesSection.querySelector('.enigmes-container');
    enigmesSection.insertBefore(progressContainer, enigmesContainer);
    
    // Ajout de boutons de validation pour chaque énigme
    const enigmes = document.querySelectorAll('.enigme');
    enigmes.forEach(enigme => {
        const validateBtn = document.createElement('button');
        validateBtn.classList.add('validate-btn');
        validateBtn.textContent = 'Valider l\'énigme';
        
        validateBtn.addEventListener('click', () => {
            if (!enigme.classList.contains('solved')) {
                enigme.classList.add('solved');
                
                // Afficher la solution
                const solution = enigme.querySelector('.enigme-solution');
                solution.classList.add('visible');
                
                // Mettre à jour la progression
                updateEnigmeProgress();
                
                // Animation de succès
                validateBtn.textContent = 'Énigme résolue!';
                validateBtn.disabled = true;
                
                // Effet visuel de succès
                enigme.style.borderLeft = '4px solid var(--zob-accent)';
                
                // Notification au système principal
                if (window.parent && window.parent.postMessage) {
                    const enigmeId = enigme.id;
                    window.parent.postMessage({ 
                        type: 'ENIGME_SOLVED', 
                        monde: 'monde-zob',
                        enigme: enigmeId
                    }, '*');
                }
            }
        });
        
        enigme.querySelector('.enigme-content').appendChild(validateBtn);
    });
}

/**
 * Met à jour la barre de progression des énigmes
 */
function updateEnigmeProgress() {
    const totalEnigmes = document.querySelectorAll('.enigme').length;
    const solvedEnigmes = document.querySelectorAll('.enigme.solved').length;
    
    const progressFill = document.querySelector('.progress-fill');
    const progressText = document.querySelector('.progress-text');
    
    const percentage = (solvedEnigmes / totalEnigmes) * 100;
    progressFill.style.width = percentage + '%';
    progressText.textContent = `${solvedEnigmes}/${totalEnigmes} énigmes résolues`;
    
    // Si toutes les énigmes sont résolues
    if (solvedEnigmes === totalEnigmes) {
        const progressContainer = document.querySelector('.enigmes-progress');
        progressContainer.classList.add('all-solved');
        
        // Afficher un message de félicitations
        const congratsMsg = document.createElement('div');
        congratsMsg.classList.add('congrats-message');
        congratsMsg.textContent = 'Félicitations! Vous avez résolu toutes les énigmes du Monde du Zob! Vous avez découvert les trois principes: HARMONIE, ÉQUILIBRE et PERSPECTIVE.';
        progressContainer.appendChild(congratsMsg);
        
        // Notification au système principal
        if (window.parent && window.parent.postMessage) {
            window.parent.postMessage({ 
                type: 'ALL_ENIGMES_SOLVED', 
                monde: 'monde-zob'
            }, '*');
        }
    }
}

/**
 * Initialise les interactions avec les PNJ
 */
function initPNJInteractions() {
    const pnjs = document.querySelectorAll('.pnj');
    
    pnjs.forEach(pnj => {
        const tirades = pnj.querySelectorAll('.tirade');
        
        // Masquer toutes les tirades sauf la première
        for (let i = 1; i < tirades.length; i++) {
            tirades[i].style.display = 'none';
        }
        
        // Ajouter des boutons de navigation pour les tirades
        const tiradesNav = document.createElement('div');
        tiradesNav.classList.add('tirades-nav');
        
        const prevBtn = document.createElement('button');
        prevBtn.classList.add('tirade-nav-btn', 'prev-btn');
        prevBtn.textContent = '← Précédent';
        prevBtn.disabled = true;
        
        const nextBtn = document.createElement('button');
        nextBtn.classList.add('tirade-nav-btn', 'next-btn');
        nextBtn.textContent = 'Suivant →';
        
        tiradesNav.appendChild(prevBtn);
        tiradesNav.appendChild(nextBtn);
        pnj.appendChild(tiradesNav);
        
        // État actuel
        let currentTirade = 0;
        
        // Gestion des clics sur les boutons
        prevBtn.addEventListener('click', () => {
            if (currentTirade > 0) {
                tirades[currentTirade].style.display = 'none';
                currentTirade--;
                tirades[currentTirade].style.display = 'block';
                
                // Mise à jour des états des boutons
                nextBtn.disabled = false;
                if (currentTirade === 0) {
                    prevBtn.disabled = true;
                }
            }
        });
        
        nextBtn.addEventListener('click', () => {
            if (currentTirade < tirades.length - 1) {
                tirades[currentTirade].style.display = 'none';
                currentTirade++;
                tirades[currentTirade].style.display = 'block';
                
                // Mise à jour des états des boutons
                prevBtn.disabled = false;
                if (currentTirade === tirades.length - 1) {
                    nextBtn.disabled = true;
                }
            }
        });
    });
}

/**
 * Initialise les animations et effets visuels
 */
function initAnimations() {
    // Animation des mots-clés d'ambiance
    const keywords = document.querySelectorAll('.ambiance-keywords span');
    
    keywords.forEach((keyword, index) => {
        // Animation décalée pour chaque mot-clé
        setTimeout(() => {
            keyword.style.opacity = '1';
            keyword.style.transform = 'translateY(0)';
        }, 300 + (index * 150));
    });
    
    // Animation au survol des sections
    const sections = document.querySelectorAll('main section');
    
    sections.forEach(section => {
        section.addEventListener('mouseenter', () => {
            section.classList.add('section-hover');
        });
        
        section.addEventListener('mouseleave', () => {
            section.classList.remove('section-hover');
        });
    });
}

/**
 * Fonction utilitaire pour limiter la fréquence d'exécution d'une fonction
 */
function debounce(func, wait) {
    let timeout;
    
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

/**
 * Ajoute des styles dynamiques au document
 */
function addDynamicStyles() {
    const styleElement = document.createElement('style');
    styleElement.textContent = `
        .active-link {
            background-color: rgba(255, 255, 255, 0.3);
            font-weight: bold;
        }
        
        .enigme {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .enigme.expanded {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .enigme-content {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
        }
        
        .enigme.expanded .enigme-content {
            max-height: 500px;
        }
        
        .indice-btn, .validate-btn {
            background-color: var(--zob-primary);
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 20px;
            margin-top: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
            font-weight: bold;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        
        .indice-btn:hover, .validate-btn:hover {
            background-color: var(--zob-secondary);
            transform: translateY(-2px);
        }
        
        .validate-btn {
            background-color: var(--zob-accent);
            margin-left: 1rem;
        }
        
        .enigme.solved {
            background-color: rgba(39, 174, 96, 0.1);
        }
        
        .enigmes-progress {
            background-color: white;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            text-align: center;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .progress-bar {
            height: 20px;
            background-color: rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            margin: 1rem 0;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background-color: var(--zob-accent);
            width: 0;
            transition: width 0.5s ease;
        }
        
        .progress-text {
            font-weight: bold;
            color: var(--zob-secondary);
        }
        
        .all-solved .progress-fill {
            background-color: var(--zob-highlight);
        }
        
        .congrats-message {
            margin-top: 1rem;
            font-weight: bold;
            color: var(--zob-accent);
            animation: pulse 2s infinite;
            padding: 15px;
            background-color: rgba(39, 174, 96, 0.1);
            border-radius: 8px;
            font-size: 1.2rem;
        }
        
        .tirades-nav {
            display: flex;
            justify-content: space-between;
            margin-top: 1.5rem;
        }
        
        .tirade-nav-btn {
            background-color: var(--zob-secondary);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .tirade-nav-btn:hover:not(:disabled) {
            background-color: var(--zob-primary);
            transform: translateY(-2px);
        }
        
        .tirade-nav-btn:disabled {
            background-color: rgba(0, 0, 0, 0.2);
            cursor: not-allowed;
        }
        
        .ambiance-keywords span {
            opacity: 0;
            transform: translateY(20px);
            transition: all 0.5s ease;
        }
        
        .section-hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
    `;
    
    document.head.appendChild(styleElement);
}

// Ajout des styles dynamiques
addDynamicStyles();