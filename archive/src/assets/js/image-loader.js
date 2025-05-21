/**
 * Script de chargement différé des images
 * Ce script détecte les images avec l'attribut data-high-res et les charge en arrière-plan
 */
document.addEventListener('DOMContentLoaded', function() {
  // Sélectionner toutes les images avec l'attribut data-high-res
  const images = document.querySelectorAll('img[data-high-res]');
  
  // Pour chaque image
  images.forEach(function(img) {
    // Précharger l'image haute résolution
    const highResUrl = img.getAttribute('data-high-res');
    const preloadImage = new Image();
    preloadImage.src = highResUrl;
    
    // Charger l'image haute résolution au survol
    img.addEventListener('mouseenter', function() {
      img.src = highResUrl;
    });
    
    // Charger l'image haute résolution au clic
    img.addEventListener('click', function() {
      img.src = highResUrl;
    });
    
    // Observer l'image pour la charger quand elle devient visible
    const observer = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          img.src = highResUrl;
          observer.unobserve(img);
        }
      });
    });
    
    observer.observe(img);
  });
  
  // Ajouter une galerie modale pour les images
  initImageGallery();
});

/**
 * Initialise une galerie modale pour les images
 */
function initImageGallery() {
  // Créer la modale
  const modal = document.createElement('div');
  modal.className = 'image-modal';
  modal.innerHTML = `
    <div class="image-modal-content">
      <span class="image-modal-close">&times;</span>
      <img class="image-modal-img">
      <div class="image-modal-caption"></div>
    </div>
  `;
  document.body.appendChild(modal);
  
  // Sélectionner les éléments de la modale
  const modalImg = modal.querySelector('.image-modal-img');
  const modalCaption = modal.querySelector('.image-modal-caption');
  const closeBtn = modal.querySelector('.image-modal-close');
  
  // Ajouter un gestionnaire de clic pour fermer la modale
  closeBtn.addEventListener('click', function() {
    modal.style.display = 'none';
  });
  
  // Fermer la modale en cliquant en dehors de l'image
  modal.addEventListener('click', function(event) {
    if (event.target === modal) {
      modal.style.display = 'none';
    }
  });
  
  // Ajouter un gestionnaire de clic pour les images de la galerie
  const galleryImages = document.querySelectorAll('.monde-gallery img');
  galleryImages.forEach(function(img) {
    img.addEventListener('click', function() {
      modal.style.display = 'block';
      modalImg.src = img.getAttribute('data-high-res') || img.src;
      modalCaption.textContent = img.alt;
    });
    
    // Ajouter un style de curseur pour indiquer que l'image est cliquable
    img.style.cursor = 'pointer';
  });
  
  // Ajouter des styles CSS pour la modale
  const style = document.createElement('style');
  style.textContent = `
    .image-modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0, 0, 0, 0.9);
    }
    
    .image-modal-content {
      margin: auto;
      display: block;
      position: relative;
      top: 50%;
      transform: translateY(-50%);
      max-width: 90%;
      max-height: 90%;
    }
    
    .image-modal-img {
      display: block;
      margin: 0 auto;
      max-width: 100%;
      max-height: 80vh;
    }
    
    .image-modal-caption {
      margin: 1rem 0;
      display: block;
      width: 80%;
      max-width: 700px;
      text-align: center;
      color: #ccc;
      padding: 10px 0;
      height: 150px;
      margin: auto;
    }
    
    .image-modal-close {
      position: absolute;
      top: -40px;
      right: 0;
      color: #f1f1f1;
      font-size: 40px;
      font-weight: bold;
      transition: 0.3s;
      cursor: pointer;
    }
    
    .image-modal-close:hover,
    .image-modal-close:focus {
      color: #bbb;
      text-decoration: none;
      cursor: pointer;
    }
    
    @media only screen and (max-width: 700px) {
      .image-modal-content {
        width: 100%;
      }
    }
  `;
  document.head.appendChild(style);
}