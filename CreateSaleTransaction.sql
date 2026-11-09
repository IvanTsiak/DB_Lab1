CREATE OR REPLACE PROCEDURE sp_create_sale_transaction(
    p_customer_id INT,
    p_employee_id INT,
    p_department_id INT,
    p_payment_method_id INT,
    p_total_amount NUMERIC(18,2),
    INOUT p_transaction_id INT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO SaleTransaction (CustomerId, EmployeeId, DepartmentId, PaymentMethodId, TotalAmount, TransactionDate)
    VALUES (p_customer_id, p_employee_id, p_department_id, p_payment_method_id, p_total_amount, CURRENT_TIMESTAMP)
    RETURNING Id INTO p_transaction_id;
END;
$$;