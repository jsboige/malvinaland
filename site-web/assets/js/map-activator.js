/**
 * Script d'activation de la carte interactive
 * Ce script s'assure que les zones cliquables de la carte fonctionnent correctement
 */
document.addEventListener('DOMContentLoaded', function() {
  // Sélectionner toutes les cartes d'images
  const maps = document.querySelectorAll('map');
  
  if (maps.length === 0) return;
  
  // Pour chaque carte
  maps.forEach(function(map) {
    // Sélectionner toutes les zones cliquables
    const areas = map.querySelectorAll('area');
    
    // Pour chaque zone cliquable
    areas.forEach(function(area) {
      // Ajouter un gestionnaire d'événements pour le clic
      area.addEventListener('click', function(event) {
        // Empêcher le comportement par défaut
        event.preventDefault();
        
        // Récupérer l'URL de destination
        const href = area.getAttribute('href');
        
        // Rediriger vers l'URL
        if (href) {
          console.log('Navigation vers:', href);
          window.location.href = href;
        }
      });
      
      // Ajouter un gestionnaire d'événements pour le survol
      area.addEventListener('mouseenter', function() {
        // Ajouter un style de curseur pour indiquer que la zone est cliquable
        document.body.style.cursor = 'pointer';
      });
      
      // Ajouter un gestionnaire d'événements pour la fin du survol
      area.addEventListener('mouseleave', function() {
        // Restaurer le style de curseur par défaut
        document.body.style.cursor = '';
      });
    });
  });
  
  // Ajouter un message de débogage
  console.log('Carte interactive activée avec', maps.length, 'cartes et', 
              document.querySelectorAll('area').length, 'zones cliquables');
});