// screenshots for 7" and 10" tablets using Puppeteer
// Usage:
// 1) Build and serve the Flutter web app (see README below)
// 2) Install puppeteer: npm install puppeteer
// 3) Run: node screenshot.js http://localhost:8000

const puppeteer = require('puppeteer');
const fs = require('fs');

const url = process.argv[2] || 'http://localhost:8000';
const outDir = 'screenshots';

const viewports = [
  { name: '7in-landscape', width: 1024, height: 600 },
  { name: '7in-portrait', width: 600, height: 1024 },
  { name: '10in-landscape', width: 1280, height: 800 },
  { name: '10in-portrait', width: 800, height: 1280 },
];

async function run() {
  if (!fs.existsSync(outDir)) fs.mkdirSync(outDir);
  const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox'] });
  const page = await browser.newPage();

  for (const vp of viewports) {
    console.log(`Capturing ${vp.name} ${vp.width}x${vp.height}`);
    await page.setViewport({ width: vp.width, height: vp.height, deviceScaleFactor: 1 });
    await page.goto(url, { waitUntil: 'networkidle2', timeout: 0 });
    // allow possible app animations to settle
    await page.waitForTimeout(1000);
    const path = `${outDir}/screenshot-${vp.name}.png`;
    await page.screenshot({ path, fullPage: false });
    console.log(`Saved ${path}`);
  }

  await browser.close();
}

run().catch(err => { console.error(err); process.exit(1); });
