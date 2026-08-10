-- A view is a saved SQL query that behaves like a virtual table.--

-- ============================================================
-- VIEW CREATION SCRIPT
-- ============================================================

-- ============================================================
-- 1. CUSTOMER ORDER VIEW
-- Shows customers and their orders
-- ============================================================

CREATE OR REPLACE VIEW V_CUSTOMER_ORDERS AS
SELECT
    c.CUSTOMER_ID,
    c.CUSTOMER_NAME,
    c.EMAIL_ID,
    c.PHONE,
    o.ORDER_ID,
    o.ORDER_DATE,
    o.ORDER_STATUS,
    o.ORDER_PRIORITY,
    o.TOTAL_AMOUNT
FROM CUSTOMER c
JOIN ORDERS o
    ON c.CUSTOMER_ID = o.CUSTOMER_ID;



-- ============================================================
-- 2. ORDER DETAILS VIEW
-- Shows order, customer and product information
-- ============================================================

CREATE OR REPLACE VIEW V_ORDER_DETAILS AS
SELECT
    o.ORDER_ID,
    o.ORDER_DATE,
    o.ORDER_STATUS,
    o.ORDER_PRIORITY,
    c.CUSTOMER_ID,
    c.CUSTOMER_NAME,
    od.ORDER_DETAIL_ID,
    p.PRODUCT_ID,
    p.PRODUCT_NAME,
    od.QUANTITY,
    od.UNIT_PRICE,
    od.TOTAL_PRICE
FROM ORDERS o
JOIN CUSTOMER c
    ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN ORDER_DETAILS od
    ON o.ORDER_ID = od.ORDER_ID
JOIN PRODUCTS p
    ON od.PRODUCT_ID = p.PRODUCT_ID;



-- ============================================================
-- 3. SHIPMENT DETAILS VIEW
-- Shows complete shipment information
-- ============================================================

CREATE OR REPLACE VIEW V_SHIPMENT_DETAILS AS
SELECT
    s.SHIPMENT_ID,
    s.ORDER_ID,
    c.CUSTOMER_ID,
    c.CUSTOMER_NAME,

    s.VEHICLE_ID,
    v.VEHICLE_NUMBER,
    v.VEHICLE_TYPE,

    s.DRIVER_ID,
    d.DRIVER_NAME,
    d.PHONE AS DRIVER_PHONE,

    s.ROUTE_ID,
    r.SOURCE_LOCATION,
    r.DESTINATION_LOCATION,
    r.DISTANCE,
    r.ESTIMATED_TIME,

    s.SHIPMENT_DATE,
    s.EXPECTED_DELIVERY_DATE,
    s.ACTUAL_DELIVERY_DATE,
    s.SHIPMENT_STATUS,
    s.SHIPPING_COST

FROM SHIPMENT s

JOIN ORDERS o
    ON s.ORDER_ID = o.ORDER_ID

JOIN CUSTOMER c
    ON o.CUSTOMER_ID = c.CUSTOMER_ID

JOIN VEHICLE v
    ON s.VEHICLE_ID = v.VEHICLE_ID

JOIN DRIVER d
    ON s.DRIVER_ID = d.DRIVER_ID

JOIN ROUTE r
    ON s.ROUTE_ID = r.ROUTE_ID;



-- ============================================================
-- 4. ACTIVE SHIPMENTS VIEW
-- Shows shipments that are currently active
-- ============================================================

CREATE OR REPLACE VIEW V_ACTIVE_SHIPMENTS AS
SELECT
    s.SHIPMENT_ID,
    s.ORDER_ID,
    c.CUSTOMER_NAME,
    v.VEHICLE_NUMBER,
    d.DRIVER_NAME,
    r.SOURCE_LOCATION,
    r.DESTINATION_LOCATION,
    s.SHIPMENT_DATE,
    s.EXPECTED_DELIVERY_DATE,
    s.SHIPMENT_STATUS
FROM SHIPMENT s

JOIN ORDERS o
    ON s.ORDER_ID = o.ORDER_ID

JOIN CUSTOMER c
    ON o.CUSTOMER_ID = c.CUSTOMER_ID

JOIN VEHICLE v
    ON s.VEHICLE_ID = v.VEHICLE_ID

JOIN DRIVER d
    ON s.DRIVER_ID = d.DRIVER_ID

JOIN ROUTE r
    ON s.ROUTE_ID = r.ROUTE_ID

WHERE s.SHIPMENT_STATUS IN (
    'CREATED',
    'PICKED UP',
    'IN TRANSIT'
);



-- ============================================================
-- 5. INVENTORY STATUS VIEW
-- Shows product stock by warehouse
-- ============================================================

CREATE OR REPLACE VIEW V_INVENTORY_STATUS AS
SELECT
    i.INVENTORY_ID,
    p.PRODUCT_ID,
    p.PRODUCT_NAME,
    pc.CATEGORY_NAME,

    w.WAREHOUSE_ID,
    w.WAREHOUSE_NAME,
    w.CITY AS WAREHOUSE_CITY,

    i.AVAILABLE_QUANTITY,
    i.RESERVED_QUANTITY,
    i.REORDER_LEVEL,
    i.LAST_UPDATED_DATE

FROM INVENTORY i

JOIN PRODUCTS p
    ON i.PRODUCT_ID = p.PRODUCT_ID

JOIN PRODUCT_CATEGORY pc
    ON p.CATEGORY_ID = pc.CATEGORY_ID

JOIN WAREHOUSE w
    ON i.WAREHOUSE_ID = w.WAREHOUSE_ID;



-- ============================================================
-- 6. LOW STOCK VIEW
-- Shows products that have reached reorder level
-- ============================================================

CREATE OR REPLACE VIEW V_LOW_STOCK AS
SELECT
    i.INVENTORY_ID,
    p.PRODUCT_ID,
    p.PRODUCT_NAME,
    pc.CATEGORY_NAME,
    w.WAREHOUSE_ID,
    w.WAREHOUSE_NAME,
    i.AVAILABLE_QUANTITY,
    i.REORDER_LEVEL

FROM INVENTORY i

JOIN PRODUCTS p
    ON i.PRODUCT_ID = p.PRODUCT_ID

JOIN PRODUCT_CATEGORY pc
    ON p.CATEGORY_ID = pc.CATEGORY_ID

JOIN WAREHOUSE w
    ON i.WAREHOUSE_ID = w.WAREHOUSE_ID

WHERE i.AVAILABLE_QUANTITY <= i.REORDER_LEVEL;



-- ============================================================
-- 7. SUPPLIER PRODUCT VIEW
-- Shows suppliers and the products they supply
-- ============================================================

CREATE OR REPLACE VIEW V_SUPPLIER_PRODUCTS AS
SELECT
    s.SUPPLIER_ID,
    s.SUPPLIER_NAME,
    s.CONTACT_PERSON,
    s.PHONE AS SUPPLIER_PHONE,

    p.PRODUCT_ID,
    p.PRODUCT_NAME,

    sp.SUPPLY_PRICE,
    sp.MINIMUM_ORDER_QUANTITY,
    sp.DELIVERY_DAYS,
    sp.SUPPLIER_PRODUCT_STATUS

FROM SUPPLIER_PRODUCT sp

JOIN SUPPLIER s
    ON sp.SUPPLIER_ID = s.SUPPLIER_ID

JOIN PRODUCTS p
    ON sp.PRODUCT_ID = p.PRODUCT_ID;



-- ============================================================
-- 8. INVOICE PAYMENT VIEW
-- Shows invoice and payment information
-- ============================================================

CREATE OR REPLACE VIEW V_INVOICE_PAYMENT AS
SELECT
    i.INVOICE_ID,
    i.SHIPMENT_ID,
    i.INVOICE_DATE,

    i.TOTAL_AMOUNT,
    i.TAX_AMOUNT,
    i.DISCOUNT_AMOUNT,
    i.NET_AMOUNT,
    i.INVOICE_STATUS,

    p.PAYMENT_ID,
    p.PAYMENT_DATE,
    p.PAYMENT_MODE,
    p.PAYMENT_AMOUNT,
    p.PAYMENT_STATUS,
    p.TRANSACTION_REFERENCE

FROM INVOICE i

LEFT JOIN PAYMENT p
    ON i.INVOICE_ID = p.INVOICE_ID;



-- ============================================================
-- END OF VIEW CREATION
-- ============================================================