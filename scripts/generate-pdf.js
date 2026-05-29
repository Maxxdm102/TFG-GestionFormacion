const fs = require('fs');
const path = require('path');
const { mdToPdf } = require('md-to-pdf');

(async () => {
  const mdPath = path.join(__dirname, '..', 'docs', 'Memoria_Barca.md');
  const pdfPath = path.join(__dirname, '..', 'docs', 'Memoria_Barca.pdf');

  try {
    console.log(`Convirtiendo ${mdPath} a PDF...`);
    const pdf = await mdToPdf({ path: mdPath }, { dest: pdfPath });
    if (pdf) {
      console.log(`¡PDF generado correctamente en ${pdfPath}!`);
    }
  } catch (err) {
    console.error('Error al generar PDF:', err);
  }
})();
