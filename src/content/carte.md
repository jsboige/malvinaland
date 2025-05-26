---
layout: layouts/base.njk
title: Carte des Mondes
description: Carte interactive des mondes de Malvinaland
---

# Carte des Mondes de Malvinaland

Explorez la carte interactive des mondes de Malvinaland. Chaque monde est représenté par une couleur distinctive et contient ses propres mystères à découvrir.

<div class="carte-container">
  <img src="/assets/images/carte-malvinaland.png?v=20250520" alt="Carte de Malvinaland" class="carte-image" usemap="#carte-map" id="carte-interactive">
  <map name="carte-map">
    <!-- Zones cliquables générées automatiquement par détection de couleurs -->
    <!-- Le Monde de la Grange (vert, en haut à gauche) -->
    <area shape="rect" coords="120,480,280,580" alt="Le monde de la grange" href="/mondes/grange/" title="Le monde de la grange">
    
    <!-- Le Monde des Sphinx (orange, au centre-haut) -->
    <area shape="circle" coords="465,440,80" alt="Le monde orange des Sphinx" href="/mondes/sphinx/" title="Le monde orange des Sphinx">
    
    <!-- Le Monde du Linge (violet, en haut à droite) -->
    <area shape="rect" coords="615,320,775,420" alt="Le monde du linge" href="/mondes/linge/" title="Le monde du linge">
    
    <!-- Le Monde du Verger (rose, en bas à droite) -->
    <area shape="rect" coords="710,570,870,670" alt="Le monde du verger" href="/mondes/verger/" title="Le monde du verger">
    
    <!-- Le Monde des Jeux (bleu, en bas à gauche) -->
    <area shape="rect" coords="15,100,175,200" alt="Le monde des jeux" href="/mondes/jeux/" title="Le monde des jeux">
    
    <!-- Le Monde de l'Assemblée (rouge/marron, au centre-bas) -->
    <area shape="rect" coords="275,135,435,235" alt="Le monde de l'assemblée" href="/mondes/assemblee/" title="Le monde de l'assemblée">
    
    <!-- Le Monde du Damier (bleu clair, en haut centre) -->
    <area shape="rect" coords="650,100,810,200" alt="Le monde du damier" href="/mondes/damier/" title="Le monde du damier">
    
    <!-- Le Monde Karibu (marron/orange, au centre-bas) -->
    <area shape="rect" coords="465,190,625,290" alt="Le monde Karibu" href="/mondes/karibu/" title="Le monde Karibu">
    
    <!-- Le Monde du Zob (gris/vert, en bas à droite) -->
    <area shape="rect" coords="715,150,875,250" alt="Le monde du Zob" href="/mondes/zob/" title="Le monde du Zob">
    
    <!-- Le Monde des Rêves (violet, si visible) -->
    <area shape="rect" coords="300,250,400,350" alt="Le monde des rêves" href="/mondes/reves/" title="Le monde des rêves">
    
    <!-- Le Monde Elysée (blanc, si visible) -->
    <area shape="rect" coords="150,350,250,450" alt="Le monde Elysée" href="/mondes/elysee/" title="Le monde Elysée">
  </map>
</div>

## Légende de la carte

- **Rouge** : Le monde de l'assemblée
- **Vert** : Le monde de la grange
- **Bleu** : Le monde des jeux
- **Violet** : Le monde des rêves
- **Bleu clair** : Le monde du damier
- **Violet clair** : Le monde du linge
- **Rose** : Le monde du verger
- **Corail** : Le monde du Zob
- **Blanc** : Le monde Elysée
- **Orange vif** : Le monde Karibu
- **Orange rouge** : Le monde orange des Sphinx

## Connexions entre les mondes

Les mondes de Malvinaland sont interconnectés par des passages mystiques. Chaque monde est relié à plusieurs autres, formant un réseau complexe de chemins à explorer.

<style>
  .carte-container {
    position: relative;
    max-width: 100%;
    margin: 2rem 0;
    text-align: center;
  }
  
  .carte-image {
    max-width: 100%;
    height: auto;
    border: 3px solid #3f51b5;
    border-radius: 12px;
    box-shadow: 0 8px 24px rgba(63, 81, 181, 0.2);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .carte-image:hover {
    transform: scale(1.02);
    box-shadow: 0 12px 32px rgba(63, 81, 181, 0.3);
  }
  
  /* Styles pour les zones cliquables */
  map area {
    cursor: pointer;
    transition: all 0.2s ease;
  }
  
  /* Indicateur visuel pour les zones cliquables */
  .carte-container::after {
    content: "💡 Cliquez sur les mondes colorés pour les explorer !";
    display: block;
    margin-top: 1rem;
    padding: 0.5rem 1rem;
    background: linear-gradient(135deg, #3f51b5, #5c6bc0);
    color: white;
    border-radius: 20px;
    font-size: 0.9rem;
    font-weight: 500;
    box-shadow: 0 4px 12px rgba(63, 81, 181, 0.3);
    animation: pulse 2s infinite;
  }
  
  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.7; }
  }
  
  /* Amélioration de la légende */
  .carte-container + h2 {
    color: #3f51b5;
    border-bottom: 2px solid #3f51b5;
    padding-bottom: 0.5rem;
    margin-top: 3rem;
  }
  
  .carte-container + h2 + ul {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 0.5rem;
    list-style: none;
    padding: 0;
    margin-top: 1rem;
  }
  
  .carte-container + h2 + ul li {
    padding: 0.5rem 1rem;
    background: #f8f9fa;
    border-left: 4px solid #3f51b5;
    border-radius: 4px;
    transition: background-color 0.2s ease;
  }
  
  .carte-container + h2 + ul li:hover {
    background: #e3f2fd;
  }
  
  /* Responsive design */
  @media (max-width: 768px) {
    .carte-container::after {
      font-size: 0.8rem;
      padding: 0.4rem 0.8rem;
    }
    
    .carte-container + h2 + ul {
      grid-template-columns: 1fr;
    }
  }
</style>

<script src="/assets/js/image-loader.js" defer></script>
<script src="/assets/js/carte-interactive.js" defer></script>