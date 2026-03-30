CREATE SCHEMA IF NOT EXISTS amazon_brazil;

SET search_path TO amazon_brazil;


-- create customers TABLE 

CREATE TABLE amazon_brazil.customers (
    customer_id               VARCHAR(50)  PRIMARY KEY,
    customer_unique_id        VARCHAR(50)  NOT NULL, -- remove data with null primary key
    customer_zip_code_prefix  INT
);

SELECT * FROM amazon_brazil.customers;



-- create product table ( set for query )

CREATE TABLE amazon_brazil.product (
    product_id                  VARCHAR(50)  PRIMARY KEY,
    product_category_name       VARCHAR(100),
    product_name_lenght         NUMERIC,
    product_description_lenght  NUMERIC,
    product_photos_qty          NUMERIC,
    product_weight_g            NUMERIC,
    product_length_cm           NUMERIC,
    product_height_cm           NUMERIC,
    product_width_cm            NUMERIC
);

SELECT * FROM amazon_brazil.product;



-- create seller table ( set to query)

CREATE TABLE amazon_brazil.seller (
    seller_id               VARCHAR(50)  PRIMARY KEY,
    seller_zip_code_prefix  INTEGER
);

SELECT * FROM amazon_brazil.seller;




-- errors coming for thses table because of all the DATE columns , data_type , so changed it to text and import
-- ALTER it when querying the TABLE


--create oders TABLE 

CREATE TABLE amazon_brazil.orders (
    order_id                       VARCHAR(50)  PRIMARY KEY,
    customer_id                    VARCHAR(50), 
    order_status                   VARCHAR(50),
    order_purchase_timestamp       TEXT,
    order_approved_at              TEXT,
    order_delivered_carrier_date   TEXT,
    order_delivered_customer_date  TEXT,
    order_estimated_delivery_date  TEXT,
    FOREIGN KEY (customer_id) REFERENCES amazon_brazil.customers(customer_id)
);


SELECT * FROM amazon_brazil.orders;




--create order_items TABLE

CREATE TABLE amazon_brazil.order_items (
    order_id             VARCHAR(50)   NOT NULL, -- remove data with null primary key
    order_item_id        INTEGER       NOT NULL, -- remove data with null primary key
    product_id           VARCHAR(50),
    seller_id            VARCHAR(50),
    shipping_limit_date  TEXT,
    price                DECIMAL(10,2),
    freight_value        DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id)   REFERENCES amazon_brazil.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES amazon_brazil.product(product_id),
    FOREIGN KEY (seller_id)  REFERENCES amazon_brazil.seller(seller_id)
);

SELECT * FROM amazon_brazil.order_items;




-- create payments TABLE 

CREATE TABLE amazon_brazil.payments (
    order_id              VARCHAR(50)  NOT NULL,
    payment_sequential    INTEGER,
    payment_type          VARCHAR(30),
    payment_installments  INTEGER,
    payment_value         DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES amazon_brazil.orders(order_id)
);

SELECT * FROM amazon_brazil.payments




-- CHANGING DATE data_type and FORMAT OF ORDERS TABLE --

ALTER TABLE amazon_brazil.orders
ALTER COLUMN order_purchase_timestamp TYPE TIMESTAMP USING to_timestamp(order_purchase_timestamp, 'DD/MM/YY HH24:MI:SS'),
ALTER COLUMN order_approved_at TYPE TIMESTAMP USING to_timestamp(order_approved_at, 'DD/MM/YY HH24:MI:SS'),
ALTER COLUMN order_delivered_carrier_date TYPE TIMESTAMP USING to_timestamp(order_delivered_carrier_date, 'DD/MM/YY HH24:MI:SS'),
ALTER COLUMN order_delivered_customer_date TYPE TIMESTAMP USING to_timestamp(order_delivered_customer_date, 'DD/MM/YY HH24:MI:SS'),
ALTER COLUMN order_estimated_delivery_date TYPE TIMESTAMP USING to_timestamp(order_estimated_delivery_date, 'DD/MM/YY HH24:MI:SS');

-- CHANGING DATE data_type and FORMAT OF ORDERS_ITEMS TABLE --

ALTER TABLE amazon_brazil.order_items
ALTER COLUMN shipping_limit_date TYPE TIMESTAMP USING to_timestamp(shipping_limit_date, 'DD/MM/YY HH24:MI:SS');









