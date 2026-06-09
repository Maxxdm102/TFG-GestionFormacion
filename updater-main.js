const { app, BrowserWindow, ipcMain, shell } = require('electron');
const path = require('path');
const fs = require('fs');
const http = require('http');
const https = require('https');
const { spawn } = require('child_process');
const { path7za } = require('7zip-bin');

let mainWindow;
let abortController = null;

const CONFIG = {
  serviceUrl: 'http://intecodistribucionsrv.intecoingenieria.com/distribucionsrv.asmx',
  appId: 40,
  fullPrefix: 'TareasGForma-Full-',
  patchPrefix: 'TareasGForma-Patch-',
  // base.update -> "1.6" dentro del nombre. Base fija a 1 por lo que hablamos.
  baseVersion: 1
};

const INSTALLED_VERSION_FILE = 'TareasGForma-InstalledVersion.json';

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 520,
    height: 360,
    resizable: false,
    autoHideMenuBar: true,
    title: 'Actualizador',
    webPreferences: {
      preload: path.join(__dirname, 'updater-preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false
    },
    show: false
  });

  mainWindow.loadFile(path.join(__dirname, 'updater', 'index.html'));
  mainWindow.webContents.once('did-finish-load', () => {
    if (process.argv.includes('--autostart')) {
      setTimeout(() => {
        runUpdateFlowPackages().catch((e) => {
          sendStatus({ phase: 'error', message: e && e.message ? e.message : String(e) });
        });
      }, 250);
    }
  });
  mainWindow.once('ready-to-show', () => mainWindow.show());
  mainWindow.on('closed', () => { mainWindow = null; });
}

function sendStatus(payload) {
  if (!mainWindow) return;
  mainWindow.webContents.send('updater:status', payload);
}

function htmlDecode(input) {
  const s = String(input || '');
  return s
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&apos;/g, "'")
    .replace(/&amp;/g, '&')
    .replace(/&#x([0-9a-fA-F]+);/g, (_m, hex) => String.fromCharCode(parseInt(hex, 16)))
    .replace(/&#([0-9]+);/g, (_m, num) => String.fromCharCode(parseInt(num, 10)));
}

function extractTag(xml, tagName) {
  const re = new RegExp(`<${tagName}[^>]*>([\\s\\S]*?)<\\/${tagName}>`, 'i');
  const m = String(xml || '').match(re);
  return m ? m[1] : null;
}

async function soapCall(soapAction, innerBodyXml) {
  const body = `<?xml version="1.0" encoding="utf-8"?>\n` +
    `<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ` +
    `xmlns:xsd="http://www.w3.org/2001/XMLSchema" ` +
    `xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">` +
    `<soap:Body>${innerBodyXml}</soap:Body>` +
    `</soap:Envelope>`;

  // Usamos fetch de Node (Electron 28) para simplificar.
  const res = await fetch(CONFIG.serviceUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': soapAction
    },
    body
  });
  const text = await res.text();
  if (!res.ok) {
    const snippet = text.slice(0, 400);
    throw new Error(`SOAP ${res.status}: ${snippet}`);
  }
  return text;
}

async function getFtpRoute() {
  const soapAction = 'http://tempuri.org/CogeRutasDescargaPorIdAplicacion';
  const inner = `<CogeRutasDescargaPorIdAplicacion xmlns="http://tempuri.org/">` +
    `<iIdAplicacion>${CONFIG.appId}</iIdAplicacion>` +
    `</CogeRutasDescargaPorIdAplicacion>`;

  const soapXml = await soapCall(soapAction, inner);
  const escaped = extractTag(soapXml, 'CogeRutasDescargaPorIdAplicacionResult');
  const decodedDs = htmlDecode(escaped || '');

  // Devuelve un DataSet con un único registro.
  const servidor = extractTag(decodedDs, 'Servidor');
  const carpeta = extractTag(decodedDs, 'Carpeta') || '';
  const usuario = extractTag(decodedDs, 'Usuario');
  const contrasena = extractTag(decodedDs, 'Contrasena');
  const direccionHttp = extractTag(decodedDs, 'DireccionHttp');

  if (!servidor || !usuario || !contrasena) {
    throw new Error('No se pudieron obtener credenciales/ruta FTP desde la API.');
  }

  return {
    servidor: servidor.trim(),
    carpeta: carpeta.trim(),
    usuario: usuario.trim(),
    contrasena: contrasena.trim(),
    direccionHttp: (direccionHttp || '').trim()
  };
}

function normalizeText(s) {
  return String(s || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9 ]+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function parseMajorMinor(s) {
  const m = String(s || '').trim().match(/^(\d+)\.(\d+)(?:\.\d+)?/);
  if (!m) return null;
  return { major: Number(m[1]), minor: Number(m[2]) };
}

async function execReg(args) {
  return await new Promise((resolve) => {
    const child = spawn('reg.exe', args, { windowsHide: true });
    let out = '';
    let err = '';
    child.stdout.on('data', (d) => { out += d.toString('utf8'); });
    child.stderr.on('data', (d) => { err += d.toString('utf8'); });
    child.on('close', (code) => resolve({ code, out, err }));
    child.on('error', (e) => resolve({ code: 1, out: '', err: e && e.message ? e.message : String(e) }));
  });
}

async function getInstalledAppVersion() {
  // Intentos por claves típicas (NSIS/electron-builder). Si no existe, hacemos búsqueda por DisplayName.
  const appId = 'com.tareasgforma.app';
  const directKeys = [
    `HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`,
    `HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`,
    `HKLM\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`
  ];

  for (const key of directKeys) {
    const r = await execReg(['query', key, '/v', 'DisplayVersion']);
    if (r.code === 0 && r.out) {
      const line = r.out.split(/\r?\n/).find((l) => /DisplayVersion/i.test(l));
      if (line) {
        const ver = line.trim().split(/\s{2,}/).pop();
        const mm = parseMajorMinor(ver);
        if (mm) return mm;
      }
    }
  }

  const targets = [
    'HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall',
    'HKLM\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall',
    'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall'
  ];

  const wanted = normalizeText('Tareas GForma');
  for (const root of targets) {
    const r = await execReg(['query', root, '/s', '/v', 'DisplayName']);
    if (r.code !== 0) continue;

    let currentKey = null;
    const lines = r.out.split(/\r?\n/);
    for (const raw of lines) {
      const line = raw.trimEnd();
      if (!line.trim()) continue;
      if (/^HKEY_/i.test(line.trim())) {
        currentKey = line.trim();
        continue;
      }
      if (!currentKey) continue;

      const parts = line.trim().split(/\s{2,}/);
      if (parts.length >= 3 && /^DisplayName$/i.test(parts[0])) {
        const displayName = parts.slice(2).join('  ');
        const norm = normalizeText(displayName);
        if (norm.includes(wanted)) {
          const v = await execReg(['query', currentKey, '/v', 'DisplayVersion']);
          if (v.code === 0) {
            const l2 = v.out.split(/\r?\n/).find((l) => /DisplayVersion/i.test(l));
            if (l2) {
              const ver = l2.trim().split(/\s{2,}/).pop();
              const mm = parseMajorMinor(ver);
              if (mm) return mm;
            }
          }
        }
      }
    }
  }

  return { major: CONFIG.baseVersion, minor: 0 };
}

function parseRegValue(output, valueName) {
  const line = String(output || '').split(/\r?\n/).find((l) => new RegExp(`\\b${valueName}\\b`, 'i').test(l));
  if (!line) return null;
  return line.trim().split(/\s{2,}/).pop() || null;
}

function parseInstallLocationFromUninstallString(uninstallString) {
  const s = String(uninstallString || '').trim();
  if (!s) return null;
  const m = s.match(/"([^"]+\.exe)"/i);
  const exePath = m ? m[1] : s.split(/\s+/)[0];
  if (!exePath) return null;
  return path.dirname(exePath);
}

function looksLikeInstallDir(dir) {
  if (!dir) return false;
  try {
    if (!fs.statSync(dir).isDirectory()) return false;
    return fs.existsSync(path.join(dir, 'resources', 'app.asar'));
  } catch {
    return false;
  }
}

async function getInstalledAppInfo() {
  const appId = 'com.tareasgforma.app';
  const directKeys = [
    `HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`,
    `HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`,
    `HKLM\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`
  ];

  for (const key of directKeys) {
    const rVer = await execReg(['query', key, '/v', 'DisplayVersion']);
    const rLoc = await execReg(['query', key, '/v', 'InstallLocation']);
    const rUn = await execReg(['query', key, '/v', 'UninstallString']);

    const verRaw = rVer.code === 0 ? parseRegValue(rVer.out, 'DisplayVersion') : null;
    const version = parseMajorMinor(verRaw) || { major: CONFIG.baseVersion, minor: 0 };

    let installDir = null;
    const loc = rLoc.code === 0 ? parseRegValue(rLoc.out, 'InstallLocation') : null;
    if (loc && looksLikeInstallDir(loc)) installDir = loc;
    if (!installDir) {
      const un = rUn.code === 0 ? parseRegValue(rUn.out, 'UninstallString') : null;
      const fromUn = parseInstallLocationFromUninstallString(un);
      if (fromUn && looksLikeInstallDir(fromUn)) installDir = fromUn;
    }

    if (installDir || verRaw) return { version, installDir };
  }

  const targets = [
    'HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall',
    'HKLM\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall',
    'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall'
  ];

  const wanted = normalizeText('TareasGForma');
  for (const root of targets) {
    const r = await execReg(['query', root, '/s', '/v', 'DisplayName']);
    if (r.code !== 0) continue;

    let currentKey = null;
    const lines = r.out.split(/\r?\n/);
    for (const raw of lines) {
      const line = raw.trimEnd();
      if (!line.trim()) continue;
      if (/^HKEY_/i.test(line.trim())) {
        currentKey = line.trim();
        continue;
      }
      if (!currentKey) continue;

      const parts = line.trim().split(/\s{2,}/);
      if (parts.length >= 3 && /^DisplayName$/i.test(parts[0])) {
        const displayName = parts.slice(2).join('  ');
        const norm = normalizeText(displayName);
        if (!norm.includes(wanted)) continue;

        const v = await execReg(['query', currentKey, '/v', 'DisplayVersion']);
        const loc = await execReg(['query', currentKey, '/v', 'InstallLocation']);
        const un = await execReg(['query', currentKey, '/v', 'UninstallString']);

        const verRaw = v.code === 0 ? parseRegValue(v.out, 'DisplayVersion') : null;
        const version = parseMajorMinor(verRaw) || { major: CONFIG.baseVersion, minor: 0 };

        let installDir = null;
        const locRaw = loc.code === 0 ? parseRegValue(loc.out, 'InstallLocation') : null;
        if (locRaw && looksLikeInstallDir(locRaw)) installDir = locRaw;
        if (!installDir) {
          const unRaw = un.code === 0 ? parseRegValue(un.out, 'UninstallString') : null;
          const fromUn = parseInstallLocationFromUninstallString(unRaw);
          if (fromUn && looksLikeInstallDir(fromUn)) installDir = fromUn;
        }

        return { version, installDir };
      }
    }
  }

  const localAppData = process.env.LOCALAPPDATA || '';
  const programFilesX86 = process.env['ProgramFiles(x86)'] || '';
  const guesses = [
    path.join(localAppData, 'Programs', 'Tareas GForma'),
    path.join(localAppData, 'Programs', 'TareasGForma'),
    // Ruta real conocida de instalación NSIS
    ...(programFilesX86 ? [
      path.join(programFilesX86, 'Inteco Ingenier\u00eda Avanzada S.L', 'Tareas GForma'),
      path.join(programFilesX86, 'Inteco Ingenier\u00eda Avanzada S.L.', 'Tareas GForma'),
      path.join(programFilesX86, 'Inteco Ingenier\u00eda Avanzada S.L', 'Tareas GForma', 'TareasGForma')
    ] : [])
  ];
  const guessed = guesses.find((d) => looksLikeInstallDir(d)) || null;
  return { version: { major: CONFIG.baseVersion, minor: 0 }, installDir: guessed };
}

/**
 * Obtiene la versión disponible desde el servicio web y construye el nombre
 * del archivo de actualización con el patrón: acTareasGForm{major}_{minor}.exe
 */
async function getModuloFromWebservice() {
  const soapAction = 'http://tempuri.org/CogeModulosPorIdAplicacion';
  const inner = `<CogeModulosPorIdAplicacion xmlns="http://tempuri.org/">` +
    `<iIdAplicacion>${CONFIG.appId}</iIdAplicacion>` +
    `</CogeModulosPorIdAplicacion>`;

  const soapXml = await soapCall(soapAction, inner);
  const escaped = extractTag(soapXml, 'CogeModulosPorIdAplicacionResult');
  const decodedDs = htmlDecode(escaped || '');

  // Parsear todos los módulos y quedarnos con el principal (Principal=1)
  const moduloBlocks = [];
  const reBlock = /<ModulosPorIdAplicacion[\s\S]*?<\/ModulosPorIdAplicacion>/gi;
  let m;
  while ((m = reBlock.exec(decodedDs)) !== null) {
    moduloBlocks.push(m[0]);
  }

  let major = null;
  let minor = null;
  for (const block of moduloBlocks) {
    const principal = extractTag(block, 'Principal');
    if (String(principal).trim() !== '1') continue;
    const vMajorRaw = (extractTag(block, 'VersionPrincipal')  || '').trim();
    const vMinorRaw = (extractTag(block, 'VersionSecundaria') || '').trim();
    major = Number(vMajorRaw);
    minor = Number(vMinorRaw);
    break;
  }

  if (major === null || !Number.isFinite(major) || !Number.isFinite(minor)) {
    throw new Error(
      'El servicio web no devolvió ningún módulo principal (Principal=1) ' +
      `para la aplicación ${CONFIG.appId}.`
    );
  }

  // Construir el nombre del archivo con el patrón oficial de TareasGForma
  const name = `acTareasGForm${major}_${minor}.exe`;
  const kind = 'direct-exe';

  return { name, major, minor, kind };
}

function pickLatestFullPackage(names) {
  const patterns = [
    // Paquete completo por versión (RAR recomendado)
    { re: /^TareasGForma-Full-(\d+)\.(\d+)(?:\.\d+)?\.rar$/i, kind: 'archive' },
    { re: /^TareasGForma-Full-(\d+)\.(\d+)(?:\.\d+)?\.exe$/i, kind: 'installer' },
    // Formato SFX (autoextraíble con UAC): acTareasGFormX_Y.sfx.exe
    { re: /^acTareasGForm(\d+)[._-](\d+).*\.sfx\.exe$/i, kind: 'sfx-installer' },
    // Formato FTP: acTareasGFormX_Y.rar -> extraer como archive
    { re: /^acTareasGForm(\d+)[._-](\d+).*\.rar$/i, kind: 'archive' },
    // Formato FTP: acTareasGFormX_Y.exe -> es el EXE de Electron de la app, copiar directamente
    // Excluimos explícitamente los que contengan .sfx. antes de .exe para no confundirlos
    { re: /^acTareasGForm(\d+)[._-](\d+)(?![^.]*\.sfx).*\.exe$/i, kind: 'direct-exe' },
    { re: /^acTareasGForm(\d+)[._-](\d+)(?:\s*\(\d+\))?$/i, kind: 'archive' }
  ];

  let best = null;
  for (const name of names || []) {
    const s = String(name || '').trim();
    if (!s) continue;

    let match = null;
    let kind = null;
    for (const p of patterns) {
      const m = s.match(p.re);
      if (m) {
        match = m;
        kind = p.kind;
        break;
      }
    }
    if (!match) continue;

    const major = Number(match[1]);
    const minor = Number(match[2]);
    if (!Number.isFinite(major) || !Number.isFinite(minor)) continue;
    if (major !== CONFIG.baseVersion) continue;

    const candidate = { name: s, major, minor, kind };
    if (!best) {
      best = candidate;
      continue;
    }

    if (candidate.minor > best.minor) {
      best = candidate;
      continue;
    }

    // A igual versión, desempatar por prioridad de formato:
    //   sfx-installer (UAC nativo) > archive > installer > direct-exe
    const kindPriority = { 'sfx-installer': 4, 'archive': 3, 'installer': 2, 'direct-exe': 1 };
    if (candidate.minor === best.minor &&
        (kindPriority[candidate.kind] || 0) > (kindPriority[best.kind] || 0)) {
      best = candidate;
    }
  }
  return best;
}

function findPatchFile(names, fromMinor, toMinor) {
  const prefix = CONFIG.patchPrefix;
  const re = new RegExp(`^${prefix.replace(/[.*+?^${}()|[\\]\\\\]/g, '\\\\$&')}` +
    `(\\d+)\\.(\\d+)-to-(\\d+)\\.(\\d+)\\.rar$`, 'i');

  for (const name of names || []) {
    const m = String(name).match(re);
    if (!m) continue;
    const majorA = Number(m[1]);
    const minorA = Number(m[2]);
    const majorB = Number(m[3]);
    const minorB = Number(m[4]);
    if (majorA !== CONFIG.baseVersion || majorB !== CONFIG.baseVersion) continue;
    if (minorA === fromMinor && minorB === toMinor) return name;
  }
  return null;
}

function buildUpdatePlan(names, installed, latest) {
  if (latest.kind === 'installer') return { mode: 'installer', files: [latest.name] };
  if (!installed) return { mode: 'full', files: [latest.name] };
  if (latest.minor <= installed.minor) return { mode: 'none', files: [] };

  const files = [];
  for (let m = installed.minor + 1; m <= latest.minor; m++) {
    const patch = findPatchFile(names, m - 1, m);
    if (!patch) return { mode: 'full', files: [latest.name] };
    files.push(patch);
  }
  return { mode: 'patch', files };
}

function spawnPromise(command, args, opts) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, opts);
    let out = '';
    let err = '';
    if (child.stdout) child.stdout.on('data', (d) => { out += d.toString('utf8'); });
    if (child.stderr) child.stderr.on('data', (d) => { err += d.toString('utf8'); });
    child.on('close', (code) => {
      if (code === 0) resolve({ code, out, err });
      else reject(new Error(`${command} ${args.join(' ')} -> exit ${code}. ${err || out}`));
    });
    child.on('error', reject);
  });
}

function resolved7zaPath() {
  const p = String(path7za || '');
  // Cuando electron-builder empaqueta con asarUnpack, el binario vive en app.asar.unpacked.
  return p.includes('app.asar') ? p.replace('app.asar', 'app.asar.unpacked') : p;
}

async function extractRarToDir(archivePath, outDir) {
  fs.mkdirSync(outDir, { recursive: true });
  await spawnPromise(resolved7zaPath(), ['x', '-y', `-o${outDir}`, archivePath], { windowsHide: true });
}

function resolveExtractedRoot(outDir) {
  try {
    const items = fs.readdirSync(outDir, { withFileTypes: true });
    const dirs = items.filter((d) => d.isDirectory());
    const files = items.filter((f) => f.isFile());
    if (files.length === 0 && dirs.length === 1) return path.join(outDir, dirs[0].name);
  } catch {
    // ignore
  }
  return outDir;
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
      if (ent.isDirectory()) stack.push(nextRel);
      else if (ent.isFile()) out.push(nextRel);
    }
  }
  out.sort((a, b) => a.localeCompare(b));
  return out;
}

function safeJoin(baseDir, relPath) {
  const target = path.resolve(baseDir, relPath);
  const base = path.resolve(baseDir);
  if (!target.startsWith(base + path.sep)) throw new Error(`Ruta insegura: ${relPath}`);
  return target;
}

function overlayCopyDir(srcDir, destDir, { preserveConfigXml } = {}) {
  const files = walkFiles(srcDir);
  for (const rel of files) {
    if (rel === '_delete.txt') continue;
    const src = path.join(srcDir, rel);
    const dest = safeJoin(destDir, rel);

    if (preserveConfigXml) {
      const relNorm = rel.replace(/\//g, '\\').toLowerCase();
      if (relNorm === path.join('resources', 'config.xml').toLowerCase() && fs.existsSync(dest)) continue;
    }

    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.copyFileSync(src, dest);
  }
}

function applyDeletes(extractedDir, destDir) {
  const delFile = path.join(extractedDir, '_delete.txt');
  if (!fs.existsSync(delFile)) return;
  const lines = fs.readFileSync(delFile, 'utf8').split(/\r?\n/).map((s) => s.trim()).filter(Boolean);
  for (const rel of lines) {
    try {
      const target = safeJoin(destDir, rel);
      fs.rmSync(target, { recursive: true, force: true });
    } catch {
      // ignore
    }
  }
}

function writeInstalledVersionMarker(installDir, version) {
  try {
    if (!installDir || !version) return;
    const payload = {
      major: Number(version.major),
      minor: Number(version.minor),
      at: new Date().toISOString()
    };
    if (!Number.isFinite(payload.major) || !Number.isFinite(payload.minor)) return;

    const json = JSON.stringify(payload, null, 2);

    // Intentar en la raíz de instalación
    try {
      const markerPath = path.join(installDir, INSTALLED_VERSION_FILE);
      fs.writeFileSync(markerPath, json, 'utf8');
    } catch {
      // ignore
    }

    // Y también en `resources/` por si el ejecutable no está en la raíz.
    try {
      const resDir = path.join(installDir, 'resources');
      if (fs.existsSync(resDir) && fs.statSync(resDir).isDirectory()) {
        const markerPath2 = path.join(resDir, INSTALLED_VERSION_FILE);
        fs.writeFileSync(markerPath2, json, 'utf8');
      }
    } catch {
      // ignore
    }
  } catch {
    // ignore
  }
}

/**
 * Actualiza o recrea los accesos directos (.lnk) de TareasGForma
 * apuntando al nuevo ejecutable en installDir.
 */
async function updateShortcuts(installDir) {
  const newExePath = path.join(installDir, 'Tareas GForma.exe');
  if (!fs.existsSync(newExePath)) return;

  // Lugares donde buscar accesos directos
  const startMenuUser = path.join(
    process.env.APPDATA || '',
    'Microsoft', 'Windows', 'Start Menu', 'Programs'
  );
  const startMenuCommon = 'C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs';
  const desktop = path.join(process.env.USERPROFILE || '', 'Desktop');
  const publicDesktop = 'C:\\Users\\Public\\Desktop';

  const searchDirs = [startMenuUser, startMenuCommon, desktop, publicDesktop];

  // Buscar .lnk que apunten a TareasGForma
  const lnkPattern = /tareas gforma/i;
  const candidates = [];
  for (const dir of searchDirs) {
    try {
      if (!fs.existsSync(dir)) continue;
      const files = fs.readdirSync(dir);
      for (const f of files) {
        if (f.toLowerCase().endsWith('.lnk') && lnkPattern.test(f)) {
          candidates.push(path.join(dir, f));
        }
      }
    } catch {
      // ignore
    }
  }

  if (candidates.length === 0) {
    // No hay accesos directos existentes: crear uno en el menú inicio
    candidates.push(path.join(startMenuUser, 'Tareas GForma.lnk'));
  }

  // Actualizar cada acceso directo con PowerShell (evita dep. COM directa)
  for (const lnkPath of candidates) {
    try {
      const escapedLnk = lnkPath.replace(/\\/g, '\\\\').replace(/'/g, "''");
      const escapedExe = newExePath.replace(/\\/g, '\\\\').replace(/'/g, "''");
      const escapedDir = installDir.replace(/\\/g, '\\\\').replace(/'/g, "''");
      const ps = `$ws = New-Object -ComObject WScript.Shell; $lnk = $ws.CreateShortcut('${escapedLnk}'); $lnk.TargetPath = '${escapedExe}'; $lnk.WorkingDirectory = '${escapedDir}'; $lnk.Description = 'Tareas GForma'; $lnk.Save()`;
      await spawnPromise('powershell.exe', [
        '-NoProfile', '-NonInteractive', '-Command', ps
      ], { windowsHide: true });
    } catch {
      // ignore if shortcut update fails
    }
  }
}

async function tryCloseRunningApp() {
  const names = ['Tareas GForma.exe', 'TareasGForma.exe'];
  for (const n of names) {
    try {
      await spawnPromise('taskkill.exe', ['/IM', n, '/F'], { windowsHide: true });
    } catch {
      // ignore
    }
  }
}

function downloadToFile(url, destPath, onProgress) {
  const lib = url.startsWith('https:') ? https : http;
  abortController = new AbortController();

  return new Promise((resolve, reject) => {
    const req = lib.get(url, { signal: abortController.signal }, (res) => {
      if (res.statusCode && res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        // redirect
        const next = res.headers.location.startsWith('http') ? res.headers.location : new URL(res.headers.location, url).toString();
        res.resume();
        downloadToFile(next, destPath, onProgress).then(resolve, reject);
        return;
      }

      if (res.statusCode !== 200) {
        res.resume();
        reject(new Error(`Descarga fallida: HTTP ${res.statusCode}`));
        return;
      }

      const total = Number(res.headers['content-length'] || 0);
      let done = 0;

      fs.mkdirSync(path.dirname(destPath), { recursive: true });
      const file = fs.createWriteStream(destPath);
      res.on('data', (chunk) => {
        done += chunk.length;
        if (typeof onProgress === 'function') {
          onProgress({ done, total });
        }
      });

      res.pipe(file);
      file.on('finish', () => file.close(() => resolve()));
      file.on('error', (err) => reject(err));
    });

    req.on('error', (err) => reject(err));
  });
}

async function downloadAndLaunchInstaller(route, fileName) {
  const baseHttp = route.direccionHttp || 'http://www.intecoingenieria.com/tecnodescargas';
  const fileUrl = `${baseHttp.replace(/\/$/, '')}/${encodeURIComponent(fileName)}`;
  const dest = path.join(app.getPath('temp'), fileName);

  sendStatus({ phase: 'downloading', message: `Descargando ${fileName}...`, progress: 0 });
  await downloadToFile(fileUrl, dest, ({ done, total }) => {
    const progress = total > 0 ? Math.min(1, done / total) : 0;
    sendStatus({ phase: 'downloading', message: `Descargando ${fileName}...`, progress });
  });

  sendStatus({ phase: 'ready', message: 'Descarga completada. Abriendo instalador...' });

  // Lanzar instalador y salir.
  try {
    const child = spawn('cmd.exe', ['/c', 'start', '""', `"${dest}"`], {
      windowsHide: true,
      detached: true,
      stdio: 'ignore'
    });
    child.unref();
  } catch {
    shell.showItemInFolder(dest);
  }

  setTimeout(() => {
    try { app.quit(); } catch { /* ignore */ }
  }, 350);
}

async function listRemoteInstallersFtp(route) {
  const ftp = require('basic-ftp');
  const client = new ftp.Client(15_000);
  client.ftp.verbose = false;
  try {
    await client.access({
      host: route.servidor,
      user: route.usuario,
      password: route.contrasena,
      secure: false
    });
    if (route.carpeta) {
      try { await client.cd(route.carpeta); } catch { /* ignore */ }
    }
    const entries = await client.list();
    return entries.filter((e) => e.isFile).map((e) => e.name);
  } finally {
    client.close();
  }
}

function pickBestPackageForVersion(names, majorVersion, minorVersion) {
  const patterns = [
    { re: /^Tareas\s?GForma-Full-(\d+)\.(\d+)(?:\.\d+)?\.rar$/i, kind: 'archive' },
    { re: /^Tareas\s?GForma-Full-(\d+)\.(\d+)(?:\.\d+)?\.exe$/i, kind: 'installer' },
    { re: /^acTareas\s?GForm(\d+)[._-](\d+).*\.sfx\.exe$/i, kind: 'sfx-installer' },
    { re: /^acTareas\s?GForm(\d+)[._-](\d+).*\.rar$/i, kind: 'archive' },
    { re: /^acTareas\s?GForm(\d+)[._-](\d+)(?![^.]*\.sfx).*\.exe$/i, kind: 'direct-exe' },
    { re: /^acTareas\s?GForm(\d+)[._-](\d+)(?:\s*\(\d+\))?$/i, kind: 'archive' }
  ];

  let best = null;
  for (const name of names || []) {
    const s = String(name || '').trim();
    if (!s) continue;
    let match = null;
    let kind = null;
    for (const p of patterns) {
      const m = s.match(p.re);
      if (m) {
        match = m;
        kind = p.kind;
        break;
      }
    }
    if (!match) continue;

    const major = Number(match[1]);
    const minor = Number(match[2]);
    if (major !== majorVersion || minor !== minorVersion) continue;

    const candidate = { name: s, major, minor, kind };
    if (!best) {
      best = candidate;
      continue;
    }

    // sfx-installer (UAC) > archive > installer > direct-exe
    const kindPriority = { 'sfx-installer': 4, 'archive': 3, 'installer': 2, 'direct-exe': 1 };
    if ((kindPriority[candidate.kind] || 0) > (kindPriority[best.kind] || 0)) {
      best = candidate;
    }
  }
  return best;
}

async function runUpdateFlowPackages() {
  sendStatus({ phase: 'checking', message: 'Buscando actualizaciones...' });

  const info = await getInstalledAppInfo();
  const installed = info.version;
  sendStatus({ phase: 'checking', message: `Versión instalada: ${installed.major}.${installed.minor}` });

  // Obtener la ruta HTTP de descarga desde el servicio web
  const route = await getFtpRoute();

  // Obtener el módulo principal directamente desde el servicio web (sin listar FTP)
  sendStatus({ phase: 'checking', message: 'Consultando servicio web de actualizaciones...' });
  const officialModule = await getModuloFromWebservice();

  if (officialModule.major < installed.major || (officialModule.major === installed.major && officialModule.minor <= installed.minor)) {
    sendStatus({ phase: 'done', message: `Ya tienes la última versión (${installed.major}.${installed.minor}).`, progress: 1 });
    return;
  }

  // Si hay una actualización oficial, listamos el FTP para encontrar el mejor formato para esa versión
  let latest = officialModule;
  try {
    const names = await listRemoteInstallersFtp(route);
    const bestPkg = pickBestPackageForVersion(names, officialModule.major, officialModule.minor);
    if (bestPkg) {
      latest = bestPkg;
    }
  } catch (ftpError) {
    console.warn('Error al buscar formato preferido en FTP, se usará el del WebService:', ftpError);
  }


  // Si el "paquete" en el FTP es un instalador NSIS (.exe TareasGForma-Full), lo descargamos y lanzamos.
  if (latest.kind === 'installer') {
    await tryCloseRunningApp();
    await downloadAndLaunchInstaller(route, latest.name);
    return;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // SFX con elevación UAC: acTareasGFormX_Y.sfx.exe
  // Descarga el SFX y lo lanza con "runas" para que Windows muestre UAC.
  // El SFX se encarga de copiar archivos y reparar el acceso directo.
  // ──────────────────────────────────────────────────────────────────────────
  if (latest.kind === 'sfx-installer') {
    const baseHttp = route.direccionHttp || 'http://www.intecoingenieria.com/tecnodescargas';
    const fileUrl  = `${baseHttp.replace(/\/$/, '')}/${encodeURIComponent(latest.name)}`;
    const destSfx  = path.join(app.getPath('temp'), latest.name);

    sendStatus({ phase: 'downloading', message: `Descargando ${latest.name}...`, progress: 0 });
    await downloadToFile(fileUrl, destSfx, ({ done, total }) => {
      const p = total > 0 ? Math.min(1, done / total) : 0;
      sendStatus({ phase: 'downloading', message: `Descargando ${latest.name}...`, progress: p * 0.8 });
    });

    sendStatus({ phase: 'applying', message: 'Descarga completada. Solicitando permisos de Administrador (UAC)...', progress: 0.85 });

    // Cerrar la app principal antes de lanzar el SFX para liberar archivos bloqueados
    await tryCloseRunningApp();
    await new Promise((r) => setTimeout(r, 1000));

    // Lanzar el SFX con elevación UAC mediante PowerShell Start-Process -Verb RunAs
    // Esto hace que Windows muestre el diálogo UAC incluso para usuarios estándar.
    try {
      const escapedSfx = destSfx.replace(/'/g, "''");
      const psCmd = `Start-Process -FilePath '${escapedSfx}' -Verb RunAs -Wait`;
      // No esperamos a que termine (el SFX puede tardar varios minutos)
      const child = spawn('powershell.exe', [
        '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass',
        '-Command', psCmd
      ], {
        windowsHide: false,   // Mostrar ventana UAC al usuario
        detached: true,
        stdio: 'ignore'
      });
      child.unref();
    } catch (e) {
      // Fallback: intentar con ShellExecute a través de cmd
      try {
        const child = spawn('cmd.exe', ['/c', 'start', '""', `"${destSfx}"`], {
          windowsHide: true,
          detached: true,
          stdio: 'ignore'
        });
        child.unref();
      } catch {
        shell.showItemInFolder(destSfx);
      }
    }

    sendStatus({
      phase: 'ready',
      message: 'Instalador lanzado. Siga las instrucciones en pantalla para completar la actualización.',
      progress: 1
    });

    // Salir del actualizador para no bloquear archivos
    setTimeout(() => {
      try { app.quit(); } catch { /* ignore */ }
    }, 500);
    return;
  }

  // Si es un EXE (acTareasGFormX_Y.exe) = el empaquetado de WinRAR SFX que subió el usuario al FTP.
  // Se descarga, se cierra la app, se lanza este ejecutable pidiendo permisos y se cierra el actualizador.
  if (latest.kind === 'direct-exe') {
    const programFilesX86 = process.env['ProgramFiles(x86)'] || '';
    const knownInstallDirs = [
      info.installDir,
      path.join(programFilesX86, 'Inteco Ingeniería Avanzada S.L', 'Tareas GForma'),
      path.join(programFilesX86, 'Inteco Ingeniería Avanzada S.L.', 'Tareas GForma')
    ].filter(Boolean);

    const installDir = knownInstallDirs.find((d) => looksLikeInstallDir(d));
    if (!installDir) {
      throw new Error('No se pudo detectar la carpeta de instalación. Reinstala la aplicación principal y vuelve a intentar.');
    }

    const baseHttp = route.direccionHttp || 'http://www.intecoingenieria.com/tecnodescargas';
    const fileUrl = `${baseHttp.replace(/\/$/, '')}/${encodeURIComponent(latest.name)}`;
    const destDownload = path.join(installDir, latest.name);

    sendStatus({ phase: 'downloading', message: `Descargando ${latest.name}...`, progress: 0 });
    await downloadToFile(fileUrl, destDownload, ({ done, total }) => {
      const p = total > 0 ? Math.min(1, done / total) : 0;
      sendStatus({ phase: 'downloading', message: `Descargando ${latest.name}...`, progress: p * 0.7 });
    });

    sendStatus({ phase: 'applying', message: 'Cerrando aplicación para iniciar instalación...', progress: 0.8 });
    await tryCloseRunningApp();
    // Pequeña pausa para asegurar que el proceso ha liberado los archivos
    await new Promise((r) => setTimeout(r, 1500));

    // Lanzar el SFX (WinRAR .exe) emulando exactamente un doble clic
    sendStatus({ phase: 'applying', message: 'Lanzando instalador automático...', progress: 0.9 });
    try {
      shell.openPath(destDownload);
    } catch (e) {
      try {
        const child = spawn('cmd.exe', ['/c', 'start', '""', `"${destDownload}"`], {
          windowsHide: true,
          detached: true,
          stdio: 'ignore'
        });
        child.unref();
      } catch {
        shell.showItemInFolder(destDownload);
      }
    }

    sendStatus({
      phase: 'ready',
      message: 'Instalador lanzado. La aplicación se actualizará automáticamente.',
      progress: 1
    });

    // Salir del actualizador para no bloquear los archivos cuando WinRAR intente sobrescribir
    setTimeout(() => {
      try { app.quit(); } catch { /* ignore */ }
    }, 500);

    return;
  }

  // Caso archive (RAR): extraer y copiar archivos al directorio de instalación
  if (!info.installDir) {
    const programFilesX86 = process.env['ProgramFiles(x86)'] || '';
    const fallbackPaths = [
      path.join(programFilesX86, 'Inteco Ingeniería Avanzada S.L', 'Tareas GForma'),
      path.join(programFilesX86, 'Inteco Ingeniería Avanzada S.L.', 'Tareas GForma')
    ];
    for (const fp of fallbackPaths) {
      if (looksLikeInstallDir(fp)) {
        info.installDir = fp;
        break;
      }
    }
  }
  if (!info.installDir) {
    throw new Error('No se pudo detectar la carpeta de instalación. Reinstala con el instalador principal y vuelve a intentar.');
  }

  await tryCloseRunningApp();

  const baseHttp = route.direccionHttp || 'http://www.intecoingenieria.com/tecnodescargas';
  const tempRoot = path.join(app.getPath('temp'), `tareasgforma-update-${Date.now()}`);
  fs.mkdirSync(tempRoot, { recursive: true });

  const fileName = latest.name;
  const fileUrl = `${baseHttp.replace(/\/$/, '')}/${encodeURIComponent(fileName)}`;
  const destArchive = path.join(tempRoot, fileName);

  sendStatus({ phase: 'downloading', message: `Descargando ${fileName}...`, progress: 0 });
  await downloadToFile(fileUrl, destArchive, ({ done, total }) => {
    const p = total > 0 ? Math.min(1, done / total) : 0;
    sendStatus({ phase: 'downloading', message: `Descargando ${fileName}...`, progress: p * 0.2 });
  });

  sendStatus({ phase: 'applying', message: `Aplicando ${fileName}...`, progress: 0.2 });
  const extractDir = path.join(tempRoot, 'extract_0');
  await extractRarToDir(destArchive, extractDir);
  const extractedRoot = resolveExtractedRoot(extractDir);

  applyDeletes(extractedRoot, info.installDir);
  overlayCopyDir(extractedRoot, info.installDir);

  writeInstalledVersionMarker(info.installDir, latest);

  sendStatus({ phase: 'applying', message: 'Actualizando accesos directos...', progress: 0.95 });
  try {
    await updateShortcuts(info.installDir);
  } catch {
    // No bloquear si falla la actualización del acceso directo
  }

  sendStatus({
    phase: 'done',
    message: `Actualización completada: ${latest.major}.${latest.minor}. Ya puedes abrir la aplicación.`,
    progress: 1
  });
}


// Mantener el nombre antiguo por compatibilidad: el flujo actual usa paquetes .rar.
async function runUpdateFlow() {
  return await runUpdateFlowPackages();
}

ipcMain.handle('updater:start', async () => {
  try {
    await runUpdateFlowPackages();
    return { ok: true };
  } catch (e) {
    sendStatus({ phase: 'error', message: e && e.message ? e.message : String(e) });
    return { ok: false, error: e && e.message ? e.message : String(e) };
  }
});

ipcMain.handle('updater:cancel', async () => {
  try {
    if (abortController) abortController.abort();
    abortController = null;
    sendStatus({ phase: 'error', message: 'Operación cancelada.' });
    return { ok: true };
  } catch (e) {
    return { ok: false, error: e && e.message ? e.message : String(e) };
  }
});

app.whenReady().then(() => {
  createWindow();
});

app.on('window-all-closed', () => {
  app.quit();
});
