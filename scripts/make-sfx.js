/**
 * make-sfx.js
 *
 * Genera un ejecutable SFX (autoextraíble) de WinRAR para distribuir
 * actualizaciones de TareasGForma con elevación UAC automática.
 *
 * Uso:
 *   node scripts/make-sfx.js
 *   npm run dist:sfx
 *
 * Prerrequisitos:
 *   - WinRAR instalado en la máquina de build (se auto-detecta).
 *   - dist/win-unpacked/ generado previamente por electron-builder.
 *
 * Salida:
 *   dist/acTareasGFormX_Y.sfx.exe
 */

'use strict';

const fs = require('fs');
const path = require('path');

const { findWinRar, createRar, findSfxModule, createSfx } = require('./winrar');

// ─────────────────────────────────────────────────────────────────────────────
// Utilidades
// ─────────────────────────────────────────────────────────────────────────────

function isFile(p) {
  try { return fs.statSync(p).isFile(); } catch { return false; }
}

function isDir(p) {
  try { return fs.statSync(p).isDirectory(); } catch { return false; }
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function parseMajorMinor(version) {
  const parts = String(version || '').trim().split('.');
  const major = Number(parts[0]);
  const minor = Number(parts[1]);
  if (!Number.isFinite(major) || !Number.isFinite(minor)) return null;
  return { major, minor };
}

function writeInstalledVersionMarker(rootDir, mm) {
  const fileName = 'TareasGForma-InstalledVersion.json';
  const payload = JSON.stringify(
    { major: mm.major, minor: mm.minor, at: new Date().toISOString() },
    null, 2
  );
  const targets = [
    path.join(rootDir, fileName),
    path.join(rootDir, 'resources', fileName)
  ];
  for (const p of targets) {
    try {
      fs.mkdirSync(path.dirname(p), { recursive: true });
      fs.writeFileSync(p, payload, 'utf8');
    } catch { /* ignore */ }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Generación del bloque de configuración SFX
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Genera el texto de configuración SFX de WinRAR.
 * La directiva "Require administrator" hace que Windows muestre UAC al ejecutar.
 *
 * Documentación: https://www.rarlab.com/rar/unrar600.txt (sección SFX)
 */
function buildSfxConfig({ major, minor, tempExtractPath, installerName }) {
  const version = `${major}.${minor}`;
  // Ruta temporal donde el SFX extrae los archivos antes de ejecutar el bat
  const extractPath = tempExtractPath || `%TEMP%\\TareasGForma-SFX-${major}_${minor}`;

  return [
    `Title=Tareas GForma Actualizador v${version}`,
    `BeginPrompt=\\u00bfDesea actualizar Tareas GForma a la versi\\u00f3n ${version}?`,
    // Ruta de extracción temporal
    `Path=${extractPath}`,
    // Limpiar la carpeta temporal al finalizar
    `TempMode`,
    // El ejecutable que se lanzará automáticamente tras la extracción
    `Setup=${installerName || 'instalar.bat'}`,
    // Sobreescribir archivos sin preguntar
    `Overwrite=1`,
    // Modo silencioso (1: Oculta dialogo de inicio, muestra extraccion; 2: Oculta todo)
    `Silent=1`,
    // *** CLAVE: Solicitar elevación UAC antes de extraer ***
    `Require administrator`,
  ].join('\n') + '\n';
}

// ─────────────────────────────────────────────────────────────────────────────
// Generación de instalar.bat
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Genera el contenido de instalar.bat que se ejecuta dentro del SFX
 * con privilegios de Administrador (garantizados por la directiva SFX).
 */
function buildInstallerBat({ major, minor }) {
  const version = `${major}.${minor}`;

  // Rutas de destino conocidas de la instalación NSIS
  // Usamos variables de entorno para robustez en sistemas 32/64-bit
  return `@echo off
:: Establecer pagina de codigos para caracteres Windows (eñes, acentos)
chcp 1252 >nul
SETLOCAL EnableDelayedExpansion

echo ============================================================
echo   Actualizador Tareas GForma v${version}
echo ============================================================
echo.

:: ── Rutas de instalacion ────────────────────────────────────────────────────
SET "DEST1=%ProgramFiles(x86)%\\Inteco Ingenieria Avanzada S.L\\Tareas GForma"
SET "DEST2=%ProgramFiles(x86)%\\Inteco Ingenier\\u00eda Avanzada S.L\\Tareas GForma"
SET "DEST3=%ProgramFiles%\\Inteco Ingenier\\u00eda Avanzada S.L\\Tareas GForma"
SET "DEST4=%LOCALAPPDATA%\\Programs\\Tareas GForma"

:: Detectar carpeta de instalacion real
SET "DEST="
IF EXIST "%DEST1%\\resources\\app.asar" SET "DEST=%DEST1%"
IF NOT DEFINED DEST IF EXIST "%DEST2%\\resources\\app.asar" SET "DEST=%DEST2%"
IF NOT DEFINED DEST IF EXIST "%DEST3%\\resources\\app.asar" SET "DEST=%DEST3%"
IF NOT DEFINED DEST IF EXIST "%DEST4%\\resources\\app.asar" SET "DEST=%DEST4%"

IF NOT DEFINED DEST (
  echo [ERROR] No se encontro la carpeta de instalacion de Tareas GForma.
  echo Por favor, reinstale la aplicacion usando el instalador principal.
  pause
  exit /b 1
)

echo [OK] Carpeta de instalacion detectada:
echo      "!DEST!"
echo.

:: ── Cerrar la aplicacion si esta en ejecucion ────────────────────────────────
echo [1/4] Cerrando Tareas GForma si esta en ejecucion...
taskkill /IM "Tareas GForma.exe" /F >nul 2>&1
taskkill /IM TareasGForma.exe /F >nul 2>&1
timeout /t 2 /nobreak >nul

:: ── Copiar archivos al directorio de instalacion ─────────────────────────────
echo [2/4] Copiando archivos de actualizacion...
SET "SFX_ROOT=%~dp0"

:: Copiar todo salvo los archivos excluidos y Config.xml (para preservarlo si existe)
xcopy /E /Y /I /Q "%SFX_ROOT%*" "!DEST!\\" /EXCLUDE:"%SFX_ROOT%exclude.txt" >nul 2>&1

:: Si Config.xml NO existe en destino, copiarlo del SFX (instalacion limpia o reparacion)
IF NOT EXIST "!DEST!\\Config.xml" (
  IF EXIST "%SFX_ROOT%Config.xml" (
    copy /Y "%SFX_ROOT%Config.xml" "!DEST!\\Config.xml" >nul
  )
)

IF ERRORLEVEL 1 (
  echo [AVISO] Algunos archivos no pudieron copiarse ^(pueden estar en uso^).
)

:: ── Reparar/crear acceso directo en escritorio publico ───────────────────────
echo [3/4] Actualizando acceso directo del escritorio...
powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command ^
  "$ws = New-Object -ComObject WScript.Shell; ^
  $desktop_public = [Environment]::GetFolderPath('CommonDesktopDirectory'); ^
  $desktop_user   = [Environment]::GetFolderPath('Desktop'); ^
  foreach ($dsk in @($desktop_public, $desktop_user)) { ^
    $lnk = $ws.CreateShortcut(($dsk + '\\Tareas GForma.lnk')); ^
    $lnk.TargetPath      = ('!DEST!\\Tareas GForma.exe' -replace '!','^!'); ^
    $lnk.WorkingDirectory = ('!DEST!' -replace '!','^!'); ^
    $lnk.Description     = 'Tareas GForma v${version}'; ^
    $lnk.Save() ^
  }" 2>nul

:: ── Finalizar ────────────────────────────────────────────────────────────────
echo [4/4] Actualizacion completada.
echo.
echo  Tareas GForma se ha actualizado a la version ${version}.
echo  Abriendo aplicacion...
echo.

:: Lanzar la aplicacion recien actualizada
start "" "!DEST!\\Tareas GForma.exe"

ENDLOCAL
exit /b 0
`;
}

// ─────────────────────────────────────────────────────────────────────────────
// Script principal
// ─────────────────────────────────────────────────────────────────────────────

function main() {
  const rootDir    = path.resolve(__dirname, '..');
  const pkgPath    = path.join(rootDir, 'package.json');
  const distDir    = path.join(rootDir, 'dist');
  const unpackedDir = path.join(distDir, 'win-unpacked');

  // ── Leer versión ─────────────────────────────────────────────────────────
  if (!isFile(pkgPath)) {
    console.error('[make-sfx] No se encontró package.json.');
    process.exit(1);
  }

  const pkg = readJson(pkgPath);
  const mm  = parseMajorMinor(pkg.version);
  if (!mm) {
    console.error(`[make-sfx] Versión inválida en package.json: "${pkg.version}". Se espera X.Y.Z`);
    process.exit(1);
  }

  console.log(`[make-sfx] Versión: ${mm.major}.${mm.minor}`);

  // ── Verificar que existe win-unpacked ────────────────────────────────────
  if (!isDir(unpackedDir)) {
    console.error('[make-sfx] No se encontró dist/win-unpacked/. Ejecuta primero: npm run build');
    process.exit(1);
  }

  // ── Localizar herramientas ───────────────────────────────────────────────
  const rarPath = findWinRar();
  if (!rarPath) {
    console.error('[make-sfx] No se encontró WinRAR/rar.exe. Instala WinRAR o define WINRAR_PATH.');
    process.exit(1);
  }
  console.log(`[make-sfx] WinRAR: ${rarPath}`);

  const sfxModule = findSfxModule();
  if (!sfxModule) {
    console.error('[make-sfx] No se encontró Default.SFX de WinRAR. Instala WinRAR 64-bit completo.');
    process.exit(1);
  }
  console.log(`[make-sfx] Default.SFX: ${sfxModule}`);

  // ── Preparar staging ─────────────────────────────────────────────────────
  const stagingDir = path.join(distDir, `._sfx_staging_${Date.now()}`);
  fs.mkdirSync(stagingDir, { recursive: true });

  const INSTALLER_NAME = 'instalar.bat';

  // Escribir instalar.bat
  const batContent = buildInstallerBat({ major: mm.major, minor: mm.minor });
  fs.writeFileSync(path.join(stagingDir, INSTALLER_NAME), batContent, 'utf8');
  console.log(`[make-sfx] instalar.bat generado.`);

  // Escribir exclude.txt (archivos que xcopy debe omitir en destino)
  const excludeContent = [
    INSTALLER_NAME,
    'exclude.txt',
    'TareasGForma-InstalledVersion.json',
    'Actualizador\\',    // No sobrescribir el actualizador en caliente
    'instalar.bat',
  ].join('\r\n') + '\r\n';
  fs.writeFileSync(path.join(stagingDir, 'exclude.txt'), excludeContent, 'utf8');

  // Escribir marcador de versión instalada
  writeInstalledVersionMarker(stagingDir, mm);

  // ── Crear .rar en staging (sin Actualizador/) ────────────────────────────
  const rarName = `acTareasGForm${mm.major}_${mm.minor}.rar`;
  const rarPath2 = path.join(stagingDir, rarName);

  console.log(`[make-sfx] Creando RAR intermedio: ${rarName}...`);

  // Primero copiar los archivos de win-unpacked al staging (excepto Actualizador/)
  // Para ello creamos una subcarpeta "payload" dentro del staging y copiamos ahí
  const payloadDir = path.join(stagingDir, 'payload');
  fs.mkdirSync(payloadDir, { recursive: true });

  // Copiar win-unpacked → payload (xcopy) a través de spawn síncrono
  const { spawnSync } = require('child_process');
  const xcopyResult = spawnSync(
    'xcopy',
    [unpackedDir, payloadDir, '/E', '/I', '/Q', '/Y'],
    { windowsHide: true, encoding: 'utf8', shell: true }
  );
  if (xcopyResult.status !== 0) {
    console.error('[make-sfx] Error copiando win-unpacked:', xcopyResult.stderr || xcopyResult.stdout);
    cleanupAndExit(stagingDir, 1);
  }

  // Escribir marcadores de versión también en payload (para que el .rar los incluya)
  writeInstalledVersionMarker(payloadDir, mm);

  // Copiar instalar.bat y exclude.txt al payload para que vayan dentro del SFX
  fs.copyFileSync(path.join(stagingDir, INSTALLER_NAME), path.join(payloadDir, INSTALLER_NAME));
  fs.copyFileSync(path.join(stagingDir, 'exclude.txt'), path.join(payloadDir, 'exclude.txt'));

  // Crear el .rar desde el directorio payload
  try {
    createRar({
      rarPath,
      archivePath: rarPath2,
      sourceDir: payloadDir,
      exclude: ['Actualizador\\*']
    });
    console.log(`[make-sfx] RAR creado: ${rarName}`);
  } catch (e) {
    console.error(`[make-sfx] Error creando RAR: ${e && e.message ? e.message : String(e)}`);
    cleanupAndExit(stagingDir, 1);
  }

  // ── Generar configuración SFX ────────────────────────────────────────────
  const sfxConfigText = buildSfxConfig({
    major: mm.major,
    minor: mm.minor,
    installerName: INSTALLER_NAME
  });

  // ── Ensamblar SFX final ──────────────────────────────────────────────────
  const sfxName    = `acTareasGForm${mm.major}_${mm.minor}.sfx.exe`;
  const sfxOutPath = path.join(distDir, sfxName);

  console.log(`[make-sfx] Ensamblando SFX: ${sfxName}...`);
  try {
    createSfx({
      sfxModulePath: sfxModule,
      rarPath: rarPath2,
      sfxConfigText,
      outputPath: sfxOutPath,
      iconPath: path.join(rootDir, 'assets', 'icon.ico')
    });
  } catch (e) {
    console.error(`[make-sfx] Error ensamblando SFX: ${e && e.message ? e.message : String(e)}`);
    cleanupAndExit(stagingDir, 1);
  }

  // ── Limpiar staging ──────────────────────────────────────────────────────
  cleanupAndExit(stagingDir, 0, sfxOutPath);
}

function cleanupAndExit(stagingDir, code, sfxOutPath) {
  try { fs.rmSync(stagingDir, { recursive: true, force: true }); } catch { /* ignore */ }
  if (code === 0 && sfxOutPath) {
    const sizeMb = (fs.statSync(sfxOutPath).size / 1_048_576).toFixed(1);
    console.log(`[make-sfx] ✓ SFX generado: ${path.basename(sfxOutPath)} (${sizeMb} MB)`);
    console.log(`[make-sfx]   Ruta: ${sfxOutPath}`);
    console.log(`[make-sfx]   Distribuya este archivo a los usuarios.`);
    console.log(`[make-sfx]   Al ejecutarlo se solicitará UAC (Administrador) automáticamente.`);
  }
  process.exit(code);
}

main();
