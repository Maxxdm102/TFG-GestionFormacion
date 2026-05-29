const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const { findWinRar, createRar } = require('./winrar');

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function isFile(p) {
  try {
    return fs.statSync(p).isFile();
  } catch {
    return false;
  }
}

function listFiles(dir) {
  try {
    return fs.readdirSync(dir);
  } catch {
    return [];
  }
}

function pickNewest(paths) {
  let best = null;
  for (const p of paths) {
    try {
      const stat = fs.statSync(p);
      if (!stat.isFile()) continue;
      if (!best || stat.mtimeMs > best.mtimeMs) best = { p, mtimeMs: stat.mtimeMs };
    } catch {
      // ignore
    }
  }
  return best ? best.p : null;
}

function parseMajorMinor(version) {
  const parts = String(version || '').trim().split('.');
  const major = Number(parts[0]);
  const minor = Number(parts[1]);
  if (!Number.isFinite(major) || !Number.isFinite(minor)) return null;
  return { major, minor };
}

function writeInstalledVersionMarkerFiles(rootDir, mm) {
  const fileName = 'TareasGForma-InstalledVersion.json';
  const payload = JSON.stringify({ major: mm.major, minor: mm.minor, at: new Date().toISOString() }, null, 2);
  const created = [];

  const writeOne = (p) => {
    try {
      fs.mkdirSync(path.dirname(p), { recursive: true });
      fs.writeFileSync(p, payload, 'utf8');
      created.push(p);
    } catch {
      // ignore
    }
  };

  writeOne(path.join(rootDir, fileName));
  writeOne(path.join(rootDir, 'resources', fileName));

  return created;
}

function main() {
  const rootDir = path.resolve(__dirname, '..');
  const pkgPath = path.join(rootDir, 'package.json');
  const distDir = path.join(rootDir, 'dist');
  const winUnpackedDir = path.join(distDir, 'win-unpacked');

  if (!isFile(pkgPath)) {
    console.error('[make-ftp-artifact] No se encontrÃ³ package.json.');
    process.exit(1);
  }

  const pkg = readJson(pkgPath);
  const mm = parseMajorMinor(pkg.version);
  if (!mm) {
    console.error(`[make-ftp-artifact] VersiÃ³n invÃ¡lida en package.json: "${pkg.version}". Se espera X.Y.Z.`);
    process.exit(1);
  }

  if (!fs.existsSync(winUnpackedDir)) {
    console.error('[make-ftp-artifact] No se encontrÃ³ dist/win-unpacked. Ejecuta primero electron-builder.');
    process.exit(1);
  }

  // 1) Generar instalador "siempre el Ãºltimo" (para distribuciÃ³n inicial)
  const installerPrefix = 'TareasGForma-Setup-';
  const installerCandidates = listFiles(distDir)
    .filter((name) => name.startsWith(installerPrefix) && name.toLowerCase().endsWith('.exe'))
    .map((name) => path.join(distDir, name))
    .filter((full) => !full.toLowerCase().endsWith('.exe.blockmap'));

  const newestInstaller = pickNewest(installerCandidates);
  if (newestInstaller) {
    const latestInstallerPath = path.join(distDir, 'TareasGForma-Setup.exe');
    fs.copyFileSync(newestInstaller, latestInstallerPath);
    console.log(`[make-ftp-artifact] Instalador latest: ${path.basename(latestInstallerPath)}`);
  } else {
    console.warn('[make-ftp-artifact] No se encontrÃ³ instalador NSIS en dist/.');
  }

  // 2) Generar paquete WinRAR por versiÃ³n (para el actualizador)
  const rarPath = findWinRar();
  const packageName = `acTareasGForm${mm.major}_${mm.minor}.rar`;
  const packagePath = path.join(distDir, packageName);

  const markerFiles = writeInstalledVersionMarkerFiles(winUnpackedDir, mm);

  try {
    // El actualizador se instala dentro de la carpeta "Actualizador/" del setup principal,
    // pero NO debe ir en el paquete .rar de parches para evitar auto-actualizaciÃ³n en caliente.
    createRar({
      rarPath,
      archivePath: packagePath,
      sourceDir: winUnpackedDir,
      exclude: ['Actualizador\\*']
    });
  } catch (e) {
    console.error(`[make-ftp-artifact] ${e && e.message ? e.message : String(e)}`);
    process.exit(1);
  } finally {
    for (const p of markerFiles) {
      try { fs.rmSync(p, { force: true }); } catch { /* ignore */ }
    }
  }

  console.log(`[make-ftp-artifact] Paquete RAR: ${packageName}`);

  // 3) Generar paquete SFX (con elevacion UAC automática)
  console.log('[make-ftp-artifact] Generando SFX...');
  const sfxResult = spawnSync('node', [path.join(__dirname, 'make-sfx.js')], {
    stdio: 'inherit',
    windowsHide: true
  });

  if (sfxResult.status !== 0) {
    console.error('[make-ftp-artifact] Error al generar el SFX.');
    process.exit(1);
  }
}

main();
