/**
 * Script de test du mode hors ligne pour Malvinaland
 * 
 * Ce script teste le fonctionnement du service worker et la disponibilité
 * du site en mode hors ligne.
 */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Configuration des tests
const config = {
  baseUrl: 'file:///d:/Production/malvinaland/Site/Core/index.html',
  screenshotDir: path.join(__dirname, '../reports/offline-tests'),
  pages: [
    { name: 'accueil', path: 'index.html' },
    { name: 'carte', path: 'carte.html' },
    { name: 'monde-assemblee', path: '../Mondes/Le monde de l\'assemblée/index.html' },
    { name: 'monde-jeux', path: '../Mondes/Le monde des jeux/index.html' }
  ]
};

// Créer le dossier de captures d'écran s'il n'existe pas
if (!fs.existsSync(config.screenshotDir)) {
  fs.mkdirSync(config.screenshotDir, { recursive: true });
}

/**
 * Fonction principale pour tester le mode hors ligne
 */
async function testOfflineMode() {
  console.log('Démarrage des tests du mode hors ligne...');
  
  const browser = await puppeteer.launch({
    headless: false,
    defaultViewport: null,
    args: ['--start-maximized']
  });
  
  try {
    // Première étape : visiter les pages en mode connecté pour les mettre en cache
    console.log('\n1. Visite des pages en mode connecté pour mise en cache');
    const page = await browser.newPage();
    
    // Activer la journalisation de la console
    page.on('console', msg => console.log('Console du navigateur:', msg.text()));
    
    // Surveiller l'installation du service worker
    let serviceWorkerInstalled = false;
    page.on('console', msg => {
      if (msg.text().includes('Service Worker enregistré avec succès')) {
        serviceWorkerInstalled = true;
      }
    });
    
    // Visiter chaque page pour la mettre en cache
    for (const pageConfig of config.pages) {
      const url = new URL(pageConfig.path, config.baseUrl).href;
      console.log(`  Visite de ${pageConfig.name} (${url})`);
      
      await page.goto(url, { waitUntil: 'networkidle2' });
      await page.waitForTimeout(2000); // Attendre que le service worker ait le temps de mettre en cache
      
      // Capturer une capture d'écran en mode connecté
      const screenshotPath = path.join(
        config.screenshotDir, 
        `${pageConfig.name}-online.png`
      );
      await page.screenshot({ path: screenshotPath, fullPage: true });
      console.log(`    Capture d'écran en mode connecté: ${screenshotPath}`);
    }
    
    // Vérifier si le service worker a été installé
    if (serviceWorkerInstalled) {
      console.log('✅ Service worker installé avec succès');
    } else {
      console.log('⚠️ Aucune confirmation d\'installation du service worker détectée');
    }
    
    // Deuxième étape : passer en mode hors ligne et tester à nouveau
    console.log('\n2. Test des pages en mode hors ligne');
    
    // Activer le mode hors ligne
    await page.setOfflineMode(true);
    console.log('  Mode hors ligne activé');
    
    // Visiter chaque page en mode hors ligne
    for (const pageConfig of config.pages) {
      const url = new URL(pageConfig.path, config.baseUrl).href;
      console.log(`  Test de ${pageConfig.name} en mode hors ligne (${url})`);
      
      try {
        await page.goto(url, { waitUntil: 'networkidle2', timeout: 10000 });
        
        // Vérifier si la page est chargée correctement
        const pageTitle = await page.title();
        console.log(`    Titre de la page: ${pageTitle}`);
        
        // Capturer une capture d'écran en mode hors ligne
        const screenshotPath = path.join(
          config.screenshotDir, 
          `${pageConfig.name}-offline.png`
        );
        await page.screenshot({ path: screenshotPath, fullPage: true });
        console.log(`    Capture d'écran en mode hors ligne: ${screenshotPath}`);
        
        // Vérifier si le contenu principal est présent
        const mainContent = await page.evaluate(() => {
          const main = document.querySelector('main');
          return main ? main.innerText : null;
        });
        
        if (mainContent) {
          console.log(`    ✅ Contenu principal chargé en mode hors ligne`);
        } else {
          console.log(`    ❌ Contenu principal non disponible en mode hors ligne`);
        }
        
        // Vérifier si les images sont chargées
        const imagesStatus = await page.evaluate(() => {
          const images = Array.from(document.querySelectorAll('img'));
          const loadedImages = images.filter(img => img.complete && img.naturalHeight !== 0);
          return {
            total: images.length,
            loaded: loadedImages.length
          };
        });
        
        console.log(`    Images: ${imagesStatus.loaded}/${imagesStatus.total} chargées`);
        
        // Vérifier si les scripts sont exécutés
        const scriptsExecuted = await page.evaluate(() => {
          // Vérifier si une fonction globale du site est disponible
          return typeof window.activateEternalFlame === 'function';
        });
        
        if (scriptsExecuted) {
          console.log(`    ✅ Scripts JavaScript exécutés en mode hors ligne`);
        } else {
          console.log(`    ⚠️ Certains scripts JavaScript pourraient ne pas être exécutés`);
        }
        
      } catch (error) {
        console.error(`    ❌ Erreur lors du chargement de la page en mode hors ligne:`, error.message);
        
        // Capturer une capture d'écran de l'erreur
        const errorScreenshotPath = path.join(
          config.screenshotDir, 
          `${pageConfig.name}-offline-error.png`
        );
        await page.screenshot({ path: errorScreenshotPath, fullPage: true });
        console.log(`    Capture d'écran de l'erreur: ${errorScreenshotPath}`);
      }
    }
    
    // Troisième étape : revenir en mode connecté et vérifier la mise à jour du cache
    console.log('\n3. Test de mise à jour du cache après reconnexion');
    
    // Désactiver le mode hors ligne
    await page.setOfflineMode(false);
    console.log('  Mode connecté restauré');
    
    // Visiter la page d'accueil
    const homeUrl = new URL('index.html', config.baseUrl).href;
    console.log(`  Visite de la page d'accueil (${homeUrl})`);
    
    await page.goto(homeUrl, { waitUntil: 'networkidle2' });
    await page.waitForTimeout(2000);
    
    // Capturer une capture d'écran après reconnexion
    const reconnectScreenshotPath = path.join(
      config.screenshotDir, 
      `accueil-reconnected.png`
    );
    await page.screenshot({ path: reconnectScreenshotPath, fullPage: true });
    console.log(`    Capture d'écran après reconnexion: ${reconnectScreenshotPath}`);
    
    console.log('\nTests du mode hors ligne terminés avec succès!');
    
    // Générer un rapport de test
    generateOfflineTestReport();
    
  } catch (error) {
    console.error('Erreur lors des tests du mode hors ligne:', error);
  } finally {
    await browser.close();
  }
}

/**
 * Génère un rapport HTML des tests du mode hors ligne
 */
function generateOfflineTestReport() {
  const reportPath = path.join(config.screenshotDir, 'offline-test-report.html');
  
  // Trouver toutes les captures d'écran
  const screenshots = fs.readdirSync(config.screenshotDir)
    .filter(file => file.endsWith('.png'))
    .map(file => path.join('offline-tests', file));
  
  // Regrouper les captures d'écran par page
  const screenshotsByPage = {};
  
  for (const screenshot of screenshots) {
    const filename = path.basename(screenshot);
    const pageName = filename.split('-')[0];
    
    if (!screenshotsByPage[pageName]) {
      screenshotsByPage[pageName] = [];
    }
    
    screenshotsByPage[pageName].push({
      path: screenshot,
      type: filename.includes('-online') ? 'online' : 
            filename.includes('-offline-error') ? 'error' : 'offline'
    });
  }
  
  // Créer le contenu HTML
  let html = `
    <!DOCTYPE html>
    <html lang="fr">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Rapport de test du mode hors ligne - Malvinaland</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          line-height: 1.6;
          max-width: 1200px;
          margin: 0 auto;
          padding: 20px;
          color: #333;
        }
        h1, h2, h3 {
          color: #3f51b5;
        }
        .page-section {
          background-color: white;
          padding: 20px;
          border-radius: 5px;
          margin-bottom: 20px;
          box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .screenshot-comparison {
          display: flex;
          flex-wrap: wrap;
          gap: 20px;
          margin-top: 20px;
        }
        .screenshot-item {
          flex: 1;
          min-width: 300px;
          border: 1px solid #ddd;
          border-radius: 5px;
          overflow: hidden;
        }
        .screenshot-image {
          width: 100%;
          height: auto;
          display: block;
        }
        .screenshot-caption {
          padding: 10px;
          background-color: #f5f5f5;
          margin: 0;
          font-size: 0.9em;
          text-align: center;
        }
        .online {
          border-color: #4caf50;
        }
        .online .screenshot-caption {
          background-color: #e8f5e9;
          color: #2e7d32;
        }
        .offline {
          border-color: #2196f3;
        }
        .offline .screenshot-caption {
          background-color: #e3f2fd;
          color: #0d47a1;
        }
        .error {
          border-color: #f44336;
        }
        .error .screenshot-caption {
          background-color: #ffebee;
          color: #c62828;
        }
        .recommendations {
          background-color: #e8f5e9;
          padding: 15px;
          border-radius: 5px;
          margin-top: 20px;
        }
        .recommendations h3 {
          color: #2e7d32;
          margin-top: 0;
        }
      </style>
    </head>
    <body>
      <h1>Rapport de test du mode hors ligne - Malvinaland</h1>
      <p>Généré le ${new Date().toLocaleString()}</p>
      
      <div class="page-section">
        <h2>Résumé</h2>
        <p>Ce rapport présente les résultats des tests du mode hors ligne pour le site Malvinaland.</p>
        
        <div class="recommendations">
          <h3>Recommandations pour le mode hors ligne</h3>
          <ul>
            <li>Ajouter une notification visible indiquant à l'utilisateur qu'il est en mode hors ligne</li>
            <li>Optimiser la mise en cache des images pour améliorer l'expérience hors ligne</li>
            <li>Mettre en place une stratégie de mise à jour du cache plus efficace</li>
            <li>Ajouter une page d'erreur personnalisée pour les ressources non disponibles hors ligne</li>
          </ul>
        </div>
      </div>
  `;
  
  // Ajouter une section pour chaque page
  for (const [pageName, screenshots] of Object.entries(screenshotsByPage)) {
    html += `
      <div class="page-section">
        <h2>Page: ${pageName}</h2>
        
        <div class="screenshot-comparison">
    `;
    
    // Trier les captures d'écran par type
    const sortedScreenshots = [...screenshots].sort((a, b) => {
      const order = { online: 1, offline: 2, error: 3 };
      return order[a.type] - order[b.type];
    });
    
    // Ajouter chaque capture d'écran
    for (const screenshot of sortedScreenshots) {
      const caption = screenshot.type === 'online' ? 'Mode connecté' : 
                     screenshot.type === 'error' ? 'Erreur en mode hors ligne' : 'Mode hors ligne';
      
      html += `
        <div class="screenshot-item ${screenshot.type}">
          <img src="../${screenshot.path}" alt="${caption}" class="screenshot-image">
          <p class="screenshot-caption">${caption}</p>
        </div>
      `;
    }
    
    html += `
        </div>
      </div>
    `;
  }
  
  html += `
    </body>
    </html>
  `;
  
  fs.writeFileSync(reportPath, html);
  console.log(`Rapport de test du mode hors ligne généré: ${reportPath}`);
}

// Exécuter les tests si ce script est exécuté directement
if (require.main === module) {
  testOfflineMode();
}

module.exports = { testOfflineMode };