# Deployment Guide: Engraved Studios (WASM)

## 2025 Flutter Web Build (WASM)

To achieve 120fps+ performance on supported browsers, we build with WebAssembly.

### Build Command
```bash
flutter build web --wasm --release
```

### Pre-requisites
- Flutter 3.22+ (or Master channel)
- Browser with GC support (Chrome 119+, Firefox 120+, Safari 17.4+)

### Hosting Configuration
WASM requires specific HTTP headers (`Cross-Origin-Opener-Policy` and `Cross-Origin-Embedder-Policy`) to enable `SharedArrayBuffer`.

#### Vercel (`vercel.json`)
```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Cross-Origin-Opener-Policy",
          "value": "same-origin"
        },
        {
          "key": "Cross-Origin-Embedder-Policy",
          "value": "require-corp"
        }
      ]
    }
  ]
}
```

### SEO
Ensure `index.html` has the correct meta tags populated in `<head>`.
