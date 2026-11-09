using StoreManagementSystem.Models;

namespace StoreManagementSystem.Repositories;

public interface ISaleRepository
{
    Task<int> CreateTransactionAsync(SaleTransaction transaction);
    
    Task AddSaleItemAsync(SaleItem item);
}