# Automatización SFX/WinRAR con Elevación UAC

## Problema y Contexto

El sistema de actualización ya funciona (descarga desde FTP, aplica parches `.rar`, actualiza accesos directos). Sin embargo, el escenario **multi-usuario estándar** presenta un problema crítico:

- La app se instala en `%ProgramFiles(x86)%\Inteco...\TareasGForma` → zona **protegida por NTFS**.
- Los empleados (**usuarios estándar**) no pueden escribir en esa ruta sin elevación → `fs.copyFileSync()` falla silenciosamente o lanza un error EPERM.
- El actualizador `.exe` actual no solicita UAC por sí mismo (no tiene `requireAdministrator` en su manifiesto).

**Objetivo**: Crear un método de distribución que garantice que la actualización siempre se ejecute con permisos de Administrador, sin importar qué usuario lo lance.

---

## Propuesta de Solución — SFX de WinRAR con Script de Auto-Instalación

La estrategia más robusta y compatible con el stack existente (WinRAR ya presente en el pipeline) es generar un **SFX autoextraíble** que:

1. Se auto-extrae a un directorio temporal.
2. Ejecuta automáticamente un **script de instalación** (`instalar.bat` / `instalar.ps1`) con `Require UAC=Yes` vía el módulo SFX de WinRAR.
3. El script reemplaza `TareasGForma.exe`, copia archivos de soporte, y repara el acceso directo del escritorio.

> [!IMPORTANT]
> WinRAR SFX puede incluir la directiva `Setup=<comando>` y `Overwrite=1` en su cabecera de configuración. La directiva **`Require administrator`** (sfx config comment) hace que Windows presente el diálogo UAC al usuario antes de extraer, sin necesidad de firmar el ejecutable.

---

## User Review Required

> [!WARNING]
> El módulo SFX de WinRAR (`Default.SFX`) debe estar presente en la máquina de **build** (no en la de destino). La ruta típica es `C:\Program Files\WinRAR\Default.SFX`. El script detectará automáticamente la ruta, pero si WinRAR no está instalado en la máquina de build, la generación del SFX fallará.

> [!IMPORTANT]
> El SFX resultante **no reemplaza el flujo FTP existente**. Es un artefacto alternativo para distribución manual/USB/red o intranet, ideal cuando no se quiere depender del actualizador Electron en equipos con restricciones de red.

---

## Propuesta de Cambios

### 1. Script de Generación del SFX

#### [NEW] [make-sfx.js](file:///c:/Users/mdbarca/Desktop/TareasGForma/scripts/make-sfx.js)

Nuevo script de Node.js que:
- Lee la versión de `package.json`.
- Genera `instalar.bat` (script de instalación elevado) en el staging.
- Genera el **comentario de configuración SFX** (`sfx-config.txt`) con:
  ```
  Title=TareasGForma Actualizador vX.Y
  BeginPrompt=¿Desea actualizar TareasGForma a la versión X.Y?
  Setup=instalar.bat
  Overwrite=1
  Path=%TEMP%\TareasGForma-SFX
  Silent=1
  Shortcut=D,TareasGForma.lnk,,,,TareasGForma
  Require administrator
  ```
- Concatena: `Default.SFX` + `sfx-config.txt` + el `.rar` → **`acTareasGFormX_Y.sfx.exe`**
- También puede usar `WinRAR.exe` con flags `-sfx` si se prefiere.

**Flujo de archivos dentro del SFX:**
```
acTareasGForm1_5.sfx.exe
├── (todos los archivos de win-unpacked/ excepto Actualizador/)
├── instalar.bat          ← ejecutado automáticamente post-extracción
└── TareasGForma-InstalledVersion.json
```

#### [MODIFY] [winrar.js](file:///c:/Users/mdbarca/Desktop/TareasGForma/scripts/winrar.js)

Añadir función `createSfx()` que localiza `Default.SFX` y ensambla el ejecutable autoextraíble usando `rar.exe` con la opción `-sfx`.

#### [MODIFY] [package.json](file:///c:/Users/mdbarca/Desktop/TareasGForma/package.json)

Añadir script npm:
```json
"dist:sfx": "node scripts/make-sfx.js"
```

---

### 2. Script de Instalación dentro del SFX

#### Contenido de `instalar.bat` (generado dinámicamente):

```bat
@echo off
:: Este script se ejecuta como Administrador gracias a "Require administrator" del SFX

SET "DEST=%ProgramFiles(x86)%\Inteco Ingeniería Avanzada S.L\Tareas GForma\TareasGForma"
SET "SFX_ROOT=%~dp0"

:: 1. Cerrar aplicación si está en ejecución
taskkill /IM TareasGForma.exe /F >nul 2>&1
timeout /t 2 /nobreak >nul

:: 2. Copiar archivos (xcopy recursivo, sobreescribir, silencioso)
::    Preservar Config.xml si ya existe
xcopy /E /Y /I /Q "%SFX_ROOT%*" "%DEST%\" /EXCLUDE:"%SFX_ROOT%exclude.txt"

:: 3. Reparar/crear acceso directo en escritorio (todos los usuarios)
powershell -NoProfile -NonInteractive -Command ^
  "$ws = New-Object -ComObject WScript.Shell; ^
  $lnk = $ws.CreateShortcut('%PUBLIC%\Desktop\TareasGForma.lnk'); ^
  $lnk.TargetPath = '%DEST%\TareasGForma.exe'; ^
  $lnk.WorkingDirectory = '%DEST%'; ^
  $lnk.Description = 'Tareas GForma'; ^
  $lnk.Save()"

:: 4. Mensaje final
echo Actualizacion completada correctamente.
```

El archivo `exclude.txt` excluye:
```
instalar.bat
exclude.txt
TareasGForma-InstalledVersion.json  ← para no pisar si ya existe más nuevo
Actualizador\
```

---

### 3. Entorno Multi-Usuario — Permisos NTFS

> [!NOTE]
> Con `Require administrator` en el SFX, el proceso se eleva vía UAC. El script bat corre como `SYSTEM`/Admin y puede escribir en `%ProgramFiles(x86)%` sin problemas. El escritorio de todos los usuarios (`%PUBLIC%\Desktop`) también es accesible con esos permisos.

**Flujo de acceso directo para todos los usuarios:**
- El bat escribe en `C:\Users\Public\Desktop\TareasGForma.lnk` → visible para **todos** los usuarios del equipo.
- El script PowerShell del `updater-main.js` ya busca `publicDesktop` — sin cambios necesarios.

---

### 4. Actualización del `updater-main.js` — Soporte SFX en FTP

Opcionalmente, el actualizador Electron puede detectar y ejecutar el `.sfx.exe` del FTP en lugar del `.rar`, delegando la instalación al SFX con UAC automático:

#### [MODIFY] [updater-main.js](file:///c:/Users/mdbarca/Desktop/TareasGForma/updater-main.js)

En `pickLatestFullPackage()`, añadir patrón para `.sfx.exe`:
```js
{ re: /^acTareasGForm(\d+)[._-](\d+).*\.sfx\.exe$/i, kind: 'sfx-installer' },
```

En `runUpdateFlowPackages()`, manejar `kind === 'sfx-installer'`:
1. Descargar el `.sfx.exe` a `%TEMP%`.
2. Cerrrar la app principal.
3. Lanzar el `.sfx.exe` con `runas` / `ShellExecute verb=runas` para forzar UAC.
4. Salir del actualizador.

---

## Verificación

### Build
```powershell
# Requiere WinRAR instalado en la máquina de build
npm run dist:sfx
# Genera: dist/acTareasGForm1_5.sfx.exe
```

### Test Manual
1. Copiar `acTareasGForm1_5.sfx.exe` a un equipo con usuario **estándar**.
2. Hacer doble clic → debe aparecer diálogo UAC solicitando credenciales de Admin.
3. Introducir credenciales → extracción + instalación automática.
4. Verificar que `TareasGForma.exe` se actualizó y el acceso directo del escritorio es válido.
5. Abrir TareasGForma con el usuario estándar → debe funcionar correctamente.

---

## Orden de Implementación

1. `scripts/winrar.js` → añadir `findSfxModule()` + `createSfx()`
2. `scripts/make-sfx.js` → nuevo script de build
3. `package.json` → añadir `"dist:sfx"` 
4. `updater-main.js` → soporte para `kind: 'sfx-installer'` (opcional, bajo tu aprobación)
