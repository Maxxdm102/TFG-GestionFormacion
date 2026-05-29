const { checkForUpdates } = require('../src/updater-check');
const path = require('path');
const fs = require('fs');

// We copy functions from updater-check.js to get route and list all FTP files
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

  const res = await fetch('http://intecodistribucionsrv.intecoingenieria.com/distribucionsrv.asmx', {
    method: 'POST',
    headers: {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': soapAction
    },
    body
  });
  return await res.text();
}

async function getFtpRoute() {
  const soapAction = 'http://tempuri.org/CogeRutasDescargaPorIdAplicacion';
  const inner = `<CogeRutasDescargaPorIdAplicacion xmlns="http://tempuri.org/">` +
    `<iIdAplicacion>40</iIdAplicacion>` +
    `</CogeRutasDescargaPorIdAplicacion>`;

  const soapXml = await soapCall(soapAction, inner);
  const escaped = extractTag(soapXml, 'CogeRutasDescargaPorIdAplicacionResult');
  const decodedDs = htmlDecode(escaped || '');

  const servidor = extractTag(decodedDs, 'Servidor');
  const carpeta = extractTag(decodedDs, 'Carpeta') || '';
  const usuario = extractTag(decodedDs, 'Usuario');
  const contrasena = extractTag(decodedDs, 'Contrasena');
  const direccionHttp = extractTag(decodedDs, 'DireccionHttp');

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
    return entries.map((e) => `${e.name} (${e.size} bytes)`);
  } finally {
    client.close();
  }
}

(async () => {
  const route = await getFtpRoute();
  console.log('Route:', route);
  const files = await listRemoteInstallersFtp(route);
  console.log('Files on FTP:', files);
})().catch(console.error);
