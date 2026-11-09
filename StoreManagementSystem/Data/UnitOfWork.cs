using Npgsql;
using StoreManagementSystem.Repositories;

namespace StoreManagementSystem.Data;

public class UnitOfWork : IUnitOfWork, IDisposable
{
    private readonly NpgsqlConnection _connection;
    private NpgsqlTransaction? _transaction;

    public IProductRepository Products { get; private set; }
    public ISaleRepository Sales { get; private set; }

    public UnitOfWork(string connectionString)
    {
        _connection = new NpgsqlConnection(connectionString);
        _connection.Open();
        
        Products = new ProductRepository(_connection, () => _transaction);
        Sales = new SaleRepository(_connection, () => _transaction);
    }

    public void BeginTransaction()
    {
        _transaction = _connection.BeginTransaction();
    }

    public async Task CommitAsync()
    {
        try
        {
            if (_transaction != null)
                await _transaction.CommitAsync();
        }
        finally
        {
            _transaction?.Dispose();
            _transaction = null;
        }
    }

    public void Rollback()
    {
        try
        {
            _transaction?.Rollback();
        }
        finally
        {
            _transaction?.Dispose();
            _transaction = null;
        }
    }

    public void Dispose()
    {
        _transaction?.Dispose();
        _connection.Dispose();
    }
}