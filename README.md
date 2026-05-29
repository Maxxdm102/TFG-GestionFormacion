# Tareas GForma

Aplicación de escritorio basada en Electron para la gestión de tareas, tiempos y presupuestos, conectada a una base de datos SQL Server.

## Características principales
- Gestión multiusuario concurrente.
- Registro y asignación de tareas a distintos perfiles.
- Control de presencia y generación de informes (CSV, PDF).
- Base de datos relacional con consultas completas.

## Requisitos previos
- **Node.js** (v16 o superior).
- **SQL Server** (se puede usar la versión Developer o Express).
- Conexión a la red local o base de datos accesible de forma externa si procede.

## Instalación y ejecución

1. Clona o descarga el repositorio.
2. Instala las dependencias necesarias:
   ```bash
   npm install
   ```
3. Ejecuta la aplicación en modo desarrollo:
   ```bash
   npm start
   ```
4. Para compilar la versión instalable (distribución NSIS para Windows):
   ```bash
   npm run dist
   ```

## Configuración necesaria

Para que la aplicación se conecte correctamente a la base de datos sin subir credenciales reales al repositorio, es necesario crear un archivo `.env` en el directorio raíz. 

Puedes copiar el archivo de ejemplo proporcionado:
```bash
cp .env.example .env
```
O simplemente crear el archivo `.env` con el siguiente contenido:

```env
DB_USER=us_AccesoTotal
DB_PASSWORD=tu_contraseña_secreta
```

Asegúrate de poner las credenciales reales de tu instancia SQL Server en este archivo `.env`. Este archivo está (o debería estar) excluido del control de versiones.

## Carga de datos de ejemplo

El proyecto incluye un script de creación y llenado de datos en SQL llamado `database_creation_script.sql`.

Para cargar los datos de ejemplo y montar la estructura de base de datos desde cero:
1. Abre **SQL Server Management Studio (SSMS)** u otra herramienta cliente para SQL Server.
2. Abre el archivo `database_creation_script.sql` proporcionado en el directorio raíz.
3. Ejecuta el script. Este script creará la base de datos `TareasGForma`, generará todas las tablas necesarias e insertará datos iniciales suficientes para probar la aplicación.
4. Opcionalmente, puedes ejecutar `node test-db.js` (si está configurado con las credenciales correctas) para probar rápidamente si Node.js logra conectar con la nueva BD.
