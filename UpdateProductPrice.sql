CREATE OR REPLACE PROCEDURE sp_update_product_price(
    p_product_id INT,
    p_new_price NUMERIC(18,2),
    p_employee_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Product
    SET
        CurrentPrice = p_new_price,
        UpdatedBy = p_employee_id,
        UpdatedAt = CURRENT_TIMESTAMP
    WHERE Id = p_product_id AND IsDeleted = FALSE;
END;
$$;