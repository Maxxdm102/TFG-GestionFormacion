const { app } = require('electron');
const path = require('path');
const fs = require('fs');

const CONFIG = {
  serviceUrl: 'http://intecodistribucionsrv.intecoingenieria.com/distribucionsrv.asmx',
  appId: 40,
  baseVersion: 1
};

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

function parseMajorMinor(s) {
  const m = String(s || '').trim().match(/^(\d+)\.(\d+)(?:\.\d+)?/);
  if (!m) return null;
  return { major: Number(m[1]), minor: Number(m[2]) };
}

function getLocalVersion() {
  try {
    const pkgPath = path.join(__dirname, '..', 'package.json');
    if (fs.existsSync(pkgPath)) {
      const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
      if (pkg.version) {
        const mm = parseMajorMinor(pkg.version);
        if (mm) return mm;
      }
    }
  } catch (e) {
    console.error('Error al leer el package.json local:', e);
  }
  return { major: 1, minor: 0 };
}

async function getModuloFromWebservice() {
  const soapAction = 'http://tempuri.org/CogeModulosPorIdAplicacion';
  const inner = `<CogeModulosPorIdAplicacion xmlns="http://tempuri.org/">` +
    `<iIdAplicacion>${CONFIG.appId}</iIdAplicacion>` +
    `</CogeModulosPorIdAplicacion>`;

  const soapXml = await soapCall(soapAction, inner);
  const escaped = extractTag(soapXml, 'CogeModulosPorIdAplicacionResult');
  const decodedDs = htmlDecode(escaped || '');

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

  const name = `acTareasGForm${major}_${minor}.exe`;
  const kind = 'direct-exe';

  return { name, major, minor, kind };
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

/**
 * Revisa el WebService para obtener la versión oficial registrada, y si es mayor que la instalada,
 * revisa el FTP para elegir el formato ideal.
 * - Caso 1: P_WS > P_INSTALADA => OBLIGATORIA
 * - Caso 2: P_WS == P_INSTALADA Y S_WS > S_INSTALADA => OPCIONAL
 */
async function checkForUpdates() {
  try {
    const localVersion = getLocalVersion();
    const officialModule = await getModuloFromWebservice();

    let isMandatory = false;
    let hasUpdate = false;

    if (officialModule.major > localVersion.major) {
      isMandatory = true;
      hasUpdate = true;
    } else if (officialModule.major === localVersion.major && officialModule.minor > localVersion.minor) {
      isMandatory = false;
      hasUpdate = true;
    }

    if (!hasUpdate) {
      return {
        hasUpdate: false,
        isMandatory: false,
        local: localVersion,
        latest: officialModule
      };
    }

    // Si hay actualización disponible, listamos FTP para buscar el mejor formato para esa versión
    let latest = officialModule;
    try {
      const route = await getFtpRoute();
      const names = await listRemoteInstallersFtp(route);
      const bestPkg = pickBestPackageForVersion(names, officialModule.major, officialModule.minor);
      if (bestPkg) {
        latest = bestPkg;
      }
    } catch (ftpError) {
      console.warn('Error al buscar formato preferido en FTP, se usará el del WebService:', ftpError);
    }

    return {
      hasUpdate,
      isMandatory,
      local: localVersion,
      latest
    };
  } catch (error) {
    console.error('Error al comprobar actualizaciones silenciosamente:', error);
    return { hasUpdate: false, isMandatory: false, error: error.message };
  }
}

module.exports = {
  checkForUpdates
};

