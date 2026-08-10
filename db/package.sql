/* A package groups related PL/SQL functions and procedures into one logical unit.
Package Specification : Defines what users can access 
Package Body : Contains the actual implementation 
Why -> It makes your project more professional because instead of having many separate 
PL/SQL objects 
*/

-- ============================================================
-- LOGISTICS MANAGEMENT SYSTEM
-- PACKAGE
-- ============================================================


-- ============================================================
-- PACKAGE SPECIFICATION
-- ============================================================

CREATE OR REPLACE PACKAGE PKG_LOGISTICS AS

    -- ORDER MANAGEMENT
    PROCEDURE CREATE_ORDER (
        P_CUSTOMER_ID    IN NUMBER,
        P_ORDER_PRIORITY IN VARCHAR2
    );

    PROCEDURE ADD_ORDER_DETAIL (
        P_ORDER_ID   IN NUMBER,
        P_PRODUCT_ID IN NUMBER,
        P_QUANTITY   IN NUMBER
    );


    -- SHIPMENT MANAGEMENT
    PROCEDURE CREATE_SHIPMENT (
        P_ORDER_ID               IN NUMBER,
        P_VEHICLE_ID             IN NUMBER,
        P_DRIVER_ID              IN NUMBER,
        P_ROUTE_ID               IN NUMBER,
        P_SHIPMENT_DATE          IN DATE,
        P_EXPECTED_DELIVERY_DATE IN DATE,
        P_SHIPPING_COST          IN NUMBER
    );

    PROCEDURE UPDATE_SHIPMENT_STATUS (
        P_SHIPMENT_ID IN NUMBER,
        P_NEW_STATUS  IN VARCHAR2,
        P_REMARKS     IN VARCHAR2,
        P_UPDATED_BY  IN VARCHAR2
    );


    -- INVENTORY MANAGEMENT
    PROCEDURE RECEIVE_INVENTORY (
        P_PRODUCT_ID   IN NUMBER,
        P_WAREHOUSE_ID IN NUMBER,
        P_QUANTITY     IN NUMBER,
        P_CREATED_BY   IN VARCHAR2
    );

    PROCEDURE ISSUE_INVENTORY (
        P_PRODUCT_ID   IN NUMBER,
        P_WAREHOUSE_ID IN NUMBER,
        P_QUANTITY     IN NUMBER,
        P_CREATED_BY   IN VARCHAR2
    );


    -- PAYMENT MANAGEMENT
    PROCEDURE RECORD_PAYMENT (
        P_INVOICE_ID            IN NUMBER,
        P_PAYMENT_MODE          IN VARCHAR2,
        P_PAYMENT_AMOUNT        IN NUMBER,
        P_TRANSACTION_REFERENCE IN VARCHAR2
    );


    -- FUNCTIONS
    FUNCTION GET_ORDER_TOTAL (
        P_ORDER_ID IN NUMBER
    ) RETURN NUMBER;

    FUNCTION GET_AVAILABLE_STOCK (
        P_PRODUCT_ID   IN NUMBER,
        P_WAREHOUSE_ID IN NUMBER
    ) RETURN NUMBER;

    FUNCTION GET_DELIVERY_DELAY (
        P_SHIPMENT_ID IN NUMBER
    ) RETURN NUMBER;

END PKG_LOGISTICS;
/

-- ============================================================
-- PACKAGE BODY
-- ============================================================

CREATE OR REPLACE PACKAGE BODY PKG_LOGISTICS AS


    -- ========================================================
    -- CREATE ORDER
    -- ========================================================

    PROCEDURE CREATE_ORDER (
        P_CUSTOMER_ID    IN NUMBER,
        P_ORDER_PRIORITY IN VARCHAR2
    )
    IS
    BEGIN

        INSERT INTO ORDERS (
            ORDER_ID,
            CUSTOMER_ID,
            ORDER_DATE,
            ORDER_STATUS,
            ORDER_PRIORITY,
            TOTAL_AMOUNT,
            CREATED_DATE
        )
        VALUES (
            ORDER_SEQ.NEXTVAL,
            P_CUSTOMER_ID,
            SYSDATE,
            'CREATED',
            P_ORDER_PRIORITY,
            0,
            SYSDATE
        );

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END CREATE_ORDER;


    -- ========================================================
    -- ADD ORDER DETAIL
    -- ========================================================

    PROCEDURE ADD_ORDER_DETAIL (
        P_ORDER_ID   IN NUMBER,
        P_PRODUCT_ID IN NUMBER,
        P_QUANTITY   IN NUMBER
    )
    IS
        V_UNIT_PRICE  NUMBER(12,2);
        V_TOTAL_PRICE NUMBER(12,2);
    BEGIN

        SELECT UNIT_PRICE
        INTO V_UNIT_PRICE
        FROM PRODUCTS
        WHERE PRODUCT_ID = P_PRODUCT_ID;

        V_TOTAL_PRICE := V_UNIT_PRICE * P_QUANTITY;

        INSERT INTO ORDER_DETAILS (
            ORDER_DETAIL_ID,
            ORDER_ID,
            PRODUCT_ID,
            QUANTITY,
            UNIT_PRICE,
            TOTAL_PRICE
        )
        VALUES (
            ORDER_DETAIL_SEQ.NEXTVAL,
            P_ORDER_ID,
            P_PRODUCT_ID,
            P_QUANTITY,
            V_UNIT_PRICE,
            V_TOTAL_PRICE
        );

        UPDATE ORDERS
        SET TOTAL_AMOUNT = (
            SELECT NVL(SUM(TOTAL_PRICE), 0)
            FROM ORDER_DETAILS
            WHERE ORDER_ID = P_ORDER_ID
        ),
        UPDATED_DATE = SYSDATE
        WHERE ORDER_ID = P_ORDER_ID;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END ADD_ORDER_DETAIL;


    -- ========================================================
    -- CREATE SHIPMENT
    -- ========================================================

    PROCEDURE CREATE_SHIPMENT (
        P_ORDER_ID               IN NUMBER,
        P_VEHICLE_ID             IN NUMBER,
        P_DRIVER_ID              IN NUMBER,
        P_ROUTE_ID               IN NUMBER,
        P_SHIPMENT_DATE          IN DATE,
        P_EXPECTED_DELIVERY_DATE IN DATE,
        P_SHIPPING_COST          IN NUMBER
    )
    IS
    BEGIN

        INSERT INTO SHIPMENT (
            SHIPMENT_ID,
            ORDER_ID,
            VEHICLE_ID,
            DRIVER_ID,
            ROUTE_ID,
            SHIPMENT_DATE,
            EXPECTED_DELIVERY_DATE,
            SHIPMENT_STATUS,
            SHIPPING_COST,
            CREATED_DATE
        )
        VALUES (
            SHIPMENT_SEQ.NEXTVAL,
            P_ORDER_ID,
            P_VEHICLE_ID,
            P_DRIVER_ID,
            P_ROUTE_ID,
            P_SHIPMENT_DATE,
            P_EXPECTED_DELIVERY_DATE,
            'CREATED',
            P_SHIPPING_COST,
            SYSDATE
        );

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END CREATE_SHIPMENT;


    -- ========================================================
    -- UPDATE SHIPMENT STATUS
    -- ========================================================

    PROCEDURE UPDATE_SHIPMENT_STATUS (
        P_SHIPMENT_ID IN NUMBER,
        P_NEW_STATUS  IN VARCHAR2,
        P_REMARKS     IN VARCHAR2,
        P_UPDATED_BY  IN VARCHAR2
    )
    IS
        V_OLD_STATUS SHIPMENT.SHIPMENT_STATUS%TYPE;
    BEGIN

        SELECT SHIPMENT_STATUS
        INTO V_OLD_STATUS
        FROM SHIPMENT
        WHERE SHIPMENT_ID = P_SHIPMENT_ID
        FOR UPDATE;


        UPDATE SHIPMENT
        SET SHIPMENT_STATUS = P_NEW_STATUS,
            ACTUAL_DELIVERY_DATE =
                CASE
                    WHEN P_NEW_STATUS = 'DELIVERED'
                    THEN SYSDATE
                    ELSE ACTUAL_DELIVERY_DATE
                END
        WHERE SHIPMENT_ID = P_SHIPMENT_ID;


        INSERT INTO SHIPMENT_STATUS_HISTORY (
            STATUS_HISTORY_ID,
            SHIPMENT_ID,
            OLD_STATUS,
            NEW_STATUS,
            STATUS_DATE,
            REMARKS,
            UPDATED_BY
        )
        VALUES (
            STATUS_HISTORY_SEQ.NEXTVAL,
            P_SHIPMENT_ID,
            V_OLD_STATUS,
            P_NEW_STATUS,
            SYSDATE,
            P_REMARKS,
            P_UPDATED_BY
        );

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END UPDATE_SHIPMENT_STATUS;


    -- ========================================================
    -- RECEIVE INVENTORY
    -- ========================================================

    PROCEDURE RECEIVE_INVENTORY (
        P_PRODUCT_ID   IN NUMBER,
        P_WAREHOUSE_ID IN NUMBER,
        P_QUANTITY     IN NUMBER,
        P_CREATED_BY   IN VARCHAR2
    )
    IS
    BEGIN

        IF P_QUANTITY <= 0 THEN
            RAISE_APPLICATION_ERROR(
                -20001,
                'Quantity must be greater than zero.'
            );
        END IF;


        UPDATE INVENTORY
        SET AVAILABLE_QUANTITY =
                AVAILABLE_QUANTITY + P_QUANTITY,
            LAST_UPDATED_DATE = SYSDATE
        WHERE PRODUCT_ID = P_PRODUCT_ID
          AND WAREHOUSE_ID = P_WAREHOUSE_ID;


        IF SQL%ROWCOUNT = 0 THEN

            INSERT INTO INVENTORY (
                INVENTORY_ID,
                PRODUCT_ID,
                WAREHOUSE_ID,
                AVAILABLE_QUANTITY,
                RESERVED_QUANTITY,
                REORDER_LEVEL,
                LAST_UPDATED_DATE
            )
            VALUES (
                INVENTORY_SEQ.NEXTVAL,
                P_PRODUCT_ID,
                P_WAREHOUSE_ID,
                P_QUANTITY,
                0,
                0,
                SYSDATE
            );

        END IF;


        INSERT INTO INVENTORY_TRANSACTION (
            TRANSACTION_ID,
            PRODUCT_ID,
            WAREHOUSE_ID,
            TRANSACTION_TYPE,
            QUANTITY,
            TRANSACTION_DATE,
            CREATED_BY
        )
        VALUES (
            TRANSACTION_SEQ.NEXTVAL,
            P_PRODUCT_ID,
            P_WAREHOUSE_ID,
            'RECEIVED',
            P_QUANTITY,
            SYSDATE,
            P_CREATED_BY
        );

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END RECEIVE_INVENTORY;


    -- ========================================================
    -- ISSUE INVENTORY
    -- ========================================================

    PROCEDURE ISSUE_INVENTORY (
        P_PRODUCT_ID   IN NUMBER,
        P_WAREHOUSE_ID IN NUMBER,
        P_QUANTITY     IN NUMBER,
        P_CREATED_BY   IN VARCHAR2
    )
    IS
        V_AVAILABLE_QUANTITY NUMBER(12,2);
    BEGIN

        IF P_QUANTITY <= 0 THEN
            RAISE_APPLICATION_ERROR(
                -20002,
                'Quantity must be greater than zero.'
            );
        END IF;


        SELECT AVAILABLE_QUANTITY
        INTO V_AVAILABLE_QUANTITY
        FROM INVENTORY
        WHERE PRODUCT_ID = P_PRODUCT_ID
          AND WAREHOUSE_ID = P_WAREHOUSE_ID
        FOR UPDATE;


        IF V_AVAILABLE_QUANTITY < P_QUANTITY THEN
            RAISE_APPLICATION_ERROR(
                -20003,
                'Insufficient inventory. Available quantity: '
                || V_AVAILABLE_QUANTITY
            );
        END IF;


        UPDATE INVENTORY
        SET AVAILABLE_QUANTITY =
                AVAILABLE_QUANTITY - P_QUANTITY,
            LAST_UPDATED_DATE = SYSDATE
        WHERE PRODUCT_ID = P_PRODUCT_ID
          AND WAREHOUSE_ID = P_WAREHOUSE_ID;


        INSERT INTO INVENTORY_TRANSACTION (
            TRANSACTION_ID,
            PRODUCT_ID,
            WAREHOUSE_ID,
            TRANSACTION_TYPE,
            QUANTITY,
            TRANSACTION_DATE,
            CREATED_BY
        )
        VALUES (
            TRANSACTION_SEQ.NEXTVAL,
            P_PRODUCT_ID,
            P_WAREHOUSE_ID,
            'ISSUED',
            P_QUANTITY,
            SYSDATE,
            P_CREATED_BY
        );

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END ISSUE_INVENTORY;


    -- ========================================================
    -- RECORD PAYMENT
    -- ========================================================

    PROCEDURE RECORD_PAYMENT (
        P_INVOICE_ID            IN NUMBER,
        P_PAYMENT_MODE          IN VARCHAR2,
        P_PAYMENT_AMOUNT        IN NUMBER,
        P_TRANSACTION_REFERENCE IN VARCHAR2
    )
    IS
        V_NET_AMOUNT  NUMBER(12,2);
        V_PAID_AMOUNT NUMBER(12,2);
    BEGIN

        IF P_PAYMENT_AMOUNT <= 0 THEN
            RAISE_APPLICATION_ERROR(
                -20004,
                'Payment amount must be greater than zero.'
            );
        END IF;


        SELECT NET_AMOUNT
        INTO V_NET_AMOUNT
        FROM INVOICE
        WHERE INVOICE_ID = P_INVOICE_ID;


        SELECT NVL(SUM(PAYMENT_AMOUNT), 0)
        INTO V_PAID_AMOUNT
        FROM PAYMENT
        WHERE INVOICE_ID = P_INVOICE_ID
          AND PAYMENT_STATUS = 'SUCCESS';


        IF V_PAID_AMOUNT + P_PAYMENT_AMOUNT > V_NET_AMOUNT THEN
            RAISE_APPLICATION_ERROR(
                -20005,
                'Payment exceeds invoice amount.'
            );
        END IF;


        INSERT INTO PAYMENT (
            PAYMENT_ID,
            INVOICE_ID,
            PAYMENT_DATE,
            PAYMENT_MODE,
            PAYMENT_AMOUNT,
            PAYMENT_STATUS,
            TRANSACTION_REFERENCE
        )
        VALUES (
            PAYMENT_SEQ.NEXTVAL,
            P_INVOICE_ID,
            SYSDATE,
            P_PAYMENT_MODE,
            P_PAYMENT_AMOUNT,
            'SUCCESS',
            P_TRANSACTION_REFERENCE
        );


        IF V_PAID_AMOUNT + P_PAYMENT_AMOUNT = V_NET_AMOUNT THEN

            UPDATE INVOICE
            SET INVOICE_STATUS = 'PAID'
            WHERE INVOICE_ID = P_INVOICE_ID;

        ELSE

            UPDATE INVOICE
            SET INVOICE_STATUS = 'PARTIALLY PAID'
            WHERE INVOICE_ID = P_INVOICE_ID;

        END IF;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END RECORD_PAYMENT;


    -- ========================================================
    -- FUNCTION: GET ORDER TOTAL
    -- ========================================================

    FUNCTION GET_ORDER_TOTAL (
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

    END GET_ORDER_TOTAL;


    -- ========================================================
    -- FUNCTION: GET AVAILABLE STOCK
    -- ========================================================

    FUNCTION GET_AVAILABLE_STOCK (
        P_PRODUCT_ID   IN NUMBER,
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

    END GET_AVAILABLE_STOCK;


    -- ========================================================
    -- FUNCTION: GET DELIVERY DELAY
    -- ========================================================

    FUNCTION GET_DELIVERY_DELAY (
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

    END GET_DELIVERY_DELAY;


END PKG_LOGISTICS;
/

/* SELECT OBJECT_NAME,
       OBJECT_TYPE,
       STATUS
FROM USER_OBJECTS
WHERE OBJECT_NAME = 'PKG_LOGISTICS';

Result:  PKG_LOGISTICS [PACKAGE] | PKG_LOGISTICS [PACKAGE BODY] ->	VALID

*/