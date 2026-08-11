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
