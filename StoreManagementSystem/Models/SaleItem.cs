namespace StoreManagementSystem.Models;

public class SaleItem
{
    public int Id { get; set; }
    public int SaleTransactionId { get; set; }
    public int ProductId { get; set; }
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
}