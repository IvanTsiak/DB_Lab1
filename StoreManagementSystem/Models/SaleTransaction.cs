namespace StoreManagementSystem.Models;

public class SaleTransaction
{
    public int Id { get; set; }
    public int? CustomerId { get; set; }
    public int EmployeeId { get; set; }
    public int DepartmentId { get; set; }
    public int PaymentMethodId { get; set; }
    public DateTime TransactionDate { get; set; }
    public decimal TotalAmount { get; set; }
    
    public List<SaleItem> Items { get; set; } = new();
}