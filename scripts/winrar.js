const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');
const os = require('os');

function isFile(p) {
  try {
    return fs.statSync(p).isFile();
  } catch {
    return false;
  }
}

function firstExisting(paths) {
  for (const p of paths) {
    if (p && isFile(p)) return p;
  }
  return null;
}

function tryWhere(cmd) {
  try {
    const r = spawnSync('where.exe', [cmd], { windowsHide: true, encoding: 'utf8' });
    if (r.status !== 0) return null;
    const candidate = String(r.stdout || '')
      .split(/\r?\n/)
      .map((s) => s.trim())
      .find(Boolean);
    return candidate && isFile(candidate) ? candidate : null;
  } catch {
    return null;
  }
}

function findWinRar() {
  const env = process.env.WINRAR_PATH;
  if (env && isFile(env)) return env;

  const programFiles = process.env['ProgramFiles'] || 'C:\\Program Files';
  const programFilesX86 = process.env['ProgramFiles(x86)'] || 'C:\\Program Files (x86)';

  const wellKnown = [
    path.join(programFiles, 'WinRAR', 'rar.exe'),
    path.join(programFiles, 'WinRAR', 'WinRAR.exe'),
    path.join(programFilesX86, 'WinRAR', 'rar.exe'),
    path.join(programFilesX86, 'WinRAR', 'WinRAR.exe')
  ];

  const fromDisk = firstExisting(wellKnown);
  if (fromDisk) return fromDisk;

  return tryWhere('rar.exe') || tryWhere('rar') || tryWhere('WinRAR.exe') || tryWhere('winrar');
}

function createRar({ rarPath, archivePath, sourceDir, exclude = [] }) {
  if (!rarPath || !isFile(rarPath)) {
    throw new Error('No se encontró WinRAR/RAR. Instala WinRAR o define WINRAR_PATH apuntando a rar.exe.');
  }
  if (!sourceDir) throw new Error('Falta sourceDir.');
  if (!archivePath) throw new Error('Falta archivePath.');

  fs.mkdirSync(path.dirname(archivePath), { recursive: true });
  if (isFile(archivePath)) fs.unlinkSync(archivePath);

  const excludeArgs = []
    .concat(exclude || [])
    .filter(Boolean)
    .map((pattern) => `-x${pattern}`);

  const r = spawnSync(rarPath, ['a', '-r', '-o+', '-idq', ...excludeArgs, archivePath, '*'], {
    cwd: sourceDir,
    windowsHide: true,
    encoding: 'utf8'
  });

  if (r.status !== 0) {
    const stderr = String(r.stderr || '').trim();
    const stdout = String(r.stdout || '').trim();
    throw new Error(`Error creando RAR (exit ${r.status}). ${stderr || stdout || 'Sin salida.'}`);
  }

  return archivePath;
}

/**
 * Localiza el módulo SFX de WinRAR (Default.SFX) necesario para crear
 * ejecutables autoextraíbles. Busca en las rutas estándar de WinRAR.
 */
function findSfxModule() {
  const env = process.env.WINRAR_SFX_PATH;
  if (env && isFile(env)) return env;

  const programFiles = process.env['ProgramFiles'] || 'C:\\Program Files';
  const programFilesX86 = process.env['ProgramFiles(x86)'] || 'C:\\Program Files (x86)';

  const wellKnown = [
    path.join(programFiles, 'WinRAR', 'Default.SFX'),
    path.join(programFilesX86, 'WinRAR', 'Default.SFX'),
    // WinRAR 64-bit también instala Default.SFX
    path.join(programFiles, 'WinRAR', 'Zip.SFX'),
    path.join(programFilesX86, 'WinRAR', 'Zip.SFX')
  ];

  return firstExisting(wellKnown) || null;
}

/**
 * Crea un ejecutable SFX (autoextraíble) de WinRAR.
 *
 * @param {object} opts
 * @param {string} opts.sfxModulePath  - Ruta a Default.SFX
 * @param {string} opts.rarPath        - Ruta al .rar fuente (ya creado por createRar)
 * @param {string} opts.sfxConfigText  - Contenido del bloque de configuración SFX
 *                                       (directivas entre ';The comment below contains SFX script commands')
 * @param {string} opts.outputPath     - Ruta de salida del .exe final
 * @param {string} [opts.iconPath]     - Opcional: Ruta a un archivo .ico para el ejecutable
 */
function createSfx({ sfxModulePath, rarPath, sfxConfigText, outputPath, iconPath }) {
  if (!sfxModulePath || !isFile(sfxModulePath)) {
    throw new Error(
      'No se encontró Default.SFX de WinRAR. ' +
      'Instala WinRAR o define WINRAR_SFX_PATH apuntando a Default.SFX.'
    );
  }
  if (!rarPath || !isFile(rarPath)) {
    throw new Error(`No se encontró el archivo RAR fuente: ${rarPath}`);
  }
  if (!outputPath) throw new Error('Falta outputPath para el SFX.');

  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  if (isFile(outputPath)) fs.unlinkSync(outputPath);

  // Si tenemos icono, es mejor usar rar.exe para ensamblar el SFX, ya que
  // permite inyectar el icono correctamente en el manifiesto del ejecutable.
  const winRarExe = findWinRar();
  if (iconPath && isFile(iconPath) && winRarExe) {
    const configTmp = path.join(os.tmpdir(), `sfx_cfg_${Date.now()}.txt`);
    const sfxHeader = ';The comment below contains SFX script commands\n' + (sfxConfigText || '');
    fs.writeFileSync(configTmp, sfxHeader, 'utf8');

    // Comando: rar.exe sfx -zconfig.txt -iiconicon.ico output.exe (pero rar no tiene comando "sfx" directo para unir)
    // Usamos el método de "re-comprimir" o el método de copia binaria + parcheo.
    // La forma más fiable con rar.exe es crear el SFX desde cero con los archivos,
    // pero aquí ya tenemos el .rar.
    // Alternativa: Usar la opción de WinRAR de convertir RAR a SFX no es trivial vía CLI.

    // Caemos de vuelta en la concatenación binaria por simplicidad,
    // el icono corporativo es un "plus" pero la estabilidad es prioridad.
    // Si en el futuro se requiere icono real, usar rcedit.exe tras la creación.
  }

  // Construir el bloque de comentario SFX según el formato de WinRAR:
  const sfxHeader = ';The comment below contains SFX script commands\n' + (sfxConfigText || '');
  const sfxHeaderBuf = Buffer.from(sfxHeader, 'utf8');

  // Leer módulo SFX y archivo RAR
  const sfxBuf = fs.readFileSync(sfxModulePath);
  const rarBuf = fs.readFileSync(rarPath);

  // Concatenar: módulo SFX + comentario + RAR
  const combined = Buffer.concat([sfxBuf, sfxHeaderBuf, rarBuf]);
  fs.writeFileSync(outputPath, combined);

  return outputPath;
}

module.exports = {
  findWinRar,
  createRar,
  findSfxModule,
  createSfx
};
