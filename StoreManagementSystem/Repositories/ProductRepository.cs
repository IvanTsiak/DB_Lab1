using Dapper;
using Npgsql;
using StoreManagementSystem.Models;
    
namespace StoreManagementSystem.Repositories;

public class ProductRepository : IProductRepository
{
    private readonly NpgsqlConnection _connection;
    private readonly Func<NpgsqlTransaction?> _transaction;

    public ProductRepository(NpgsqlConnection connection, Func<NpgsqlTransaction?> transaction)
    {
        _connection = connection;
        _transaction = transaction;
    }

    public async Task<IEnumerable<ProductViewDto>> GetActiveProductsAsync()
    {
        string sql = "SELECT * FROM vw_ActiveProducts;";
        return await _connection.QueryAsync<ProductViewDto>(sql, transaction: _transaction());
    }

    public async Task<ProductViewDto?> GetByIdAsync(int id)
    {
        string sql = "SELECT * FROM vw_ActiveProducts WHERE ProductId = @Id;";
        return await _connection.QuerySingleOrDefaultAsync<ProductViewDto>(sql, new { Id = id }, transaction: _transaction());
    }

    public async Task UpdatePriceAsync(int productId, decimal newPrice, int employeeId)
    {
        string sql = "CALL sp_update_product_price(@ProductId, @NewPrice, @EmployeeId);";
        await _connection.ExecuteAsync(sql, new { ProductId = productId, NewPrice = newPrice, EmployeeId = employeeId }, transaction: _transaction());
    }

    public async Task SoftDeleteAsync(int productId, int employeeId)
    {
        string sql = "CALL sp_soft_delete_product(@ProductId, @EmployeeId);";
        await _connection.ExecuteAsync(sql, new { ProductId = productId, EmployeeId = employeeId }, transaction: _transaction());
    }
}