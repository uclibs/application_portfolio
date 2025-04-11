// public/sw.js
self.addEventListener("install", function(event) {
  console.log("Service Worker installing.");
});

self.addEventListener("fetch", function(event) {
  // Basic example - pass-through
  return fetch(event.request);
});

