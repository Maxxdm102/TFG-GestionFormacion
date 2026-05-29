# Release (Windows)

## Setup único (app + actualizador)

- Generar instalador y artefactos FTP: `npm run dist`
- Salidas principales:
  - `dist/TareasGForma-Setup-<version>.exe` (instalador)
  - `dist/TareasGForma-Setup.exe` (copia “latest” del instalador)
  - `dist/acTareasGForm<major>_<minor>.rar` (paquete para el actualizador)

## Notas

- El actualizador se incluye dentro del instalador principal en `Actualizador/` (no hay un setup aparte para distribuir).
- El `.rar` de parches excluye `Actualizador/` para evitar que el actualizador se sobreescriba mientras está ejecutándose.
- Si necesitas construir el actualizador aparte:
  - `npm run dist:updater` (salida en `dist-updater/`)

