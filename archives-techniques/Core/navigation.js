/**
 * Script de navigation pour Les mondes de Malvinaland
 *
 * Ce script gère la navigation desktop et mobile du site, avec un menu hamburger
 * pour les appareils mobiles et une navigation horizontale pour les écrans plus larges.
 *
 * Fonctionnalités principales :
 * - Menu hamburger responsive pour les appareils mobiles
 * - Animations fluides pour l'ouverture/fermeture du menu
 * - Support tactile optimisé pour les appareils mobiles
 * - Navigation fluide avec défilement doux vers les sections
 * - Mise en évidence automatique de la section active lors du défilement
 * - Accessibilité améliorée avec attributs ARIA et support clavier
 * - Optimisations de performance pour éviter les problèmes de jank visuel
 */

document.addEventListener('DOMContentLoaded', function() {
    // Éléments du DOM
    const mobileNavToggle = document.getElementById('mobile-nav-toggle');
    const mobileNav = document.getElementById('mobile-nav');
    const body = document.body;
    
    // Créer un overlay pour fermer le menu en cliquant à l'extérieur
    const overlay = document.createElement('div');
    overlay.className = 'overlay';
    body.appendChild(overlay);
    
    /**
     * Fonction pour ouvrir/fermer le menu mobile avec animation
     * Cette fonction gère l'état du menu, les attributs d'accessibilité,
     * et les animations d'entrée/sortie des éléments du menu
     */
    function toggleMobileNav() {
        // Basculer les classes active pour le bouton, le menu et l'overlay
        mobileNavToggle.classList.toggle('active');
        mobileNav.classList.toggle('active');
        overlay.classList.toggle('active');
        
        // Mettre à jour les attributs ARIA pour l'accessibilité
        const isExpanded = mobileNav.classList.contains('active');
        mobileNavToggle.setAttribute('aria-expanded', isExpanded);
        mobileNav.setAttribute('aria-hidden', !isExpanded);
        
        // Gestion du défilement de la page
        if (mobileNav.classList.contains('active')) {
            // Empêcher le défilement du body quand le menu est ouvert
            body.style.overflow = 'hidden';
            
            // Animation séquentielle des éléments du menu
            const menuItems = mobileNav.querySelectorAll('li');
            menuItems.forEach((item, index) => {
                // Stocker l'index pour l'animation séquentielle via CSS
                item.style.setProperty('--item-index', index);
                
                // Réinitialiser l'animation pour permettre de la rejouer
                item.style.opacity = '0';
                item.style.transform = 'translateX(20px)';
                
                // Forcer un reflow pour que l'animation se déclenche
                // Cette technique est nécessaire pour réinitialiser l'animation
                void item.offsetWidth;
                
                // Appliquer l'animation avec un délai progressif
                // Chaque élément apparaît 50ms après le précédent
                setTimeout(() => {
                    item.style.opacity = '1';
                    item.style.transform = 'translateX(0)';
                }, 50 * index);
            });
        } else {
            // Restaurer le défilement après l'animation de fermeture
            setTimeout(() => {
                body.style.overflow = '';
            }, 300); // Délai correspondant à la durée de l'animation
        }
    }
    
    // Événement pour le bouton hamburger avec gestion tactile améliorée
    mobileNavToggle.addEventListener('click', function(e) {
        e.preventDefault();
        toggleMobileNav();
    });
    
    // Support tactile amélioré
    mobileNavToggle.addEventListener('touchend', function(e) {
        e.preventDefault();
        toggleMobileNav();
    });
    
    // Fermer le menu en cliquant sur l'overlay
    overlay.addEventListener('click', toggleMobileNav);
    overlay.addEventListener('touchend', function(e) {
        e.preventDefault();
        toggleMobileNav();
    });
    
    // Fermer le menu en cliquant sur un lien avec animation
    const mobileNavLinks = mobileNav.querySelectorAll('a');
    mobileNavLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Vérifier si c'est un lien d'ancrage (commence par #) ou un lien externe
            const href = this.getAttribute('href');
            const isAnchorLink = href && href.startsWith('#');
            
            if (isAnchorLink) {
                e.preventDefault();
                
                // Ajouter un effet de clic
                this.classList.add('link-clicked');
                
                // Petit délai pour l'animation
                setTimeout(() => {
                    toggleMobileNav();
                    
                    // Délai pour permettre la fermeture du menu avant le défilement
                    setTimeout(() => {
                        this.classList.remove('link-clicked');
                        const targetId = href.substring(1);
                        const targetElement = document.getElementById(targetId);
                        
                        if (targetElement) {
                            targetElement.scrollIntoView({
                                behavior: 'smooth'
                            });
                        }
                    }, 300);
                }, 150);
            } else {
                // Pour les liens externes, fermer simplement le menu et laisser le comportement par défaut
                toggleMobileNav();
            }
        });
        
        // Support tactile amélioré
        link.addEventListener('touchend', function(e) {
            e.preventDefault();
            this.click();
        });
    });
    
    // Navigation fluide pour les liens desktop avec effet visuel
    const desktopNavLinks = document.getElementById('desktop-nav').querySelectorAll('a');
    desktopNavLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Vérifier si c'est un lien d'ancrage (commence par #) ou un lien externe
            const href = this.getAttribute('href');
            const isAnchorLink = href && href.startsWith('#');
            
            if (isAnchorLink) {
                e.preventDefault();
                
                // Supprimer la classe active de tous les liens
                desktopNavLinks.forEach(l => l.classList.remove('active'));
                
                // Ajouter la classe active au lien cliqué
                this.classList.add('active');
                
                // Effet de clic
                this.classList.add('link-clicked');
                
                const targetId = href.substring(1);
                const targetElement = document.getElementById(targetId);
                
                if (targetElement) {
                    // Ajouter une classe pour l'animation de transition
                    targetElement.classList.add('page-transition');
                    
                    targetElement.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                    
                    // Retirer la classe d'animation après la transition
                    setTimeout(() => {
                        this.classList.remove('link-clicked');
                        targetElement.classList.remove('page-transition');
                    }, 500);
                }
            } else {
                // Pour les liens externes, simplement mettre à jour la classe active
                desktopNavLinks.forEach(l => l.classList.remove('active'));
                this.classList.add('active');
            }
        });
        
        // Support tactile amélioré
        link.addEventListener('touchend', function(e) {
            e.preventDefault();
            this.click();
        });
    });
    
    // Mettre en évidence la section active lors du défilement avec optimisation des performances
    const sections = document.querySelectorAll('section');
    const navLinks = document.querySelectorAll('nav a');
    
    /**
     * Utiliser requestAnimationFrame pour optimiser les performances de défilement
     * Cette technique évite d'exécuter des calculs coûteux à chaque événement de défilement
     */
    let ticking = false;
    
    /**
     * Met en évidence le lien de navigation correspondant à la section actuellement visible
     * Cette fonction est optimisée pour éviter les problèmes de performance lors du défilement
     */
    function highlightActiveSection() {
        // Position actuelle du défilement
        let scrollPosition = window.scrollY;
        
        // Vérifier chaque section pour déterminer laquelle est visible
        sections.forEach(section => {
            // Calculer les limites de la section avec un offset pour une meilleure UX
            const sectionTop = section.offsetTop - 100; // Offset pour déclencher plus tôt
            const sectionHeight = section.offsetHeight;
            const sectionId = section.getAttribute('id');
            
            // Vérifier si la position de défilement est dans cette section
            if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
                // Mettre à jour les classes active dans les liens de navigation
                navLinks.forEach(link => {
                    // Supprimer la classe active de tous les liens
                    link.classList.remove('active');
                    // Ajouter la classe active au lien correspondant à la section
                    if (link.getAttribute('href') === '#' + sectionId) {
                        link.classList.add('active');
                    }
                });
            }
        });
        
        // Réinitialiser le flag pour permettre la prochaine mise à jour
        ticking = false;
    }
    
    /**
     * Événement de défilement optimisé pour mettre à jour la section active
     * Utilise requestAnimationFrame pour limiter les calculs et améliorer les performances
     */
    window.addEventListener('scroll', function() {
        // Vérifier si une mise à jour est déjà en attente
        if (!ticking) {
            // Planifier une mise à jour au prochain frame d'animation
            window.requestAnimationFrame(function() {
                highlightActiveSection();
            });
            // Marquer qu'une mise à jour est en attente
            ticking = true;
        }
    });
    
    // Initialiser la section active au chargement
    highlightActiveSection();
    
    /**
     * Gestionnaire pour les événements de redimensionnement avec debounce
     * Évite les calculs excessifs pendant le redimensionnement de la fenêtre
     */
    let resizeTimer;
    window.addEventListener('resize', function() {
        // Annuler le timer précédent pour éviter les calculs multiples
        clearTimeout(resizeTimer);
        // Définir un nouveau timer (technique de debounce)
        resizeTimer = setTimeout(function() {
            // Recalculer les positions des sections après redimensionnement
            highlightActiveSection();
        }, 250); // Attendre 250ms après la fin du redimensionnement
    });
    
    /**
     * Ajouter des retours visuels pour les interactions tactiles
     * Améliore l'expérience utilisateur sur les appareils tactiles en fournissant
     * un feedback visuel immédiat lors des interactions
     */
    document.querySelectorAll('.interactive').forEach(element => {
        // Ajouter une classe au début de l'interaction tactile
        element.addEventListener('touchstart', function() {
            this.classList.add('touch-active');
        });
        
        // Supprimer la classe à la fin de l'interaction tactile
        element.addEventListener('touchend', function() {
            this.classList.remove('touch-active');
        });
    });
    
    /**
     * Gestionnaire d'événements pour la touche Échap
     * Améliore l'accessibilité en permettant de fermer le menu mobile avec la touche Échap
     */
    document.addEventListener('keydown', function(e) {
        // Fermer le menu mobile si la touche Échap est pressée et que le menu est ouvert
        if (e.key === 'Escape' && mobileNav.classList.contains('active')) {
            toggleMobileNav();
        }
    });
    
    // Initialiser les attributs ARIA au chargement
    mobileNavToggle.setAttribute('aria-expanded', 'false');
    mobileNav.setAttribute('aria-hidden', 'true');
    
    // Améliorer l'accessibilité du menu mobile
    mobileNavToggle.setAttribute('aria-label', 'Menu de navigation');
    
    /**
     * Gestionnaire pour fermer automatiquement le menu mobile lors du redimensionnement
     * Si l'utilisateur passe d'une vue mobile à une vue desktop avec le menu ouvert,
     * celui-ci sera automatiquement fermé pour éviter les problèmes d'interface
     */
    window.addEventListener('resize', function() {
        // Si la fenêtre est redimensionnée à une largeur supérieure au breakpoint mobile
        // et que le menu mobile est ouvert, le fermer automatiquement
        if (window.innerWidth > 768 && mobileNav.classList.contains('active')) {
            toggleMobileNav();
        }
    });
    
    /**
     * Fonction alternative pour déterminer la section active basée sur la position dans le viewport
     * Cette méthode est plus précise que celle basée uniquement sur scrollY car elle prend en compte
     * la position réelle des éléments dans la fenêtre visible
     */
    function setActiveLink() {
        // Trouver la première section dont le haut est proche ou au-dessus du haut de la fenêtre
        // et dont le bas est encore visible dans la fenêtre
        const currentSection = Array.from(sections).find(section => {
            const rect = section.getBoundingClientRect();
            // La section est considérée comme "active" si son haut est à moins de 100px du haut de la fenêtre
            // et que son bas est encore visible (au-delà du haut de la fenêtre)
            return rect.top <= 100 && rect.bottom > 100;
        });
        
        // Si une section active est trouvée, mettre à jour les liens de navigation
        if (currentSection) {
            const id = currentSection.getAttribute('id');
            navLinks.forEach(link => {
                if (link.getAttribute('href') === '#' + id) {
                    link.classList.add('active');
                } else {
                    link.classList.remove('active');
                }
            });
        }
    }
});