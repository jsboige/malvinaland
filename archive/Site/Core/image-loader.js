/**
 * Script de chargement diffÃ©rÃ© des images
 * Ce script dÃ©tecte les images avec l'attribut data-high-res et les charge en arriÃ¨re-plan
 */
document.addEventListener('DOMContentLoaded', function() {
    // SÃ©lectionner toutes les images avec l'attribut data-high-res
    const images = document.querySelectorAll('img[data-high-res]');
    
    // Pour chaque image
    images.forEach(function(img) {
        // PrÃ©charger l'image haute rÃ©solution
        const highResUrl = img.getAttribute('data-high-res');
        const preloadImage = new Image();
        preloadImage.src = highResUrl;
        
        // Charger l'image haute rÃ©solution au survol
        img.addEventListener('mouseenter', function() {
            img.src = highResUrl;
        });
        
        // Charger l'image haute rÃ©solution au clic
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
});
