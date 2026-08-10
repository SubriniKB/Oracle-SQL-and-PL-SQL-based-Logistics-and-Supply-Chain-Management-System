/* Indexes make searching and joining your tables faster. 

do not create indexes for primary keys and unique constraints*/

-- ============================================================
-- LOGISTICS MANAGEMENT SYSTEM
-- INDEX CREATION SCRIPT
-- Oracle SQL
-- ============================================================


-- ============================================================
-- 1. CUSTOMER INDEXES
-- ============================================================

-- Search customers by phone
CREATE INDEX IDX_CUSTOMER_PHONE
ON CUSTOMER(PHONE);

-- Search customers by city
CREATE INDEX IDX_CUSTOMER_CITY
ON CUSTOMER(CITY);


-- ============================================================
-- 2. PRODUCT CATEGORY INDEXES
-- ============================================================

-- Search categories by name
CREATE INDEX IDX_CATEGORY_NAME
ON PRODUCT_CATEGORY(CATEGORY_NAME);


-- ============================================================
-- 3. PRODUCT INDEXES
-- ============================================================

-- Foreign key: PRODUCT -> PRODUCT_CATEGORY
CREATE INDEX IDX_PRODUCTS_CATEGORY
ON PRODUCTS(CATEGORY_ID);

-- Search products by name
CREATE INDEX IDX_PRODUCTS_NAME
ON PRODUCTS(PRODUCT_NAME);

-- Filter products by status
CREATE INDEX IDX_PRODUCTS_STATUS
ON PRODUCTS(PRODUCT_STATUS);


-- ============================================================
-- 4. WAREHOUSE INDEXES
-- ============================================================

-- Search warehouses by city
CREATE INDEX IDX_WAREHOUSE_CITY
ON WAREHOUSE(CITY);

-- Filter warehouses by status
CREATE INDEX IDX_WAREHOUSE_STATUS
ON WAREHOUSE(WAREHOUSE_STATUS);


-- ============================================================
-- 5. VEHICLE INDEXES
-- ============================================================

-- Filter vehicles by status
CREATE INDEX IDX_VEHICLE_STATUS
ON VEHICLE(VEHICLE_STATUS);

-- Search vehicles by type
CREATE INDEX IDX_VEHICLE_TYPE
ON VEHICLE(VEHICLE_TYPE);


-- ============================================================
-- 6. DRIVER INDEXES
-- ============================================================

-- Search driver by phone
CREATE INDEX IDX_DRIVER_PHONE
ON DRIVER(PHONE);

-- Filter drivers by status
CREATE INDEX IDX_DRIVER_STATUS
ON DRIVER(DRIVER_STATUS);


-- ============================================================
-- 7. ROUTE INDEXES
-- ============================================================

-- Search routes by source
CREATE INDEX IDX_ROUTE_SOURCE
ON ROUTE(SOURCE_LOCATION);

-- Search routes by destination
CREATE INDEX IDX_ROUTE_DESTINATION
ON ROUTE(DESTINATION_LOCATION);


-- ============================================================
-- 8. ORDERS INDEXES
-- ============================================================

-- Foreign key: ORDERS -> CUSTOMER
CREATE INDEX IDX_ORDERS_CUSTOMER
ON ORDERS(CUSTOMER_ID);

-- Search orders by date
CREATE INDEX IDX_ORDERS_DATE
ON ORDERS(ORDER_DATE);

-- Filter orders by status
CREATE INDEX IDX_ORDERS_STATUS
ON ORDERS(ORDER_STATUS);

-- Filter orders by priority
CREATE INDEX IDX_ORDERS_PRIORITY
ON ORDERS(ORDER_PRIORITY);


-- ============================================================
-- 9. ORDER DETAILS INDEXES
-- ============================================================

-- Foreign key: ORDER_DETAILS -> ORDERS
CREATE INDEX IDX_ORDER_DETAILS_ORDER
ON ORDER_DETAILS(ORDER_ID);

-- Foreign key: ORDER_DETAILS -> PRODUCTS
CREATE INDEX IDX_ORDER_DETAILS_PRODUCT
ON ORDER_DETAILS(PRODUCT_ID);


-- ============================================================
-- 10. INVENTORY INDEXES
-- ============================================================

-- Foreign key: INVENTORY -> PRODUCTS
CREATE INDEX IDX_INVENTORY_PRODUCT
ON INVENTORY(PRODUCT_ID);

-- Foreign key: INVENTORY -> WAREHOUSE
CREATE INDEX IDX_INVENTORY_WAREHOUSE
ON INVENTORY(WAREHOUSE_ID);

-- Search low/reorder stock
CREATE INDEX IDX_INVENTORY_REORDER
ON INVENTORY(REORDER_LEVEL);


-- ============================================================
-- 11. INVENTORY TRANSACTION INDEXES
-- ============================================================

-- Foreign key: INVENTORY_TRANSACTION -> PRODUCTS
CREATE INDEX IDX_INV_TRANS_PRODUCT
ON INVENTORY_TRANSACTION(PRODUCT_ID);

-- Foreign key: INVENTORY_TRANSACTION -> WAREHOUSE
CREATE INDEX IDX_INV_TRANS_WAREHOUSE
ON INVENTORY_TRANSACTION(WAREHOUSE_ID);

-- Search transactions by date
CREATE INDEX IDX_INV_TRANS_DATE
ON INVENTORY_TRANSACTION(TRANSACTION_DATE);

-- Filter transaction type
CREATE INDEX IDX_INV_TRANS_TYPE
ON INVENTORY_TRANSACTION(TRANSACTION_TYPE);


-- ============================================================
-- 12. SUPPLIER INDEXES
-- ============================================================

-- Search supplier by name
CREATE INDEX IDX_SUPPLIER_NAME
ON SUPPLIER(SUPPLIER_NAME);

-- Search supplier by city
CREATE INDEX IDX_SUPPLIER_CITY
ON SUPPLIER(CITY);


-- ============================================================
-- 13. SUPPLIER PRODUCT INDEXES
-- ============================================================

-- Foreign key: SUPPLIER_PRODUCT -> SUPPLIER
CREATE INDEX IDX_SUPPLIER_PRODUCT_SUPPLIER
ON SUPPLIER_PRODUCT(SUPPLIER_ID);

-- Foreign key: SUPPLIER_PRODUCT -> PRODUCTS
CREATE INDEX IDX_SUPPLIER_PRODUCT_PRODUCT
ON SUPPLIER_PRODUCT(PRODUCT_ID);


-- ============================================================
-- 14. SHIPMENT INDEXES
-- ============================================================

-- Foreign key: SHIPMENT -> ORDERS
CREATE INDEX IDX_SHIPMENT_ORDER
ON SHIPMENT(ORDER_ID);

-- Foreign key: SHIPMENT -> VEHICLE
CREATE INDEX IDX_SHIPMENT_VEHICLE
ON SHIPMENT(VEHICLE_ID);

-- Foreign key: SHIPMENT -> DRIVER
CREATE INDEX IDX_SHIPMENT_DRIVER
ON SHIPMENT(DRIVER_ID);

-- Foreign key: SHIPMENT -> ROUTE
CREATE INDEX IDX_SHIPMENT_ROUTE
ON SHIPMENT(ROUTE_ID);

-- Search shipments by status
CREATE INDEX IDX_SHIPMENT_STATUS
ON SHIPMENT(SHIPMENT_STATUS);

-- Search shipments by shipment date
CREATE INDEX IDX_SHIPMENT_DATE
ON SHIPMENT(SHIPMENT_DATE);

-- Search expected deliveries
CREATE INDEX IDX_SHIPMENT_EXPECTED_DATE
ON SHIPMENT(EXPECTED_DELIVERY_DATE);


-- ============================================================
-- 15. SHIPMENT STATUS HISTORY INDEXES
-- ============================================================

-- Foreign key: STATUS_HISTORY -> SHIPMENT
CREATE INDEX IDX_STATUS_HISTORY_SHIPMENT
ON SHIPMENT_STATUS_HISTORY(SHIPMENT_ID);

-- Search status changes by date
CREATE INDEX IDX_STATUS_HISTORY_DATE
ON SHIPMENT_STATUS_HISTORY(STATUS_DATE);


-- ============================================================
-- 16. INVOICE INDEXES
-- ============================================================

-- Foreign key: INVOICE -> SHIPMENT
CREATE INDEX IDX_INVOICE_SHIPMENT
ON INVOICE(SHIPMENT_ID);

-- Search invoices by date
CREATE INDEX IDX_INVOICE_DATE
ON INVOICE(INVOICE_DATE);

-- Filter invoices by status
CREATE INDEX IDX_INVOICE_STATUS
ON INVOICE(INVOICE_STATUS);


-- ============================================================
-- 17. PAYMENT INDEXES
-- ============================================================

-- Foreign key: PAYMENT -> INVOICE
CREATE INDEX IDX_PAYMENT_INVOICE
ON PAYMENT(INVOICE_ID);

-- Search payments by date
CREATE INDEX IDX_PAYMENT_DATE
ON PAYMENT(PAYMENT_DATE);

-- Filter payments by status
CREATE INDEX IDX_PAYMENT_STATUS
ON PAYMENT(PAYMENT_STATUS);


-- ============================================================
-- END OF INDEX CREATION
-- ============================================================