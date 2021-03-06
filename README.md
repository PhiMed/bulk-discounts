# Bulk Discounts

![bulk-discounts-cover](https://user-images.githubusercontent.com/87627363/142251302-e21d1d6f-09fe-49b9-8ed7-e26c7770010b.png)

[Link to Page](https://bulk-discounts-phimed.herokuapp.com/)

## Description

Little Esty Shop is a webhosted application that emulates the workings of a typical web store.

Bulk Discounts is an extension of this project, in which a mechanism has been added for merchants to create bulk discounts that are applied to their items at point-of-sale. The discounts have attributes for minimum item quantity threshhold and what percentage discount is applied (eg minimum 4 items, 20% discount applied). Once in place, a merchant's bulk discounts are automatically applied to an invoice with that merchant's items. Logic is built in to only apply the discount to eligible items belonging to that merchant, to select for the best (highest) discount when multiple apply, and handle complex scenarios involving multiple item quantities with multiple discounts and multiple merchants on a single invoice. Additionally, it can provide discount revenue information to merchants and administrators of the application.

Lastly, upcoming US holiday information is provided via API on the bulk discount index, to aid merchants with planning holiday sales.

## Pages

There are two main sections of the website; one for merchants and one for site admins each with their respective dashboard pages.

On the merchant dashboard, you are able to see information about that merchant, including statistics on the customers and items ready to ship. It also has links to pages with more information about the items, bulk discounts and invoices that belong to that specific merchant.

On the admin dashboard you see information about all invoices and custormers for the shop and links to more information about all merchants and invoices which have more tailored information.

## Credits

[Philip](https://github.com/PhiMed)


## Schema
![bulk-discount-schema](https://user-images.githubusercontent.com/87627363/142140892-edc2c746-3f7b-4e5a-b52b-f71a6d2d8563.png)


