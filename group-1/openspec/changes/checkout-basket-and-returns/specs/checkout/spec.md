## ADDED Requirements

### Requirement: Basket total
The app SHALL let the cashier add products to a basket and SHALL show the basket total,
with VAT included in every price and no separate VAT line.

#### Scenario: Add products
- **WHEN** the cashier adds a product at 20.00 and a product at 15.50
- **THEN** the basket total is 35.50

#### Scenario: Same product twice
- **WHEN** the cashier adds the same product at 20.00 twice
- **THEN** the basket holds that product with quantity 2 and the total is 40.00

#### Scenario: No VAT line
- **WHEN** the basket has products
- **THEN** the screen shows the total and no separate VAT amount

### Requirement: Discount sticker
The app SHALL apply a product's discount sticker, a percentage, to the price before VAT,
and SHALL round the discounted price down to the cent, in the customer's favour.

#### Scenario: Sticker on a product
- **WHEN** the cashier adds a product at 20.00 with a 30 % sticker
- **THEN** its price in the basket is 14.00 and the total is 14.00

#### Scenario: Rounding in the customer's favour
- **WHEN** the cashier adds a product at 19.99 with a 30 % sticker
- **THEN** its price in the basket is 13.99, not 14.00

### Requirement: Payment by card or cash
The app SHALL let the cashier close a basket by card or by cash. For cash, the app SHALL
take the amount received and show the change to give back.

#### Scenario: Pay by card
- **WHEN** the cashier closes a basket of 35.50 by card
- **THEN** the sale is recorded as paid by card for 35.50

#### Scenario: Pay by cash with change
- **WHEN** the cashier closes a basket of 35.50 by cash and enters 40.00 received
- **THEN** the change to give back is 4.50 and the sale is recorded as paid by cash

#### Scenario: Cash received is not enough
- **WHEN** the cashier closes a basket of 35.50 by cash and enters 30.00 received
- **THEN** the sale is not closed and the screen says the amount is not enough

### Requirement: Return with the receipt
The app SHALL let the cashier return part of a sale found by its receipt, and SHALL refund
the price actually paid for the returned items. A return without a receipt SHALL be refused.

#### Scenario: Partial return
- **WHEN** a sale holds two shirts at 14.00 each and the cashier returns one of them
- **THEN** the refund is 14.00

#### Scenario: Return of a discounted product
- **WHEN** the cashier returns a product that was sold at 13.99 after a sticker
- **THEN** the refund is 13.99, never the price before the sticker

#### Scenario: Return without a receipt
- **WHEN** the cashier tries to start a return with no receipt
- **THEN** the return is refused and nothing is refunded

#### Scenario: Cannot return more than was bought
- **WHEN** a sale holds one shirt and the cashier returns two
- **THEN** the return is refused

#### Scenario: Cannot return the same article twice
- **WHEN** a sale holds one shirt, it is returned, and the cashier returns it again
- **THEN** the second return is refused

### Requirement: Refund method
The app SHALL let the cashier choose, for each return, to refund to the card or in cash
from the drawer, whatever the payment method of the original sale.

#### Scenario: Cash sale refunded to the card
- **WHEN** a sale paid in cash is returned and the cashier chooses card
- **THEN** the refund is recorded as card and the drawer does not move

#### Scenario: Card sale refunded in cash
- **WHEN** a sale paid by card is returned and the cashier chooses cash
- **THEN** the refund is recorded as cash and the drawer holds that amount less

### Requirement: Drawer at closing
The app SHALL show, at closing time, the cash the drawer must hold: the cash kept from
sales, which is the amount received minus the change given, less the cash refunds.

#### Scenario: Drawer after sales and a refund
- **WHEN** the day has one cash sale of 35.50 paid with 40.00, and one cash refund of 14.00
- **THEN** the closing view shows 21.50 of cash expected in the drawer

#### Scenario: Card does not touch the drawer
- **WHEN** the day has only card sales and card refunds
- **THEN** the closing view shows 0.00 of cash expected in the drawer
