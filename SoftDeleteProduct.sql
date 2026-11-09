CREATE OR REPLACE PROCEDURE sp_soft_delete_product(
    p_product_id INT,
    p_employee_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Product
    SET
        IsDeleted = TRUE,
        UpdatedBy = p_employee_id,
        UpdatedAt = CURRENT_TIMESTAMP
    WHERE Id = p_product_id AND IsDeleted = FALSE;
END;
$$;