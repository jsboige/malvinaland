/**
 * Service Worker pour Malvinaland
 * Permet la consultation du site en mode hors-ligne.
 *
 * v4 (2026-07-10) — refonte suite aux problèmes de contenu périmé et d'espace
 * organisateurs cassé sur mobile :
 *   1. /organisateurs/* n'est JAMAIS intercepté : le Basic Auth IIS est géré
 *      nativement par le navigateur (dialogue), rien n'est mis en cache.
 *   2. skipWaiting() + clients.claim() : un nouveau SW prend le contrôle dès
 *      son installation — les anciens SW/caches ne persistent plus indéfiniment.
 *   3. Pages HTML (navigations) : network-first (contenu toujours frais),
 *      cache en secours seulement hors ligne.
 *   4. Assets (css/js/images) : cache-first avec mise à jour du cache.
 * Ce fichier est émis par le build Eleventy (passthrough src/service-worker.js).
 */

const CACHE_NAME = 'malvinaland-cache-v4';
const URLS_TO_CACHE = [
  '/',
  '/index.html',
  '/assets/css/main.css',
  '/assets/css/monde.css',
  '/assets/css/organisateur.css',
  '/assets/js/navigation.js',
  '/assets/js/image-loader.js',
  '/assets/js/register-sw.js',
  '/assets/images/carte-malvinaland.png',
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
  '/assets/icons/icon-512x512.png'
];

// Configuration du mode hors ligne
const OFFLINE_PAGE = '/index.html';
const OFFLINE_IMG = '/assets/images/placeholder.png';

// Installation : précache tolérant aux échecs (un 404 ne doit pas bloquer la
// mise à jour du SW) + activation immédiate.
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => Promise.allSettled(URLS_TO_CACHE.map(url => cache.add(url))))
      .then(() => self.skipWaiting())
  );
});

// Activation : purge des anciens caches + prise de contrôle immédiate des
// pages ouvertes (clients.claim), sinon l'ancien SW reste actif indéfiniment.
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys()
      .then(cacheNames => Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      ))
      .then(() => self.clients.claim())
  );
});

// Interception des requêtes
self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);

  // Jamais d'interception : requêtes non-GET, autres origines, espace
  // organisateurs (Basic Auth géré par le navigateur) et le SW lui-même.
  if (event.request.method !== 'GET') return;
  if (url.origin !== self.location.origin) return;
  if (url.pathname.startsWith('/organisateurs')) return;
  if (url.pathname === '/service-worker.js') return;

  // Navigations (pages HTML) : network-first — le contenu publié est toujours
  // servi frais ; le cache ne sert que hors ligne.
  if (event.request.mode === 'navigate') {
    event.respondWith(
      fetch(event.request)
        .then(response => {
          if (response && response.status === 200) {
            const responseToCache = response.clone();
            caches.open(CACHE_NAME).then(cache => cache.put(event.request, responseToCache));
          }
          return response;
        })
        .catch(() => {
          return caches.match(event.request)
            .then(cached => cached || caches.match(OFFLINE_PAGE))
            .then(page => {
              if (page) {
                self.clients.matchAll().then(clients => {
                  clients.forEach(client => {
                    client.postMessage({
                      type: 'OFFLINE_MODE',
                      message: 'Vous êtes actuellement hors ligne. Certaines fonctionnalités peuvent être limitées.'
                    });
                  });
                });
                return page;
              }
              return new Response('Contenu non disponible en mode hors ligne', {
                status: 503,
                statusText: 'Service Unavailable'
              });
            });
        })
    );
    return;
  }

  // Assets : cache-first, réseau en secours avec mise en cache.
  event.respondWith(
    caches.match(event.request)
      .then(cached => {
        if (cached) return cached;
        return fetch(event.request)
          .then(response => {
            if (response && response.status === 200 && response.type === 'basic') {
              const responseToCache = response.clone();
              caches.open(CACHE_NAME).then(cache => cache.put(event.request, responseToCache));
            }
            return response;
          })
          .catch(() => {
            if (event.request.destination === 'image') {
              return caches.match(OFFLINE_IMG)
                .then(img => img || new Response('Image non disponible en mode hors ligne', {
                  status: 503,
                  statusText: 'Service Unavailable'
                }));
            }
            return new Response('Contenu non disponible en mode hors ligne', {
              status: 503,
              statusText: 'Service Unavailable'
            });
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
