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

  if (!mobileNavToggle || !mobileNav) {
    console.error('Éléments du menu mobile (toggle ou nav) non trouvés pour navigation.js');
    return;
  }

  // Vérifier si l'overlay existe, sinon le créer
  let overlay = document.querySelector('.overlay');
  if (!overlay) {
    overlay = document.createElement('div');
    overlay.className = 'overlay'; // Assurez-vous que cette classe correspond à votre CSS
    document.body.appendChild(overlay);
    console.log('Overlay créé dynamiquement par navigation.js');
  }

  // Fonction pour basculer le menu mobile (inspirée de fix-mobile-menu.js)
  function toggleMobileNav() {
    const isExpanded = mobileNavToggle.getAttribute('aria-expanded') === 'true';

    mobileNavToggle.setAttribute('aria-expanded', String(!isExpanded));
    mobileNav.setAttribute('aria-hidden', String(isExpanded));

    if (isExpanded) {
      mobileNav.classList.remove('active');
      overlay.classList.remove('active');
      document.body.style.overflow = '';

      const bars = mobileNavToggle.querySelectorAll('.bar');
      if (bars.length === 3) {
        bars[0].style.transform = '';
        bars[1].style.opacity = '1'; // Rétablir l'opacité
        bars[2].style.transform = '';
      }
    } else {
      mobileNav.classList.add('active');
      overlay.classList.add('active');
      document.body.style.overflow = 'hidden';

      const bars = mobileNavToggle.querySelectorAll('.bar');
      if (bars.length === 3) {
        bars[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
        bars[1].style.opacity = '0';
        bars[2].style.transform = 'rotate(-45deg) translate(5px, -5px)';
      }
    }
  }

  // Attacher l'événement au bouton de bascule
  // Supprimer d'abord tout écouteur existant pour éviter les doublons si ce script est chargé plusieurs fois
  mobileNavToggle.removeEventListener('click', toggleMobileNav);
  mobileNavToggle.addEventListener('click', toggleMobileNav);

  // Fermer le menu mobile lorsqu'un lien est cliqué
  mobileNav.querySelectorAll('a').forEach(link => {
    link.removeEventListener('click', toggleMobileNavOnLinkClick); // Évite doublons
    link.addEventListener('click', toggleMobileNavOnLinkClick);
  });
  
  function toggleMobileNavOnLinkClick() {
    if (mobileNav.classList.contains('active')) {
        toggleMobileNav();
    }
  }

  // Fermer le menu mobile lorsque l'utilisateur clique sur l'overlay
  overlay.removeEventListener('click', toggleMobileNavOnOverlayClick); // Évite doublons
  overlay.addEventListener('click', toggleMobileNavOnOverlayClick);

  function toggleMobileNavOnOverlayClick() {
    if (mobileNav.classList.contains('active')) {
      toggleMobileNav();
    }
  }

  // Fermer le menu mobile lorsque l'utilisateur appuie sur Échap
  document.removeEventListener('keydown', handleEscKey); // Évite doublons
  document.addEventListener('keydown', handleEscKey);

  function handleEscKey(event) {
    if (event.key === 'Escape' && mobileNav.classList.contains('active')) {
      toggleMobileNav();
    }
  }
  console.log('Navigation mobile initialisée et améliorée par navigation.js');
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