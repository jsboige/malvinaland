---
layout: layouts/organisateur.njk
title: Dashboard PNJ - Malvinaland
---

<div class="pnj-dashboard">
  <div class="dashboard-header">
    <h1>Dashboard PNJ</h1>
    <div class="dashboard-actions">
      <button id="emergency-mode-button" class="emergency-button" onclick="toggleEmergencyMode()">
        <span class="icon">🚨</span> Mode Urgence
      </button>
      <button id="filter-toggle" class="filter-button" onclick="toggleFilterPanel()">
        <span class="icon">🔍</span> Filtrer
      </button>
    </div>
  </div>

  <div id="filter-panel" class="filter-panel" style="display: none;">
    <div class="filter-group">
      <label for="monde-filter">Filtrer par monde:</label>
      <select id="monde-filter" onchange="filterPNJContent()">
        <option value="all">Tous les mondes</option>
        <option value="reves">Monde des Rêves</option>
        <option value="verger">Monde du Verger</option>
        <option value="jeux">Monde des Jeux</option>
        <option value="damier">Monde du Damier</option>
        <option value="elysee">Monde Elysée</option>
        <option value="sphinx">Monde des Sphinx</option>
        <option value="zob">Monde du Zob</option>
      </select>
    </div>
    <div class="filter-group">
      <label for="pnj-filter">Filtrer par PNJ:</label>
      <select id="pnj-filter" onchange="filterPNJContent()">
        <option value="all">Tous les PNJ</option>
        <option value="celestine">Madame Célestine</option>
        <option value="lili">Liliane "Lili"</option>
        <option value="gardien-verger">Gardien du Verger</option>
        <option value="collectionneur">Collectionneur d'Âmes</option>
        <option value="princesse">Princesse Malvina</option>
      </select>
    </div>
    <div class="filter-group">
      <label for="search-input">Recherche rapide:</label>
      <input type="text" id="search-input" placeholder="Mot-clé..." oninput="filterPNJContent()">
    </div>
  </div>

  <div class="quick-access">
    <h2>Accès rapide</h2>
    <div class="quick-access-grid">
      <a href="/organisateurs/pnj/celestine/" class="quick-access-card" data-pnj="celestine" data-monde="reves">
        <div class="card-icon">👩‍🦳</div>
        <div class="card-title">Madame Célestine</div>
      </a>
      <a href="/organisateurs/pnj/lili/" class="quick-access-card" data-pnj="lili" data-monde="jeux reves">
        <div class="card-icon">👧</div>
        <div class="card-title">Liliane "Lili"</div>
      </a>
      <a href="/organisateurs/pnj/gardien-verger/" class="quick-access-card" data-pnj="gardien-verger" data-monde="verger">
        <div class="card-icon">👨‍🌾</div>
        <div class="card-title">Gardien du Verger</div>
      </a>
      <a href="/organisateurs/pnj/collectionneur/" class="quick-access-card" data-pnj="collectionneur" data-monde="damier">
        <div class="card-icon">🧙‍♂️</div>
        <div class="card-title">Collectionneur d'Âmes</div>
      </a>
      <a href="/organisateurs/pnj/princesse/" class="quick-access-card" data-pnj="princesse" data-monde="all">
        <div class="card-icon">👸</div>
        <div class="card-title">Princesse Malvina</div>
      </a>
    </div>
  </div>

  <div class="tirades-section">
    <h2>Tirades importantes</h2>
    <div class="tirades-container" id="tirades-container">
      <!-- Les tirades seront filtrées dynamiquement ici -->
      <div class="tirade" data-pnj="celestine" data-monde="reves">
        <div class="tirade-header">
          <h3>Accueil des visiteurs</h3>
          <span class="tirade-meta">Madame Célestine - Monde des Rêves</span>
        </div>
        <div class="tirade-content">
          "Les rêves nous parlent toujours, mais savons-nous écouter? Bienvenue dans le Monde des Rêves, où les frontières entre l'imaginaire et le réel s'estompent. Je suis Madame Célestine, votre guide dans ce voyage onirique."
        </div>
      </div>
      
      <div class="tirade" data-pnj="lili" data-monde="jeux">
        <div class="tirade-header">
          <h3>Introduction à l'énigme principale</h3>
          <span class="tirade-meta">Liliane "Lili" - Monde des Jeux</span>
        </div>
        <div class="tirade-content">
          "C'est comme un jeu, mais pour de vrai! La princesse disait toujours que les secrets se cachent dans les endroits qu'on regarde trop pour vraiment les voir. Avez-vous bien regardé les motifs sur les cartes?"
        </div>
      </div>
      
      <div class="tirade" data-pnj="gardien-verger" data-monde="verger">
        <div class="tirade-header">
          <h3>Indice pour l'énigme des fruits</h3>
          <span class="tirade-meta">Gardien du Verger - Monde du Verger</span>
        </div>
        <div class="tirade-content">
          "Chaque fruit a son temps, chaque graine sa saison. Les arbres parlent à ceux qui savent écouter. Observez l'ordre dans lequel les fruits mûrissent, et vous trouverez la clé de l'énigme."
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  // Fonction pour activer/désactiver le mode urgence
  function toggleEmergencyMode() {
    document.body.classList.toggle('emergency-mode');
    
    const button = document.getElementById('emergency-mode-button');
    if (document.body.classList.contains('emergency-mode')) {
      button.innerHTML = '<span class="icon">✓</span> Mode Normal';
      localStorage.setItem('emergencyMode', 'true');
    } else {
      button.innerHTML = '<span class="icon">🚨</span> Mode Urgence';
      localStorage.setItem('emergencyMode', 'false');
    }
  }
  
  // Fonction pour afficher/masquer le panneau de filtrage
  function toggleFilterPanel() {
    const filterPanel = document.getElementById('filter-panel');
    if (filterPanel.style.display === 'none') {
      filterPanel.style.display = 'flex';
    } else {
      filterPanel.style.display = 'none';
    }
  }
  
  // Fonction pour filtrer le contenu PNJ
  function filterPNJContent() {
    const mondeFilter = document.getElementById('monde-filter').value;
    const pnjFilter = document.getElementById('pnj-filter').value;
    const searchInput = document.getElementById('search-input').value.toLowerCase();
    
    // Filtrer les cartes d'accès rapide
    const quickAccessCards = document.querySelectorAll('.quick-access-card');
    quickAccessCards.forEach(card => {
      const cardPNJ = card.getAttribute('data-pnj');
      const cardMondes = card.getAttribute('data-monde').split(' ');
      
      let showCard = true;
      
      // Filtre par PNJ
      if (pnjFilter !== 'all' && cardPNJ !== pnjFilter) {
        showCard = false;
      }
      
      // Filtre par monde
      if (mondeFilter !== 'all' && !cardMondes.includes(mondeFilter) && !cardMondes.includes('all')) {
        showCard = false;
      }
      
      // Filtre par recherche
      if (searchInput && !card.textContent.toLowerCase().includes(searchInput)) {
        showCard = false;
      }
      
      card.style.display = showCard ? 'flex' : 'none';
    });
    
    // Filtrer les tirades
    const tirades = document.querySelectorAll('.tirade');
    tirades.forEach(tirade => {
      const tiradePNJ = tirade.getAttribute('data-pnj');
      const tiradeMonde = tirade.getAttribute('data-monde');
      
      let showTirade = true;
      
      // Filtre par PNJ
      if (pnjFilter !== 'all' && tiradePNJ !== pnjFilter) {
        showTirade = false;
      }
      
      // Filtre par monde
      if (mondeFilter !== 'all' && tiradeMonde !== mondeFilter) {
        showTirade = false;
      }
      
      // Filtre par recherche
      if (searchInput && !tirade.textContent.toLowerCase().includes(searchInput)) {
        showTirade = false;
      }
      
      tirade.style.display = showTirade ? 'block' : 'none';
    });
  }
  
  // Appliquer les préférences utilisateur au chargement
  document.addEventListener('DOMContentLoaded', function() {
    const isEmergencyMode = localStorage.getItem('emergencyMode') === 'true';
    if (isEmergencyMode) {
      document.body.classList.add('emergency-mode');
      const button = document.getElementById('emergency-mode-button');
      button.innerHTML = '<span class="icon">✓</span> Mode Normal';
    }
  });
</script>