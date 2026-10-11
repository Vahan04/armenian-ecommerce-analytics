DROP TABLE IF EXISTS deliveries, payments, order_items, orders, products, categories, customers CASCADE;

CREATE TABLE customers (
    customer_id BIGSERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    city TEXT NOT NULL,
    registered_at DATE NOT NULL DEFAULT CURRENT_DATE,
    CHECK (position('@' IN email) > 1)
);

CREATE TABLE categories (
    category_id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id BIGSERIAL PRIMARY KEY,
    category_id BIGINT NOT NULL REFERENCES categories(category_id),
    name TEXT NOT NULL,
    description TEXT,
    price_amd NUMERIC(12, 2) NOT NULL CHECK (price_amd > 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0),
    reorder_level INTEGER NOT NULL DEFAULT 5 CHECK (reorder_level >= 0),
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE orders (
    order_id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(customer_id),
    ordered_at TIMESTAMPTZ NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'paid', 'shipped', 'delivered', 'cancelled')),
    delivery_city TEXT NOT NULL
);

CREATE TABLE order_items (
    order_id BIGINT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price_amd NUMERIC(12, 2) NOT NULL CHECK (unit_price_amd > 0),
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE payments (
    payment_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE REFERENCES orders(order_id) ON DELETE CASCADE,
    paid_at TIMESTAMPTZ,
    amount_amd NUMERIC(12, 2) NOT NULL CHECK (amount_amd >= 0),
    method TEXT NOT NULL CHECK (method IN ('card', 'cash_on_delivery', 'idram', 'bank_transfer')),
    status TEXT NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded'))
);

CREATE TABLE deliveries (
    delivery_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE REFERENCES orders(order_id) ON DELETE CASCADE,
    courier TEXT NOT NULL,
    delivery_fee_amd NUMERIC(12, 2) NOT NULL CHECK (delivery_fee_amd >= 0),
    status TEXT NOT NULL CHECK (status IN ('preparing', 'in_transit', 'delivered', 'returned')),
    delivered_at TIMESTAMPTZ
);

CREATE INDEX idx_orders_ordered_at ON orders (ordered_at);
CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_order_items_product_id ON order_items (product_id);
CREATE INDEX idx_products_low_stock ON products (stock_quantity, reorder_level)
    WHERE active = TRUE;
