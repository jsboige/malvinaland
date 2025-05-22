---
layout: layouts/base.njk
title: Carte des Mondes
description: Carte interactive des mondes de Malvinaland
---

# Carte des Mondes de Malvinaland

Explorez la carte interactive des mondes de Malvinaland. Chaque monde est représenté par une couleur distinctive et contient ses propres mystères à découvrir.

<div class="carte-container">
  <img src="/assets/images/carte-malvinaland.png?v=20250520" alt="Carte de Malvinaland" class="carte-image" usemap="#carte-map">
  <map name="carte-map">
    <area shape="poly" coords="150,200,200,180,250,200,200,220" alt="Le monde de l'assemblée" href="/mondes/assemblee/" title="Le monde de l'assemblée">
    <area shape="poly" coords="300,150,350,130,400,150,350,170" alt="Le monde de la grange" href="/mondes/grange/" title="Le monde de la grange">
    <area shape="poly" coords="450,200,500,180,550,200,500,220" alt="Le monde des jeux" href="/mondes/jeux/" title="Le monde des jeux">
    <area shape="poly" coords="300,250,350,230,400,250,350,270" alt="Le monde des rêves" href="/mondes/reves/" title="Le monde des rêves">
    <area shape="poly" coords="450,300,500,280,550,300,500,320" alt="Le monde du damier" href="/mondes/damier/" title="Le monde du damier">
    <area shape="poly" coords="150,300,200,280,250,300,200,320" alt="Le monde du linge" href="/mondes/linge/" title="Le monde du linge">
    <area shape="poly" coords="300,350,350,330,400,350,350,370" alt="Le monde du verger" href="/mondes/verger/" title="Le monde du verger">
    <area shape="poly" coords="450,350,500,330,550,350,500,370" alt="Le monde du Zob" href="/mondes/zob/" title="Le monde du Zob">
    <area shape="poly" coords="150,350,200,330,250,350,200,370" alt="Le monde Elysée" href="/mondes/elysee/" title="Le monde Elysée">
    <area shape="poly" coords="300,400,350,380,400,400,350,420" alt="Le monde Karibu" href="/mondes/karibu/" title="Le monde Karibu">
    <area shape="poly" coords="450,400,500,380,550,400,500,420" alt="Le monde orange des Sphinx" href="/mondes/sphinx/" title="Le monde orange des Sphinx">
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
  }
  
  .carte-image {
    max-width: 100%;
    height: auto;
    border: 2px solid #3f51b5;
    border-radius: 8px;
  }
</style>

<script src="/assets/js/image-loader.js" defer></script>