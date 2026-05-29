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

(async () => {
  const soapAction = 'http://tempuri.org/CogeModulosPorIdAplicacion';
  const inner = `<CogeModulosPorIdAplicacion xmlns="http://tempuri.org/">` +
    `<iIdAplicacion>40</iIdAplicacion>` +
    `</CogeModulosPorIdAplicacion>`;

  const soapXml = await soapCall(soapAction, inner);
  const escaped = extractTag(soapXml, 'CogeModulosPorIdAplicacionResult');
  const decodedDs = htmlDecode(escaped || '');
  console.log('Decoded WebService modules response:');
  console.log(decodedDs);
})().catch(console.error);
