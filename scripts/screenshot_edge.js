// Playwright script to open Microsoft Edge and capture 7" and 10" tablet screenshots
// Usage:
// 1) Build and serve Flutter web: `flutter build web` then serve `build/web` on localhost:8000
// 2) Install Playwright: `npm init -y && npm i -D playwright`
// 3) Run: `node screenshot_edge.js http://localhost:8000`

const { chromium } = require('playwright');
const fs = require('fs');

const url = process.argv[2] || 'http://localhost:8000';
const outDir = 'screenshots-edge';

const viewports = [
  { name: '7in-landscape', width: 1024, height: 600 },
  { name: '7in-portrait', width: 600, height: 1024 },
  { name: '10in-landscape', width: 1280, height: 800 },
  { name: '10in-portrait', width: 800, height: 1280 },
];

(async () => {
  if (!fs.existsSync(outDir)) fs.mkdirSync(outDir);
  // Launch Edge if installed. Playwright recognizes the 'msedge' channel.
  const browser = await chromium.launch({ channel: 'msedge', headless: false });
  const context = await browser.newContext();
  const page = await context.newPage();

  for (const vp of viewports) {
    console.log(`Capturing ${vp.name} ${vp.width}x${vp.height}`);
    await page.setViewportSize({ width: vp.width, height: vp.height });
    await page.goto(url, { waitUntil: 'networkidle' });
    // wait for app to render
    await page.waitForTimeout(1200);
    const path = `${outDir}/screenshot-${vp.name}.png`;
    await page.screenshot({ path, fullPage: false });
    console.log(`Saved ${path}`);
  }

  await browser.close();
})();
