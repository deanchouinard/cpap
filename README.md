# CPAP

A database for ordering CPAP supplies.

## Domain Model

### Accounts

#### Users

### Supplies

#### Products or Parts
* code
* description
* interval-id
* qty

#### Replacement Interval
* term : # of months part is eligible for replacement

### Purchases

#### Order
* user-id
* order-date

#### Order Items
* order-id
* qty
* product-id


## Reports
### Projected Orders

Take each product and look at Interval; if not an order containing
product within Interval, put on list to order.

Based upon ordering history what are the projected orders for the next
6 months.

Since this is the point of the system, this should be main dashboard rather
than a report.

### Interval History
Take a list of orders and items, compare the frequency of items ordering to
the Product Interval.

