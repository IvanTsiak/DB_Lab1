CREATE OR REPLACE FUNCTION fn_get_customer_total_spent(p_customer_id INT)
RETURNS NUMERIC(18,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total NUMERIC(18,2);
BEGIN
    SELECT COALESCE(SUM(TotalAmount), 0.00)
    INTO v_total
    FROM SaleTransaction
    WHERE CustomerId = p_customer_id;

    RETURN v_total;
END;
$$;