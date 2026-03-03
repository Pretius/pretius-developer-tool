const fs = require('fs');
const path = require('path');
const esbuild = require('esbuild');
const archiver = require('archiver');

// Clean server-dist folder
function cleanDist(distPath = path.join(__dirname, 'server-dist')) {
  
  // Create server-dist if it doesn't exist
  if (!fs.existsSync(distPath)) {
    fs.mkdirSync(distPath, { recursive: true });
  }
  
  // Remove all files in server-dist (but keep the folder)
  const files = fs.readdirSync(distPath);
  files.forEach(file => {
    const filePath = path.join(distPath, file);
    if (fs.statSync(filePath).isDirectory()) {
      fs.rmSync(filePath, { recursive: true, force: true });
    } else {
      fs.unlinkSync(filePath);
    }
  });
  
  console.log(`Cleaned ${path.relative(__dirname, distPath)} folder`);
}

function keepOnlyZipFiles(distPath = path.join(__dirname, 'server-dist')) {
  if (!fs.existsSync(distPath)) {
    return;
  }

  const entries = fs.readdirSync(distPath);
  entries.forEach((entry) => {
    const entryPath = path.join(distPath, entry);
    const stat = fs.statSync(entryPath);

    if (stat.isDirectory()) {
      fs.rmSync(entryPath, { recursive: true, force: true });
      return;
    }

    if (path.extname(entry).toLowerCase() !== '.zip') {
      fs.unlinkSync(entryPath);
    }
  });

  console.log(`Kept only zip files in ${path.relative(__dirname, distPath)}`);
}

function preprocessConditionalBlocks(content, { lite = false } = {}) {
  if (!lite) {
    return content;
  }

  const lines = content.split(/\r?\n/);
  const result = [];
  let inConditionalSection = false;
  let includeLine = true;

  lines.forEach((line) => {
    const trimmed = line.trim();

    if (/^(\/\*#conditional\*\/|<!--#conditional-->)$/.test(trimmed)) {
      inConditionalSection = true;
      includeLine = true;
      return;
    }

    if (/^(\/\*#endconditional\*\/|<!--#endconditional-->)$/.test(trimmed)) {
      inConditionalSection = false;
      includeLine = true;
      return;
    }

    if (inConditionalSection) {
      if (/^(\/\/\s*#if\s*!LITE_BUILD|<!--#if\s*!LITE_BUILD-->)$/.test(trimmed)) {
        includeLine = false;
        return;
      }

      if (/^(\/\/\s*#if\s*LITE_BUILD|<!--#if\s*LITE_BUILD-->)$/.test(trimmed)) {
        includeLine = true;
        return;
      }

      if (/^(\/\/\s*#endif|<!--#endif-->)$/.test(trimmed)) {
        includeLine = true;
        return;
      }

      if (includeLine) {
        result.push(line);
      }
      return;
    }

    result.push(line);
  });

  return result.join('\n');
}

// Convert file to data URI
function fileToDataURI(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  return 'data:image/svg+xml,' + encodeURIComponent(content);
}

// Escape string for JavaScript
function escapeForJS(str) {
  return str
    .replace(/\\/g, '\\\\')
    .replace(/`/g, '\\`')
    .replace(/\$/g, '\\$');
}

// Read CSS files and return as embedded JS variables
function getEmbeddedCSS() {
  const cssFiles = [
    { varName: 'cssBuildOptionHighlight', path: 'plugin/server/build-option-highlight/contentBuildOptionHighlight.css' },
    { varName: 'cssApexSpotlight', path: 'plugin/server/dev-bar/apexspotlight.css' },
    { varName: 'cssDevBar', path: 'plugin/server/dev-bar/dev-bar.css' },
    { varName: 'cssDialogCollapse', path: 'plugin/server/revealer/jquery.ui.dialog-collapse.css' },
    { varName: 'cssRevealer', path: 'plugin/server/revealer/revealer.css' }
  ];
  
  let cssVars = '';
  cssFiles.forEach(({ varName, path: cssPath }) => {
    const filePath = path.join(__dirname, cssPath);
    if (fs.existsSync(filePath)) {
      const content = fs.readFileSync(filePath, 'utf8');
      const escaped = escapeForJS(content);
      cssVars += `var ${varName}=\`${escaped}\`;`;
      console.log(`Embedded CSS: ${cssPath}`);
    } else {
      console.warn(`Warning: ${cssPath} not found`);
    }
  });
  
  return cssVars;
}

// Bundle JS files
async function bundleJS({ lite = false, distPath = path.join(__dirname, 'server-dist') } = {}) {
  console.log('Embedding CSS files...');
  const embeddedCSS = getEmbeddedCSS();
  
  console.log('\nEmbedding HTML files...');
  const htmlFiles = [
    { key: 'pretiusDeveloperTool.html', path: 'plugin/server/pretiusDeveloperTool.html' },
    { key: 'revealer.html', path: 'plugin/server/revealer/revealer.html' }
  ];
  
  let htmlVars = '';
  htmlFiles.forEach(({key, path: htmlPath}, index) => {
    const filePath = path.join(__dirname, htmlPath);
    if (fs.existsSync(filePath)) {
      const content = preprocessConditionalBlocks(fs.readFileSync(filePath, 'utf8'), { lite });
      const escaped = escapeForJS(content);
      const varName = index === 0 ? 'htmlPretiusDeveloperTool' : 'htmlRevealer';
      htmlVars += `var ${varName}=\`${escaped}\`;`;
      console.log(`Embedded ${key}`);
    } else {
      console.warn(`Warning: ${htmlPath} not found`);
    }
  });
  
  console.log('\nBundling JS files...');
  const jsFiles = [
    { name: 'pretiusDeveloperTool.js', path: 'plugin/server/pretiusDeveloperTool.js' },
    { name: 'revealer/jquery.ui.dialog-collapse.js', path: 'plugin/server/revealer/jquery.ui.dialog-collapse.js' },
    { name: 'revealer/revealer.js', path: 'plugin/server/revealer/revealer.js' },
    { name: 'revealer/contentRevealer.js', path: 'plugin/server/revealer/contentRevealer.js' },
    { name: 'reload-frame/contentReloadFrame.js', path: 'plugin/server/reload-frame/contentReloadFrame.js' },
    { name: 'build-option-highlight/contentBuildOptionHighlight.js', path: 'plugin/server/build-option-highlight/contentBuildOptionHighlight.js' },
    { name: 'dev-bar/pretiusToolbar.js', path: 'plugin/server/dev-bar/pretiusToolbar.js' },
    { name: 'dev-bar/contentDevBar.js', path: 'plugin/server/dev-bar/contentDevBar.js' },
    { name: 'dev-bar/apexspotlight.js', path: 'plugin/server/dev-bar/apexspotlight.js' },
    { name: 'dev-bar/debugControl.js', path: 'plugin/server/dev-bar/debugControl.js' }
  ];

  // Separate lib files to inject as script tags (not bundled)
  const libFiles = [
    { name: 'libs/mousetrap/mousetrap.min.js', path: 'plugin/server/libs/mousetrap/mousetrap.min.js' },
    { name: 'libs/mousetrap/mousetrap-global-bind.min.js', path: 'plugin/server/libs/mousetrap/mousetrap-global-bind.min.js' },
    { name: 'libs/pako/pako.min.js', path: 'plugin/server/libs/pako/pako.min.js' }
  ];

  const svgFiles = [
    { key: 'fontApexHipster-o.svg', path: 'plugin/server/revealer/fontApexHipster-o.svg' },
    { key: 'fontApexHipster.svg', path: 'plugin/server/revealer/fontApexHipster.svg' }
  ];

  // Create temp entry file (non-lib imports only)
  const tempDir = path.join(__dirname, '.tmp');
  if (!fs.existsSync(tempDir)) {
    fs.mkdirSync(tempDir, { recursive: true });
  }
  const entryPath = path.join(tempDir, 'entry-all.js');
  const entryContent = jsFiles
    .map(file => `import "../${file.path.replace(/\\/g, '/')}";`)
    .join('\n');
  fs.writeFileSync(entryPath, entryContent);

  // Build lib scripts to inject before bundle (no IIFE wrapping - let them set globals)
  console.log('\nInjecting external libraries...');
  let libScripts = '';
  libFiles.forEach(file => {
    const filePath = path.join(__dirname, file.path);
    if (fs.existsSync(filePath)) {
      const content = fs.readFileSync(filePath, 'utf8');
      libScripts += content + '\n';
      console.log(`Embedded library: ${file.path}`);
    }
  });

  // Expose HTML files to window
  console.log('\nExposing HTML files to window...');
  let htmlExpose = '';
  htmlFiles.forEach(({key}, index) => {
    const varName = index === 0 ? 'htmlPretiusDeveloperTool' : 'htmlRevealer';
    htmlExpose += `window.__PDT_HTML__=window.__PDT_HTML__||{};window.__PDT_HTML__["${key}"]=${varName};`;
  });

  console.log('\nEmbedding SVG files...');
  let svgExpose = '';
  svgFiles.forEach(({key, path: svgPath}) => {
    const filePath = path.join(__dirname, svgPath);
    if (fs.existsSync(filePath)) {
      const dataURI = fileToDataURI(filePath);
      svgExpose += `window.__PDT_SVG__=window.__PDT_SVG__||{};window.__PDT_SVG__["${key}"]="${dataURI}";`;
      console.log(`Embedded ${key}`);
    } else {
      console.warn(`Warning: ${svgPath} not found`);
    }
  });

  const banner = `${libScripts}var pdt;${embeddedCSS}${htmlVars}${htmlExpose}${svgExpose}`;

  // Footer: CSS injection + jQuery.load override + expose pdt
  const footer = `(function(){if(typeof document=="undefined")return;let e=document.createElement("style");e.setAttribute("data-pdt","0"),e.textContent=cssBuildOptionHighlight,document.head.appendChild(e);let r=document.createElement("style");r.setAttribute("data-pdt","1"),r.textContent=cssApexSpotlight,document.head.appendChild(r);let n=document.createElement("style");n.setAttribute("data-pdt","2"),n.textContent=cssDevBar,document.head.appendChild(n);let a=document.createElement("style");a.setAttribute("data-pdt","3"),a.textContent=cssDialogCollapse,document.head.appendChild(a);let t=document.createElement("style");t.setAttribute("data-pdt","4"),t.textContent=cssRevealer,document.head.appendChild(t)})();` +
    `(function(){function e(){return typeof window=="undefined"||!window.jQuery?!1:(function(n){var a=n.fn.load;n.fn.load=function(t){var o=t.split("/").pop();if(window.__PDT_HTML__&&window.__PDT_HTML__[o]){this.html(window.__PDT_HTML__[o]);var s=arguments[1]||arguments[0];return typeof s=="function"&&s.call(this),this}return a.apply(this,arguments)}}(window.jQuery),!0)}var r=setInterval(function(){e()&&clearInterval(r)},50);setTimeout(function(){clearInterval(r)},5e3)})();` +
    `globalThis.pdt=pdt;`;

  const outputPath = path.join(distPath, 'pretiusDeveloperTool.bundle.min.js');

  await esbuild.build({
    entryPoints: [entryPath],
    bundle: true,
    format: 'iife',
    sourcemap: true,
    minify: true,
    outfile: outputPath,
    banner: { js: banner },
    footer: { js: footer },
    plugins: [
      {
        name: 'pdt-replacements',
        setup(build) {
          build.onLoad({ filter: /\.js$/ }, async (args) => {
            if (!args.path.includes(path.join('plugin', 'server'))) {
              return null;
            }
            let content = await fs.promises.readFile(args.path, 'utf8');

            content = preprocessConditionalBlocks(content, { lite });

            // Replace apex.server.plugin with apex.server.process
            content = content.replace(/apex\.server\.plugin/g, 'apex.server.process');

            // Replace SVG file references with embedded data URIs
            content = content.replace(/pdt\.opt\.filePrefix\s*\+\s*['"]revealer\/fontApexHipster-o\.svg['"]/g, 'window.__PDT_SVG__["fontApexHipster-o.svg"]');
            content = content.replace(/pdt\.opt\.filePrefix\s*\+\s*['"]revealer\/fontApexHipster\.svg['"]/g, 'window.__PDT_SVG__["fontApexHipster.svg"]');

            // Make pdt shared across modules
            if (args.path.endsWith(path.join('plugin', 'server', 'pretiusDeveloperTool.js'))) {
              content = content.replace(/var\s+pdt\s*=\s*\(function\s*\(\)\s*\{/m, 'pdt = (function () {');
            }

            // Make pretiusRevealer global
            if (args.path.endsWith(path.join('plugin', 'server', 'revealer', 'revealer.js'))) {
              content = content.replace(/var\s+pretiusRevealer\s*=/, 'window.pretiusRevealer =');
            }

            return { contents: content, loader: 'js' };
          });
        }
      }
    ]
  });

  console.log(`\nCreated ${outputPath}`);
}

// Generate source map
function generateSourceMap() {
  // Source maps are generated by esbuild.
}

// Copy deferred files (dev-bar folder)
function copyDeferredFiles({ lite = false, distPath = path.join(__dirname, 'server-dist') } = {}) {
  const devBarSource = path.join(__dirname, 'plugin/server/dev-bar');
  const devBarDest = path.join(distPath, 'dev-bar');
  
  // Create dev-bar folder in server-dist
  if (!fs.existsSync(devBarDest)) {
    fs.mkdirSync(devBarDest, { recursive: true });
  }
  
  // Copy specific deferred files
  const deferredFiles = [
    'debugTakeover.css',
    'debugTakeover.js',
    'debugTakeoverMaster.js',
    'debugTakover.html'
  ];
  
  deferredFiles.forEach(file => {
    const sourcePath = path.join(devBarSource, file);
    const destPath = path.join(devBarDest, file);
    
    if (fs.existsSync(sourcePath)) {
      if (lite && /\.(js|html)$/i.test(file)) {
        const content = fs.readFileSync(sourcePath, 'utf8');
        fs.writeFileSync(destPath, preprocessConditionalBlocks(content, { lite }), 'utf8');
      } else {
        fs.copyFileSync(sourcePath, destPath);
      }
      console.log(`Copied ${file} to dev-bar/`);
    } else {
      console.warn(`Warning: ${file} not found in dev-bar`);
    }
  });
  
  // Copy minified versions
  const minifiedSource = path.join(devBarSource, 'minified');
  const minifiedDest = path.join(devBarDest, 'minified');
  
  if (fs.existsSync(minifiedSource)) {
    if (!fs.existsSync(minifiedDest)) {
      fs.mkdirSync(minifiedDest, { recursive: true });
    }
    
    const minifiedFiles = [
      'debugTakeover.min.css',
      'debugTakeover.min.js',
      'debugTakeoverMaster.min.js'
    ];
    
    minifiedFiles.forEach(file => {
      const sourcePath = path.join(minifiedSource, file);
      const destPath = path.join(minifiedDest, file);
      
      if (fs.existsSync(sourcePath)) {
        fs.copyFileSync(sourcePath, destPath);
        console.log(`Copied ${file} to dev-bar/minified/`);
      }
    });
  }
}

// Create zip archive of server-dist
function createZip({ sourcePath, zipPath, ignore = [] }) {
  return new Promise((resolve, reject) => {
    const output = fs.createWriteStream(zipPath);
    const archive = archiver('zip', { zlib: { level: 9 } });

    output.on('close', () => {
      console.log(`Created ${path.basename(zipPath)} (${archive.pointer()} bytes)`);
      resolve();
    });

    archive.on('error', (err) => reject(err));
    archive.pipe(output);
    
    // Add all contents of server-dist to the zip
    archive.glob('**/*', { 
      cwd: sourcePath,
      ignore
    });
    
    archive.finalize();
  });
}

// Main build function
async function build() {
  console.log('Starting build...\n');

  const regularDistPath = path.join(__dirname, 'server-dist');
  const liteDistPath = path.join(__dirname, '.tmp', 'server-dist-lite');
  
  cleanDist(regularDistPath);
  console.log('');
  
  await bundleJS({ lite: false, distPath: regularDistPath });
  console.log('');
  
  console.log('Copying deferred files...');
  copyDeferredFiles({ lite: false, distPath: regularDistPath });
  console.log('');
  
  console.log('Creating zip archive...');
  await createZip({
    sourcePath: regularDistPath,
    zipPath: path.join(regularDistPath, 'pdt-bundle.zip'),
    ignore: ['pdt-bundle.zip', 'pdt-bundle-lite.zip']
  });
  console.log('');

  console.log('Starting lite build...');
  cleanDist(liteDistPath);
  console.log('');

  await bundleJS({ lite: true, distPath: liteDistPath });
  console.log('');

  console.log('Skipping deferred files for lite build...');
  console.log('');

  console.log('Creating lite zip archive...');
  await createZip({
    sourcePath: liteDistPath,
    zipPath: path.join(regularDistPath, 'pdt-bundle-lite.zip'),
    ignore: ['pdt-bundle.zip', 'pdt-bundle-lite.zip']
  });
  console.log('');

  console.log('Cleaning output folder...');
  keepOnlyZipFiles(regularDistPath);
  console.log('');
  
  console.log('Build complete!');
}

// Run build
build().catch((err) => {
  console.error(err);
  process.exit(1);
});
