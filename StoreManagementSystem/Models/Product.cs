namespace StoreManagementSystem.Models;

public class ProductViewDto
{
    public int ProductId { get; set; }
    public string SKU { get; set; } = string.Empty;
    public string ProductName { get; set; } = string.Empty;
    public decimal CurrentPrice { get; set; }
    public string CategoryName { get; set; } = string.Empty;
}