/**
 * Script d'enregistrement du Service Worker pour Malvinaland
 * Permet l'utilisation du site en mode hors-ligne
 */

// Vérifier si le navigateur prend en charge les Service Workers
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/service-worker.js')
      .then(registration => {
        console.log('Service Worker enregistré avec succès:', registration.scope);
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