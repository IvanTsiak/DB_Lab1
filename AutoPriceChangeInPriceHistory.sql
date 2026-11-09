CREATE OR REPLACE FUNCTION fn_track_price_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.CurrentPrice IS DISTINCT FROM NEW.CurrentPrice THEN
        INSERT INTO PriceHistory (ProductId, OldPrice, NewPrice, ChangedAt, ChangedBy)
        VALUES (NEW.Id, OLD.CurrentPrice, NEW.CurrentPrice, CURRENT_TIMESTAMP, NEW.UpdatedBy);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_track_product_price
AFTER UPDATE ON Product
FOR EACH ROW
EXECUTE FUNCTION fn_track_price_changes();