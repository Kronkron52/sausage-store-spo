CREATE INDEX idx_order_product_product_id ON order_product (product_id);
CREATE INDEX idx_product_id ON product (id);
CREATE INDEX idx_order_product_order_id_product_id ON order_product (order_id, product_id);
CREATE INDEX idx_product_price ON product (price)