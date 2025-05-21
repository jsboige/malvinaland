---
layout: layouts/base.njk
title: Accueil - Malvinaland
---

# Bienvenue dans les mondes de Malvinaland

Bienvenue dans l'univers immersif de Malvinaland, un jeu de piste où réalité et imaginaire se rencontrent pour créer une expérience unique. Explorez des mondes fascinants, résolvez des énigmes et découvrez les secrets cachés de ce lieu extraordinaire.

## Les mondes à explorer

<div class="mondes-grid">
{% for monde in collections.mondes %}
  <a href="{{ monde.url }}" class="monde-card" style="--monde-color: {{ mondes[monde.data.monde].couleur }};">
    <h3>{{ mondes[monde.data.monde].icone }} {{ mondes[monde.data.monde].nom }}</h3>
    <p>{{ mondes[monde.data.monde].description }}</p>
  </a>
{% endfor %}
</div>

## L'histoire de Malvinaland

Malvinaland est un lieu où les frontières entre les mondes s'estompent, où chaque espace raconte une histoire et cache des mystères à découvrir. La princesse Malvina, gardienne de ces lieux, a disparu, capturée par le mystérieux Collectionneur d'Âmes. Votre mission, si vous l'acceptez, est d'explorer les différents mondes, de résoudre les énigmes et de retrouver la princesse avant qu'il ne soit trop tard.

Chaque monde possède sa propre atmosphère, ses propres défis et ses propres secrets. En naviguant d'un monde à l'autre, vous découvrirez progressivement les indices qui vous mèneront à la princesse captive.

## Comment jouer

1. **Explorez les mondes** : Visitez chaque monde et imprégnez-vous de son ambiance unique.
2. **Observez attentivement** : Chaque détail peut être un indice.
3. **Résolvez les énigmes** : Chaque monde propose des défis à relever.
4. **Collectez les indices** : Ils vous guideront vers la princesse.
5. **Collaborez** : Certaines énigmes nécessitent la coopération de plusieurs joueurs.

Êtes-vous prêt à vous lancer dans cette aventure extraordinaire ? Choisissez un monde et commencez votre exploration !

<div class="cta-container">
  <a href="/carte/" class="cta-button">Voir la carte des mondes</a>
</div>