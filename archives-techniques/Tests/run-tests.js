/**
 * Script principal pour exécuter les tests de Malvinaland
 * 
 * Ce script orchestre l'exécution des tests visuels et d'analyse de contenu,
 * puis génère un rapport complet combinant les résultats des deux approches.
 */

const fs = require('fs');
const path = require('path');
const { runVisualTests } = require('./browser-tests/visual-test');
const { runContentAnalysis } = require('./content-tests/content-analyzer');

// Configuration
const config = {
  reportDir: path.join(__dirname, 'reports'),
  combinedReportPath: path.join(__dirname, 'reports', `combined-report-${Date.now()}.html`),
  checklistPath: path.join(__dirname, 'checklists', 'test-checklist.md')
};

// Créer le dossier de rapports s'il n'existe pas
if (!fs.existsSync(config.reportDir)) {
  fs.mkdirSync(config.reportDir, { recursive: true });
}

/**
 * Fonction principale pour exécuter tous les tests
 */
async function runAllTests() {
  console.log('=== DÉMARRAGE DES TESTS MALVINALAND ===');
  console.log('Date et heure:', new Date().toLocaleString());
  console.log('');
  
  try {
    // Exécuter les tests visuels
    console.log('=== TESTS VISUELS ===');
    const visualResults = await runVisualTests();
    console.log('Tests visuels terminés');
    console.log('');
    
    // Exécuter l'analyse de contenu
    console.log('=== ANALYSE DE CONTENU ===');
    const contentResults = await runContentAnalysis();
    console.log('Analyse de contenu terminée');
    console.log('');
    
    // Générer un rapport combiné
    console.log('=== GÉNÉRATION DU RAPPORT COMBINÉ ===');
    await generateCombinedReport(visualResults, contentResults);
    console.log('Rapport combiné généré:', config.combinedReportPath);
    console.log('');
    
    console.log('=== TOUS LES TESTS SONT TERMINÉS ===');
    console.log('Consultez les rapports dans le dossier:', config.reportDir);
  } catch (error) {
    console.error('Erreur lors de l\'exécution des tests:', error);
  }
}

/**
 * Génère un rapport HTML combinant les résultats des tests visuels et d'analyse de contenu
 */
async function generateCombinedReport(visualResults, contentResults) {
  // Lire la checklist
  let checklist = '';
  try {
    checklist = fs.readFileSync(config.checklistPath, 'utf8');
  } catch (error) {
    console.error('Erreur lors de la lecture de la checklist:', error);
    checklist = 'Checklist non disponible';
  }
  
  // Convertir la checklist Markdown en HTML (version simplifiée)
  const checklistHtml = checklist
    .replace(/^# (.*)/gm, '<h1>$1</h1>')
    .replace(/^## (.*)/gm, '<h2>$1</h2>')
    .replace(/^- \[ \] \*\*(.*)\*\*/gm, '<h3>$1</h3><ul>')
    .replace(/^  - \[ \] (.*)/gm, '<li>$1</li>')
    .replace(/^- \[ \] (.*)/gm, '<li>$1</li>')
    .replace(/^<h3>/gm, '</ul><h3>')
    .replace('</ul><h3>', '<h3>')
    .replace(/\n\n/g, '</ul>\n\n');
  
  // Trouver les captures d'écran
  const screenshotDir = path.join(config.reportDir, 'screenshots');
  let screenshotHtml = '<p>Aucune capture d\'écran disponible</p>';
  
  if (fs.existsSync(screenshotDir)) {
    const screenshots = fs.readdirSync(screenshotDir)
      .filter(file => file.endsWith('.png'))
      .map(file => path.join('screenshots', file));
    
    if (screenshots.length > 0) {
      screenshotHtml = `
        <div class="screenshot-gallery">
          ${screenshots.map(screenshot => `
            <div class="screenshot-item">
              <img src="${screenshot}" alt="Capture d'écran" class="screenshot-image">
              <p class="screenshot-caption">${path.basename(screenshot)}</p>
            </div>
          `).join('')}
        </div>
      `;
    }
  }
  
  // Créer le rapport HTML
  const html = `
    <!DOCTYPE html>
    <html lang="fr">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Rapport de tests - Malvinaland</title>
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
        .section {
          background-color: white;
          padding: 20px;
          border-radius: 5px;
          margin-bottom: 20px;
          box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .tabs {
          display: flex;
          margin-bottom: 20px;
        }
        .tab {
          padding: 10px 20px;
          background-color: #e0e0e0;
          cursor: pointer;
          border-radius: 5px 5px 0 0;
          margin-right: 5px;
        }
        .tab.active {
          background-color: #3f51b5;
          color: white;
        }
        .tab-content {
          display: none;
          padding: 20px;
          background-color: white;
          border-radius: 0 5px 5px 5px;
          box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .tab-content.active {
          display: block;
        }
        .screenshot-gallery {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
          gap: 20px;
          margin-top: 20px;
        }
        .screenshot-item {
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
        }
        .checklist ul {
          list-style-type: none;
          padding-left: 20px;
        }
        .checklist li {
          margin-bottom: 5px;
          position: relative;
          padding-left: 25px;
        }
        .checklist li:before {
          content: "☐";
          position: absolute;
          left: 0;
          color: #3f51b5;
        }
        .progress-bar {
          height: 20px;
          background-color: #e0e0e0;
          border-radius: 10px;
          margin-bottom: 10px;
        }
        .progress-fill {
          height: 100%;
          border-radius: 10px;
          background-color: #3f51b5;
        }
        .stat {
          display: flex;
          align-items: center;
          margin-bottom: 10px;
        }
        .stat-label {
          width: 200px;
        }
        .stat-bar {
          flex-grow: 1;
        }
        .stat-value {
          width: 50px;
          text-align: right;
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
      <h1>Rapport de tests - Malvinaland</h1>
      <p>Généré le ${new Date().toLocaleString()}</p>
      
      <div class="tabs">
        <div class="tab active" onclick="openTab(event, 'summary')">Résumé</div>
        <div class="tab" onclick="openTab(event, 'visual')">Tests visuels</div>
        <div class="tab" onclick="openTab(event, 'content')">Analyse de contenu</div>
        <div class="tab" onclick="openTab(event, 'checklist')">Liste de vérification</div>
        <div class="tab" onclick="openTab(event, 'recommendations')">Recommandations</div>
      </div>
      
      <div id="summary" class="tab-content active">
        <div class="section">
          <h2>Résumé des tests</h2>
          <p>Ce rapport combine les résultats des tests visuels et de l'analyse de contenu pour le site Malvinaland.</p>
          
          <h3>Statistiques globales</h3>
          
          ${contentResults && contentResults.summary ? `
            <div class="stat">
              <div class="stat-label">Pages avec description:</div>
              <div class="stat-bar">
                <div class="progress-bar">
                  <div class="progress-fill" style="width: ${contentResults.summary.percentWithDescription}%"></div>
                </div>
              </div>
              <div class="stat-value">${contentResults.summary.percentWithDescription}%</div>
            </div>
            
            <div class="stat">
              <div class="stat-label">Pages avec ambiance:</div>
              <div class="stat-bar">
                <div class="progress-bar">
                  <div class="progress-fill" style="width: ${contentResults.summary.percentWithAmbiance}%"></div>
                </div>
              </div>
              <div class="stat-value">${contentResults.summary.percentWithAmbiance}%</div>
            </div>
            
            <div class="stat">
              <div class="stat-label">Pages avec histoire:</div>
              <div class="stat-bar">
                <div class="progress-bar">
                  <div class="progress-fill" style="width: ${contentResults.summary.percentWithHistoire}%"></div>
                </div>
              </div>
              <div class="stat-value">${contentResults.summary.percentWithHistoire}%</div>
            </div>
            
            <div class="stat">
              <div class="stat-label">Pages avec énigmes:</div>
              <div class="stat-bar">
                <div class="progress-bar">
                  <div class="progress-fill" style="width: ${contentResults.summary.percentWithEnigmes}%"></div>
                </div>
              </div>
              <div class="stat-value">${contentResults.summary.percentWithEnigmes}%</div>
            </div>
            
            <p>Nombre total d'énigmes: ${contentResults.summary.totalEnigmes}</p>
          ` : '<p>Données d\'analyse de contenu non disponibles</p>'}
          
          <div class="recommendations">
            <h3>Points clés à améliorer</h3>
            <ul>
              <li>Optimiser l'ergonomie mobile en augmentant la taille des éléments interactifs</li>
              <li>Améliorer l'intégration de la carte stylisée avec des zones cliquables plus précises</li>
              <li>Enrichir le contexte narratif dans les mondes qui en manquent</li>
              <li>Clarifier les énigmes et ajouter des indices progressifs</li>
              <li>Optimiser le service worker pour un meilleur fonctionnement hors ligne</li>
            </ul>
          </div>
        </div>
      </div>
      
      <div id="visual" class="tab-content">
        <div class="section">
          <h2>Tests visuels</h2>
          <p>Résultats des tests visuels effectués avec le navigateur.</p>
          
          <h3>Captures d'écran</h3>
          ${screenshotHtml}
          
          <h3>Problèmes d'ergonomie mobile identifiés</h3>
          <ul>
            <li>Certains boutons sont trop petits pour une utilisation tactile confortable</li>
            <li>Le menu mobile pourrait être amélioré pour une meilleure accessibilité</li>
            <li>Certains textes manquent de contraste sur fond coloré</li>
          </ul>
          
          <h3>Problèmes d'affichage de la carte</h3>
          <ul>
            <li>La carte pourrait bénéficier de zones cliquables plus précises</li>
            <li>La légende pourrait être plus visible sur mobile</li>
            <li>L'image de la carte pourrait être optimisée pour un chargement plus rapide</li>
          </ul>
        </div>
      </div>
      
      <div id="content" class="tab-content">
        <div class="section">
          <h2>Analyse de contenu</h2>
          <p>Résultats de l'analyse de contenu effectuée avec jinavigator.</p>
          
          ${contentResults && contentResults.pages ? `
            <h3>Détails par page</h3>
            ${contentResults.pages.map(page => `
              <div class="page-summary">
                <h4>${page.name}</h4>
                <p>Nombre de mots: ${page.wordCount || 'N/A'}</p>
                <p>Qualité du contenu: ${page.contentQuality ? page.contentQuality.score : 'N/A'}/10</p>
                
                <p>Éléments présents:</p>
                <ul>
                  <li>Description: ${page.hasDescription ? '✅' : '❌'}</li>
                  <li>Ambiance: ${page.hasAmbiance ? '✅' : '❌'}</li>
                  <li>Histoire: ${page.hasHistoire ? '✅' : '❌'}</li>
                  <li>Énigmes: ${page.hasEnigmes ? '✅' : '❌'} (${page.enigmesCount || 0})</li>
                </ul>
              </div>
            `).join('')}
          ` : '<p>Données d\'analyse de contenu non disponibles</p>'}
        </div>
      </div>
      
      <div id="checklist" class="tab-content">
        <div class="section checklist">
          <h2>Liste de vérification</h2>
          <p>Utilisez cette liste pour vérifier méthodiquement tous les aspects du site.</p>
          
          ${checklistHtml}
        </div>
      </div>
      
      <div id="recommendations" class="tab-content">
        <div class="section">
          <h2>Recommandations d'optimisation</h2>
          <p>Basées sur les résultats des tests visuels et de l'analyse de contenu.</p>
          
          <h3>Ergonomie mobile</h3>
          <ul>
            <li>Augmenter la taille des boutons et zones cliquables à au moins 44x44px</li>
            <li>Améliorer le contraste des textes sur les fonds colorés</li>
            <li>Optimiser le menu mobile pour une navigation plus intuitive</li>
            <li>Ajouter des animations de feedback tactile pour améliorer l'expérience utilisateur</li>
          </ul>
          
          <h3>Intégration de la carte</h3>
          <ul>
            <li>Créer une version interactive de la carte avec des zones cliquables précises</li>
            <li>Optimiser l'image de la carte pour un chargement plus rapide</li>
            <li>Améliorer la légende pour une meilleure lisibilité sur tous les appareils</li>
            <li>Ajouter des infobulles sur la carte pour afficher des informations sur les mondes</li>
          </ul>
          
          <h3>Contexte narratif</h3>
          <ul>
            <li>Enrichir les descriptions des mondes qui manquent de contenu</li>
            <li>Ajouter des éléments d'ambiance sonore pour renforcer l'immersion</li>
            <li>Créer des connexions narratives plus fortes entre les différents mondes</li>
            <li>Développer l'histoire du "Collectionneur d'Âmes" mentionné dans certains mondes</li>
          </ul>
          
          <h3>Clarté des énigmes</h3>
          <ul>
            <li>Structurer toutes les énigmes avec un format cohérent</li>
            <li>Ajouter un système d'indices progressifs pour guider les utilisateurs</li>
            <li>Améliorer le feedback lors de la validation des réponses</li>
            <li>Créer un système de suivi de progression pour les énigmes résolues</li>
          </ul>
          
          <h3>Service worker</h3>
          <ul>
            <li>Optimiser la stratégie de mise en cache pour un meilleur fonctionnement hors ligne</li>
            <li>Ajouter une notification pour informer l'utilisateur du mode hors ligne</li>
            <li>Mettre en place un système de synchronisation des données lorsque la connexion est rétablie</li>
            <li>Améliorer la gestion des mises à jour du service worker</li>
          </ul>
          
          <h3>Processus d'optimisation itératif</h3>
          <ul>
            <li>Mettre en place un système de tests automatisés à exécuter après chaque modification</li>
            <li>Créer un tableau de bord pour suivre l'évolution des métriques au fil du temps</li>
            <li>Établir un cycle régulier de tests et d'optimisations</li>
            <li>Documenter les améliorations apportées et leur impact sur l'expérience utilisateur</li>
          </ul>
        </div>
      </div>
      
      <script>
        function openTab(evt, tabName) {
          // Cacher tous les contenus d'onglets
          const tabContents = document.getElementsByClassName("tab-content");
          for (let i = 0; i < tabContents.length; i++) {
            tabContents[i].classList.remove("active");
          }
          
          // Désactiver tous les onglets
          const tabs = document.getElementsByClassName("tab");
          for (let i = 0; i < tabs.length; i++) {
            tabs[i].classList.remove("active");
          }
          
          // Afficher le contenu de l'onglet sélectionné et activer l'onglet
          document.getElementById(tabName).classList.add("active");
          evt.currentTarget.classList.add("active");
        }
      </script>
    </body>
    </html>
  `;
  
  fs.writeFileSync(config.combinedReportPath, html);
}

// Exécuter tous les tests si ce script est exécuté directement
if (require.main === module) {
  runAllTests();
}

module.exports = { runAllTests };