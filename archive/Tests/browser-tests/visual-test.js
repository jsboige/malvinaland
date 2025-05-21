/**
 * Script de test visuel pour Malvinaland
 * 
 * Ce script utilise Puppeteer pour automatiser les tests visuels du site Malvinaland.
 * Il permet de capturer des captures d'écran à différentes tailles d'écran et de vérifier
 * l'apparence visuelle et l'ergonomie du site.
 */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Configuration des tests
const config = {
  baseUrl: 'file:///d:/Production/malvinaland/Site/Core/index.html',
  screenshotDir: path.join(__dirname, '../reports/screenshots'),
  viewports: [
    { name: 'mobile', width: 375, height: 667 },
    { name: 'tablet', width: 768, height: 1024 },
    { name: 'desktop', width: 1366, height: 768 }
  ],
  pages: [
    { name: 'accueil', path: 'index.html' },
    { name: 'carte', path: 'carte.html' },
    { name: 'monde-assemblee', path: '../Mondes/Le monde de l\'assemblée/index.html' },
    { name: 'monde-jeux', path: '../Mondes/Le monde des jeux/index.html' },
    { name: 'monde-reves', path: '../Mondes/Le monde des rêves/index.html' }
  ]
};

// Créer le dossier de captures d'écran s'il n'existe pas
if (!fs.existsSync(config.screenshotDir)) {
  fs.mkdirSync(config.screenshotDir, { recursive: true });
}

/**
 * Fonction principale pour exécuter les tests visuels
 */
async function runVisualTests() {
  console.log('Démarrage des tests visuels...');
  
  const browser = await puppeteer.launch({
    headless: false,
    defaultViewport: null,
    args: ['--start-maximized']
  });
  
  try {
    // Tester chaque page à chaque taille d'écran
    for (const viewport of config.viewports) {
      console.log(`\nTest avec viewport ${viewport.name} (${viewport.width}x${viewport.height})`);
      
      const page = await browser.newPage();
      await page.setViewport({ width: viewport.width, height: viewport.height });
      
      for (const pageConfig of config.pages) {
        const url = new URL(pageConfig.path, config.baseUrl).href;
        console.log(`  Testing ${pageConfig.name} (${url})`);
        
        // Naviguer vers la page
        await page.goto(url, { waitUntil: 'networkidle2' });
        
        // Attendre que la page soit complètement chargée
        await page.waitForTimeout(1000);
        
        // Capturer une capture d'écran
        const screenshotPath = path.join(
          config.screenshotDir, 
          `${pageConfig.name}-${viewport.name}.png`
        );
        await page.screenshot({ path: screenshotPath, fullPage: true });
        console.log(`    Capture d'écran enregistrée: ${screenshotPath}`);
        
        // Tester l'accessibilité des éléments interactifs
        await testInteractiveElements(page, pageConfig, viewport);
        
        // Tester la navigation mobile si on est en mode mobile
        if (viewport.name === 'mobile') {
          await testMobileNavigation(page, pageConfig);
        }
      }
      
      await page.close();
    }
    
    console.log('\nTests visuels terminés avec succès!');
  } catch (error) {
    console.error('Erreur lors des tests visuels:', error);
  } finally {
    await browser.close();
  }
}

/**
 * Teste les éléments interactifs d'une page
 */
async function testInteractiveElements(page, pageConfig, viewport) {
  console.log(`    Test des éléments interactifs...`);
  
  // Vérifier la taille des éléments interactifs (pour l'ergonomie mobile)
  const interactiveElementsSize = await page.evaluate(() => {
    const elements = Array.from(document.querySelectorAll('a, button, input, select, textarea'));
    return elements.map(el => {
      const rect = el.getBoundingClientRect();
      return {
        tag: el.tagName,
        width: rect.width,
        height: rect.height,
        text: el.textContent.trim().substring(0, 20)
      };
    });
  });
  
  // Vérifier si les éléments interactifs sont assez grands pour le mobile
  if (viewport.name === 'mobile') {
    const tooSmallElements = interactiveElementsSize.filter(
      el => (el.width < 44 || el.height < 44)
    );
    
    if (tooSmallElements.length > 0) {
      console.log(`    ⚠️ Éléments trop petits pour une utilisation mobile (< 44px):`);
      tooSmallElements.forEach(el => {
        console.log(`      - ${el.tag}: "${el.text}" (${el.width}x${el.height}px)`);
      });
    }
  }
}

/**
 * Teste la navigation mobile
 */
async function testMobileNavigation(page, pageConfig) {
  console.log(`    Test de la navigation mobile...`);
  
  try {
    // Vérifier si le bouton de menu mobile existe
    const mobileMenuButton = await page.$('#mobile-nav-toggle');
    
    if (mobileMenuButton) {
      // Cliquer sur le bouton de menu mobile
      await mobileMenuButton.click();
      await page.waitForTimeout(500);
      
      // Capturer une capture d'écran avec le menu ouvert
      const screenshotPath = path.join(
        config.screenshotDir, 
        `${pageConfig.name}-mobile-menu-open.png`
      );
      await page.screenshot({ path: screenshotPath });
      console.log(`    Capture d'écran du menu mobile: ${screenshotPath}`);
      
      // Vérifier si les liens du menu sont visibles et assez grands
      const menuLinks = await page.evaluate(() => {
        const links = Array.from(document.querySelectorAll('#mobile-nav a'));
        return links.map(link => {
          const rect = link.getBoundingClientRect();
          return {
            text: link.textContent.trim(),
            width: rect.width,
            height: rect.height,
            visible: rect.width > 0 && rect.height > 0
          };
        });
      });
      
      const invisibleLinks = menuLinks.filter(link => !link.visible);
      if (invisibleLinks.length > 0) {
        console.log(`    ⚠️ Liens de menu mobile non visibles:`);
        invisibleLinks.forEach(link => {
          console.log(`      - "${link.text}"`);
        });
      }
      
      // Fermer le menu mobile
      await mobileMenuButton.click();
      await page.waitForTimeout(500);
    } else {
      console.log(`    ⚠️ Bouton de menu mobile non trouvé`);
    }
  } catch (error) {
    console.error(`    Erreur lors du test de navigation mobile:`, error);
  }
}

// Exécuter les tests si ce script est exécuté directement
if (require.main === module) {
  runVisualTests();
}

module.exports = { runVisualTests };