# Walkthrough — SFX/WinRAR con Elevación UAC

## Cambios Realizados

### 1. `scripts/winrar.js` — Nuevas funciones SFX

Añadidas dos funciones exportadas:

| Función | Descripción |
|---|---|
| `findSfxModule()` | Localiza `Default.SFX` de WinRAR en rutas estándar (`%ProgramFiles%\WinRAR\Default.SFX`). Soporta variable de entorno `WINRAR_SFX_PATH` para override. |
| `createSfx(opts)` | Ensambla el ejecutable final concatenando en binario: `Default.SFX` + cabecera de config SFX + el `.rar` fuente. Respeta el formato estándar de WinRAR SFX. |

### 2. `scripts/make-sfx.js` — Script de build del SFX (NUEVO)

Script Node.js invocado con `npm run dist:sfx`. Hace:

1. Lee la versión de `package.json` (ej. `1.5.0` → major=1, minor=5).
2. Verifica que existe `dist/win-unpacked/`.
3. Localiza `rar.exe` y `Default.SFX` automáticamente.
4. Crea directorio staging temporal.
5. Genera **`instalar.bat`** dinámicamente con la versión correcta y las 4 rutas de instalación posibles.
6. Genera **`exclude.txt`** para que `xcopy` omita `instalar.bat`, `exclude.txt` y la carpeta `Actualizador\`.
7. Copia `win-unpacked/` al staging y crea el `.rar` intermedio (excluyendo `Actualizador\*`).
8. Genera la cabecera SFX con `Require administrator` → esto fuerza UAC.
9. Ensambla el `.sfx.exe` final con `createSfx()`.
10. Limpia el staging.

**Salida:** `dist/acTareasGForm1_5.sfx.exe`

### 3. `package.json` — Nuevo script npm

```json
"dist:sfx": "node scripts/make-sfx.js"
```

### 4. `updater-main.js` — Soporte para `sfx-installer` desde FTP

- `pickLatestFullPackage()`: Nuevo patrón regex `acTareasGFormX_Y.sfx.exe` con `kind: 'sfx-installer'` — tiene **prioridad** sobre `.rar` y `.exe` porque el SFX maneja UAC por sí solo.
- `runUpdateFlowPackages()`: Nueva rama `sfx-installer` que:
  1. Descarga el `.sfx.exe` a `%TEMP%`.
  2. Cierra `TareasGForma.exe` (libera archivos bloqueados).
  3. Lanza el SFX vía `powershell Start-Process -Verb RunAs` → Windows muestra UAC.
  4. Muestra estado `ready` y cierra el actualizador (el SFX toma el control).

---

## Cómo Construir el SFX

```powershell
# Prerrequisito: electron-builder ya corrió y existe dist/win-unpacked/
npm run dist:sfx

# Salida esperada:
# [make-sfx] Versión: 1.5
# [make-sfx] WinRAR: C:\Program Files\WinRAR\rar.exe
# [make-sfx] Default.SFX: C:\Program Files\WinRAR\Default.SFX
# [make-sfx] instalar.bat generado.
# [make-sfx] Creando RAR intermedio: acTareasGForm1_5.rar...
# [make-sfx] RAR creado: acTareasGForm1_5.rar
# [make-sfx] Ensamblando SFX: acTareasGForm1_5.sfx.exe...
# [make-sfx] ✓ SFX generado: acTareasGForm1_5.sfx.exe (90.3 MB)
```

---

## Flujo de Actualización End-to-End

```
Empleado (usuario estándar)
         │
         ▼
  Lanza Actualizador
  (TareasGForma Actualizador.exe)
         │
         ├─ Conecta al web service SOAP → obtiene credenciales FTP
         ├─ Lista archivos FTP
         ├─ Detecta acTareasGForm1_5.sfx.exe (nueva versión)
         ├─ Descarga .sfx.exe a %TEMP%
         ├─ Cierra TareasGForma.exe
         └─ PowerShell: Start-Process -Verb RunAs
                  │
                  ▼
           Windows UAC Dialog
           [introducir credenciales Admin]
                  │
                  ▼
       SFX se extrae a %TEMP%\TareasGForma-SFX-1_5\
                  │
                  ├─ xcopy archivos → C:\Program Files (x86)\...\TareasGForma\
                  │   (preservando Config.xml existente gracias a exclude.txt)
                  └─ PowerShell crea/repara acceso directo en:
                       C:\Users\Public\Desktop\TareasGForma.lnk
                         (visible para TODOS los usuarios del equipo)
```

---

## Distribución Alternativa (sin FTP)

El `.sfx.exe` se puede distribuir también por:
- **Red compartida / carpeta de red**
- **USB**
- **Correo electrónico** (si el tamaño lo permite)
- **Enlace HTTP directo**

El empleado simplemente hace doble clic → UAC → actualización automática.

---

## Prioridad de Formatos en el FTP

El actualizador busca paquetes en este orden de preferencia:

| Prioridad | Formato | Kind | Acción |
|---|---|---|---|
| 1 | `TareasGForma-Full-X.Y.rar` | `archive` | Extrae y copia (sin UAC nativo) |
| 2 | `TareasGForma-Full-X.Y.exe` | `installer` | Lanza instalador NSIS |
| **3** | **`acTareasGFormX_Y.sfx.exe`** | **`sfx-installer`** | **Descarga y lanza con UAC ✓** |
| 4 | `acTareasGFormX_Y.rar` | `archive` | Extrae y copia |
| 5 | `acTareasGFormX_Y.exe` | `direct-exe` | Copia EXE directo |

> Subir el `.sfx.exe` al FTP hace que el actualizador lo prefiera automáticamente sobre el `.rar` del mismo número de versión, delegando la elevación al SFX.
