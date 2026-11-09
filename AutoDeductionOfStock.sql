CREATE OR REPLACE FUNCTION fn_reduce_inventory_on_sale()
RETURNS TRIGGER AS $$
DECLARE
    v_department_id INT;
BEGIN
    SELECT DepartmentId INTO v_department_id
    FROM SaleTransaction
    WHERE Id = NEW.SaleTransactionId;

    UPDATE Inventory
    SET Quantity = Quantity - NEW.Quantity
    WHERE ProductId = NEW.ProductId AND DepartmentId = v_department_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_reduce_inventory
AFTER INSERT ON SaleItem
FOR EACH ROW
EXECUTE FUNCTION fn_reduce_inventory_on_sale();