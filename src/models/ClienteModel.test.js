const ClienteModel = require('./ClienteModel');
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
      NVarChar: jest.fn(() => 'NVarChar'),
      MAX: 'MAX'
    }
  };
});

describe('ClienteModel', () => {
  let mockRequest;
  
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('getAll() debería realizar una query correctamente sin filtros', async () => {
    const pool = await getPool();
    const req = pool.request();
    
    req.query.mockResolvedValueOnce({
      recordset: [{ IdCliente: 1, NombreComercial: 'Empresa Test' }]
    });

    const result = await ClienteModel.getAll();

    expect(result).toEqual([{ IdCliente: 1, NombreComercial: 'Empresa Test' }]);
    expect(req.query).toHaveBeenCalled();
  });

  test('getAll() debería añadir filtro de nombre si se especifica', async () => {
    const pool = await getPool();
    const req = pool.request();
    
    req.query.mockResolvedValueOnce({ recordset: [] });

    await ClienteModel.getAll({ nombre: 'Test' });

    expect(req.input).toHaveBeenCalledWith('nombre', 'NVarChar', '%Test%');
    expect(req.query).toHaveBeenCalled();
    // Verify that the query string contains the where clause for nombre
    const queryCall = req.query.mock.calls[0][0];
    expect(queryCall).toContain('c.NombreComercial COLLATE Latin1_General_CI_AI LIKE @nombre');
  });

  test('getById() debería retornar un cliente por id', async () => {
    const pool = await getPool();
    const req = pool.request();
    
    req.query.mockResolvedValueOnce({
      recordset: [{ IdCliente: 2, NombreComercial: 'Empresa Dos' }]
    });

    const result = await ClienteModel.getById(2);

    expect(result).toEqual({ IdCliente: 2, NombreComercial: 'Empresa Dos' });
    expect(req.input).toHaveBeenCalledWith('id', 'Int', 2);
    expect(req.query).toHaveBeenCalled();
  });
});
