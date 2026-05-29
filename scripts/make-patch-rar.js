const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

const { findWinRar, createRar } = require('./winrar');

const INSTALLED_VERSION_FILE = 'TareasGForma-InstalledVersion.json';

function isDir(p) {
  try {
    return fs.statSync(p).isDirectory();
  } catch {
    return false;
  }
}

function isFile(p) {
  try {
    return fs.statSync(p).isFile();
  } catch {
    return false;
  }
}

function walkFiles(rootDir) {
  const out = [];
  const stack = [''];
  while (stack.length) {
    const rel = stack.pop();
    const abs = path.join(rootDir, rel);
    let entries;
    try {
      entries = fs.readdirSync(abs, { withFileTypes: true });
    } catch {
      continue;
    }
    for (const ent of entries) {
      const nextRel = path.join(rel, ent.name);
      if (ent.isDirectory()) {
        stack.push(nextRel);
      } else if (ent.isFile()) {
        out.push(nextRel);
      }
    }
  }
  out.sort((a, b) => a.localeCompare(b));
  return out;
}

function sha256File(filePath) {
  const h = crypto.createHash('sha256');
  const buf = fs.readFileSync(filePath);
  h.update(buf);
  return h.digest('hex');
}

function ensureEmptyDir(dir) {
  fs.rmSync(dir, { recursive: true, force: true });
  fs.mkdirSync(dir, { recursive: true });
}

function copyFileEnsuringDir(src, dest) {
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.copyFileSync(src, dest);
}

function usageAndExit() {
  console.error('Uso: node scripts/make-patch-rar.js --prev <dir> --next <dir> --out <archivo.rar>');
  process.exit(2);
}

function parseArgs(argv) {
  const args = { prev: null, next: null, out: null };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--prev') args.prev = argv[++i];
    else if (a === '--next') args.next = argv[++i];
    else if (a === '--out') args.out = argv[++i];
    else if (a === '--help' || a === '-h') usageAndExit();
  }
  if (!args.prev || !args.next || !args.out) usageAndExit();
  return args;
}

function parseTargetMajorMinorFromPatchName(outPath) {
  const base = path.basename(String(outPath || ''));
  const m = base.match(/(\d+)\.(\d+)-to-(\d+)\.(\d+)/i);
  if (!m) return null;
  const major = Number(m[3]);
  const minor = Number(m[4]);
  if (!Number.isFinite(major) || !Number.isFinite(minor)) return null;
  return { major, minor };
}

function writeInstalledVersionMarkerFiles(rootDir, mm) {
  try {
    if (!mm) return;
    const payload = JSON.stringify({ major: mm.major, minor: mm.minor, at: new Date().toISOString() }, null, 2);
    const targets = [
      path.join(rootDir, INSTALLED_VERSION_FILE),
      path.join(rootDir, 'resources', INSTALLED_VERSION_FILE)
    ];
    for (const p of targets) {
      try {
        fs.mkdirSync(path.dirname(p), { recursive: true });
        fs.writeFileSync(p, payload, 'utf8');
      } catch {
        // ignore
      }
    }
  } catch {
    // ignore
  }
}

function main() {
  const { prev, next, out } = parseArgs(process.argv);

  const prevDir = path.resolve(prev);
  const nextDir = path.resolve(next);
  const outPath = path.resolve(out);

  if (!isDir(prevDir)) {
    console.error(`[make-patch-rar] Directorio --prev no válido: ${prevDir}`);
    process.exit(1);
  }
  if (!isDir(nextDir)) {
    console.error(`[make-patch-rar] Directorio --next no válido: ${nextDir}`);
    process.exit(1);
  }

  const shouldIgnore = (rel) => {
    const norm = String(rel || '').replace(/\//g, '\\').toLowerCase();
    return norm === 'actualizador' || norm.startsWith('actualizador\\');
  };

  const prevFiles = walkFiles(prevDir).filter((rel) => !shouldIgnore(rel));
  const nextFiles = walkFiles(nextDir).filter((rel) => !shouldIgnore(rel));

  const prevSet = new Set(prevFiles);
  const nextSet = new Set(nextFiles);

  const deleted = prevFiles.filter((rel) => !nextSet.has(rel));
  const addedOrChanged = [];

  for (const rel of nextFiles) {
    const nextAbs = path.join(nextDir, rel);
    if (!prevSet.has(rel)) {
      addedOrChanged.push(rel);
      continue;
    }
    const prevAbs = path.join(prevDir, rel);
    try {
      const prevStat = fs.statSync(prevAbs);
      const nextStat = fs.statSync(nextAbs);
      if (prevStat.size !== nextStat.size) {
        addedOrChanged.push(rel);
        continue;
      }
    } catch {
      addedOrChanged.push(rel);
      continue;
    }

    // Hash para confirmar
    const prevHash = sha256File(prevAbs);
    const nextHash = sha256File(nextAbs);
    if (prevHash !== nextHash) addedOrChanged.push(rel);
  }

  if (addedOrChanged.length === 0 && deleted.length === 0) {
    console.log('[make-patch-rar] No hay cambios; no se generó parche.');
    process.exit(0);
  }

  const stagingDir = path.join(path.dirname(outPath), `._patch_${Date.now()}`);
  ensureEmptyDir(stagingDir);

  const targetMm = parseTargetMajorMinorFromPatchName(outPath);
  writeInstalledVersionMarkerFiles(stagingDir, targetMm);

  for (const rel of addedOrChanged) {
    copyFileEnsuringDir(path.join(nextDir, rel), path.join(stagingDir, rel));
  }

  if (deleted.length) {
    const delPath = path.join(stagingDir, '_delete.txt');
    fs.writeFileSync(delPath, deleted.join('\n') + '\n', 'utf8');
  }

  const rarPath = findWinRar();
  try {
    createRar({ rarPath, archivePath: outPath, sourceDir: stagingDir });
  } catch (e) {
    console.error(`[make-patch-rar] ${e && e.message ? e.message : String(e)}`);
    process.exit(1);
  } finally {
    try { fs.rmSync(stagingDir, { recursive: true, force: true }); } catch { /* ignore */ }
  }

  if (!isFile(outPath)) {
    console.error('[make-patch-rar] No se generó el archivo de salida.');
    process.exit(1);
  }

  console.log(`[make-patch-rar] Parche generado: ${outPath}`);
  console.log(`[make-patch-rar] Incluye: ${addedOrChanged.length} archivos; elimina: ${deleted.length} archivos.`);
}

main();
