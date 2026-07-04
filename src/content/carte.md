---
layout: layouts/base.njk
title: Carte des Mondes
description: Carte interactive des mondes de Malvinaland
permalink: "/carte/"
---

# Carte des Mondes de Malvinaland

Explorez la carte interactive des mondes de Malvinaland. Chaque monde est représenté par une couleur distinctive et contient ses propres mystères à découvrir.

<!-- CARTE INTERACTIVE SIMPLIFIÉE - APPROCHE MINIMALISTE -->
<div class="carte-container-simple">
  <img src="https://malvinaland.myia.io/assets/images/carte-malvinaland.png" 
       alt="Carte de Malvinaland" 
       class="carte-image-simple" 
       usemap="#image-map"
       id="carte-interactive">
  
  <map name="image-map">
    <!-- COORDONNÉES FIXES OPTIMISÉES POUR RESPONSIVE CSS -->
    <!-- Dimensions de référence : 1441x978 -->
    
    <!-- Le Monde de la Grange -->
    <area shape="rect" 
          coords="171,324,542,563" 
          href="/mondes/grange/" 
          title="🌾 Le Monde de la Grange - Royaume de l'Agriculture Mystique"
          alt="Le Monde de la Grange">
    
    <!-- Le Monde des Sphinx -->
    <area shape="rect" 
          coords="663,113,975,352" 
          href="/mondes/sphinx/" 
          title="🦁 Le Monde des Sphinx - Royaume des Énigmes Anciennes"
          alt="Le Monde des Sphinx">
    
    <!-- Le Monde du Linge -->
    <area shape="rect" 
          coords="1024,113,1262,333" 
          href="/mondes/linge/" 
          title="👗 Le Monde du Linge - Royaume des Tissus Enchantés"
          alt="Le Monde du Linge">
    
    <!-- Le Monde du Verger -->
    <area shape="rect" 
          coords="1114,350,1392,579" 
          href="/mondes/verger/" 
          title="🍎 Le Monde du Verger - Royaume des Fruits Éternels"
          alt="Le Monde du Verger">
    
    <!-- Le Monde du Damier -->
    <area shape="rect" 
          coords="965,556,1219,780" 
          href="/mondes/damier/" 
          title="♟️ Le Monde du Damier - Royaume des Stratégies Infinies"
          alt="Le Monde du Damier">
    
    <!-- Le Monde du Zob -->
    <area shape="rect" 
          coords="1224,723,1441,978" 
          href="/mondes/zob/" 
          title="🎪 Le Monde du Zob - Royaume de la Fantaisie Débridée"
          alt="Le Monde du Zob">
    
    <!-- Le Monde Karibu -->
    <area shape="rect" 
          coords="714,635,1034,955" 
          href="/mondes/karibu/" 
          title="🔥 Le Monde Karibu - Royaume du Feu Sacré"
          alt="Le Monde Karibu">
    
    <!-- Le Monde de l'Assemblée -->
    <area shape="rect" 
          coords="422,656,682,901" 
          href="/mondes/assemblee/" 
          title="🏛️ Le Monde de l'Assemblée - Royaume de la Gouvernance Sage"
          alt="Le Monde de l'Assemblée">
    
    <!-- Le Monde des Jeux -->
    <area shape="rect" 
          coords="77,590,373,826" 
          href="/mondes/jeux/" 
          title="🎮 Le Monde des Jeux - Royaume de l'Enfance Éternelle"
          alt="Le Monde des Jeux">
    
    <!-- Le Monde Elysée -->
    <area shape="rect" 
          coords="187,160,530,319" 
          href="/mondes/elysee/" 
          title="🏰 Le Monde Elysée - Royaume de la Noblesse Perdue"
          alt="Le Monde Elysée">
    
    <area shape="rect"
          coords="591,362,909,602"
          href="/mondes/reves/"
          title="🌙 Le Monde des Rêves - Royaume des Songes Éthérés"
          alt="Le Monde des Rêves">
  </map>
</div>

## Légende de la carte

- **🔥 Rouge** : Le Monde de l'Assemblée
- **🌾 Vert** : Le Monde de la Grange
- **🎮 Bleu** : Le Monde des Jeux
- **♟️ Bleu clair** : Le Monde du Damier
- **👗 Violet** : Le Monde du Linge
- **🍎 Rose** : Le Monde du Verger
- **🎪 Corail** : Le Monde du Zob
- **🏰 Blanc** : Le Monde Elysée
- **🔥 Orange vif** : Le Monde Karibu
- **🦁 Orange rouge** : Le Monde des Sphinx
- **🌙 Bleu nuit** : Le Monde des Rêves

## Connexions entre les mondes

Les mondes de Malvinaland sont interconnectés par des passages mystiques. Chaque monde est relié à plusieurs autres, formant un réseau complexe de chemins à explorer.

<style>
  /* APPROCHE MINIMALISTE - ZÉRO JAVASCRIPT */
  .carte-container-simple {
    position: relative;
    max-width: 100%;
    margin: 2rem auto;
    text-align: center;
    background: linear-gradient(135deg, #f8f9fa, #e9ecef);
    padding: 1rem;
    border-radius: 16px;
    box-shadow: 0 8px 32px rgba(63, 81, 181, 0.15);
  }
  
  .carte-image-simple {
    width: 100%;
    height: auto;
    max-width: 1441px;
    border: 3px solid #3f51b5;
    border-radius: 12px;
    box-shadow: 0 8px 24px rgba(63, 81, 181, 0.2);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    cursor: pointer;
  }
  
  .carte-image-simple:hover {
    transform: scale(1.01);
    box-shadow: 0 12px 32px rgba(63, 81, 181, 0.3);
  }
  
  /* ZONES CLIQUABLES OPTIMISÉES MOBILE */
  map area {
    cursor: pointer;
    outline: none;
  }
  
  map area:hover {
    /* Effet visuel natif du navigateur */
  }
  
  map area:focus {
    outline: 2px solid #3f51b5;
    outline-offset: 2px;
  }
  
  /* LÉGENDE AMÉLIORÉE */
  .carte-container-simple + h2 + ul {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 0.75rem;
    list-style: none;
    padding: 0;
    margin: 2rem 0;
    background: #f8f9fa;
    padding: 1.5rem;
    border-radius: 12px;
    border-left: 4px solid #3f51b5;
  }
  
  .carte-container-simple + h2 + ul li {
    padding: 0.75rem 1rem;
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    transition: all 0.2s ease;
    font-weight: 500;
  }
  
  .carte-container-simple + h2 + ul li:hover {
    background: #e3f2fd;
    transform: translateY(-2px);
    box-shadow: 0 4px 16px rgba(63, 81, 181, 0.2);
  }
  
  /* INDICATEUR TACTILE */
  .carte-container-simple::after {
    content: "💡 Touchez les mondes colorés pour les explorer !";
    display: block;
    margin-top: 1rem;
    padding: 0.75rem 1.5rem;
    background: linear-gradient(135deg, #3f51b5, #5c6bc0);
    color: white;
    border-radius: 25px;
    font-size: 0.95rem;
    font-weight: 600;
    box-shadow: 0 4px 16px rgba(63, 81, 181, 0.3);
    animation: pulse-simple 3s infinite;
  }
  
  @keyframes pulse-simple {
    0%, 100% { opacity: 1; transform: scale(1); }
    50% { opacity: 0.8; transform: scale(1.02); }
  }
  
  /* RESPONSIVE MOBILE-FIRST */
  @media (max-width: 768px) {
    .carte-container-simple {
      margin: 1rem 0;
      padding: 0.75rem;
    }
    
    .carte-image-simple {
      border-width: 2px;
    }
    
    .carte-container-simple::after {
      font-size: 0.85rem;
      padding: 0.6rem 1.2rem;
    }
    
    .carte-container-simple + h2 + ul {
      grid-template-columns: 1fr;
      gap: 0.5rem;
      padding: 1rem;
    }
    
    .carte-container-simple + h2 + ul li {
      padding: 0.6rem 0.8rem;
      font-size: 0.9rem;
    }
    
    /* ZONES TACTILES OPTIMISÉES - MINIMUM 44px */
    map area {
      /* Les zones sont automatiquement agrandies par le navigateur sur mobile */
    }
  }
  
  @media (max-width: 480px) {
    .carte-container-simple {
      padding: 0.5rem;
    }
    
    .carte-image-simple {
      border-width: 1px;
    }
    
    .carte-container-simple::after {
      font-size: 0.8rem;
      padding: 0.5rem 1rem;
      margin-top: 0.75rem;
    }
  }
  
  /* OPTIMISATION TABLETTE */
  @media (min-width: 769px) and (max-width: 1024px) {
    .carte-container-simple + h2 + ul {
      grid-template-columns: repeat(2, 1fr);
    }
  }
  
  /* OPTIMISATION DESKTOP */
  @media (min-width: 1025px) {
    .carte-container-simple {
      padding: 1.5rem;
    }
    
    .carte-container-simple + h2 + ul {
      grid-template-columns: repeat(3, 1fr);
    }
  }
  
  /* ACCESSIBILITÉ */
  @media (prefers-reduced-motion: reduce) {
    .carte-image-simple,
    .carte-container-simple + h2 + ul li,
    .carte-container-simple::after {
      transition: none;
      animation: none;
    }
  }
  
  /* CONTRASTE ÉLEVÉ */
  @media (prefers-contrast: high) {
    .carte-image-simple {
      border-width: 4px;
      border-color: #000;
    }
    
    .carte-container-simple + h2 + ul li {
      border: 2px solid #000;
    }
  }
</style>
