// service-worker.js
const CACHE_NAME = 'goodify-v1.9';

// List of assets' url to cache
const assetsToCache = [
  '/',
  '/assos',
  '/donator',
  '/assets/application.css',
];

// Install event: cache essential assets
self.addEventListener('install', (event) => {
  console.log('installed');
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('cache name to open:', cache);

      return cache.addAll(assetsToCache);
    })
  );
});

// Activate event: clean up old caches
self.addEventListener('activate', (event) => {
  console.log('activated');
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        // cacheNames.map((cache) => caches.delete(cache))
        cacheNames.map((cache) => {
          if (cache !== CACHE_NAME) {
            console.log('cache name to delete', cache);
            return caches.delete(cache); // Delete old caches

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
      console.log('response if exist', response);

      // If there's a cached response, return it
      // If not in cache, fetch from the network
      return response || fetch(event.request)
    })
  );
});
