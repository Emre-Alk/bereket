// service-worker.js
const CACHE_NAME = 'goodify-v1.5';

// List of assets' url to cache
const assetsToCache = [
  '/',
  '/assos',
  '/donator',
  'https://www.goodify.fr/assets/application-dcd0508af0592a2634000bf6a5ef6d716a1e5a821b80820b65e79a0e0eb78889.css',
  'https://www.goodify.fr/assets/inter-font-8c3e82affb176f4bca9616b838d906343d1251adc8408efe02cf2b1e4fcf2bc4.css',
  // '/assets/images/default_avatar.png',
  // '/favicon.ico',
];

// Install event: cache essential assets
self.addEventListener('install', (event) => {
  console.log('installed');
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(assetsToCache);
    })
  );
});

// Activate event: clean up old caches
self.addEventListener('activate', (event) => {
  console.log('activated');

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
  console.log('fetch');

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
