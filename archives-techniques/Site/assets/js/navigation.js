/**
 * Script de navigation pour Malvinaland
 * Gère la navigation mobile et desktop
 */

document.addEventListener('DOMContentLoaded', function() {
  // Initialiser la navigation mobile
  initMobileNavigation();
  
  // Ajouter des effets d'animation lors du défilement
  initScrollAnimations();
});

/**
 * Initialise la navigation mobile
 */
function initMobileNavigation() {
  const mobileNavToggle = document.getElementById('mobile-nav-toggle');
  const mobileNav = document.getElementById('mobile-nav');
  
  if (!mobileNavToggle || !mobileNav) return;
  
  mobileNavToggle.addEventListener('click', function() {
    const isExpanded = mobileNavToggle.getAttribute('aria-expanded') === 'true';
    
    // Mettre à jour l'état du bouton
    mobileNavToggle.setAttribute('aria-expanded', !isExpanded);
    
    // Mettre à jour l'état du menu
    mobileNav.setAttribute('aria-hidden', isExpanded);
    
    // Afficher/masquer le menu
    if (isExpanded) {
      mobileNav.classList.remove('active');
      document.body.style.overflow = '';
      
      // Animer les barres du bouton
      mobileNavToggle.querySelectorAll('.bar').forEach(bar => {
        bar.style.transform = '';
      });
    } else {
      mobileNav.classList.add('active');
      document.body.style.overflow = 'hidden'; // Empêcher le défilement du body
      
      // Animer les barres du bouton pour former un X
      const bars = mobileNavToggle.querySelectorAll('.bar');
      bars[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
      bars[1].style.opacity = '0';
      bars[2].style.transform = 'rotate(-45deg) translate(5px, -5px)';
    }
  });
  
  // Fermer le menu mobile lorsqu'un lien est cliqué
  mobileNav.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', function() {
      mobileNavToggle.click();
    });
  });
  
  // Fermer le menu mobile lorsque l'utilisateur clique en dehors
  document.addEventListener('click', function(event) {
    if (mobileNav.classList.contains('active') && 
        !mobileNav.contains(event.target) && 
        !mobileNavToggle.contains(event.target)) {
      mobileNavToggle.click();
    }
  });
}

/**
 * Initialise les animations au défilement
 */
function initScrollAnimations() {
  // Sélectionner tous les éléments à animer
  const sections = document.querySelectorAll('.monde-section, .pnj-card');
  
  // Options pour l'observateur d'intersection
  const observerOptions = {
    root: null,
    rootMargin: '0px',
    threshold: 0.1
  };
  
  // Créer l'observateur d'intersection
  const sectionObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('fade-in');
        observer.unobserve(entry.target);
      }
    });
  }, observerOptions);
  
  // Observer chaque section
  sections.forEach(section => {
    section.style.opacity = '0';
    section.style.transform = 'translateY(20px)';
    section.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
    sectionObserver.observe(section);
  });
}