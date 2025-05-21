/**
 * Service Worker pour Malvinaland
 * Permet la consultation du site en mode hors-ligne
 */

const CACHE_NAME = 'malvinaland-cache-v1';
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
  '/carte/',
  '/mondes/',
  '/narration/'
];

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
          .catch(() => {
            // En cas d'erreur réseau, essayer de servir la page d'accueil
            if (event.request.mode === 'navigate') {
              return caches.match('/');
            }
            
            // Ou une image par défaut pour les requêtes d'images
            if (event.request.destination === 'image') {
              return caches.match('/assets/images/placeholder.png');
            }
          });
      })
  );
});