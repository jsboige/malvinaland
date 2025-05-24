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
  }
  // Authentification spécifique pour les PNJ
  else {
    const pnjCredentials = {
      // Identifiants génériques (du GUIDE_PNJ.md)
      "pnj": "malvina2025",
      // Identifiants spécifiques (de identifiants-test.md)
      "pnj_assemblee": "Pnj@ssemb!",
      "pnj_grange": "Pnj@gr@nge!",
      "pnj_jeux": "Pnj@j3ux!",
      "pnj_reves": "Pnj@r3v3s!",
      "pnj_damier": "Pnj@d@m13r!",
      "pnj_linge": "Pnj@l1ng3!",
      "pnj_verger": "Pnj@v3rg3r!",
      "pnj_zob": "Pnj@z0b!",
      "pnj_elysee": "Pnj@3lys33!",
      "pnj_karibu": "Pnj@k@r1bu!",
      "pnj_sphinx": "Pnj@sph1nx!"
    };

    if (pnjCredentials.hasOwnProperty(username) && pnjCredentials[username] === password) {
      // Stocker l'authentification en session
      sessionStorage.setItem('authenticated', 'true');
      sessionStorage.setItem('userRole', 'pnj'); // Garder 'pnj' comme rôle générique pour la compatibilité
                                                // avec updateAuthUI et updateOrganisateurContent.
                                                // On pourrait stocker le username spécifique si besoin futur.
      
      // Rediriger vers la page d'accueil PNJ
      window.location.href = '/organisateurs/pnj/dashboard/';
    } else {
      // Afficher un message d'erreur si ce n'est ni orga ni PNJ valide
      const errorMessage = document.getElementById('error-message');
      if (errorMessage) {
        errorMessage.textContent = 'Identifiants incorrects';
        errorMessage.style.display = 'block';
      }
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
  const pnjLinks = document.querySelectorAll('.pnj-link');
  
  if (isAuthenticated) {
    // Afficher le lien de déconnexion et masquer le lien de connexion
    authLinks.forEach(link => {
      if (link.classList.contains('login-link')) {
        link.style.display = 'none';
      } else if (link.classList.contains('logout-link')) {
        link.style.display = 'inline-block';
      }
    });
    
    // Afficher les liens selon le rôle
    if (userRole === 'organisateur') {
      // Afficher les liens vers les pages organisateurs
      orgaLinks.forEach(link => {
        link.style.display = 'inline-block';
      });
      
      // Les organisateurs peuvent voir les liens PNJ
      pnjLinks.forEach(link => {
        link.style.display = 'inline-block';
      });
    }
    else if (userRole === 'pnj') {
      // Les PNJ ne voient que les liens PNJ
      orgaLinks.forEach(link => {
        link.style.display = 'none';
      });
      
      pnjLinks.forEach(link => {
        link.style.display = 'inline-block';
      });
    }
  } else {
    // Afficher uniquement le lien de connexion
    authLinks.forEach(link => {
      if (link.classList.contains('login-link')) {
        link.style.display = 'inline-block';
      } else if (link.classList.contains('logout-link')) {
        link.style.display = 'none';
      }
    });
    
    // Masquer les liens vers les pages organisateurs et PNJ
    orgaLinks.forEach(link => {
      link.style.display = 'none';
    });
    
    pnjLinks.forEach(link => {
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
  const pnjContent = document.querySelectorAll('.pnj-only');
  
  // Gestion du contenu organisateur
  if (isAuthenticated && userRole === 'organisateur') {
    // Les organisateurs voient tout
    orgaContent.forEach(el => {
      el.style.display = 'block';
    });
    pnjContent.forEach(el => {
      el.style.display = 'block';
    });
  }
  // Gestion du contenu PNJ
  else if (isAuthenticated && userRole === 'pnj') {
    // Les PNJ ne voient que le contenu PNJ
    orgaContent.forEach(el => {
      el.style.display = 'none';
    });
    pnjContent.forEach(el => {
      el.style.display = 'block';
    });
  }
  else {
    // Non authentifié : masquer tout contenu protégé
    orgaContent.forEach(el => {
      el.style.display = 'none';
    });
    pnjContent.forEach(el => {
      el.style.display = 'none';
    });
  }
}