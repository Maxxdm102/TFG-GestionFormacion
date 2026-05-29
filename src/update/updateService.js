const { app } = require('electron');
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const SERVICE_URL = 'http://intecodistribucionsrv.intecoingenieria.com/distribucionsrv.asmx';
const APP_ID = 40;

const POLICY_FILE = 'TareasGForma-UpdatePolicy.json';
const INSTALLED_VERSION_FILE = 'TareasGForma-InstalledVersion.json';

// Compatibilidad con nombres existentes en FTP (y variantes típicas):
// - TareasGForma-Full-1.6.rar (o TareasGForma-Full-1.6.0.rar)
// - acTareasGForm1_6.rar/.exe (o acTareasGForm1-6.rar, acTareasGForm1_6 (1).rar)
// - acTareasGForm1_6 (sin extensión)
const FULL_PACKAGE_PATTERNS = [
  { re: /^TareasGForma-Full-(\d+)\.(\d+)(?:\.\d+)?\.rar$/i, majorIdx: 1, minorIdx: 2 },
  { re: /^TareasGForma-Full-(\d+)\.(\d+)(?:\.\d+)?\.exe$/i, majorIdx: 1, minorIdx: 2 },
  { re: /^acTareasGForm(\d+)[._-](\d+).*\.rar$/i, majorIdx: 1, minorIdx: 2 },
  { re: /^acTareasGForm(\d+)[._-](\d+).*\.exe$/i, majorIdx: 1, minorIdx: 2 },
  { re: /^acTareasGForm(\d+)[._-](\d+)(?:\s*\(\d+\))?$/i, majorIdx: 1, minorIdx: 2 }
];

let _cache = { at: 0, value: null };
const CACHE_MS = 5 * 60 * 1000;

function parseMajorMinor(versionStr) {
  const m = String(versionStr || '').trim().match(/^(\d+)\.(\d+)(?:\.\d+)?/);
  if (!m) return null;
  return { major: Number(m[1]), minor: Number(m[2]) };
}

function compareMM(a, b) {
  if (a.major !== b.major) return a.major - b.major;
  return a.minor - b.minor;
}

function readInstalledVersionMarker() {
  const readOne = (dir) => {
    try {
      if (!dir) return null;
      const markerPath = path.join(dir, INSTALLED_VERSION_FILE);
      if (!fs.existsSync(markerPath)) return null;
      const raw = fs.readFileSync(markerPath, 'utf8');
      const json = JSON.parse(raw);
      if (!json || typeof json !== 'object') return null;
      const major = Number(json.major);
      const minor = Number(json.minor);
      if (!Number.isFinite(major) || !Number.isFinite(minor)) return null;
      return { major, minor };
    } catch {
      return null;
    }
  };

  const candidates = [];
  try { candidates.push(path.dirname(process.execPath)); } catch { /* ignore */ }
  try { if (process.resourcesPath) candidates.push(process.resourcesPath); } catch { /* ignore */ }
  try { if (process.resourcesPath) candidates.push(path.dirname(process.resourcesPath)); } catch { /* ignore */ }
  try { candidates.push(app.getPath('userData')); } catch { /* ignore */ }

  let best = null;
  for (const dir of candidates) {
    const mm = readOne(dir);
    if (!mm) continue;
    if (!best || compareMM(mm, best) > 0) best = mm;
  }
  return best;
}

async function readInstalledVersionFromRegistry() {
  try {
    const appId = 'com.tareasgforma.app';
    const directKeys = [
      `HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`,
      `HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`,
      `HKLM\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`
    ];

    for (const key of directKeys) {
      const r = await execReg(['query', key, '/v', 'DisplayVersion']);
      if (r.code !== 0 || !r.out) continue;
      const line = r.out.split(/\r?\n/).find((l) => /DisplayVersion/i.test(l));
      if (!line) continue;
      const ver = line.trim().split(/\s{2,}/).pop();
      const mm = parseMajorMinor(ver);
      if (mm) return mm;
    }
  } catch {
    // ignore
  }
  return null;
}

async function getInstalledVersionForUpdateCheck() {
  const fromApp = parseMajorMinor(app.getVersion());
  const fromMarker = readInstalledVersionMarker();
  const fromRegistry = await readInstalledVersionFromRegistry();

  let best = null;
  for (const mm of [fromApp, fromMarker, fromRegistry]) {
    if (!mm) continue;
    if (!best || compareMM(mm, best) > 0) best = mm;
  }

  return best || { major: 1, minor: 0 };
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

  const ctrl = new AbortController();
  const t = setTimeout(() => ctrl.abort(), 15_000);
  const res = await fetch(SERVICE_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': soapAction
    },
    body,
    signal: ctrl.signal
  }).finally(() => clearTimeout(t));
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
    `<iIdAplicacion>${APP_ID}</iIdAplicacion>` +
    `</CogeRutasDescargaPorIdAplicacion>`;

  const soapXml = await soapCall(soapAction, inner);
  const escaped = extractTag(soapXml, 'CogeRutasDescargaPorIdAplicacionResult');
  const decodedDs = htmlDecode(escaped || '');

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

async function listRemoteFilesFtp(route) {
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

function parseFullPackageName(name) {
  const s = String(name || '').trim();
  if (!s) return null;
  for (const p of FULL_PACKAGE_PATTERNS) {
    const m = s.match(p.re);
    if (!m) continue;
    const major = Number(m[p.majorIdx]);
    const minor = Number(m[p.minorIdx]);
    if (!Number.isFinite(major) || !Number.isFinite(minor)) return null;
    return { name: s, major, minor };
  }
  return null;
}

function pickLatestFullPackage(names, baseMajor) {
  let best = null;
  for (const name of names || []) {
    const parsed = parseFullPackageName(name);
    if (!parsed) continue;
    if (parsed.major !== baseMajor) continue;
    if (!best || parsed.minor > best.minor) best = parsed;
  }
  return best;
}

async function tryFetchUpdatePolicy(baseHttp) {
  const url = `${String(baseHttp || '').replace(/\/$/, '')}/${POLICY_FILE}`;
  try {
    const ctrl = new AbortController();
    const t = setTimeout(() => ctrl.abort(), 10_000);
    const res = await fetch(url, { method: 'GET', signal: ctrl.signal }).finally(() => clearTimeout(t));
    if (!res.ok) return null;
    const txt = await res.text();
    const json = JSON.parse(txt);
    return typeof json === 'object' && json ? json : null;
  } catch {
    return null;
  }
}

function computeUpdateStatus({ installed, latest, policy }) {
  const available = compareMM(latest, installed) > 0;
  if (!available) {
    return { status: 'none', message: null };
  }

  let mandatory = false;
  if (policy && typeof policy === 'object') {
    if (policy.mandatory === true) mandatory = true;
    if (policy.mandatoryFrom) {
      const mm = parseMajorMinor(policy.mandatoryFrom);
      if (mm && compareMM(installed, mm) < 0) mandatory = true;
    }
    if (policy.minSupported) {
      const mm = parseMajorMinor(policy.minSupported);
      if (mm && compareMM(installed, mm) < 0) mandatory = true;
    }
  }

  // Fallback: cambio de versión principal -> obligatorio
  if (latest.major > installed.major) mandatory = true;

  const status = mandatory ? 'mandatory' : 'optional';
  const msgKey = mandatory ? 'messageMandatory' : 'messageOptional';
  const message = policy && typeof policy[msgKey] === 'string' && policy[msgKey].trim()
    ? policy[msgKey].trim()
    : (mandatory
      ? `Hay una actualización obligatoria (${latest.major}.${latest.minor}). Debes actualizar para continuar.`
      : `Hay una actualización disponible (${latest.major}.${latest.minor}).`);

  return { status, message };
}

async function checkForUpdates() {
  const now = Date.now();
  if (_cache.value && (now - _cache.at) < CACHE_MS) return _cache.value;

  const installed = await getInstalledVersionForUpdateCheck();
  const route = await getFtpRoute();
  const names = await listRemoteFilesFtp(route);
  const latest = pickLatestFullPackage(names, installed.major);

  if (!latest) {
    const value = {
      ok: true,
      status: 'none',
      installed,
      latest: null,
      message: null
    };
    _cache = { at: now, value };
    return value;
  }

  const baseHttp = route.direccionHttp || 'http://www.intecoingenieria.com/tecnodescargas';
  const policy = await tryFetchUpdatePolicy(baseHttp);
  const computed = computeUpdateStatus({ installed, latest, policy });

  const value = {
    ok: true,
    status: computed.status,
    installed,
    latest: { major: latest.major, minor: latest.minor, file: latest.name },
    message: computed.message
  };
  _cache = { at: now, value };
  return value;
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

function findExeInDir(dir, preferredNames) {
  try {
    if (!fs.statSync(dir).isDirectory()) return null;
    for (const n of preferredNames) {
      const p = path.join(dir, n);
      if (fs.existsSync(p)) return p;
    }
    const exes = fs.readdirSync(dir)
      .filter((n) => n.toLowerCase().endsWith('.exe'))
      .filter((n) => !/^unins/i.test(n) && !/uninstall/i.test(n))
      .sort();
    const best = exes.find((n) => /actualizador/i.test(n)) || exes[0];
    return best ? path.join(dir, best) : null;
  } catch {
    return null;
  }
}

function findBundledUpdaterExecutable() {
  const preferredExeNames = [
    'TareasGForma Actualizador.exe',
    'TareasGFormaActualizador.exe'
  ];

  // Producción (NSIS): el actualizador va incluido en la carpeta `Actualizador/` junto al EXE principal.
  try {
    const appDir = path.dirname(process.execPath);
    const bundledDir = path.join(appDir, 'Actualizador');
    const exe = findExeInDir(bundledDir, preferredExeNames);
    if (exe) return exe;
  } catch {
    // ignore
  }

  // Desarrollo: permitir probar el botón de "Actualizar" sin instalar el setup.
  if (!app.isPackaged) {
    try {
      const updaterEntry = path.join(app.getAppPath(), 'updater-main.js');
      if (fs.existsSync(updaterEntry)) {
        return { command: process.execPath, args: [updaterEntry, '--autostart'] };
      }
    } catch {
      // ignore
    }
  }

  return null;
}

async function findUpdaterExecutable() {
  const bundled = findBundledUpdaterExecutable();
  if (bundled) return bundled;

  const appId = 'com.tareasgforma.updater';
  const directKeys = [
    `HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`,
    `HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`,
    `HKLM\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\${appId}`
  ];

  const preferredExeNames = [
    'TareasGForma Actualizador.exe',
    'TareasGFormaActualizador.exe'
  ];

  for (const key of directKeys) {
    const rLoc = await execReg(['query', key, '/v', 'InstallLocation']);
    const rUn = await execReg(['query', key, '/v', 'UninstallString']);
    const loc = rLoc.code === 0 ? parseRegValue(rLoc.out, 'InstallLocation') : null;
    const un = rUn.code === 0 ? parseRegValue(rUn.out, 'UninstallString') : null;
    const dir = (loc && loc.trim()) ? loc.trim() : parseInstallLocationFromUninstallString(un);
    if (!dir) continue;
    const exe = findExeInDir(dir, preferredExeNames);
    if (exe) return exe;
  }

  // Fallback: buscar en resources (si algún día se empaqueta junto)
  const resDir = process.resourcesPath || '';
  const maybe = findExeInDir(resDir, []);
  return maybe;
}

async function launchUpdaterAndQuit() {
  const exe = await findUpdaterExecutable();
  if (!exe) return { ok: false, error: 'No se encontró el actualizador (no está instalado o no está incluido en la carpeta Actualizador).' };

  try {
    if (typeof exe === 'object' && exe && exe.command) {
      const child = spawn(exe.command, exe.args || [], { detached: true, stdio: 'ignore', windowsHide: false });
      child.unref();
    } else {
      const child = spawn(exe, ['--autostart'], {
        detached: true,
        stdio: 'ignore',
        windowsHide: false,
        cwd: path.dirname(exe)
      });
      child.unref();
    }
  } catch (e) {
    return { ok: false, error: e && e.message ? e.message : String(e) };
  }

  setTimeout(() => {
    try { app.quit(); } catch { /* ignore */ }
  }, 350);

  return { ok: true };
}

module.exports = {
  checkForUpdates,
  launchUpdaterAndQuit
};
