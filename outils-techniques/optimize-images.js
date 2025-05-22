/**
 * Script d'optimisation des images pour Malvinaland
 * Ce script optimise les images et génère des miniatures
 */

const sharp = require('sharp');
const fs = require('fs');
const path = require('path');
const glob = require('glob');

// Configuration
const sourceDir = path.join(__dirname, '../src/assets/images');
const outputDir = path.join(__dirname, '../dist/assets/images');
const thumbnailsDir = path.join(__dirname, '../dist/assets/thumbnails');

// Créer les répertoires de sortie s'ils n'existent pas
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

if (!fs.existsSync(thumbnailsDir)) {
  fs.mkdirSync(thumbnailsDir, { recursive: true });
}

// Trouver toutes les images
const imageFiles = glob.sync(`${sourceDir}/**/*.{jpg,jpeg,png,gif}`);

// Traiter chaque image
async function processImages() {
  console.log(`Traitement de ${imageFiles.length} images...`);
  
  for (const file of imageFiles) {
    const relativePath = path.relative(sourceDir, file);
    const outputPath = path.join(outputDir, relativePath);
    const thumbnailPath = path.join(thumbnailsDir, relativePath);
    
    // Créer les répertoires de sortie pour cette image
    const outputDirForFile = path.dirname(outputPath);
    const thumbnailDirForFile = path.dirname(thumbnailPath);
    
    if (!fs.existsSync(outputDirForFile)) {
      fs.mkdirSync(outputDirForFile, { recursive: true });
    }
    
    if (!fs.existsSync(thumbnailDirForFile)) {
      fs.mkdirSync(thumbnailDirForFile, { recursive: true });
    }
    
    try {
      // Optimiser l'image originale
      await sharp(file)
        .jpeg({ quality: 80, progressive: true })
        .toFile(outputPath);
      
      // Créer une miniature
      await sharp(file)
        .resize(300, 200, { fit: 'inside', withoutEnlargement: true })
        .jpeg({ quality: 60, progressive: true })
        .toFile(thumbnailPath);
      
      console.log(`✓ Traité: ${relativePath}`);
    } catch (error) {
      console.error(`✗ Erreur lors du traitement de ${relativePath}: ${error.message}`);
    }
  }
  
  console.log('Optimisation des images terminée!');
}

processImages();