CREATE OR REPLACE FUNCTION fn_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.UpdatedAt = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_product_updated_at
BEFORE UPDATE ON Product
FOR EACH ROW
EXECUTE FUNCTION fn_set_updated_at();

CREATE TRIGGER trg_customer_updated_at
BEFORE UPDATE ON Customer
FOR EACH ROW
EXECUTE FUNCTION fn_set_updated_at();