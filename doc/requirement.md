# Logistics Management System Requirements

## Project Objective

The objective of this project is to build an Oracle-based logistics management system to manage shipments, customers, vehicles, drivers, warehouses, and reporting.

## Business Problem

Logistics companies need a system to track shipments, manage resources, and generate operational reports.


## 3. Project Scope

The Logistics Management System will cover the following areas:

- Customer management
  - Store and manage customer details
  - Maintain customer shipment history

- Order management
  - Create and manage shipment orders
  - Track order status

- Shipment management
  - Create shipments
  - Assign vehicles and drivers
  - Track shipment lifecycle from pickup to delivery

- Warehouse management
  - Maintain warehouse details
  - Track inventory movement

- Inventory management
  - Maintain product information
  - Track stock availability across warehouses
  - Record inventory received and issued
  - Prevent incorrect stock levels
  - Provide inventory reports

- Vehicle management
  - Store vehicle information
  - Track vehicle availability and assignments

- Driver management
  - Maintain driver details
  - Assign drivers to shipments

- Route management
  - Store delivery routes
  - Monitor route performance

- Billing and payment management
  - Generate invoices
  - Track payment status

- Reporting
  - Generate operational and business reports


## 4. System Modules

 Customer Management
- Order Management
- Shipment Tracking
- Warehouse Management
- Vehicle Management
- Driver Management
- Billing
- Reports


## 5. Business Rules

1. A customer can create multiple shipment orders.

2. Each shipment must belong to one customer order.

3. Each shipment must have a shipment status:
   - Created
   - Picked Up
   - In Transit
   - Delivered
   - Cancelled

4. A vehicle can be assigned to multiple shipments over time but cannot handle multiple active shipments at the same time.

5. A driver can be assigned to multiple shipments over time but can only manage one active shipment at a time.

6. Every shipment must have a pickup location and delivery location.

7. Each shipment must be assigned a route before delivery.

8. Warehouse inventory quantity cannot become negative.

9. Every invoice must be linked to a shipment.

10. Payment status must be tracked for every invoice.

11. Customer, shipment, vehicle, driver, and warehouse records cannot be deleted if they are referenced by active transactions.

12. All important transaction changes should be recorded for auditing purposes.


## 6. Future Enhancements

Possible improvements in future versions:

- Real-time shipment tracking using GPS integration

- Mobile application for drivers and customers

- Automated route optimization using machine learning

- Customer notification system through email/SMS

- Dashboard with real-time logistics analytics

- Integration with external courier and transportation systems

- Data warehouse implementation for advanced analytics

- Cloud deployment using Oracle Cloud Infrastructure


### 7.Out of Scope

The following features are not included in the initial version:

- Real-time GPS tracking
- Mobile application
- Customer self-service portal
- Online payment gateway integration
- AI-based route optimization




