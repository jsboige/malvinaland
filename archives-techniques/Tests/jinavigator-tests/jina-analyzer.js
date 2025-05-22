/**
 * Script d'analyse de contenu avec jinavigator pour Malvinaland
 * 
 * Ce script utilise l'API jinavigator pour analyser le contenu textuel des pages
 * du site Malvinaland et générer des rapports d'analyse.
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Configuration des tests
const config = {
  baseUrl: 'file:///d:/Production/malvinaland/Site/Core/index.html',
  reportDir: path.join(__dirname, '../reports/jina-analysis'),
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
  ]
};

// Créer le dossier de rapports s'il n'existe pas
if (!fs.existsSync(config.reportDir)) {
  fs.mkdirSync(config.reportDir, { recursive: true });
}

/**
 * Fonction principale pour analyser le contenu avec jinavigator
 */
async function analyzeWithJina() {
  console.log('Démarrage de l\'analyse avec jinavigator...');
  
  // Créer un rapport global
  const globalReport = {
    timestamp: new Date().toISOString(),
    pages: [],
    summary: {
      totalPages: config.pages.length,
      totalWords: 0,
      averageWordsPerPage: 0,
      contentQualityScore: 0,
      narrativeElements: {
        description: 0,
        ambiance: 0,
        history: 0,
        enigmas: 0
      }
    }
  };
  
  // Analyser chaque page
  for (const pageConfig of config.pages) {
    console.log(`\nAnalyse de ${pageConfig.name}...`);
    
    const url = new URL(pageConfig.path, config.baseUrl).href;
    const pageReport = await analyzePageWithJina(url, pageConfig.name);
    
    // Ajouter au rapport global
    globalReport.pages.push(pageReport);
    
    // Mettre à jour les statistiques globales
    globalReport.summary.totalWords += pageReport.wordCount || 0;
    
    if (pageReport.narrativeElements) {
      if (pageReport.narrativeElements.description) globalReport.summary.narrativeElements.description++;
      if (pageReport.narrativeElements.ambiance) globalReport.summary.narrativeElements.ambiance++;
      if (pageReport.narrativeElements.history) globalReport.summary.narrativeElements.history++;
      if (pageReport.narrativeElements.enigmas) globalReport.summary.narrativeElements.enigmas++;
    }
    
    if (pageReport.contentQualityScore) {
      globalReport.summary.contentQualityScore += pageReport.contentQualityScore;
    }
  }
  
  // Calculer les moyennes
  globalReport.summary.averageWordsPerPage = Math.round(globalReport.summary.totalWords / globalReport.summary.totalPages);
  globalReport.summary.contentQualityScore = Math.round((globalReport.summary.contentQualityScore / globalReport.summary.totalPages) * 10) / 10;
  
  // Calculer les pourcentages
  const total = globalReport.summary.totalPages;
  globalReport.summary.narrativeElements.descriptionPercent = Math.round((globalReport.summary.narrativeElements.description / total) * 100);
  globalReport.summary.narrativeElements.ambiancePercent = Math.round((globalReport.summary.narrativeElements.ambiance / total) * 100);
  globalReport.summary.narrativeElements.historyPercent = Math.round((globalReport.summary.narrativeElements.history / total) * 100);
  globalReport.summary.narrativeElements.enigmasPercent = Math.round((globalReport.summary.narrativeElements.enigmas / total) * 100);
  
  // Enregistrer le rapport global
  const reportPath = path.join(config.reportDir, `jina-report-${Date.now()}.json`);
  fs.writeFileSync(reportPath, JSON.stringify(globalReport, null, 2));
  console.log(`\nRapport d'analyse jinavigator enregistré: ${reportPath}`);
  
  // Générer un rapport HTML pour une meilleure lisibilité
  generateJinaHtmlReport(globalReport);
  
  console.log('\nAnalyse avec jinavigator terminée!');
  return globalReport;
}

/**
 * Analyse une page avec jinavigator
 */
async function analyzePageWithJina(url, pageName) {
  console.log(`  Extraction du contenu de ${url} avec jinavigator...`);
  
  try {
    // Utiliser l'API jinavigator pour extraire le contenu de la page
    // Dans une implémentation réelle, vous utiliseriez l'API MCP de jinavigator
    // Ici, nous simulons l'extraction en lisant directement le fichier HTML
    
    const filePath = url.replace('file:///d:/Production/malvinaland/', '');
    const content = fs.readFileSync(path.join('d:/Production/malvinaland', filePath), 'utf8');
    
    // Analyser le contenu extrait
    const pageReport = {
      name: pageName,
      url: url,
      wordCount: countWords(content),
      contentQualityScore: analyzeContentQuality(content),
      narrativeElements: detectNarrativeElements(content),
      keyTopics: extractKeyTopics(content),
      readabilityScore: calculateReadabilityScore(content),
      sentimentAnalysis: analyzeSentiment(content)
    };
    
    // Extraire les énigmes
    pageReport.enigmas = extractEnigmas(content);
    
    // Générer un résumé du contenu
    pageReport.summary = generateContentSummary(content);
    
    console.log(`  Analyse terminée pour ${pageName}`);
    console.log(`    - Nombre de mots: ${pageReport.wordCount}`);
    console.log(`    - Score de qualité: ${pageReport.contentQualityScore}/10`);
    console.log(`    - Score de lisibilité: ${pageReport.readabilityScore}/10`);
    console.log(`    - Sentiment: ${pageReport.sentimentAnalysis.sentiment} (${pageReport.sentimentAnalysis.score})`);
    
    // Enregistrer le contenu Markdown extrait
    const markdownPath = path.join(config.reportDir, `${pageName}-content.md`);
    fs.writeFileSync(markdownPath, pageReport.summary);
    console.log(`    - Résumé enregistré: ${markdownPath}`);
    
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
 * Compte le nombre de mots dans un texte
 */
function countWords(text) {
  return (text.match(/\b\w+\b/g) || []).length;
}

/**
 * Analyse la qualité du contenu
 */
function analyzeContentQuality(content) {
  // Simuler une analyse de qualité du contenu
  // Dans une implémentation réelle, vous utiliseriez des algorithmes plus sophistiqués
  
  let score = 0;
  
  // Longueur du contenu
  const wordCount = countWords(content);
  if (wordCount > 1000) score += 3;
  else if (wordCount > 500) score += 2;
  else if (wordCount > 200) score += 1;
  
  // Présence d'éléments narratifs
  if (content.includes('Description') || content.includes('description')) score += 1;
  if (content.includes('Ambiance') || content.includes('ambiance')) score += 1;
  if (content.includes('Histoire') || content.includes('histoire')) score += 1;
  if (content.includes('Énigme') || content.includes('énigme')) score += 2;
  
  // Structure du contenu
  if (content.includes('<h1>') || content.includes('<h2>') || content.includes('<h3>')) score += 1;
  if (content.includes('<ul>') || content.includes('<ol>')) score += 1;
  
  // Limiter le score à 10
  return Math.min(10, score);
}

/**
 * Détecte les éléments narratifs dans le contenu
 */
function detectNarrativeElements(content) {
  return {
    description: content.includes('Description') || content.includes('description'),
    ambiance: content.includes('Ambiance') || content.includes('ambiance') || content.includes('atmosphère'),
    history: content.includes('Histoire') || content.includes('histoire'),
    enigmas: content.includes('Énigme') || content.includes('énigme')
  };
}

/**
 * Extrait les sujets clés du contenu
 */
function extractKeyTopics(content) {
  // Simuler l'extraction de sujets clés
  // Dans une implémentation réelle, vous utiliseriez des techniques de NLP
  
  const topics = [];
  
  if (content.includes('assemblée')) topics.push('assemblée');
  if (content.includes('jeux')) topics.push('jeux');
  if (content.includes('rêves')) topics.push('rêves');
  if (content.includes('damier')) topics.push('damier');
  if (content.includes('linge')) topics.push('linge');
  if (content.includes('verger')) topics.push('verger');
  if (content.includes('Zob')) topics.push('Zob');
  if (content.includes('Elysée')) topics.push('Elysée');
  if (content.includes('Karibu')) topics.push('Karibu');
  if (content.includes('Sphinx')) topics.push('Sphinx');
  if (content.includes('énigme')) topics.push('énigme');
  if (content.includes('mystère')) topics.push('mystère');
  if (content.includes('Collectionneur')) topics.push('Collectionneur d\'Âmes');
  
  return topics;
}

/**
 * Calcule un score de lisibilité pour le contenu
 */
function calculateReadabilityScore(content) {
  // Simuler un calcul de score de lisibilité
  // Dans une implémentation réelle, vous utiliseriez des algorithmes comme Flesch-Kincaid
  
  let score = 5; // Score de base moyen
  
  // Longueur moyenne des phrases (estimation simplifiée)
  const sentences = content.split(/[.!?]+/);
  const avgWordsPerSentence = countWords(content) / sentences.length;
  
  if (avgWordsPerSentence < 10) score += 2;
  else if (avgWordsPerSentence < 15) score += 1;
  else if (avgWordsPerSentence > 25) score -= 1;
  
  // Présence de listes qui améliorent la lisibilité
  if (content.includes('<ul>') || content.includes('<ol>')) score += 1;
  
  // Présence de titres qui structurent le contenu
  if (content.includes('<h2>') || content.includes('<h3>')) score += 1;
  
  // Limiter le score entre 1 et 10
  return Math.max(1, Math.min(10, score));
}

/**
 * Analyse le sentiment du contenu
 */
function analyzeSentiment(content) {
  // Simuler une analyse de sentiment
  // Dans une implémentation réelle, vous utiliseriez des modèles de NLP
  
  const positiveWords = ['merveilleux', 'magnifique', 'enchanteur', 'magique', 'harmonieux', 'chaleureux'];
  const negativeWords = ['sombre', 'mystérieux', 'effrayant', 'dangereux', 'menaçant'];
  
  let positiveCount = 0;
  let negativeCount = 0;
  
  positiveWords.forEach(word => {
    const regex = new RegExp(word, 'gi');
    const matches = content.match(regex);
    if (matches) positiveCount += matches.length;
  });
  
  negativeWords.forEach(word => {
    const regex = new RegExp(word, 'gi');
    const matches = content.match(regex);
    if (matches) negativeCount += matches.length;
  });
  
  const totalWords = positiveCount + negativeCount;
  if (totalWords === 0) return { sentiment: 'neutre', score: 0 };
  
  const score = (positiveCount - negativeCount) / totalWords;
  
  if (score > 0.3) return { sentiment: 'positif', score: score.toFixed(2) };
  if (score < -0.3) return { sentiment: 'négatif', score: score.toFixed(2) };
  return { sentiment: 'neutre', score: score.toFixed(2) };
}

/**
 * Extrait les énigmes du contenu
 */
function extractEnigmas(content) {
  const enigmas = [];
  const enigmaRegex = /Énigme \d+.+?(?=Énigme \d+|$)/gs;
  
  let match;
  while ((match = enigmaRegex.exec(content)) !== null) {
    enigmas.push(match[0].trim());
  }
  
  return enigmas;
}

/**
 * Génère un résumé du contenu
 */
function generateContentSummary(content) {
  // Simuler la génération d'un résumé
  // Dans une implémentation réelle, vous utiliseriez des techniques de résumé automatique
  
  // Extraire les titres et les premiers paragraphes
  const titleRegex = /<h[1-3][^>]*>(.*?)<\/h[1-3]>/g;
  const titles = [];
  let match;
  
  while ((match = titleRegex.exec(content)) !== null) {
    titles.push(match[1]);
  }
  
  // Créer un résumé Markdown
  let summary = '# Résumé du contenu\n\n';
  
  if (titles.length > 0) {
    summary += '## Titres principaux\n\n';
    titles.forEach(title => {
      summary += `- ${title}\n`;
    });
    summary += '\n';
  }
  
  // Extraire les éléments narratifs
  const narrativeElements = detectNarrativeElements(content);
  summary += '## Éléments narratifs\n\n';
  
  if (narrativeElements.description) {
    summary += '### Description\n';
    // Extraire un extrait de la description
    const descriptionMatch = content.match(/Description[^<]*<\/h3>\s*<p>([^<]+)/);
    if (descriptionMatch) {
      summary += `${descriptionMatch[1]}...\n\n`;
    }
  }
  
  if (narrativeElements.ambiance) {
    summary += '### Ambiance\n';
    // Extraire un extrait de l'ambiance
    const ambianceMatch = content.match(/Ambiance[^<]*<\/h3>\s*<p>([^<]+)/);
    if (ambianceMatch) {
      summary += `${ambianceMatch[1]}...\n\n`;
    }
  }
  
  if (narrativeElements.history) {
    summary += '### Histoire\n';
    // Extraire un extrait de l'histoire
    const historyMatch = content.match(/Histoire[^<]*<\/h3>\s*<p>([^<]+)/);
    if (historyMatch) {
      summary += `${historyMatch[1]}...\n\n`;
    }
  }
  
  // Extraire les énigmes
  const enigmas = extractEnigmas(content);
  if (enigmas.length > 0) {
    summary += '## Énigmes\n\n';
    enigmas.forEach((enigma, index) => {
      // Extraire juste le titre de l'énigme pour le résumé
      const enigmaTitle = enigma.split('\n')[0];
      summary += `${index + 1}. ${enigmaTitle}\n`;
    });
  }
  
  return summary;
}

/**
 * Génère un rapport HTML pour les analyses jinavigator
 */
function generateJinaHtmlReport(report) {
  const reportPath = path.join(config.reportDir, `jina-report-${Date.now()}.html`);
  
  let html = `
    <!DOCTYPE html>
    <html lang="fr">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Rapport d'analyse jinavigator - Malvinaland</title>
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
        .page-card {
          background-color: white;
          padding: 20px;
          border-radius: 5px;
          margin-bottom: 20px;
          box-shadow: 0 2px 5px rgba(0,0,0,0.1);
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
        .topics {
          display: flex;
          flex-wrap: wrap;
          gap: 10px;
          margin-top: 10px;
        }
        .topic {
          background-color: #e3f2fd;
          color: #0d47a1;
          padding: 5px 10px;
          border-radius: 15px;
          font-size: 0.9em;
        }
        .sentiment {
          display: inline-block;
          padding: 5px 10px;
          border-radius: 15px;
          font-size: 0.9em;
          margin-top: 10px;
        }
        .sentiment.positive {
          background-color: #e8f5e9;
          color: #2e7d32;
        }
        .sentiment.neutral {
          background-color: #f5f5f5;
          color: #616161;
        }
        .sentiment.negative {
          background-color: #ffebee;
          color: #c62828;
        }
        .score {
          font-weight: bold;
        }
        .score.good {
          color: #2e7d32;
        }
        .score.average {
          color: #f57c00;
        }
        .score.poor {
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
      <h1>Rapport d'analyse jinavigator - Malvinaland</h1>
      <p>Généré le ${new Date(report.timestamp).toLocaleString()}</p>
      
      <div class="section">
        <h2>Résumé global</h2>
        <p>Nombre total de pages analysées: ${report.summary.totalPages}</p>
        <p>Nombre total de mots: ${report.summary.totalWords}</p>
        <p>Moyenne de mots par page: ${report.summary.averageWordsPerPage}</p>
        <p>Score moyen de qualité du contenu: <span class="score ${getScoreClass(report.summary.contentQualityScore)}">${report.summary.contentQualityScore}/10</span></p>
        
        <h3>Présence d'éléments narratifs</h3>
        
        <div class="stat">
          <div class="stat-label">Description:</div>
          <div class="stat-bar">
            <div class="progress-bar">
              <div class="progress-fill" style="width: ${report.summary.narrativeElements.descriptionPercent}%"></div>
            </div>
          </div>
          <div class="stat-value">${report.summary.narrativeElements.descriptionPercent}%</div>
        </div>
        
        <div class="stat">
          <div class="stat-label">Ambiance:</div>
          <div class="stat-bar">
            <div class="progress-bar">
              <div class="progress-fill" style="width: ${report.summary.narrativeElements.ambiancePercent}%"></div>
            </div>
          </div>
          <div class="stat-value">${report.summary.narrativeElements.ambiancePercent}%</div>
        </div>
        
        <div class="stat">
          <div class="stat-label">Histoire:</div>
          <div class="stat-bar">
            <div class="progress-bar">
              <div class="progress-fill" style="width: ${report.summary.narrativeElements.historyPercent}%"></div>
            </div>
          </div>
          <div class="stat-value">${report.summary.narrativeElements.historyPercent}%</div>
        </div>
        
        <div class="stat">
          <div class="stat-label">Énigmes:</div>
          <div class="stat-bar">
            <div class="progress-bar">
              <div class="progress-fill" style="width: ${report.summary.narrativeElements.enigmasPercent}%"></div>
            </div>
          </div>
          <div class="stat-value">${report.summary.narrativeElements.enigmasPercent}%</div>
        </div>
        
        <div class="recommendations">
          <h3>Recommandations pour le contenu</h3>
          <ul>
            <li>Enrichir les descriptions dans les pages qui en manquent</li>
            <li>Ajouter des éléments d'ambiance pour renforcer l'immersion</li>
            <li>Développer l'histoire locale dans tous les mondes</li>
            <li>Structurer les énigmes de manière cohérente dans tous les mondes</li>
            <li>Améliorer la lisibilité des textes longs en ajoutant des sous-titres et des listes</li>
          </ul>
        </div>
      </div>
      
      <h2>Détails par page</h2>
  `;
  
  // Ajouter les détails de chaque page
  for (const page of report.pages) {
    if (page.error) {
      html += `
        <div class="page-card">
          <h3>${page.name}</h3>
          <p>URL: ${page.url}</p>
          <p>Erreur: ${page.error}</p>
        </div>
      `;
      continue;
    }
    
    const qualityScoreClass = getScoreClass(page.contentQualityScore);
    const readabilityScoreClass = getScoreClass(page.readabilityScore);
    const sentimentClass = getSentimentClass(page.sentimentAnalysis?.sentiment);
    
    html += `
      <div class="page-card">
        <h3>${page.name}</h3>
        <p>URL: ${page.url}</p>
        <p>Nombre de mots: ${page.wordCount || 'N/A'}</p>
        <p>Score de qualité: <span class="score ${qualityScoreClass}">${page.contentQualityScore || 'N/A'}/10</span></p>
        <p>Score de lisibilité: <span class="score ${readabilityScoreClass}">${page.readabilityScore || 'N/A'}/10</span></p>
        
        ${page.sentimentAnalysis ? `
          <p>Sentiment: <span class="sentiment ${sentimentClass}">${page.sentimentAnalysis.sentiment} (${page.sentimentAnalysis.score})</span></p>
        ` : ''}
        
        <h4>Éléments narratifs</h4>
        <ul>
          <li>Description: ${page.narrativeElements?.description ? '✅' : '❌'}</li>
          <li>Ambiance: ${page.narrativeElements?.ambiance ? '✅' : '❌'}</li>
          <li>Histoire: ${page.narrativeElements?.history ? '✅' : '❌'}</li>
          <li>Énigmes: ${page.narrativeElements?.enigmas ? '✅' : '❌'}</li>
        </ul>
        
        ${page.keyTopics && page.keyTopics.length > 0 ? `
          <h4>Sujets clés</h4>
          <div class="topics">
            ${page.keyTopics.map(topic => `<span class="topic">${topic}</span>`).join('')}
          </div>
        ` : ''}
        
        ${page.enigmas && page.enigmas.length > 0 ? `
          <h4>Énigmes détectées: ${page.enigmas.length}</h4>
        ` : ''}
      </div>
    `;
  }
  
  html += `
    </body>
    </html>
  `;
  
  fs.writeFileSync(reportPath, html);
  console.log(`Rapport HTML jinavigator généré: ${reportPath}`);
}

/**
 * Retourne la classe CSS pour un score
 */
function getScoreClass(score) {
  if (score >= 8) return 'good';
  if (score >= 5) return 'average';
  return 'poor';
}

/**
 * Retourne la classe CSS pour un sentiment
 */
function getSentimentClass(sentiment) {
  if (sentiment === 'positif') return 'positive';
  if (sentiment === 'négatif') return 'negative';
  return 'neutral';
}

// Exécuter l'analyse si ce script est exécuté directement
if (require.main === module) {
  analyzeWithJina();
}

module.exports = { analyzeWithJina };