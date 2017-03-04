# CPAP

A database for ordering CPAP supplies.

## Schema

#### Users

#### Products
* code
* description
* interval-id
* qty

#### Order
* user-id
* order-date

#### Order Items
* order-id
* qty
* supply-id

#### Interval
* term : # of months between orders

## Reports
### Projected Orders
Based upon ordering history what are the projected orders for the next
6 months.

