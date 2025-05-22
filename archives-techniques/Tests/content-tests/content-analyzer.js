/**
 * Script d'analyse de contenu pour Malvinaland
 * 
 * Ce script utilise jinavigator pour analyser le contenu textuel des pages du site Malvinaland.
 * Il permet d'extraire et d'analyser le contenu pour vérifier la qualité du texte, la présence
 * d'éléments narratifs, la clarté des énigmes, etc.
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Configuration des tests
const config = {
  baseUrl: 'file:///d:/Production/malvinaland/Site/Core/index.html',
  reportDir: path.join(__dirname, '../reports/content'),
  pages: [
    { name: 'accueil', path: 'index.html' },
    { name: 'carte', path: 'carte.html' },
    { name: 'monde-assemblee', path: '../Mondes/Le monde de l\'assemblée/index.html' },
    { name: 'monde-jeux', path: '../Mondes/Le monde des jeux/index.html' },
    { name: 'monde-reves', path: '../Mondes/Le monde des rêves/index.html' },
    { name: 'monde-damier', path: '../Mondes/Le monde du damier/index.html' },
    { name: 'monde-linge', path: '../Mondes/Le monde du linge/index.html' },
    { name: 'monde-verger', path: '../Mondes/Le monde du verger/index.html' },
    { name: 'monde-zob', path: '../Mondes/Le monde du Zob/index.html' },
    { name: 'monde-elysee', path: '../Mondes/Le monde Elysée/index.html' },
    { name: 'monde-karibu', path: '../Mondes/Le monde Karibu/index.html' },
    { name: 'monde-sphinx', path: '../Mondes/Le monde orange des Sphinx/index.html' }
  ],
  contentElements: {
    'description': 'h3:contains("Description du lieu") + p, p:contains("Description du lieu")',
    'ambiance': 'h3:contains("Ambiance") + p, p:contains("Ambiance")',
    'histoire': 'h3:contains("Histoire locale") + p, p:contains("Histoire locale")',
    'enigmes': 'h3:contains("Énigmes proposées") + ul, ul:contains("Énigme")'
  }
};

// Créer le dossier de rapports s'il n'existe pas
if (!fs.existsSync(config.reportDir)) {
  fs.mkdirSync(config.reportDir, { recursive: true });
}

/**
 * Fonction principale pour exécuter les analyses de contenu
 */
async function runContentAnalysis() {
  console.log('Démarrage de l\'analyse de contenu...');
  
  // Créer un rapport global
  const globalReport = {
    timestamp: new Date().toISOString(),
    pages: [],
    summary: {
      totalPages: config.pages.length,
      pagesWithDescription: 0,
      pagesWithAmbiance: 0,
      pagesWithHistoire: 0,
      pagesWithEnigmes: 0,
      totalEnigmes: 0
    }
  };
  
  // Analyser chaque page
  for (const pageConfig of config.pages) {
    console.log(`\nAnalyse de ${pageConfig.name}...`);
    
    const url = new URL(pageConfig.path, config.baseUrl).href;
    const pageReport = await analyzePageContent(url, pageConfig.name);
    
    // Ajouter au rapport global
    globalReport.pages.push(pageReport);
    
    // Mettre à jour les statistiques globales
    if (pageReport.hasDescription) globalReport.summary.pagesWithDescription++;
    if (pageReport.hasAmbiance) globalReport.summary.pagesWithAmbiance++;
    if (pageReport.hasHistoire) globalReport.summary.pagesWithHistoire++;
    if (pageReport.hasEnigmes) globalReport.summary.pagesWithEnigmes++;
    globalReport.summary.totalEnigmes += pageReport.enigmesCount || 0;
  }
  
  // Calculer les pourcentages
  const total = globalReport.summary.totalPages;
  globalReport.summary.percentWithDescription = Math.round((globalReport.summary.pagesWithDescription / total) * 100);
  globalReport.summary.percentWithAmbiance = Math.round((globalReport.summary.pagesWithAmbiance / total) * 100);
  globalReport.summary.percentWithHistoire = Math.round((globalReport.summary.pagesWithHistoire / total) * 100);
  globalReport.summary.percentWithEnigmes = Math.round((globalReport.summary.pagesWithEnigmes / total) * 100);
  
  // Enregistrer le rapport global
  const reportPath = path.join(config.reportDir, `content-report-${Date.now()}.json`);
  fs.writeFileSync(reportPath, JSON.stringify(globalReport, null, 2));
  console.log(`\nRapport d'analyse de contenu enregistré: ${reportPath}`);
  
  // Générer un rapport HTML pour une meilleure lisibilité
  generateHtmlReport(globalReport);
  
  console.log('\nAnalyse de contenu terminée!');
  return globalReport;
}

/**
 * Analyse le contenu d'une page spécifique
 */
async function analyzePageContent(url, pageName) {
  console.log(`  Extraction du contenu de ${url}...`);
  
  try {
    // Utiliser jinavigator pour extraire le contenu de la page
    const pageContent = await extractPageContent(url);
    
    // Analyser le contenu extrait
    const pageReport = {
      name: pageName,
      url: url,
      hasDescription: pageContent.includes('Description du lieu'),
      hasAmbiance: pageContent.includes('Ambiance') || pageContent.includes('atmosphère'),
      hasHistoire: pageContent.includes('Histoire locale'),
      hasEnigmes: pageContent.includes('Énigme') || pageContent.includes('énigme'),
      contentQuality: analyzeContentQuality(pageContent),
      wordCount: countWords(pageContent)
    };
    
    // Compter les énigmes
    const enigmeMatches = pageContent.match(/Énigme \d+|énigme \d+/g);
    pageReport.enigmesCount = enigmeMatches ? enigmeMatches.length : 0;
    
    // Extraire les énigmes
    if (pageReport.hasEnigmes) {
      pageReport.enigmes = extractEnigmes(pageContent);
    }
    
    console.log(`  Analyse terminée pour ${pageName}`);
    console.log(`    - Nombre de mots: ${pageReport.wordCount}`);
    console.log(`    - Qualité du contenu: ${pageReport.contentQuality.score}/10`);
    console.log(`    - Nombre d'énigmes: ${pageReport.enigmesCount}`);
    
    return pageReport;
  } catch (error) {
    console.error(`  Erreur lors de l'analyse de ${pageName}:`, error);
    return {
      name: pageName,
      url: url,
      error: error.message
    };
  }
}

/**
 * Extrait le contenu d'une page en utilisant jinavigator
 */
async function extractPageContent(url) {
  // Simuler l'utilisation de jinavigator
  // Dans une implémentation réelle, vous utiliseriez l'API de jinavigator
  console.log(`    Simulation de l'extraction avec jinavigator pour ${url}`);
  
  // Lire le fichier HTML directement (pour la simulation)
  const filePath = url.replace('file:///d:/Production/malvinaland/', '');
  try {
    const content = fs.readFileSync(path.join('d:/Production/malvinaland', filePath), 'utf8');
    return content;
  } catch (error) {
    console.error(`    Erreur lors de la lecture du fichier ${filePath}:`, error);
    return '';
  }
}

/**
 * Analyse la qualité du contenu
 */
function analyzeContentQuality(content) {
  const result = {
    score: 0,
    issues: []
  };
  
  // Vérifier la longueur du contenu
  const wordCount = countWords(content);
  if (wordCount < 100) {
    result.issues.push('Contenu trop court (moins de 100 mots)');
  } else if (wordCount > 500) {
    result.score += 2;
  } else {
    result.score += 1;
  }
  
  // Vérifier la présence de descriptions
  if (content.includes('Description') || content.includes('description')) {
    result.score += 2;
  } else {
    result.issues.push('Pas de section de description');
  }
  
  // Vérifier la présence d'éléments narratifs
  if (content.includes('Histoire') || content.includes('histoire')) {
    result.score += 2;
  } else {
    result.issues.push('Pas d\'éléments narratifs');
  }
  
  // Vérifier la présence d'énigmes
  if (content.includes('Énigme') || content.includes('énigme')) {
    result.score += 2;
  } else {
    result.issues.push('Pas d\'énigmes');
  }
  
  // Vérifier la richesse du vocabulaire
  const uniqueWords = new Set(content.toLowerCase().match(/\b\w+\b/g) || []);
  const vocabularyRichness = uniqueWords.size / wordCount;
  if (vocabularyRichness > 0.4) {
    result.score += 2;
  } else if (vocabularyRichness > 0.3) {
    result.score += 1;
  } else {
    result.issues.push('Vocabulaire limité');
  }
  
  // Limiter le score à 10
  result.score = Math.min(10, result.score);
  
  return result;
}

/**
 * Compte le nombre de mots dans un texte
 */
function countWords(text) {
  return (text.match(/\b\w+\b/g) || []).length;
}

/**
 * Extrait les énigmes d'un contenu
 */
function extractEnigmes(content) {
  const enigmes = [];
  const enigmeRegex = /Énigme \d+.+?(?=Énigme \d+|$)/gs;
  
  let match;
  while ((match = enigmeRegex.exec(content)) !== null) {
    enigmes.push(match[0].trim());
  }
  
  return enigmes;
}

/**
 * Génère un rapport HTML pour une meilleure lisibilité
 */
function generateHtmlReport(report) {
  const htmlPath = path.join(config.reportDir, `content-report-${Date.now()}.html`);
  
  let html = `
    <!DOCTYPE html>
    <html lang="fr">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Rapport d'analyse de contenu - Malvinaland</title>
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; max-width: 1200px; margin: 0 auto; padding: 20px; }
        h1, h2, h3 { color: #3f51b5; }
        .summary { background-color: #f5f5f5; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .page { background-color: white; padding: 20px; border-radius: 5px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .score { font-weight: bold; }
        .good { color: green; }
        .average { color: orange; }
        .poor { color: red; }
        .progress-bar { height: 20px; background-color: #e0e0e0; border-radius: 10px; margin-bottom: 10px; }
        .progress-fill { height: 100%; border-radius: 10px; background-color: #3f51b5; }
        .stat { display: flex; align-items: center; margin-bottom: 10px; }
        .stat-label { width: 200px; }
        .stat-bar { flex-grow: 1; }
        .stat-value { width: 50px; text-align: right; }
      </style>
    </head>
    <body>
      <h1>Rapport d'analyse de contenu - Malvinaland</h1>
      <p>Généré le ${new Date(report.timestamp).toLocaleString()}</p>
      
      <div class="summary">
        <h2>Résumé</h2>
        <p>Nombre total de pages analysées: ${report.summary.totalPages}</p>
        
        <div class="stat">
          <div class="stat-label">Pages avec description:</div>
          <div class="stat-bar">
            <div class="progress-bar">
              <div class="progress-fill" style="width: ${report.summary.percentWithDescription}%"></div>
            </div>
          </div>
          <div class="stat-value">${report.summary.percentWithDescription}%</div>
        </div>
        
        <div class="stat">
          <div class="stat-label">Pages avec ambiance:</div>
          <div class="stat-bar">
            <div class="progress-bar">
              <div class="progress-fill" style="width: ${report.summary.percentWithAmbiance}%"></div>
            </div>
          </div>
          <div class="stat-value">${report.summary.percentWithAmbiance}%</div>
        </div>
        
        <div class="stat">
          <div class="stat-label">Pages avec histoire:</div>
          <div class="stat-bar">
            <div class="progress-bar">
              <div class="progress-fill" style="width: ${report.summary.percentWithHistoire}%"></div>
            </div>
          </div>
          <div class="stat-value">${report.summary.percentWithHistoire}%</div>
        </div>
        
        <div class="stat">
          <div class="stat-label">Pages avec énigmes:</div>
          <div class="stat-bar">
            <div class="progress-bar">
              <div class="progress-fill" style="width: ${report.summary.percentWithEnigmes}%"></div>
            </div>
          </div>
          <div class="stat-value">${report.summary.percentWithEnigmes}%</div>
        </div>
        
        <p>Nombre total d'énigmes: ${report.summary.totalEnigmes}</p>
      </div>
      
      <h2>Détails par page</h2>
  `;
  
  // Ajouter les détails de chaque page
  for (const page of report.pages) {
    let scoreClass = 'average';
    if (page.contentQuality && page.contentQuality.score >= 8) {
      scoreClass = 'good';
    } else if (page.contentQuality && page.contentQuality.score <= 4) {
      scoreClass = 'poor';
    }
    
    html += `
      <div class="page">
        <h3>${page.name}</h3>
        <p>URL: ${page.url}</p>
        <p>Nombre de mots: ${page.wordCount || 'N/A'}</p>
        <p>Qualité du contenu: <span class="score ${scoreClass}">${page.contentQuality ? page.contentQuality.score : 'N/A'}/10</span></p>
        
        <p>Éléments présents:</p>
        <ul>
          <li>Description: ${page.hasDescription ? '✅' : '❌'}</li>
          <li>Ambiance: ${page.hasAmbiance ? '✅' : '❌'}</li>
          <li>Histoire: ${page.hasHistoire ? '✅' : '❌'}</li>
          <li>Énigmes: ${page.hasEnigmes ? '✅' : '❌'} (${page.enigmesCount || 0})</li>
        </ul>
        
        ${page.contentQuality && page.contentQuality.issues.length > 0 ? `
          <p>Problèmes identifiés:</p>
          <ul>
            ${page.contentQuality.issues.map(issue => `<li>${issue}</li>`).join('')}
          </ul>
        ` : ''}
      </div>
    `;
  }
  
  html += `
    </body>
    </html>
  `;
  
  fs.writeFileSync(htmlPath, html);
  console.log(`Rapport HTML généré: ${htmlPath}`);
}

// Exécuter l'analyse si ce script est exécuté directement
if (require.main === module) {
  runContentAnalysis();
}

module.exports = { runContentAnalysis };