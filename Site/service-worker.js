/**
 * Service Worker pour Malvinaland
 * Permet la consultation du site en mode hors-ligne
 */

const CACHE_NAME = 'malvinaland-cache-v2';
const URLS_TO_CACHE = [
  '/',
  '/index.html',
  '/assets/css/main.css',
  '/assets/css/monde.css',
  '/assets/css/organisateur.css',
  '/assets/js/navigation.js',
  '/assets/js/auth.js',
  '/assets/js/image-loader.js',
  '/assets/js/fix-mobile-menu.js',
  '/assets/js/register-sw.js',
  '/carte/',
  '/mondes/',
  '/narration/',
  '/personnages/',
  '/manifest.json',
  // Icônes
  '/assets/icons/icon-72x72.png',
  '/assets/icons/icon-96x96.png',
  '/assets/icons/icon-128x128.png',
  '/assets/icons/icon-144x144.png',
  '/assets/icons/icon-152x152.png',
  '/assets/icons/icon-192x192.png',
  '/assets/icons/icon-384x384.png',
  '/assets/icons/icon-512x512.png',
  // Captures d'écran
  '/assets/screenshots/screenshot1.jpg',
  '/assets/screenshots/screenshot2.jpg'
];

// Configuration du mode hors ligne
const OFFLINE_PAGE = '/index.html';
const OFFLINE_IMG = '/assets/images/placeholder.png';

// Installation du service worker
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('Cache ouvert');
        return cache.addAll(URLS_TO_CACHE);
      })
  );
});

// Activation du service worker
self.addEventListener('activate', event => {
  const cacheWhitelist = [CACHE_NAME];
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheWhitelist.indexOf(cacheName) === -1) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

// Interception des requêtes
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // Cache hit - retourner la réponse du cache
        if (response) {
          return response;
        }
        
        // Cloner la requête
        const fetchRequest = event.request.clone();
        
        return fetch(fetchRequest)
          .then(response => {
            // Vérifier si la réponse est valide
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response;
            }
            
            // Cloner la réponse
            const responseToCache = response.clone();
            
            // Mettre en cache la nouvelle ressource
            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });
            
            return response;
          })
          .catch(error => {
            console.error('Erreur de récupération:', error);
            
            // En cas d'erreur réseau, servir le contenu approprié selon le type de requête
            if (event.request.mode === 'navigate') {
              return caches.match(OFFLINE_PAGE)
                .then(response => {
                  if (response) {
                    // Notifier l'utilisateur qu'il est en mode hors ligne
                    self.clients.matchAll().then(clients => {
                      clients.forEach(client => {
                        client.postMessage({
                          type: 'OFFLINE_MODE',
                          message: 'Vous êtes actuellement hors ligne. Certaines fonctionnalités peuvent être limitées.'
                        });
                      });
                    });
                    return response;
                  }
                  return caches.match('/');
                });
            }
            
            // Pour les images, servir une image par défaut
            if (event.request.destination === 'image') {
              return caches.match(OFFLINE_IMG)
                .then(response => {
                  return response || new Response(
                    'Image non disponible en mode hors ligne',
                    { status: 503, statusText: 'Service Unavailable' }
                  );
                });
            }
            
            // Pour les autres ressources, retourner une réponse d'erreur personnalisée
            return new Response(
              'Contenu non disponible en mode hors ligne',
              { status: 503, statusText: 'Service Unavailable' }
            );
          });
      })
  );
});

// Écouter les messages du client
self.addEventListener('message', event => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

// Fonction pour envoyer un message à tous les clients
function sendMessageToAllClients(message) {
  self.clients.matchAll().then(clients => {
    clients.forEach(client => {
      client.postMessage(message);
    });
  });
}

// Vérifier périodiquement la connectivité
self.addEventListener('sync', event => {
  if (event.tag === 'connectivity-check') {
    event.waitUntil(
      fetch('/manifest.json')
        .then(() => {
          sendMessageToAllClients({
            type: 'ONLINE_MODE',
            message: 'Vous êtes de nouveau en ligne'
          });
        })
        .catch(() => {
          sendMessageToAllClients({
            type: 'OFFLINE_MODE',
            message: 'Vous êtes toujours hors ligne'
          });
        })
    );
  }
});