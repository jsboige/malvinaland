/**
 * Script d'enregistrement du Service Worker pour Malvinaland
 * Permet l'utilisation du site en mode hors-ligne.
 *
 * v4 : auto-guérison des appareils avec un ancien SW/cache périmé.
 * - updateViaCache 'none' : le navigateur revalide toujours le SW au réseau.
 * - registration.update() : force une vérification de mise à jour à chaque visite.
 * - controllerchange → reload : quand un nouveau SW prend le contrôle
 *   (skipWaiting + clients.claim côté SW), la page se recharge une fois pour
 *   servir immédiatement le contenu frais au lieu de l'ancien cache.
 */

// Vérifier si le navigateur prend en charge les Service Workers
if ('serviceWorker' in navigator) {
  // Recharger la page (une seule fois) quand un NOUVEAU SW remplace un ancien :
  // les visiteurs avec un ancien cache reçoivent le contenu frais sans action.
  // Pas de reload à la toute première visite (aucun contrôleur avant).
  let hadController = !!navigator.serviceWorker.controller;
  let refreshing = false;
  navigator.serviceWorker.addEventListener('controllerchange', () => {
    if (!hadController) { hadController = true; return; }
    if (refreshing) return;
    refreshing = true;
    window.location.reload();
  });

  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/service-worker.js', { updateViaCache: 'none' })
      .then(registration => {
        console.log('Service Worker enregistré avec succès:', registration.scope);
        // Vérifier immédiatement s'il existe une version plus récente du SW.
        registration.update().catch(() => {});
      })
      .catch(error => {
        console.error('Erreur lors de l\'enregistrement du Service Worker:', error);
      });
  });
}

// Afficher un message lorsque l'utilisateur est hors ligne
window.addEventListener('online', () => {
  document.body.classList.remove('offline-mode');

  // Afficher une notification
  const notification = document.createElement('div');
  notification.className = 'online-notification';
  notification.textContent = 'Vous êtes de nouveau en ligne';
  document.body.appendChild(notification);

  // Supprimer la notification après 3 secondes
  setTimeout(() => {
    notification.remove();
  }, 3000);
});

window.addEventListener('offline', () => {
  document.body.classList.add('offline-mode');

  // Afficher une notification
  const notification = document.createElement('div');
  notification.className = 'offline-notification';
  notification.textContent = 'Vous êtes hors ligne. Certaines fonctionnalités peuvent être limitées.';
  document.body.appendChild(notification);

  // Supprimer la notification après 5 secondes
  setTimeout(() => {
    notification.remove();
  }, 5000);
});
