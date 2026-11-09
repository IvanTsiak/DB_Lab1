using StoreManagementSystem.Models;

namespace StoreManagementSystem.Repositories;

public interface IProductRepository
{
    Task<IEnumerable<ProductViewDto>> GetActiveProductsAsync();
    Task<ProductViewDto?> GetByIdAsync(int id);
    
    Task UpdatePriceAsync(int productId, decimal newPrice, int employeeId);
    Task SoftDeleteAsync(int productId, int employeeId);
}