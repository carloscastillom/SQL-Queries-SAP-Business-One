# SQL Queries - SAP Business One
Using SAP business as our ERP I have implemented the following SQL queries which are functional for Operations and Sales control. I will explain what every every uploaded query does and why is it useful 

## Inventory_Control
The SQL query keeps track of critical items for our company. Critical is defined as items with a defined minimun level quantity(MLQ) by management. It prints the current stock of the items that have a minimun level quantity(MLQ), for an specific warehouse. It Helps to have an overview of the items Based on the current status of them. When the inventory of the stock is lower that the MLQ, is required to order that specific item. The amount to order is evaluated based on the forecas 

## Open_ProdOrder_Project
The SQL Query keeps track of the company´s open production orders and the percentage of materials issued. It prints all open production orders throughout the company, with the percentage of material already issued. the percentage of materials issed is calculated as  the amount  of items issued, divided by the total number of items. This is an overview of the work in process for the current week. 

## Open_PurchaOrder
The SQL Query reports the items that the company is waiting on the suppliers to send. It can be used once a week or more frequently depending on the business dynamics. It prints the expected delivery date which helps in controlling the suppliers fulfillment

## Inventory_Service_Engineers


Carlos Castillo


