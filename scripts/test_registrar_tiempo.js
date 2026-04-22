const TareaController = require('../src/controllers/TareaController');
const TareaModel = require('../src/models/TareaModel');

(async () => {
  // Stubear métodos de TareaModel para evitar acceso real a BD
  TareaModel.getTiempos = async function (id) {
    if (id === 1) return [
      { Fecha: '2026-03-15', Horas: 3.5 },
      { Fecha: '2026-03-15', Horas: 4.0 },
      { Fecha: '2026-03-14', Horas: 2.0 }
    ];
    return [];
  };

  TareaModel.registrarTiempo = async function ({ idTarea, fecha, horas, comentario, idIdentidad }) {
    return { IdTareaTiempo: 123, IdTiempo: 456 };
  };

  TareaModel.getById = async function (id) {
    // Simular que HorasReales se actualizó a la suma de registros
    if (id === 1) return { IdTarea: 1, HorasEstimadas: 5, HorasReales: 3.5 + 4.0 + 2.0 };
    return { IdTarea: id, HorasEstimadas: 0, HorasReales: 0 };
  };

  // Stub recalcularHorasReales para evitar llamada real a BD
  TareaModel.recalcularHorasReales = async function (id) {
    if (id === 1) return 3.5 + 4.0 + 2.0;
    return 0;
  };

  console.log('--- Test: registrarTiempo (simulado) ---');
  console.log('Intentando registrar 2.5 h en 2026-03-15 para tarea 1 (ya tiene 7.5 h ese día).');

  try {
    const res = await TareaController.registrarTiempo({ idTarea: 1, fecha: '2026-03-15', horas: 2.5, comentario: 'Test', idIdentidad: 10 });
    console.log('Respuesta controller:', JSON.stringify(res, null, 2));
  } catch (e) {
    console.error('Error durante la prueba:', e.stack || e);
  }
})();
