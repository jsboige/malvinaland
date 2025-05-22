/**
 * Script d'authentification pour Malvinaland
 * Gère l'authentification des organisateurs
 */

document.addEventListener('DOMContentLoaded', function() {
  // Initialiser l'authentification
  initAuth();
  
  // Afficher/masquer le contenu réservé aux organisateurs
  updateOrganisateurContent();
});

/**
 * Initialise l'authentification
 */
function initAuth() {
  // Vérifier si l'utilisateur est déjà authentifié
  const isAuthenticated = sessionStorage.getItem('authenticated') === 'true';
  const userRole = sessionStorage.getItem('userRole');
  
  // Mettre à jour l'interface utilisateur
  updateAuthUI(isAuthenticated, userRole);
  
  // Ajouter les gestionnaires d'événements pour le formulaire de connexion
  const loginForm = document.getElementById('login-form');
  if (loginForm) {
    loginForm.addEventListener('submit', handleLogin);
  }
  
  // Ajouter le gestionnaire d'événements pour la déconnexion
  const logoutButton = document.getElementById('logout-button');
  if (logoutButton) {
    logoutButton.addEventListener('click', handleLogout);
  }
}

/**
 * Gère la soumission du formulaire de connexion
 * @param {Event} event - L'événement de soumission du formulaire
 */
function handleLogin(event) {
  event.preventDefault();
  
  const username = document.getElementById('username').value;
  const password = document.getElementById('password').value;
  
  // Dans un environnement de production, cette vérification serait faite côté serveur
  // Pour ce prototype, nous utilisons une vérification côté client simple
  if (username === 'organisateur' && password === 'malvinaland2025') {
    // Stocker l'authentification en session
    sessionStorage.setItem('authenticated', 'true');
    sessionStorage.setItem('userRole', 'organisateur');
    
    // Rediriger vers la page d'accueil organisateurs
    window.location.href = '/organisateurs/';
  } else {
    // Afficher un message d'erreur
    const errorMessage = document.getElementById('error-message');
    if (errorMessage) {
      errorMessage.textContent = 'Identifiants incorrects';
      errorMessage.style.display = 'block';
    }
  }
}

/**
 * Gère la déconnexion
 * @param {Event} event - L'événement de clic sur le bouton de déconnexion
 */
function handleLogout(event) {
  event.preventDefault();
  
  // Supprimer l'authentification
  sessionStorage.removeItem('authenticated');
  sessionStorage.removeItem('userRole');
  
  // Rediriger vers la page d'accueil
  window.location.href = '/';
}

/**
 * Met à jour l'interface utilisateur en fonction de l'état d'authentification
 * @param {boolean} isAuthenticated - Indique si l'utilisateur est authentifié
 * @param {string} userRole - Le rôle de l'utilisateur
 */
function updateAuthUI(isAuthenticated, userRole) {
  const authLinks = document.querySelectorAll('.auth-link');
  const orgaLinks = document.querySelectorAll('.orga-link');
  
  if (isAuthenticated && userRole === 'organisateur') {
    // Afficher les liens pour les organisateurs
    authLinks.forEach(link => {
      if (link.classList.contains('login-link')) {
        link.style.display = 'none';
      } else if (link.classList.contains('logout-link')) {
        link.style.display = 'inline-block';
      }
    });
    
    // Afficher les liens vers les pages organisateurs
    orgaLinks.forEach(link => {
      link.style.display = 'inline-block';
    });
  } else {
    // Afficher uniquement le lien de connexion
    authLinks.forEach(link => {
      if (link.classList.contains('login-link')) {
        link.style.display = 'inline-block';
      } else if (link.classList.contains('logout-link')) {
        link.style.display = 'none';
      }
    });
    
    // Masquer les liens vers les pages organisateurs
    orgaLinks.forEach(link => {
      link.style.display = 'none';
    });
  }
}

/**
 * Affiche/masque le contenu réservé aux organisateurs
 */
function updateOrganisateurContent() {
  const isAuthenticated = sessionStorage.getItem('authenticated') === 'true';
  const userRole = sessionStorage.getItem('userRole');
  
  const orgaContent = document.querySelectorAll('.organisateurs-only');
  
  if (isAuthenticated && userRole === 'organisateur') {
    // Afficher le contenu réservé aux organisateurs
    orgaContent.forEach(el => {
      el.style.display = 'block';
    });
  } else {
    // Masquer le contenu réservé aux organisateurs
    orgaContent.forEach(el => {
      el.style.display = 'none';
    });
  }
}