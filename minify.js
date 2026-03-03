const fs = require('fs');
const path = require('path');
const esbuild = require('esbuild');

const SERVER_ROOT = path.join(__dirname, 'plugin', 'server');
const SKIP_DIRS = new Set(['libs', 'minified']);
const SUPPORTED_EXTENSIONS = new Set(['.js', '.css']);

function shouldSkipDir(dirName) {
  return SKIP_DIRS.has(dirName.toLowerCase());
}

function collectFilesRecursively(rootDir) {
  const files = [];

  function walk(currentDir) {
    const entries = fs.readdirSync(currentDir, { withFileTypes: true });

    for (const entry of entries) {
      const fullPath = path.join(currentDir, entry.name);

      if (entry.isDirectory()) {
        if (shouldSkipDir(entry.name)) {
          continue;
        }
        walk(fullPath);
        continue;
      }

      const extension = path.extname(entry.name).toLowerCase();
      if (!SUPPORTED_EXTENSIONS.has(extension)) {
        continue;
      }

      if (entry.name.toLowerCase().includes('.min.')) {
        continue;
      }

      files.push(fullPath);
    }
  }

  walk(rootDir);
  return files;
}

async function minifyFile(filePath) {
  const ext = path.extname(filePath).toLowerCase();
  const source = fs.readFileSync(filePath, 'utf8');

  const result = await esbuild.transform(source, {
    loader: ext === '.css' ? 'css' : 'js',
    minify: true,
    legalComments: 'none'
  });

  const targetDir = path.join(path.dirname(filePath), 'minified');
  const parsed = path.parse(filePath);
  const minifiedFileName = `${parsed.name}.min${parsed.ext}`;
  const targetPath = path.join(targetDir, minifiedFileName);

  fs.mkdirSync(targetDir, { recursive: true });
  fs.writeFileSync(targetPath, result.code, 'utf8');

  return targetPath;
}

async function main() {
  if (!fs.existsSync(SERVER_ROOT)) {
    console.error(`Server folder not found: ${SERVER_ROOT}`);
    process.exit(1);
  }

  const files = collectFilesRecursively(SERVER_ROOT);

  if (files.length === 0) {
    console.log('No JS/CSS files found to minify.');
    return;
  }

  let successCount = 0;

  for (const filePath of files) {
    try {
      const outPath = await minifyFile(filePath);
      const relativeIn = path.relative(__dirname, filePath);
      const relativeOut = path.relative(__dirname, outPath);
      console.log(`Minified ${relativeIn} -> ${relativeOut}`);
      successCount += 1;
    } catch (error) {
      const relativeIn = path.relative(__dirname, filePath);
      console.error(`Failed to minify ${relativeIn}`);
      console.error(error.message || error);
      process.exitCode = 1;
    }
  }

  console.log(`\nDone. Minified ${successCount}/${files.length} file(s).`);

  if (process.exitCode) {
    process.exit(process.exitCode);
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
