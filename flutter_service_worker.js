'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "782236127d9dc679bb9a71e39e8432e8",
".git/config": "fa8677fe9b4c4f2a59847215d5824a17",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "37bbdee8936d1084cd9758793d069992",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "806474a33671fafbca651b56a2f3434c",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "c20f105d5fdfd2921cfd188863930839",
".git/logs/refs/heads/main": "dc0cb001cd57fb85d8093d9e0decb6cb",
".git/logs/refs/remotes/origin/main": "b1e9cdb818fb2c4091209fe98131e272",
".git/objects/02/31eb37a2f2a9b657721a68363572b6c0d794f0": "494779e2348c1d8eb03b56c6ea3ec634",
".git/objects/03/2fe904174b32b7135766696dd37e9a95c1b4fd": "80ba3eb567ab1b2327a13096a62dd17e",
".git/objects/0c/7b82c71f7a7a2952887febc025a9df4501d3c5": "ba4ba83355d91c22db088e207f86c4c5",
".git/objects/0e/0a579942b0ad2e992c93b18bb416244c20b06d": "a78c517b4673b8320796b2c8f563c2bd",
".git/objects/0e/852ff2f6737736c552687bf25d456c08c4f5a3": "c2c91442783c909fa17da07fca84588d",
".git/objects/15/e9321b96e71451eaf6c5b9af47f7ba1377562c": "5ae81f408709e03293fde416377f0754",
".git/objects/1d/dd5da5310e811f88d85147ca9979b2b718d40c": "7f083991d53077278fe5de9208a01c9c",
".git/objects/24/47a88cc55e69351611ecb6091426d692c07542": "4e38005845f856a908a185a7aedec828",
".git/objects/31/6ef94aa2edbe73e4ddeb39ddc7f45f50ac317c": "14835b27267ad3e78a7f9f9ae1940e15",
".git/objects/32/6be63ec1df63364faee0250d9cce76af2c79b5": "bcc9fce57ebc43ce4c4adfed2053977c",
".git/objects/33/31d9290f04df89cea3fb794306a371fcca1cd9": "e54527b2478950463abbc6b22442144e",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/41/b0932911c2621a8e30aa8621d768f8a5f621ff": "7d80e334aa6af1db2cf93917f803717b",
".git/objects/42/1383c82e318634817b5d34e1d9b457560cb765": "ba63745ccd13cca5e5bf249f887bc693",
".git/objects/43/1ca67cfdba8a4111a19bb2f49c6a462c88ffc1": "f91d93ed48f5c63257c531bf6425d767",
".git/objects/4f/02e9875cb698379e68a23ba5d25625e0e2e4bc": "254bc336602c9480c293f5f1c64bb4c7",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/59/00cdb901de8ec21b580869c01c70d32e764dae": "498630bca95d427f12739acd32c22b3c",
".git/objects/5a/62b427f6636e6692c4f108b56ebb7e6e655b0e": "f204a1433bf4de1ef679ad330d78e269",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/64/5116c20530a7bd227658a3c51e004a3f0aefab": "f10b5403684ce7848d8165b3d1d5bbbe",
".git/objects/66/ff0b6686e16e2da096144d8f7b8739f545966e": "a25cb02d4513ea25075f711de62314c4",
".git/objects/77/e9bbf93df91971a48fa780a80cc8c88df5862f": "0a77cd92c567eeecd89985cd6cae2e69",
".git/objects/7f/c1adf90a03b21b2376752f9e70b386bd7fafb5": "8ef9901b6ca04ced8be010d915abfdde",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8b/531a6c600533d9b25bd67e6d663f2e95f2b533": "8390669d721d1e8f7a0bf17f61a1a07a",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/92/ab747ed6e2cac143d6891bf3787ec175ac50cf": "1ad12d5e34d8f15ef252c3240d11c287",
".git/objects/93/be7fd9b9dcdd8564dafd7040a0c8c8f68d4080": "b27ff257c793a735fc818ff37f392ff9",
".git/objects/94/e4325a4f94a030289832970f985c191bbd1623": "0745a5157c6f50fc199b3041e7666d81",
".git/objects/9a/3b4ca7a40100cd34a72fb70a10145553dd0b36": "b57d5045349176dc12d054851bb5e2d9",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/aa/ace59d73dfd89ca62911633da78f5d88d4c045": "19a3de06a681f694c8c76604c9a87eee",
".git/objects/b0/0c915a301c8891835721cd7292ff3a21a14462": "15f4d89157582971fb53d610919b9d10",
".git/objects/bb/384a12362c7fcfbd5567f924b31554e7245eaa": "2bc525c26074f7e276478c8a2b7691ab",
".git/objects/bc/190eff1690f7256accab96a96423df833f6d74": "28dc3ecf609186c4f8c6f606cb7ddf34",
".git/objects/cd/4f94436f8bd22793102970a5bb4f6758c59422": "25d4a42d77739a952111c46a00ad2d6d",
".git/objects/ce/8a40fff6a734e9f40ebfcdc20dbe6fd2022986": "c52cc8eef6b3f5f44f8932fe254632c5",
".git/objects/d2/fb0a6d883b20a6859e2bd8d80d32bc9e75cc5a": "914bf8f3692cd72d48dac82680da8ed0",
".git/objects/d3/2cca838ab320b6809cd5146e39747e0d7d6345": "f1eba3705c25dc359a38454b010e0c93",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/d9/8cdd864f70a20450487dfbb47e4f86215bd87e": "e30be2cc6080a0370da4e7826f22a2f4",
".git/objects/dd/f4bfacb396e97546364ccfeeb9c31dfaea4c25": "049d11285bcbd30a249b4dff756126a0",
".git/objects/e1/1db3b262d569aeafa4b07ebc28ae1fa023bcbe": "0623b206c0960c84b402ef537dd4d4c6",
".git/objects/e6/657110cf1f5b2a6965365a808ff8df8dfa2505": "abc88df1e5cc841ebe338415a4eae889",
".git/objects/e7/202eeda6e9d0f9ed75e2458a99c97ce767b38e": "49b5d2562c88d10df91ae737776acabd",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/ef/ba9307b29ced961a8129926185b696ed90de2a": "d91fa51653fffc5ca3f7b16fd54db0cd",
".git/objects/f0/3ed115ffa42f7c0dd50ba9df4db69759151458": "7e7ab0ee4e7da381875b3e7a6f206efc",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f5/a5b7006271bc738bf93db4a13e45ab074874d5": "05538391ccaece3cb5ab5a7cfb616eec",
".git/objects/f9/16f22214a648002f68b9ad2a9cadd76e655665": "044448440d3dc4afd569cd9ff804b431",
".git/objects/fd/f0c6bd0029a5a0f7b19b32b5f7b11713eff642": "388b3bbb48988446e241c927db2cd922",
".git/objects/pack/pack-f815893fb445fc9a2ef7b298c1d09dc7881867aa.idx": "3ba71171cf095725a84969594ea21d40",
".git/objects/pack/pack-f815893fb445fc9a2ef7b298c1d09dc7881867aa.pack": "b935bf41d08e4770770e016dd39934bb",
".git/objects/pack/pack-f815893fb445fc9a2ef7b298c1d09dc7881867aa.rev": "4f6f5e41c968a05e4535e38b475e2d57",
".git/ORIG_HEAD": "6243a18be405f811b28497bb170c1f93",
".git/refs/heads/main": "6243a18be405f811b28497bb170c1f93",
".git/refs/remotes/origin/main": "025528a876b78d449a57d3fefef338df",
"assets/AssetManifest.bin": "29fa8beb18cd7d6c304a790946428de2",
"assets/AssetManifest.bin.json": "1234119a405d3ae7be1a8faed21c6cbf",
"assets/AssetManifest.json": "35595b54d0c37e317407d5fba91c1932",
"assets/FontManifest.json": "d46497f3e73c0b145c0b7d7dde5416a5",
"assets/fonts/MaterialIcons-Regular.otf": "ec7a40eaed3f2113f5a6f0b75e76516a",
"assets/images/alhadiq_icon.png": "d5c8c1847a7e48c3c4b68458b14c3dee",
"assets/images/welcome_image.png": "b03c2fbf2188b36b3cce3030a61e5518",
"assets/NOTICES": "bc59a2455f668679c9d23ba8b2b00b5c",
"assets/packages/awesome_notifications/test/assets/images/test_image.png": "c27a71ab4008c83eba9b554775aa12ca",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "cc26808b75bd1a5529ce7ade2a2ce8c4",
"assets/packages/flutter_islamic_icons/assets/fonts/IslamicIcons.ttf": "83caab3a2c2b140f80725df6ac6e80cc",
"assets/packages/simple_circular_progress_bar/fonts/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "8dbe109b8b3fbdcd51a81774230c3915",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "3e2b973b51103369f86186e0eceeb888",
"icons/Icon-192.png": "d8cbe09599244b871ecf7096e691b8b6",
"icons/Icon-512.png": "aff6768cf12069a97c0a3e5a59a53f2d",
"icons/Icon-maskable-192.png": "d8cbe09599244b871ecf7096e691b8b6",
"icons/Icon-maskable-512.png": "aff6768cf12069a97c0a3e5a59a53f2d",
"index.html": "dfe60fb2f7335cf8ff0f642899a205a9",
"/": "dfe60fb2f7335cf8ff0f642899a205a9",
"main.dart.js": "9378c8c6570b96daa1768a1bb7a698c4",
"manifest.json": "873d71de50ee0e03f1756db9c6d01be9",
"version.json": "ef88edd6d5c63fb14dbc705b28fa014f"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
