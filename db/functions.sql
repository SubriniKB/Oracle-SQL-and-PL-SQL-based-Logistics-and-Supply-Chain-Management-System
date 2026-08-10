/* A function is a stored program that (created in Oracle PL/SQL functions):

Takes input values.
Performs some calculation or lookup.
Returns one value. */

-- ============================================================
-- 1. CALCULATE ORDER TOTAL
-- This calculates the total of all products in an order from ORDER_DETAILS
-- ============================================================

CREATE OR REPLACE FUNCTION FN_ORDER_TOTAL (
    P_ORDER_ID IN NUMBER
)
RETURN NUMBER
IS
    V_TOTAL NUMBER(12,2);
BEGIN

    SELECT NVL(SUM(TOTAL_PRICE), 0)
    INTO V_TOTAL
    FROM ORDER_DETAILS
    WHERE ORDER_ID = P_ORDER_ID;

    RETURN V_TOTAL;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;

    WHEN OTHERS THEN
        RAISE;
END;
/

-- ============================================================
-- 2. GET AVAILABLE INVENTORY
--This returns the available quantity of a product in a particular warehouse.
-- ============================================================

CREATE OR REPLACE FUNCTION FN_AVAILABLE_STOCK (
    P_PRODUCT_ID  IN NUMBER,
    P_WAREHOUSE_ID IN NUMBER
)
RETURN NUMBER
IS
    V_QUANTITY NUMBER(12,2);
BEGIN

    SELECT NVL(AVAILABLE_QUANTITY, 0)
    INTO V_QUANTITY
    FROM INVENTORY
    WHERE PRODUCT_ID = P_PRODUCT_ID
      AND WAREHOUSE_ID = P_WAREHOUSE_ID;

    RETURN V_QUANTITY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;

    WHEN OTHERS THEN
        RAISE;
END;
/

-- ============================================================
-- 3. CALCULATE DELIVERY DELAY
--This tells us how many days late a shipment was.
-- ============================================================

CREATE OR REPLACE FUNCTION FN_DELIVERY_DELAY (
    P_SHIPMENT_ID IN NUMBER
)
RETURN NUMBER
IS
    V_EXPECTED_DATE DATE;
    V_ACTUAL_DATE   DATE;
    V_DELAY         NUMBER;
BEGIN

    SELECT EXPECTED_DELIVERY_DATE,
           ACTUAL_DELIVERY_DATE
    INTO V_EXPECTED_DATE,
         V_ACTUAL_DATE
    FROM SHIPMENT
    WHERE SHIPMENT_ID = P_SHIPMENT_ID;

    IF V_ACTUAL_DATE IS NULL THEN
        RETURN NULL;
    END IF;

    V_DELAY := V_ACTUAL_DATE - V_EXPECTED_DATE;

    IF V_DELAY < 0 THEN
        RETURN 0;
    END IF;

    RETURN V_DELAY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;

    WHEN OTHERS THEN
        RAISE;
END;
/

-- ============================================================
-- 4. CALCULATE INVOICE NET AMOUNT
--NET = TOTAL + TAX - DISCOUNT
-- ============================================================

CREATE OR REPLACE FUNCTION FN_INVOICE_NET_AMOUNT (
    P_TOTAL_AMOUNT    IN NUMBER,
    P_TAX_AMOUNT      IN NUMBER,
    P_DISCOUNT_AMOUNT IN NUMBER
)
RETURN NUMBER
IS
    V_NET_AMOUNT NUMBER(12,2);
BEGIN

    V_NET_AMOUNT :=
        NVL(P_TOTAL_AMOUNT, 0)
        + NVL(P_TAX_AMOUNT, 0)
        - NVL(P_DISCOUNT_AMOUNT, 0);

    RETURN V_NET_AMOUNT;

END;
/

-- ============================================================
-- 5. CUSTOMER TOTAL ORDER VALUE
--This is useful for reporting and customer analysis.
-- ============================================================

CREATE OR REPLACE FUNCTION FN_CUSTOMER_ORDER_VALUE (
    P_CUSTOMER_ID IN NUMBER
)
RETURN NUMBER
IS
    V_TOTAL NUMBER(14,2);
BEGIN

    SELECT NVL(SUM(TOTAL_AMOUNT), 0)
    INTO V_TOTAL
    FROM ORDERS
    WHERE CUSTOMER_ID = P_CUSTOMER_ID;

    RETURN V_TOTAL;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;

    WHEN OTHERS THEN
        RAISE;
END;
/


