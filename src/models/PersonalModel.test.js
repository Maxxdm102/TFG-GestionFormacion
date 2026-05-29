const PersonalModel = require('./PersonalModel');
const { getPool, sql } = require('../database/db');

// Hacemos mock del módulo de base de datos
jest.mock('../database/db', () => {
  const mInput = jest.fn();
  const mExecute = jest.fn();
  const mRequest = jest.fn(() => ({
    input: mInput,
    execute: mExecute
  }));
  const mPool = {
    request: mRequest
  };

  return {
    getPool: jest.fn(() => Promise.resolve(mPool)),
    sql: {
      Int: 'Int',
      TinyInt: 'TinyInt',
      VarChar: jest.fn(() => 'VarChar'),
      MAX: 'MAX'
    }
  };
});

describe('PersonalModel', () => {
  let mockRequest;
  
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('getAll() debería llamar a up_bp_Personal_Select_Corto con Activo en 1 cuando filtros.activo es true', async () => {
    // Obtenemos las referencias a las funciones mockeadas
    const pool = await getPool();
    const req = pool.request();
    
    // Configuramos el valor de retorno para execute
    req.execute.mockResolvedValueOnce({
      recordset: [{ IdPersonal: 1, NombreCompleto: 'Juan Perez' }]
    });

    const result = await PersonalModel.getAll({ activo: true });

    // Verificamos que se devuelva el resultado esperado
    expect(result).toEqual([{ IdPersonal: 1, NombreCompleto: 'Juan Perez' }]);

    // Verificamos que se llamaron a los inputs correctamente
    expect(req.input).toHaveBeenCalledWith('Activo', 'TinyInt', 1);
    expect(req.input).toHaveBeenCalledWith('IdPersonal', 'Int', null);

    // Verificamos que se ejecutó el procedimiento correcto
    expect(req.execute).toHaveBeenCalledWith('up_bp_Personal_Select_Corto');
  });

  test('getAll() debería llamar a up_bp_Personal_Select_Corto con Activo en null cuando no se especifican filtros', async () => {
    const pool = await getPool();
    const req = pool.request();
    
    req.execute.mockResolvedValueOnce({
      recordset: []
    });

    const result = await PersonalModel.getAll();

    expect(result).toEqual([]);
    expect(req.input).toHaveBeenCalledWith('Activo', 'TinyInt', null);
    expect(req.execute).toHaveBeenCalledWith('up_bp_Personal_Select_Corto');
  });
});
