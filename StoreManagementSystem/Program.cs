using Microsoft.Extensions.Configuration;
using StoreManagementSystem.Data;
using StoreManagementSystem.Models;

namespace StoreManagementSystem;

class Program
{
    static async Task Main(string[] args)
    {
        var config = new ConfigurationBuilder()
            .AddUserSecrets<Program>()
            .Build();

        string connectionString = config.GetConnectionString("DefaultConnection")
                                  ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found in secrets!");
        
        Console.WriteLine("Connecting to the Database...");
        
        using var unitOfWork = new UnitOfWork(connectionString);
        
        var activeProducts = await unitOfWork.Products.GetActiveProductsAsync();
        Console.WriteLine("\nActive products");
        foreach (var p in activeProducts)
        {
            Console.WriteLine($"[{p.SKU}] {p.ProductName} - Price: {p.CurrentPrice} (Category: {p.CategoryName})");
        }

        var productToSell = activeProducts.FirstOrDefault();
        if (productToSell == null)
        {
            Console.WriteLine("There are no products for sale. Add data to the database—it’s empty!!!!!!!!");
            return;
        }

        Console.WriteLine("\nSale transaction...");
        unitOfWork.BeginTransaction();

        try
        {
            var newSale = new SaleTransaction
            {
                CustomerId = null,
                EmployeeId = 1,
                DepartmentId = 1,
                PaymentMethodId = 1, 
                TotalAmount = productToSell.CurrentPrice * 2
            };

            int transactionId = await unitOfWork.Sales.CreateTransactionAsync(newSale);
            Console.WriteLine($"Check No. {transactionId} created.");
            
            var saleItem = new SaleItem
            {
                SaleTransactionId = transactionId,
                ProductId = productToSell.ProductId,
                Quantity = 2,
                UnitPrice = productToSell.CurrentPrice
            };
            
            await unitOfWork.Sales.AddSaleItemAsync(saleItem);
            Console.WriteLine($"{saleItem.Quantity} pcs. added '{productToSell.ProductName}' into the check.");
            
            decimal newPrice = productToSell.CurrentPrice + 500m;
            await unitOfWork.Products.UpdatePriceAsync(productToSell.ProductId, newPrice, 1);
            Console.WriteLine($"Price changed for the future");
            
            await unitOfWork.CommitAsync();
            Console.WriteLine("\nTransaction successfully recorded!");
        }
        catch (Exception ex)
        {
            unitOfWork.Rollback();
            Console.WriteLine($"\nTransaction declined. Why? Well, here’s why: {ex.Message}");
        }
    }
}