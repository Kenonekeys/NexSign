# NexSign — Apple ID Signing (demo)

This repository contains NexSign, a simple demo for generating Apple development certificates.

---

## Index (demo)

Below is the index HTML used for the demo application (placed originally in the README). You can copy this to `public/index.html` or similar to run the demo.

```html name=index.html
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>NexSign — Apple ID Signing</title>
    <style>
      body { font-family: Arial, Helvetica, sans-serif; max-width: 720px; margin: 40px auto; }
      label { display:block; margin-top: 8px }
    </style>
  </head>
  <body>
    <h1>NexSign — Apple ID Signing (demo)</h1>
    <form id="form">
      <label>Bundle ID
        <input name="bundleId" required placeholder="com.example.app" />
      </label>
      <label>Common Name (optional)
        <input name="commonName" placeholder="Developer Name" />
      </label>
      <button type="submit">Request Development Certificate</button>
    </form>

    <pre id="out"></pre>

    <script>
      const form = document.getElementById('form')
      const out = document.getElementById('out')
      form.addEventListener('submit', async e => {
        e.preventDefault()
        const data = Object.fromEntries(new FormData(form))
        out.textContent = 'Requesting...'
        try {
          const res = await fetch('/api/generate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
          })
          const json = await res.json()
          out.textContent = JSON.stringify(json, null, 2)
        } catch (err) {
          out.textContent = String(err)
        }
      })
    </script>
  </body>
</html>
```

---

## Design / Color system

I've included a recommended color system and example styles you can use to restyle the site. Add the CSS below to `assets/colors.css` (or `app/assets/stylesheets/colors.css` if using Rails) and then link it from your layout (e.g. `application.html.erb`) to apply the palette.

Palette (short)

- Primary (brand): #2B3A67 — deep indigo for headers, links, primary CTAs
- Accent (bright): #00BFA6 — lively teal for highlights
- Secondary (warm): #FF6B6B — coral for emphasis
- Background: #F7F9FC — page background
- Surface: #FFFFFF — card backgrounds
- Text: #111827 — body copy
- Muted: #6B7280 — metadata/captions

Add this CSS file at `assets/colors.css`:

```css name=assets/colors.css
:root{
  /* Palette */
  --color-bg: #F7F9FC;
  --color-surface: #FFFFFF;
  --color-primary: #2B3A67;
  --color-primary-600: #213055;
  --color-accent: #00BFA6;
  --color-secondary: #FF6B6B;
  --color-text: #111827;
  --color-muted: #6B7280;
  --color-border: #E6E9F0;
  --color-success: #16A34A;
  --color-warning: #F59E0B;
  --color-error: #EF4444;

  /* Spacing & radius */
  --radius: 10px;
  --shadow-sm: 0 1px 2px rgba(16,24,40,0.04);
  --shadow-md: 0 8px 24px rgba(16,24,40,0.08);
}

/* Dark mode */
@media (prefers-color-scheme: dark) {
  :root{
    --color-bg: #0B1020;
    --color-surface: #0F1724;
    --color-primary: #5160A6;
    --color-accent: #00D3B3;
    --color-secondary: #FF7B7B;
    --color-text: #E6EEF6;
    --color-muted: #9AA6B2;
    --color-border: rgba(255,255,255,0.06);
  }
}

/* Base page */
body{
  background-color: var(--color-bg);
  color: var(--color-text);
  font-family: Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
  line-height: 1.6;
  margin: 0;
}

/* Container */
.container{
  max-width: 1100px;
  margin: 0 auto;
  padding: 2rem;
}

/* Header / nav */
.site-header{
  background: linear-gradient(180deg, color-mix(in srgb, var(--color-primary) 8%, transparent), transparent);
  backdrop-filter: blur(6px);
  border-bottom: 1px solid var(--color-border);
  padding: 1rem 0;
}
.site-header .logo{
  color: var(--color-primary);
  font-weight: 700;
  letter-spacing: -0.02em;
}

/* Hero */
.hero{
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
  padding: 3rem 0;
}
.hero h1{
  color: var(--color-primary);
  font-size: 2.25rem;
  margin: 0 0 0.75rem;
}
.hero p{
  color: var(--color-muted);
  font-size: 1.05rem;
}

/* Primary button */
.btn{
  display: inline-flex;
  align-items: center;
  gap: .5rem;
  padding: .6rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  border: none;
  cursor: pointer;
  transition: transform .12s ease, box-shadow .12s ease;
}
.btn:active{ transform: translateY(1px); }

.btn-primary{
  background: linear-gradient(90deg, var(--color-primary), var(--color-primary-600));
  color: white;
  box-shadow: 0 6px 18px rgba(43,58,103,0.14);
}
.btn-outline{
  background: transparent;
  color: var(--color-primary);
  border: 1px solid var(--color-border);
}

/* Accent CTA */
.accent-pill{
  background-color: var(--color-accent);
  color: white;
  padding: .25rem .6rem;
  border-radius: 999px;
  font-weight: 700;
  font-size: .85rem;
}

/* Cards */
.card{
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
  padding: 1.25rem;
}

/* Code blocks */
pre, code{
  background: linear-gradient(180deg, rgba(15,23,36,0.03), rgba(15,23,36,0.02));
  border-radius: 8px;
  padding: .75rem;
  color: var(--color-text);
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, "Roboto Mono", "Courier New", monospace;
  font-size: .9rem;
  overflow: auto;
}

/* Footer */
.site-footer{
  margin-top: 3rem;
  padding: 2rem 0;
  color: var(--color-muted);
  border-top: 1px solid var(--color-border);
}
```

### Example header usage

```html name=examples/header.html
<header class="site-header">
  <div class="container" style="display:flex;align-items:center;justify-content:space-between;">
    <div class="logo">NexSign</div>
    <nav style="display:flex;gap:1rem;align-items:center;">
      <a href="/" class="btn btn-outline">Docs</a>
      <a href="/download" class="btn btn-primary">Get NexSign</a>
    </nav>
  </div>
</header>

<section class="container hero">
  <div>
    <h1>Easy, secure signing for iOS and the web</h1>
    <p>Sign, validate and manage digital signatures with a simple API and polished UI components.</p>
    <div style="display:flex;gap:.75rem;margin-top:1rem;">
      <a class="btn btn-primary" href="/docs">Get started</a>
      <a class="btn btn-outline" href="/examples">Examples</a>
    </div>
  </div>
</section>
```

---

## Accessibility notes

- Ensure contrast ratios meet WCAG AA. Test using Lighthouse or axe and adjust colors if necessary.
- Provide visible focus styles for interactive controls.
- Respect `prefers-reduced-motion` for animations.

---

## Next steps I can take for you

- (A) Create `assets/colors.css` in the repository and wire it into the layout (I can commit this file and update the layout for you).
- (B) Create a branch + PR with the CSS and a small refactor of the header/hero to use the variables.

If you want me to proceed with (A) or (B), tell me which branch to target (I'll default to `main` if you don't specify).