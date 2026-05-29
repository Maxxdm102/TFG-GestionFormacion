const TareaModel = require('./TareaModel');
const { getPool, sql } = require('../database/db');

jest.mock('../database/db', () => {
  const mInput = jest.fn();
  const mQuery = jest.fn();
  const mRequest = jest.fn(() => ({
    input: mInput,
    query: mQuery
  }));
  const mPool = {
    request: mRequest
  };

  return {
    getPool: jest.fn(() => Promise.resolve(mPool)),
    sql: {
      Int: 'Int',
      SmallDateTime: 'SmallDateTime',
      TinyInt: 'TinyInt',
      Float: 'Float',
      Decimal: jest.fn(() => 'Decimal'),
      VarChar: jest.fn(() => 'VarChar'),
      NVarChar: jest.fn(() => 'NVarChar'),
      MAX: 'MAX'
    }
  };
});

describe('TareaModel', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('getAll() debería ejecutar up_bp_Tareas_Select', async () => {
    const pool = await getPool();
    const req = pool.request();
    
    req.query.mockResolvedValueOnce({
      recordset: [{ IdTarea: 10, Descripcion: 'Tarea Test' }]
    });

    const result = await TareaModel.getAll({ idTarea: 10 });

    expect(result).toEqual([{ IdTarea: 10, Descripcion: 'Tarea Test' }]);
    expect(req.input).toHaveBeenCalledWith('IdTarea', 'Int', 10);
    expect(req.query).toHaveBeenCalled();
    const queryCall = req.query.mock.calls[0][0];
    expect(queryCall).toContain('EXEC up_bp_Tareas_Select');
  });

  test('getById() debería buscar una tarea por IdTarea', async () => {
    const pool = await getPool();
    const req = pool.request();
    
    req.query.mockResolvedValueOnce({
      recordset: [{ IdTarea: 5, Descripcion: 'Tarea Cinco' }]
    });

    const result = await TareaModel.getById(5);

    expect(result).toEqual({ IdTarea: 5, Descripcion: 'Tarea Cinco' });
    expect(req.input).toHaveBeenCalledWith('IdTarea', 'Int', 5);
  });

  test('delete() debería ejecutar up_bp_Tareas_Delete', async () => {
    const pool = await getPool();
    const req = pool.request();
    
    req.query.mockResolvedValueOnce({ recordset: [] });

    await TareaModel.delete(3);

    expect(req.input).toHaveBeenCalledWith('id', 'Int', 3);
    const queryCall = req.query.mock.calls[0][0];
    expect(queryCall).toContain('EXEC up_bp_Tareas_Delete @IdTarea = @id');
  });
});
