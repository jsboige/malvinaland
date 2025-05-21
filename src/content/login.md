---
layout: layouts/base.njk
title: Connexion - Malvinaland
---

<div class="login-container">
  <h2>Accès Réservé</h2>
  <p>Cette interface est réservée aux organisateurs et PNJ de Malvinaland.</p>
  
  <div class="login-tabs">
    <button class="login-tab active" onclick="switchTab('organisateur')">Organisateur</button>
    <button class="login-tab" onclick="switchTab('pnj')">PNJ</button>
  </div>
  
  <form id="login-form" class="login-form">
    <div id="error-message" style="display: none;"></div>
    
    <div class="form-group">
      <label for="username">Nom d'utilisateur</label>
      <input type="text" id="username" required>
    </div>
    
    <div class="form-group">
      <label for="password">Mot de passe</label>
      <input type="password" id="password" required>
    </div>
    
    <button type="submit">Se connecter</button>
  </form>
  
  <div class="login-help">
    <div id="organisateur-help" class="login-help-content active">
      <h3>Aide Organisateurs</h3>
      <p>En tant qu'organisateur, vous aurez accès à toutes les informations du jeu, y compris les solutions des énigmes et les informations sur tous les PNJ.</p>
      <p>Pour obtenir les identifiants, contactez l'administrateur du jeu.</p>
    </div>
    
    <div id="pnj-help" class="login-help-content">
      <h3>Aide PNJ</h3>
      <p>En tant que PNJ, vous aurez accès à votre fiche personnage, vos tirades et les informations nécessaires pour votre rôle.</p>
      <p>Consultez le <a href="/GUIDE_PNJ.md">Guide PNJ</a> pour plus d'informations sur l'utilisation de l'interface.</p>
    </div>
  </div>
  
  <div class="login-footer">
    <p><a href="/">Retour à l'accueil</a></p>
  </div>
</div>

<script>
  function switchTab(tab) {
    // Mettre à jour les onglets actifs
    document.querySelectorAll('.login-tab').forEach(el => {
      el.classList.remove('active');
    });
    document.querySelector(`.login-tab[onclick*="${tab}"]`).classList.add('active');
    
    // Mettre à jour le contenu d'aide
    document.querySelectorAll('.login-help-content').forEach(el => {
      el.classList.remove('active');
    });
    document.getElementById(`${tab}-help`).classList.add('active');
    
    // Pré-remplir le nom d'utilisateur selon l'onglet
    const usernameInput = document.getElementById('username');
    usernameInput.value = tab;
    
    // Focus sur le champ mot de passe
    document.getElementById('password').focus();
  }
</script>