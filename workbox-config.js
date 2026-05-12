module.exports = {
  globDirectory: 'public/',
  globPatterns: ['**/*.{html,css,js,woff2,svg,png,webp,json}'],
  globIgnores: ['**/bundles/**', '**/media/**'],
  swDest: 'public/sw.js',
  maximumFileSizeToCacheInBytes: 5_000_000,
  runtimeCaching: [
    {
      urlPattern: ({ request }) => request.destination === 'image',
      handler: 'CacheFirst',
      options: {
        cacheName: 'images',
        expiration: { maxEntries: 100, maxAgeSeconds: 30 * 24 * 60 * 60 }
      }
    }
  ]
};
