using Dapper;
using Npgsql;
using StoreManagementSystem.Models;

namespace StoreManagementSystem.Repositories;

public class SaleRepository : ISaleRepository
{
    private readonly NpgsqlConnection _connection;
    private readonly Func<NpgsqlTransaction?> _transaction;

    public SaleRepository(NpgsqlConnection connection, Func<NpgsqlTransaction?> transaction)
    {
        _connection = connection;
        _transaction = transaction;
    }

    public async Task<int> CreateTransactionAsync(SaleTransaction transaction)
    {
        string sql = @"
            CALL sp_create_sale_transaction(
                @CustomerId, @EmployeeId, @DepartmentId, @PaymentMethodId, @TotalAmount, NULL
            );";
        
        var transactionId = await _connection.QuerySingleAsync<int>(sql, new 
        { 
            CustomerId = transaction.CustomerId,
            EmployeeId = transaction.EmployeeId,
            DepartmentId = transaction.DepartmentId,
            PaymentMethodId = transaction.PaymentMethodId,
            TotalAmount = transaction.TotalAmount
        }, transaction: _transaction());
        
        return transactionId;
    }

    public async Task AddSaleItemAsync(SaleItem item)
    {
        string sql = @"
            INSERT INTO SaleItem (SaleTransactionId, ProductId, Quantity, UnitPrice) 
            VALUES (@SaleTransactionId, @ProductId, @Quantity, @UnitPrice);";
        
        await _connection.ExecuteAsync(sql, item, transaction: _transaction());
    }
}