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
Based upon ordering history what are the projected orders for the next
6 months.

Since this is the point of the system, this should be main dashboard rather
than a report.


