/**
 * Script de correction pour le menu mobile de Malvinaland
 * Ce script vérifie et corrige les problèmes potentiels avec le menu mobile
 */

document.addEventListener('DOMContentLoaded', function() {
  // Vérifier si les éléments du menu mobile existent
  const mobileNavToggle = document.getElementById('mobile-nav-toggle');
  const mobileNav = document.getElementById('mobile-nav');
  
  if (!mobileNavToggle || !mobileNav) {
    console.error('Éléments du menu mobile non trouvés');
    return;
  }
  
  // Vérifier si l'overlay existe, sinon le créer
  let overlay = document.querySelector('.overlay');
  if (!overlay) {
    overlay = document.createElement('div');
    overlay.className = 'overlay';
    document.body.appendChild(overlay);
    console.log('Overlay créé pour le menu mobile');
  }
  
  // Fonction pour basculer le menu mobile
  function toggleMobileNav() {
    const isExpanded = mobileNavToggle.getAttribute('aria-expanded') === 'true';
    
    // Mettre à jour l'état du bouton
    mobileNavToggle.setAttribute('aria-expanded', !isExpanded);
    
    // Mettre à jour l'état du menu
    mobileNav.setAttribute('aria-hidden', isExpanded);
    
    // Afficher/masquer le menu et l'overlay
    if (isExpanded) {
      mobileNav.classList.remove('active');
      overlay.classList.remove('active');
      document.body.style.overflow = '';
      
      // Animer les barres du bouton
      const bars = mobileNavToggle.querySelectorAll('.bar');
      if (bars.length === 3) {
        bars[0].style.transform = '';
        bars[1].style.opacity = '';
        bars[2].style.transform = '';
      }
    } else {
      mobileNav.classList.add('active');
      overlay.classList.add('active');
      document.body.style.overflow = 'hidden'; // Empêcher le défilement du body
      
      // Animer les barres du bouton pour former un X
      const bars = mobileNavToggle.querySelectorAll('.bar');
      if (bars.length === 3) {
        bars[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
        bars[1].style.opacity = '0';
        bars[2].style.transform = 'rotate(-45deg) translate(5px, -5px)';
      }
    }
  }
  
  // Remplacer les gestionnaires d'événements existants
  mobileNavToggle.removeEventListener('click', toggleMobileNav);
  mobileNavToggle.addEventListener('click', toggleMobileNav);
  
  // Fermer le menu mobile lorsqu'un lien est cliqué
  mobileNav.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', function() {
      toggleMobileNav();
    });
  });
  
  // Fermer le menu mobile lorsque l'utilisateur clique sur l'overlay
  overlay.addEventListener('click', function() {
    if (mobileNav.classList.contains('active')) {
      toggleMobileNav();
    }
  });
  
  // Fermer le menu mobile lorsque l'utilisateur appuie sur Échap
  document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape' && mobileNav.classList.contains('active')) {
      toggleMobileNav();
    }
  });
  
  console.log('Correction du menu mobile appliquée');
});