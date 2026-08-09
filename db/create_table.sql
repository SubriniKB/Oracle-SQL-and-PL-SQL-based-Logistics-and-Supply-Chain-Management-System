-- ============================================================
-- LOGISTICS MANAGEMENT SYSTEM
-- TABLE CREATION SCRIPT
-- Oracle SQL
-- ============================================================

-- ============================================================
-- 1. CUSTOMER
-- ============================================================

CREATE TABLE CUSTOMER (
    CUSTOMER_ID        NUMBER(10),
    CUSTOMER_NAME      VARCHAR2(100),
    EMAIL_ID           VARCHAR2(100),
    PHONE              VARCHAR2(20),
    ADDRESS            VARCHAR2(250),
    CITY               VARCHAR2(50),
    STATE              VARCHAR2(50),
    PIN_CODE           VARCHAR2(10),
    COUNTRY            VARCHAR2(50),
    CREATED_DATE       DATE DEFAULT SYSDATE,
    CUSTOMER_STATUS    VARCHAR2(20)
);


-- ============================================================
-- 2. PRODUCT_CATEGORY
-- ============================================================

CREATE TABLE PRODUCT_CATEGORY (
    CATEGORY_ID           NUMBER(10),
    CATEGORY_NAME         VARCHAR2(100),
    CATEGORY_DESCRIPTION  VARCHAR2(500),
    CREATED_DATE          DATE DEFAULT SYSDATE
);


-- ============================================================
-- 3. PRODUCTS
-- ============================================================

CREATE TABLE PRODUCTS (
    PRODUCT_ID             NUMBER(10),
    CATEGORY_ID            NUMBER(10),
    PRODUCT_NAME           VARCHAR2(150),
    PRODUCT_DESCRIPTION    VARCHAR2(500),
    UNIT_OF_MEASURE        VARCHAR2(30),
    UNIT_PRICE             NUMBER(12,2),
    WEIGHT                 NUMBER(10,2),
    PRODUCT_STATUS         VARCHAR2(20),
    CREATED_DATE           DATE DEFAULT SYSDATE
);


-- ============================================================
-- 4. WAREHOUSE
-- ============================================================

CREATE TABLE WAREHOUSE (
    WAREHOUSE_ID       NUMBER(10),
    WAREHOUSE_NAME     VARCHAR2(100),
    ADDRESS            VARCHAR2(250),
    CITY               VARCHAR2(50),
    STATE              VARCHAR2(50),
    PIN_CODE           VARCHAR2(10),
    CAPACITY           NUMBER(12,2),
    WAREHOUSE_STATUS   VARCHAR2(20),
    CREATED_DATE       DATE DEFAULT SYSDATE
);


-- ============================================================
-- 5. VEHICLE
-- ============================================================

CREATE TABLE VEHICLE (
    VEHICLE_ID           NUMBER(10),
    VEHICLE_NUMBER       VARCHAR2(30),
    VEHICLE_TYPE         VARCHAR2(50),
    MODEL                VARCHAR2(100),
    MANUFACTURING_YEAR   NUMBER(4),
    CAPACITY             NUMBER(12,2),
    FUEL_TYPE            VARCHAR2(30),
    VEHICLE_STATUS       VARCHAR2(20),
    CREATED_DATE         DATE DEFAULT SYSDATE
);


-- ============================================================
-- 6. DRIVER
-- ============================================================

CREATE TABLE DRIVER (
    DRIVER_ID             NUMBER(10),
    DRIVER_NAME           VARCHAR2(100),
    PHONE                 VARCHAR2(20),
    EMAIL_ID              VARCHAR2(100),
    LICENSE_NUMBER        VARCHAR2(50),
    LICENSE_EXPIRY_DATE   DATE,
    ADDRESS               VARCHAR2(250),
    DRIVER_STATUS          VARCHAR2(20),
    JOINING_DATE          DATE
);


-- ============================================================
-- 7. ROUTE
-- ============================================================

CREATE TABLE ROUTE (
    ROUTE_ID               NUMBER(10),
    SOURCE_LOCATION        VARCHAR2(150),
    DESTINATION_LOCATION   VARCHAR2(150),
    DISTANCE               NUMBER(10,2),
    ESTIMATED_TIME         NUMBER(10,2),
    ROUTE_STATUS            VARCHAR2(20),
    CREATED_DATE            DATE DEFAULT SYSDATE
);


-- ============================================================
-- 8. ORDERS
-- ============================================================

CREATE TABLE ORDERS (
    ORDER_ID          NUMBER(10),
    CUSTOMER_ID       NUMBER(10),
    ORDER_DATE        DATE DEFAULT SYSDATE,
    ORDER_STATUS      VARCHAR2(30),
    ORDER_PRIORITY    VARCHAR2(20),
    TOTAL_AMOUNT      NUMBER(12,2),
    CREATED_DATE      DATE DEFAULT SYSDATE,
    UPDATED_DATE      DATE
);


-- ============================================================
-- 9. ORDER_DETAILS
-- ============================================================

CREATE TABLE ORDER_DETAILS (
    ORDER_DETAIL_ID   NUMBER(10),
    ORDER_ID          NUMBER(10),
    PRODUCT_ID        NUMBER(10),
    QUANTITY          NUMBER(10,2),
    UNIT_PRICE        NUMBER(12,2),
    TOTAL_PRICE       NUMBER(12,2)
);


-- ============================================================
-- 10. INVENTORY
-- ============================================================

CREATE TABLE INVENTORY (
    INVENTORY_ID          NUMBER(10),
    PRODUCT_ID            NUMBER(10),
    WAREHOUSE_ID          NUMBER(10),
    AVAILABLE_QUANTITY    NUMBER(12,2),
    RESERVED_QUANTITY     NUMBER(12,2),
    REORDER_LEVEL         NUMBER(12,2),
    LAST_UPDATED_DATE     DATE DEFAULT SYSDATE
);


-- ============================================================
-- 11. INVENTORY_TRANSACTION
-- ============================================================

CREATE TABLE INVENTORY_TRANSACTION (
    TRANSACTION_ID      NUMBER(10),
    PRODUCT_ID          NUMBER(10),
    WAREHOUSE_ID        NUMBER(10),
    TRANSACTION_TYPE    VARCHAR2(20),
    QUANTITY            NUMBER(12,2),
    TRANSACTION_DATE    DATE DEFAULT SYSDATE,
    REFERENCE_ID        NUMBER(10),
    CREATED_BY          VARCHAR2(100)
);


-- ============================================================
-- 12. SHIPMENT
-- ============================================================

CREATE TABLE SHIPMENT (
    SHIPMENT_ID              NUMBER(10),
    ORDER_ID                 NUMBER(10),
    VEHICLE_ID               NUMBER(10),
    DRIVER_ID                NUMBER(10),
    ROUTE_ID                 NUMBER(10),
    SHIPMENT_DATE            DATE,
    EXPECTED_DELIVERY_DATE   DATE,
    ACTUAL_DELIVERY_DATE     DATE,
    SHIPMENT_STATUS          VARCHAR2(30),
    SHIPPING_COST            NUMBER(12,2),
    CREATED_DATE             DATE DEFAULT SYSDATE
);


-- ============================================================
-- 13. SHIPMENT_STATUS_HISTORY
-- ============================================================

CREATE TABLE SHIPMENT_STATUS_HISTORY (
    STATUS_HISTORY_ID   NUMBER(10),
    SHIPMENT_ID         NUMBER(10),
    OLD_STATUS          VARCHAR2(30),
    NEW_STATUS          VARCHAR2(30),
    STATUS_DATE         DATE DEFAULT SYSDATE,
    REMARKS             VARCHAR2(500),
    UPDATED_BY          VARCHAR2(100)
);


-- ============================================================
-- 14. INVOICE
-- ============================================================

CREATE TABLE INVOICE (
    INVOICE_ID          NUMBER(10),
    SHIPMENT_ID         NUMBER(10),
    INVOICE_DATE        DATE DEFAULT SYSDATE,
    TOTAL_AMOUNT        NUMBER(12,2),
    TAX_AMOUNT          NUMBER(12,2),
    DISCOUNT_AMOUNT     NUMBER(12,2),
    NET_AMOUNT          NUMBER(12,2),
    INVOICE_STATUS      VARCHAR2(20)
);


-- ============================================================
-- 15. PAYMENT
-- ============================================================

CREATE TABLE PAYMENT (
    PAYMENT_ID             NUMBER(10),
    INVOICE_ID             NUMBER(10),
    PAYMENT_DATE           DATE DEFAULT SYSDATE,
    PAYMENT_MODE           VARCHAR2(30),
    PAYMENT_AMOUNT         NUMBER(12,2),
    PAYMENT_STATUS         VARCHAR2(20),
    TRANSACTION_REFERENCE  VARCHAR2(100)
);


-- ============================================================
-- 16. SUPPLIER
-- ============================================================

CREATE TABLE SUPPLIER (
    SUPPLIER_ID       NUMBER(10),
    SUPPLIER_NAME     VARCHAR2(150),
    CONTACT_PERSON    VARCHAR2(100),
    PHONE             VARCHAR2(20),
    EMAIL_ID          VARCHAR2(100),
    ADDRESS           VARCHAR2(250),
    CITY              VARCHAR2(50),
    STATE             VARCHAR2(50),
    CREATED_DATE      DATE DEFAULT SYSDATE
);


-- ============================================================
-- 17. SUPPLIER_PRODUCT
-- ============================================================

CREATE TABLE SUPPLIER_PRODUCT (
    SUPPLIER_PRODUCT_ID       NUMBER(10),
    SUPPLIER_ID               NUMBER(10),
    PRODUCT_ID                NUMBER(10),
    SUPPLY_PRICE              NUMBER(12,2),
    MINIMUM_ORDER_QUANTITY    NUMBER(12,2),
    DELIVERY_DAYS             NUMBER(5),
    SUPPLIER_PRODUCT_STATUS   VARCHAR2(20),
    CREATED_DATE              DATE DEFAULT SYSDATE
);


-- ============================================================
-- END OF TABLE CREATION
-- ============================================================