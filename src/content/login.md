---
layout: layouts/base.njk
title: Connexion - Malvinaland
permalink: "/login/"
---

<!-- L'authentification par formulaire (auth.js + sessionStorage) a été retirée :
     elle était purement côté client (contournable) et entrait en conflit avec la
     protection réelle, le Basic Auth IIS sur /organisateurs/*. Cette page ne
     subsiste que pour les anciens liens/favoris : elle renvoie vers l'espace
     organisateurs, où le navigateur affiche le dialogue d'identification. -->

<div class="login-container">
  <h2>Accès organisateurs</h2>
  <p>L'accès organisateurs a changé : les identifiants sont désormais demandés
     directement par votre navigateur.</p>
  <p><a href="/organisateurs/" class="cta-button">Accéder à l'espace organisateurs</a></p>
  <div class="login-footer">
    <p><a href="/">Retour à l'accueil</a></p>
  </div>
</div>

<script>
  // Redirection automatique (les favoris /login/ restent utilisables).
  setTimeout(function () { window.location.replace('/organisateurs/'); }, 1500);
</script>
