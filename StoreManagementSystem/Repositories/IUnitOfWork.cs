namespace StoreManagementSystem.Repositories;

public interface IUnitOfWork
{
    IProductRepository Products { get; }
    ISaleRepository Sales { get; }
    
    void BeginTransaction();
    Task CommitAsync();
    void Rollback(); 
}