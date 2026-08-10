/* ============================================================
   LOGISTICS MANAGEMENT SYSTEM
   CREATE CONSTRAINTS
   ============================================================ */
   /* =========================
   PRIMARY KEYS
   ========================= */

ALTER TABLE customer
ADD CONSTRAINT pk_customer
PRIMARY KEY (customer_id);

ALTER TABLE orders
ADD CONSTRAINT pk_orders
PRIMARY KEY (order_id);

ALTER TABLE order_details
ADD CONSTRAINT pk_order_details
PRIMARY KEY (order_detail_id);

ALTER TABLE product_category
ADD CONSTRAINT pk_product_category
PRIMARY KEY (category_id);

ALTER TABLE products
ADD CONSTRAINT pk_products
PRIMARY KEY (product_id);

ALTER TABLE warehouse
ADD CONSTRAINT pk_warehouse
PRIMARY KEY (warehouse_id);

ALTER TABLE inventory
ADD CONSTRAINT pk_inventory
PRIMARY KEY (inventory_id);

ALTER TABLE inventory_transaction
ADD CONSTRAINT pk_inventory_transaction
PRIMARY KEY (transaction_id);

ALTER TABLE supplier
ADD CONSTRAINT pk_supplier
PRIMARY KEY (supplier_id);

ALTER TABLE supplier_product
ADD CONSTRAINT pk_supplier_product
PRIMARY KEY (supplier_product_id);

ALTER TABLE vehicle
ADD CONSTRAINT pk_vehicle
PRIMARY KEY (vehicle_id);

ALTER TABLE driver
ADD CONSTRAINT pk_driver
PRIMARY KEY (driver_id);

ALTER TABLE route
ADD CONSTRAINT pk_route
PRIMARY KEY (route_id);

ALTER TABLE shipment
ADD CONSTRAINT pk_shipment
PRIMARY KEY (shipment_id);

ALTER TABLE shipment_status_history
ADD CONSTRAINT pk_shipment_status_history
PRIMARY KEY (status_history_id);

ALTER TABLE invoice
ADD CONSTRAINT pk_invoice
PRIMARY KEY (invoice_id);

ALTER TABLE payment
ADD CONSTRAINT pk_payment
PRIMARY KEY (payment_id);

/* =========================
FOREIGN KEYS
========================= */
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id)
REFERENCES product_category(category_id);

/*Inventory relationships*/

ALTER TABLE inventory
ADD CONSTRAINT fk_inventory_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE inventory
ADD CONSTRAINT fk_inventory_warehouse
FOREIGN KEY (warehouse_id)
REFERENCES warehouse(warehouse_id);

ALTER TABLE inventory_transaction
ADD CONSTRAINT fk_inv_transaction_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE inventory_transaction
ADD CONSTRAINT fk_inv_transaction_warehouse
FOREIGN KEY (warehouse_id)
REFERENCES warehouse(warehouse_id);

/*Supplier relationship
SUPPLIER
   ↓
SUPPLIER_PRODUCT
   ↑
PRODUCT */

ALTER TABLE supplier_product
ADD CONSTRAINT fk_supplier_product_supplier
FOREIGN KEY (supplier_id)
REFERENCES supplier(supplier_id);

ALTER TABLE supplier_product
ADD CONSTRAINT fk_supplier_product_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

/*Shipment relationship
SHIPMENT
 ├── ORDER
 ├── VEHICLE
 ├── DRIVER
 └── ROUTE*/

ALTER TABLE shipment
ADD CONSTRAINT fk_shipment_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE shipment
ADD CONSTRAINT fk_shipment_vehicle
FOREIGN KEY (vehicle_id)
REFERENCES vehicle(vehicle_id);

ALTER TABLE shipment
ADD CONSTRAINT fk_shipment_driver
FOREIGN KEY (driver_id)
REFERENCES driver(driver_id);

ALTER TABLE shipment
ADD CONSTRAINT fk_shipment_route
FOREIGN KEY (route_id)
REFERENCES route(route_id);

/*Shipment status history  */

ALTER TABLE shipment_status_history

ADD CONSTRAINT fk_status_history_shipment

FOREIGN KEY (shipment_id)

REFERENCES shipment(shipment_id);



/*invoice & payment  

SHIPMENT → INVOICE → PAYMENT */

ALTER TABLE invoice

ADD CONSTRAINT fk_invoice_shipment

FOREIGN KEY (shipment_id)

REFERENCES shipment(shipment_id);



ALTER TABLE payment
ADD CONSTRAINT fk_payment_invoice
FOREIGN KEY (invoice_id)
REFERENCES invoice(invoice_id);


/* Not null constraints  */
/* customer shouldn't exist without a name*/

ALTER TABLE customer
MODIFY customer_name CONSTRAINT nn_customer_name NOT NULL;

/*Orders must have a customer */

ALTER TABLE orders
MODIFY customer_id CONSTRAINT nn_orders_customer NOT NULL;

ALTER TABLE orders
MODIFY order_date CONSTRAINT nn_orders_date NOT NULL;

/*Order details must identify the order and product  */

ALTER TABLE order_details
MODIFY order_id CONSTRAINT nn_order_details_order NOT NULL;

ALTER TABLE order_details
MODIFY product_id CONSTRAINT nn_order_details_product NOT NULL;


ALTER TABLE order_details
MODIFY quantity CONSTRAINT nn_order_details_quantity NOT NULL;

/*Shipment must have an order */

ALTER TABLE shipment
MODIFY order_id CONSTRAINT nn_shipment_order NOT NULL;


ALTER TABLE shipment
MODIFY shipment_status CONSTRAINT nn_shipment_status NOT NULL;

/*Invoice must belong to a shipment  */

ALTER TABLE invoice
MODIFY shipment_id CONSTRAINT nn_invoice_shipment NOT NULL;

/*Payment must belong to an invoice */

ALTER TABLE payment

MODIFY invoice_id CONSTRAINT nn_payment_invoice NOT NULL;



/*UNIQUE constraints  

Customer email | Vehicle number | Driver license | supplier email | */



ALTER TABLE customer

ADD CONSTRAINT uq_customer_email

UNIQUE (email_id);



ALTER TABLE vehicle

ADD CONSTRAINT uq_vehicle_number

UNIQUE (vehicle_number);



ALTER TABLE driver

ADD CONSTRAINT uq_driver_license

UNIQUE (license_number);



ALTER TABLE supplier

ADD CONSTRAINT uq_supplier_email

UNIQUE (email_id);



/*Check Constraints 

 Order priority | Order status | Shipment status | Vehicle Status | Driver Status |*/

ALTER TABLE orders
ADD CONSTRAINT ck_orders_priority
CHECK (order_priority IN ('LOW', 'MEDIUM', 'HIGH'));


ALTER TABLE orders
ADD CONSTRAINT ck_orders_status
CHECK (
    order_status IN (
        'CREATED',
        'CONFIRMED',
        'PROCESSING',
        'SHIPPED',
        'DELIVERED',
        'CANCELLED'
    )
);


ALTER TABLE shipment
ADD CONSTRAINT ck_shipment_status
CHECK (
    shipment_status IN (
        'CREATED',
        'PICKED UP',
        'IN TRANSIT',
        'DELIVERED',
        'CANCELLED'
    )
);


ALTER TABLE vehicle
ADD CONSTRAINT ck_vehicle_status
CHECK (
    vehicle_status IN (
        'AVAILABLE',
        'ASSIGNED',
        'MAINTENANCE',
        'INACTIVE'
    )
);


ALTER TABLE driver
ADD CONSTRAINT ck_driver_status
CHECK (
    driver_status IN (
        'AVAILABLE',
        'ASSIGNED',
        'ON LEAVE',
        'INACTIVE'
    )
);


/* Inventory transaction type | Payment status */
ALTER TABLE inventory_transaction
ADD CONSTRAINT ck_inventory_transaction_type
CHECK (
    transaction_type IN (
        'RECEIVED',
        'ISSUED',
        'RETURNED',
        'ADJUSTMENT'
    )
);

ALTER TABLE payment
ADD CONSTRAINT ck_payment_status
CHECK (
    payment_status IN (
        'PENDING',
        'SUCCESS',
        'FAILED',
        'REFUNDED'
    )
);


/*Prevent negative values*/

ALTER TABLE inventory
ADD CONSTRAINT ck_inventory_available_qty
CHECK (available_quantity >= 0);

ALTER TABLE inventory
ADD CONSTRAINT ck_inventory_reserved_qty
CHECK (reserved_quantity >= 0);

ALTER TABLE order_details
ADD CONSTRAINT ck_order_details_quantity
CHECK (quantity > 0);

ALTER TABLE order_details
ADD CONSTRAINT ck_order_details_unit_price
CHECK (unit_price >= 0);

ALTER TABLE products
ADD CONSTRAINT ck_products_unit_price
CHECK (unit_price >= 0);

ALTER TABLE supplier_product
ADD CONSTRAINT ck_supplier_supply_price
CHECK (supply_price >= 0);

ALTER TABLE payment
ADD CONSTRAINT ck_payment_amount
CHECK (payment_amount > 0);

/*Important inventory constraint
Product 101 + Warehouse 1
Product 101 + Warehouse 1 */

ALTER TABLE inventory
ADD CONSTRAINT uq_inventory_product_warehouse
UNIQUE (product_id, warehouse_id);

/* Supplier-product uniqueness
one supplier shouldn't have duplicate entries for the same product: */

ALTER TABLE supplier_product
ADD CONSTRAINT uq_supplier_product
UNIQUE (supplier_id, product_id);

/* What NOT to implement here

# Vehicle cannot handle multiple active shipments.

If vehicle already has an active shipment
        ↓
Reject new assignment

# Driver can only manage one active shipment.

# Inventory must never become negative after an inventory transaction.

If inventory quantity - issued quantity < 0
        ↓
Reject transaction

# Shipment status must follow a valid lifecycle.

*/
