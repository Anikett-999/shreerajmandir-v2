Instructions to build Flutter web, serve it, and capture 7" and 10" tablet screenshots

1) Build Flutter web

```powershell
cd C:\Users\anike\Downloads\ShreeRajmandirV2
flutter build web
```

2) Serve the built web folder

Using Python (if installed):

```powershell
cd build\web
python -m http.server 8000
```

Or use npx http-server:

```powershell
npx http-server -p 8000
```

3) In a separate terminal, install Puppeteer and run the screenshot script

```powershell
cd C:\Users\anike\Downloads\ShreeRajmandirV2\scripts
npm install puppeteer
node screenshot.js http://localhost:8000
```

4) Output

Screenshots will be saved to `scripts/screenshots/` with names:
- screenshot-7in-landscape.png
- screenshot-7in-portrait.png
- screenshot-10in-landscape.png
- screenshot-10in-portrait.png

Notes:
- Ensure the app loads correctly in a browser build; some platform-specific features (Bluetooth printers, native SDKs) may not work in web.
- If the web build requires additional flags or a different URL, pass the URL as the first argument to the script.
