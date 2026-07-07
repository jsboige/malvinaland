---
layout: layouts/base.njk
title: Carte des Mondes
description: Carte interactive des mondes de Malvinaland
permalink: "/carte/"
---

# Carte des Mondes de Malvinaland

Explorez la carte interactive des mondes de Malvinaland. Chaque monde est représenté par une couleur distinctive et contient ses propres mystères à découvrir.

<!-- CARTE INTERACTIVE — zones cliquables positionnées en POURCENTAGE. -->
<!-- Elles suivent l'échelle de l'image sur tout écran (mobile compris), -->
<!-- contrairement à une <map>/<area> à coordonnées fixes qui ne marche qu'à la taille de référence. -->
<div class="carte-container-simple">
  <div class="carte-stage">
    <img src="/assets/images/carte-malvinaland.png"
         alt="Carte de Malvinaland"
         class="carte-image-simple"
         id="carte-interactive">

    <a class="carte-zone" href="/mondes/grange/" aria-label="Le Monde de la Grange" style="left:11.867%;top:33.129%;width:25.746%;height:24.438%;"><span>🌾 La Grange</span></a>
    <a class="carte-zone" href="/mondes/sphinx/" aria-label="Le Monde des Sphinx" style="left:46.010%;top:11.554%;width:21.652%;height:24.438%;"><span>🦁 Les Sphinx</span></a>
    <a class="carte-zone" href="/mondes/linge/" aria-label="Le Monde du Linge" style="left:71.062%;top:11.554%;width:16.516%;height:22.495%;"><span>👗 Le Linge</span></a>
    <a class="carte-zone" href="/mondes/verger/" aria-label="Le Monde du Verger" style="left:77.307%;top:35.787%;width:19.292%;height:23.415%;"><span>🍎 Le Verger</span></a>
    <a class="carte-zone" href="/mondes/damier/" aria-label="Le Monde du Damier" style="left:66.967%;top:56.851%;width:17.627%;height:22.904%;"><span>♟️ Le Damier</span></a>
    <a class="carte-zone" href="/mondes/zob/" aria-label="Le Monde du Zob" style="left:84.941%;top:73.926%;width:15.059%;height:26.074%;"><span>🎪 Le Zob</span></a>
    <a class="carte-zone" href="/mondes/karibu/" aria-label="Le Monde Karibu" style="left:49.549%;top:64.928%;width:22.207%;height:32.720%;"><span>🔥 Karibu</span></a>
    <a class="carte-zone" href="/mondes/assemblee/" aria-label="Le Monde de l'Assemblée" style="left:29.285%;top:67.076%;width:18.043%;height:25.051%;"><span>🏛️ L'Assemblée</span></a>
    <a class="carte-zone" href="/mondes/jeux/" aria-label="Le Monde des Jeux" style="left:5.344%;top:60.327%;width:20.541%;height:24.131%;"><span>🎮 Les Jeux</span></a>
    <a class="carte-zone" href="/mondes/elysee/" aria-label="Le Monde Elysée" style="left:12.977%;top:16.360%;width:23.803%;height:16.258%;"><span>🏰 Elysée</span></a>
    <a class="carte-zone" href="/mondes/reves/" aria-label="Le Monde des Rêves" style="left:41.013%;top:37.014%;width:22.068%;height:24.540%;"><span>🌙 Les Rêves</span></a>
  </div>
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

  /* Étage de positionnement : enveloppe l'image et sert de repère aux zones % */
  .carte-stage {
    position: relative;
    display: inline-block;
    width: 100%;
    max-width: 1441px;
    line-height: 0;
  }

  .carte-image-simple {
    width: 100%;
    height: auto;
    max-width: 1441px;
    border: 3px solid #3f51b5;
    border-radius: 12px;
    box-shadow: 0 8px 24px rgba(63, 81, 181, 0.2);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }

  /* ZONES CLIQUABLES EN POURCENTAGE — suivent l'échelle de l'image (OK mobile) */
  .carte-zone {
    position: absolute;
    box-sizing: border-box;
    border-radius: 10px;
    text-decoration: none;
    display: flex;
    align-items: flex-start;
    justify-content: center;
    -webkit-tap-highlight-color: rgba(63, 81, 181, 0.25);
    transition: background-color 0.15s ease, box-shadow 0.15s ease;
  }

  .carte-zone span {
    margin-top: 6%;
    padding: 0.25rem 0.65rem;
    font-size: clamp(0.7rem, 2.4vw, 0.95rem);
    font-weight: 700;
    line-height: 1.2;
    color: #fff;
    background: rgba(63, 81, 181, 0.94);
    border-radius: 999px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.25);
    opacity: 0;
    transform: translateY(-4px);
    transition: opacity 0.15s ease, transform 0.15s ease;
    pointer-events: none;
    white-space: nowrap;
  }

  .carte-zone:hover,
  .carte-zone:focus-visible {
    background: rgba(63, 81, 181, 0.18);
    box-shadow: 0 0 0 3px rgba(63, 81, 181, 0.85) inset;
    outline: none;
  }

  .carte-zone:hover span,
  .carte-zone:focus-visible span {
    opacity: 1;
    transform: translateY(0);
  }

  .carte-zone:focus-visible {
    outline: 3px solid #ffffff;
    outline-offset: -3px;
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

    /* Sur très petit écran, les libellés de zone gênent : on ne les montre qu'au focus clavier */
    .carte-zone:hover span { opacity: 0; }
    .carte-zone:focus-visible span { opacity: 1; }
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
    .carte-zone,
    .carte-zone span,
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

    .carte-zone:hover,
    .carte-zone:focus-visible {
      box-shadow: 0 0 0 3px #000 inset;
    }

    .carte-container-simple + h2 + ul li {
      border: 2px solid #000;
    }
  }
</style>
