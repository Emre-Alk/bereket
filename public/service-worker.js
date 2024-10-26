// service-worker.js
const CACHE_NAME = 'goodify-v2';

// List of assets to cache
const ASSETS_TO_CACHE = [
  '/',                            // Main HTML
  '/assos',                       // Main HTML file
  '/donator',                     // Main HTML file
  '/images/logo.png',             // Essential images
  '/images/icon-192x192.png',     // Icons
  '/images/icon-512x512.png',     // Icons
  '/manifest.json',               // Manifest file
  '/service-worker.js',
  'scan_icon.svg',
  '/assets/tailwind-a6e6b660ecfe4481c6ce578a28986ccd8a1b7468842897188fd96ce1b2ca3580.css',
  '/assets/inter-font-8c3e82affb176f4bca9616b838d906343d1251adc8408efe02cf2b1e4fcf2bc4.css',
  '/assets/application-f290d9b5e2569d77b8cedb026d0bbdf32da69a2228e1c8e666c8be271ee2327c.css',

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
