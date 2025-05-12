/**
 * Navigation commune pour tous les mondes de Malvinha
 * Ce fichier utilise la configuration centralisée des mondes pour générer la navigation
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log('Initialisation de la navigation commune...');
    initCommonNavigation();
});

/**
 * Initialise la navigation commune à tous les mondes
 */
function initCommonNavigation() {
    // Récupérer l'élément de navigation
    const mainNavigation = document.getElementById('main-navigation');
    
    if (!mainNavigation) {
        console.error('Élément de navigation non trouvé');
        return;
    }
    
    // Déterminer le monde actuel à partir de l'URL
    const currentPath = window.location.pathname;
    const currentMonde = getCurrentMonde(currentPath);
    
    // Charger la configuration des mondes
    let mondesConfig = [];
    
    // Vérifier si la configuration est déjà disponible (via script séparé)
    if (typeof MONDES_CONFIG !== 'undefined') {
        mondesConfig = MONDES_CONFIG;
        generateNavigation(mainNavigation, mondesConfig, currentMonde);
    } else {
        // Sinon, charger la configuration dynamiquement
        const configPath = getRelativePath(currentPath, 'Core/mondes-config.js');
        
        // Créer et charger le script
        const script = document.createElement('script');
        script.src = configPath;
        script.onload = () => {
            generateNavigation(mainNavigation, MONDES_CONFIG, currentMonde);
        };
        script.onerror = () => {
            console.error('Erreur lors du chargement de la configuration des mondes');
            // Fallback à une navigation minimale
            generateFallbackNavigation(mainNavigation);
        };
        
        document.head.appendChild(script);
    }
}

/**
 * Génère la navigation à partir de la configuration des mondes
 */
function generateNavigation(navigationElement, mondesConfig, currentMonde) {
    // Vider la navigation existante
    navigationElement.innerHTML = '';
    
    // Ajouter les liens vers les mondes
    mondesConfig.forEach(monde => {
        // Ne pas inclure le monde actuel dans la navigation
        if (monde.id !== currentMonde) {
            const li = document.createElement('li');
            const a = document.createElement('a');
            
            // Déterminer le chemin relatif vers le monde
            const relativePath = getRelativePathToMonde(currentMonde, monde.id);
            
            a.href = relativePath;
            a.textContent = monde.name;
            a.title = monde.description || '';
            
            // Ajouter une classe pour le style spécifique au monde
            a.classList.add(`monde-${monde.id}`);
            
            li.appendChild(a);
            navigationElement.appendChild(li);
        }
    });
    
    // Ajouter un lien vers l'accueil
    const homeLi = document.createElement('li');
    const homeLink = document.createElement('a');
    
    // Déterminer le chemin relatif vers l'accueil
    const homeRelativePath = getRelativePathToHome(currentMonde);
    
    homeLink.href = homeRelativePath;
    homeLink.textContent = '🏠 Accueil';
    homeLink.classList.add('home-link');
    
    homeLi.appendChild(homeLink);
    navigationElement.appendChild(homeLi);
    
    // Ajouter un lien vers la carte
    const mapLi = document.createElement('li');
    const mapLink = document.createElement('a');
    
    // Déterminer le chemin relatif vers la carte
    const mapRelativePath = getRelativePathToMap(currentMonde);
    
    mapLink.href = mapRelativePath;
    mapLink.textContent = '🗺️ Carte';
    mapLink.classList.add('map-link');
    
    mapLi.appendChild(mapLink);
    navigationElement.appendChild(mapLi);
}

/**
 * Génère une navigation de secours minimale en cas d'erreur
 */
function generateFallbackNavigation(navigationElement) {
    navigationElement.innerHTML = `
        <li><a href="../../index.html">🏠 Accueil</a></li>
        <li><a href="../../Mondes/Carte de Malvinaland stylisée.png">🗺️ Carte</a></li>
    `;
}

/**
 * Détermine l'ID du monde actuel à partir du chemin
 */
function getCurrentMonde(path) {
    // Extraire le nom du monde à partir du chemin
    const matches = path.match(/Le monde (de l['a]|du|des)\s*([^\/]+)/i);
    
    if (matches && matches[2]) {
        const mondeName = matches[2].toLowerCase().trim();
        
        // Correspondance entre les noms de dossiers et les IDs
        const nameToId = {
            'assemblée': 'assemblee',
            'grange': 'grange',
            'jeux': 'jeux',
            'rêves': 'reves',
            'damier': 'damier',
            'linge': 'linge',
            'verger': 'verger',
            'zob': 'zob',
            'elysée': 'elysee',
            'karibu': 'karibu',
            'orange des sphinx': 'sphinx'
        };
        
        return nameToId[mondeName] || null;
    }
    
    return null;
}

/**
 * Calcule le chemin relatif entre le monde actuel et un autre monde
 */
function getRelativePathToMonde(currentMonde, targetMonde) {
    if (!currentMonde) {
        // Si on ne peut pas déterminer le monde actuel, utiliser un chemin absolu
        return `Mondes/Le monde ${getMondeFullName(targetMonde)}/index.html`;
    }
    
    // Si on est dans un monde, le chemin vers un autre monde est toujours "../Le monde X/index.html"
    return `../Le monde ${getMondeFullName(targetMonde)}/index.html`;
}

/**
 * Obtient le nom complet du monde à partir de son ID
 */
function getMondeFullName(mondeId) {
    const mondeNames = {
        'assemblee': 'de l\'assemblée',
        'grange': 'de la grange',
        'jeux': 'des jeux',
        'reves': 'des rêves',
        'damier': 'du damier',
        'linge': 'du linge',
        'verger': 'du verger',
        'zob': 'du Zob',
        'elysee': 'Elysée',
        'karibu': 'Karibu',
        'sphinx': 'orange des Sphinx'
    };
    
    return mondeNames[mondeId] || mondeId;
}

/**
 * Calcule le chemin relatif vers l'accueil depuis le monde actuel
 */
function getRelativePathToHome(currentMonde) {
    if (!currentMonde) {
        return 'index.html';
    }
    
    return '../../index.html';
}

/**
 * Calcule le chemin relatif vers la carte depuis le monde actuel
 */
function getRelativePathToMap(currentMonde) {
    if (!currentMonde) {
        return 'Mondes/Carte de Malvinaland stylisée.png';
    }
    
    return '../Carte de Malvinaland stylisée.png';
}

/**
 * Calcule le chemin relatif entre le chemin actuel et une cible
 */
function getRelativePath(currentPath, targetPath) {
    // Simplification : si on est dans un monde, on remonte de deux niveaux
    if (currentPath.includes('/Mondes/Le monde')) {
        return '../../' + targetPath;
    }
    
    // Si on est à la racine
    return targetPath;
}