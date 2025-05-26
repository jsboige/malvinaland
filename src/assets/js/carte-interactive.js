/**
 * Script pour la carte interactive améliorée de Malvinaland
 * Ajoute des effets visuels, des tooltips et une meilleure interactivité
 */

document.addEventListener('DOMContentLoaded', function() {
    const carteImage = document.getElementById('carte-interactive');
    const map = document.querySelector('map[name="carte-map"]');
    const areas = document.querySelectorAll('map[name="carte-map"] area');
    
    if (!carteImage || !map || areas.length === 0) {
        console.log('Carte interactive : éléments non trouvés');
        return;
    }
    
    // Créer un overlay pour les effets visuels
    const overlay = document.createElement('div');
    overlay.className = 'carte-overlay';
    overlay.style.cssText = `
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        pointer-events: none;
        z-index: 10;
    `;
    carteImage.parentElement.appendChild(overlay);
    
    // Créer un tooltip
    const tooltip = document.createElement('div');
    tooltip.className = 'carte-tooltip';
    tooltip.style.cssText = `
        position: absolute;
        background: linear-gradient(135deg, #3f51b5, #5c6bc0);
        color: white;
        padding: 8px 12px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 500;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        pointer-events: none;
        opacity: 0;
        transform: translateY(-10px);
        transition: all 0.3s ease;
        z-index: 20;
        white-space: nowrap;
    `;
    document.body.appendChild(tooltip);
    
    // Fonction pour créer un effet de surbrillance
    function createHighlight(area) {
        const highlight = document.createElement('div');
        const coords = area.getAttribute('coords').split(',').map(Number);
        const shape = area.getAttribute('shape');
        
        let style = `
            position: absolute;
            pointer-events: none;
            background: rgba(63, 81, 181, 0.2);
            border: 2px solid #3f51b5;
            border-radius: 8px;
            opacity: 0;
            transition: all 0.3s ease;
            z-index: 5;
        `;
        
        if (shape === 'rect') {
            const [x1, y1, x2, y2] = coords;
            const rect = carteImage.getBoundingClientRect();
            const scaleX = rect.width / carteImage.naturalWidth;
            const scaleY = rect.height / carteImage.naturalHeight;
            
            style += `
                left: ${x1 * scaleX}px;
                top: ${y1 * scaleY}px;
                width: ${(x2 - x1) * scaleX}px;
                height: ${(y2 - y1) * scaleY}px;
            `;
        } else if (shape === 'circle') {
            const [cx, cy, r] = coords;
            const rect = carteImage.getBoundingClientRect();
            const scaleX = rect.width / carteImage.naturalWidth;
            const scaleY = rect.height / carteImage.naturalHeight;
            
            style += `
                left: ${(cx - r) * scaleX}px;
                top: ${(cy - r) * scaleY}px;
                width: ${r * 2 * scaleX}px;
                height: ${r * 2 * scaleY}px;
                border-radius: 50%;
            `;
        }
        
        highlight.style.cssText = style;
        return highlight;
    }
    
    // Ajouter les gestionnaires d'événements pour chaque zone
    areas.forEach(function(area) {
        const highlight = createHighlight(area);
        overlay.appendChild(highlight);
        
        // Événement de survol
        area.addEventListener('mouseenter', function(e) {
            // Afficher la surbrillance
            highlight.style.opacity = '1';
            highlight.style.transform = 'scale(1.05)';
            
            // Afficher le tooltip
            const title = area.getAttribute('title');
            if (title) {
                tooltip.textContent = title;
                tooltip.style.opacity = '1';
                tooltip.style.transform = 'translateY(0)';
            }
            
            // Changer le curseur
            carteImage.style.cursor = 'pointer';
            
            // Ajouter un effet de pulsation à l'image
            carteImage.style.filter = 'brightness(1.1)';
        });
        
        // Événement de fin de survol
        area.addEventListener('mouseleave', function() {
            // Masquer la surbrillance
            highlight.style.opacity = '0';
            highlight.style.transform = 'scale(1)';
            
            // Masquer le tooltip
            tooltip.style.opacity = '0';
            tooltip.style.transform = 'translateY(-10px)';
            
            // Restaurer le curseur
            carteImage.style.cursor = '';
            
            // Restaurer l'effet sur l'image
            carteImage.style.filter = '';
        });
        
        // Événement de mouvement de la souris pour le tooltip
        area.addEventListener('mousemove', function(e) {
            tooltip.style.left = (e.pageX + 10) + 'px';
            tooltip.style.top = (e.pageY - 40) + 'px';
        });
        
        // Événement de clic avec effet
        area.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Effet de clic
            highlight.style.background = 'rgba(63, 81, 181, 0.4)';
            highlight.style.transform = 'scale(0.95)';
            
            setTimeout(() => {
                highlight.style.background = 'rgba(63, 81, 181, 0.2)';
                highlight.style.transform = 'scale(1.05)';
            }, 150);
            
            // Navigation avec délai pour l'effet
            const href = area.getAttribute('href');
            if (href) {
                setTimeout(() => {
                    window.location.href = href;
                }, 300);
            }
        });
    });
    
    // Redimensionnement responsive
    function updateHighlights() {
        areas.forEach(function(area, index) {
            const highlight = overlay.children[index];
            if (highlight) {
                const coords = area.getAttribute('coords').split(',').map(Number);
                const shape = area.getAttribute('shape');
                const rect = carteImage.getBoundingClientRect();
                const scaleX = rect.width / carteImage.naturalWidth;
                const scaleY = rect.height / carteImage.naturalHeight;
                
                if (shape === 'rect') {
                    const [x1, y1, x2, y2] = coords;
                    highlight.style.left = `${x1 * scaleX}px`;
                    highlight.style.top = `${y1 * scaleY}px`;
                    highlight.style.width = `${(x2 - x1) * scaleX}px`;
                    highlight.style.height = `${(y2 - y1) * scaleY}px`;
                } else if (shape === 'circle') {
                    const [cx, cy, r] = coords;
                    highlight.style.left = `${(cx - r) * scaleX}px`;
                    highlight.style.top = `${(cy - r) * scaleY}px`;
                    highlight.style.width = `${r * 2 * scaleX}px`;
                    highlight.style.height = `${r * 2 * scaleY}px`;
                }
            }
        });
    }
    
    // Écouter les redimensionnements
    window.addEventListener('resize', updateHighlights);
    carteImage.addEventListener('load', updateHighlights);
    
    // Animation d'introduction
    setTimeout(() => {
        carteImage.style.opacity = '1';
        carteImage.style.transform = 'scale(1)';
    }, 100);
    
    console.log('Carte interactive améliorée activée avec', areas.length, 'zones cliquables');
});