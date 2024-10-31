// service-worker.js
const CACHE_NAME = 'goodify-v1.3';

// List of assets to cache
const ASSETS_TO_CACHE = [
  './',
  './assos',
  './donator',
  './images/logo.png',
  './assets/images/avatar.jpeg',
  './assets/config/manifest.json',
  './service-worker.js',
  './assets/images/scan_icon.svg',
  './assets/stylesheets/application.css',
  './assets/stylesheets/application.tailwind.css',
  './javascript/application.js'
];

// Install event: cache essential assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(ASSETS_TO_CACHE);
    })
  );
});

// Activate event: clean up old caches
self.addEventListener('activate', (event) => {
  const cacheWhitelist = [CACHE_NAME]; // Keep only the latest cache
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheWhitelist.indexOf(cacheName) === -1) {
            return caches.delete(cacheName); // Delete old caches
          }
        })
      );
    })
  );
});

// Fetch event: respond with cached resources or fetch from the network
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      // If there's a cached response, return it
      if (response) {
        return response; // Return the cached version if available
      }

      // If not in cache, fetch from the network
      return fetch(event.request).then((response) => {
        // Cache the new response for future use
        return caches.open(CACHE_NAME).then((cache) => {
          cache.put(event.request, response.clone()); // Cache the response
          return response; // Return the network response
        });
      });
    })
  );
});
