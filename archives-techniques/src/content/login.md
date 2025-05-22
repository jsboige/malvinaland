---
layout: layouts/base.njk
title: Connexion - Malvinaland
---

<div class="login-container">
  <h2>Accès Organisateurs</h2>
  <p>Cette interface est réservée aux organisateurs de Malvinaland.</p>
  
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
  
  <div class="login-footer">
    <p>Pour obtenir les identifiants, contactez l'organisateur du jeu.</p>
    <p><a href="/">Retour à l'accueil</a></p>
  </div>
</div>