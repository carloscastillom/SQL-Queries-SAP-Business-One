# SQL Queries - SAP Business One
Using SAP business as our ERP I have implemented the following SQL queries which are functional for Operations and Sales control. I will explain what every uploaded query does and why is it useful for our company 

## Sales

- [Sales Orders with delivery Notes](https://github.com/carloscastillom/SQL-Queries-SAP-Business-One/blob/main/SalesO_with_DeliveryN.sql)
The SQL exhibits the sales orders which have at least one delivery note older than 2010 (can be modified depending of every need). It can be used to calculate our own lead time. the level of granularity is item in the sales order in case of a partial delivery

```
SELECT T1.[DocNum], T1.[DocDate], T1.[DocDueDate], T1.[DocTotalSy], T1.[CardCode], T1.[CardName], T0.[ItemCode], T0.[Dscription], T0.[Quantity], T0.[Price], T0.[LineTotal], T1.[DocTotal],  T3.TaxDate, T3.U_DocdueDate
FROM RDR1 T0  INNER JOIN ORDR T1 ON T0.[DocEntry] = T1.[DocEntry]
left outer join DLN1 T2 on T2.BaseEntry = T0.DocEntry and T2.BaseLine = T0.Linenum
left outer join ODLN T3 on T2.DocEntry = T3.DocEntry

WHERE T3.TaxDate> '01.01.2010'
```



- [Payment Received](https://github.com/carloscastillom/SQL-Queries-SAP-Business-One/blob/main/Payment%20Received.sql) 
the query reports the dates of the payments received by customer. The The sales team of our subsidiary required this for their internal operation 

```
SELECT T2.[DocDate] AS 'Posting Date',T2.[DocNum] AS 'Document Number',T2.[CardCode] AS 'Customer/Vendor Code', T2.[CardName] AS 'Customer/Vendor Name', T1.[SumApplied], T0.[DocNum], T3.[Country]  

FROM [dbo].[OINV] T0 

INNER JOIN [dbo].[RCT2] T1 ON T1.[DocEntry] = T0.[DocEntry]
INNER JOIN [dbo].[ORCT] T2 ON T2.[DocNum] = T1.[DocNum]
INNER JOIN [dbo].[OCRD] T3 ON T3.[CardCode] = T2.[CardCode]
```

## Inventory

- [Inventory_Control](https://github.com/carloscastillom/SQL-Queries-SAP-Business-One/blob/main/Inventory_Control.sql)
The SQL query keeps track of critical items for our company. Critical is defined as items with a defined minimun level quantity(MLQ) by management. It prints the current stock of the items that have a minimun level quantity(MLQ), for an specific warehouse. It Helps to have an overview of the items Based on the current status of them. When the inventory of the stock is lower that the MLQ, is required to order that specific item. The amount to order is evaluated based on the forecas 

```
SELECT T0.[ItemCode], T0.[ItemName], T0.[FrgnName], T1.[OnHand] AS 'DALOG´s Warehouse (100) Quantity', T0.[IsCommited] AS 'Demanded by Customer Quantity', T1.[OnHand] - T0.[IsCommited] As 'Available Quantity', T0.[OnOrder] AS 'Ordered Quantity',  0 AS 'Open Quantity', T2.[CardName], T0.[MinLevel], T0.[MaxLevel] As 'Preferred Inventory Level'

/*Tables OITM, OITW and OCRD*/
FROM OITM T0
LEFT JOIN OITW T1 ON T0.[ItemCode] = T1.[ItemCode] 
LEFT JOIN OCRD T2 
      ON T0.CardCode = T2.CardCode

/*The materials that have a minimun Inventory Level and the amount only in specific warehouse*/
WHERE  T0.[MinLevel]>0 AND T1.[WhsCode]=100

/*Order by Available Quantity*/
ORDER BY T2.[CardName], 'Available Quantity'
```

- [Inventory_Service_Engineers](https://github.com/carloscastillom/SQL-Queries-SAP-Business-One/blob/main/Inventory_Service_Engineers.sql)
Service engineers are employees that face the customer and commission our equiment on plant or remote. When they travel, the regularly take with them some items and  the company handles the inventory in our ERP as they were warehouses. The SQL shows the current status of the service engineers. This is helpful to keep track of the inventory.

## Production

- [Open_ProdOrder_Project](https://github.com/carloscastillom/SQL-Queries-SAP-Business-One/blob/main/Open_ProdOrder_Project.sql)
The SQL Query keeps track of the company´s open production orders and the percentage of materials issued. It prints all open production orders throughout the company, with the percentage of material already issued. the percentage of materials issed is calculated as  the amount  of items issued, divided by the total number of items. This is an overview of the work in process for the current week. 


## Procurement

- [Open_Purchase_Order](https://github.com/carloscastillom/SQL-Queries-SAP-Business-One/blob/main/Open_Purchase_Order.sql)
The SQL Query reports the items that the company is waiting on the suppliers to send. It can be used once a week or more frequently depending on the business dynamics. It prints the expected delivery date which helps in controlling the suppliers fulfillment

- [Supplier_Lead_Time](https://github.com/carloscastillom/SQL-Queries-SAP-Business-One/blob/main/Open_ProdOrder_Project.sql)
The SQL Query links tables related to the purchase Order and the delivery time of the items. The information is used to calculate the suppliers lead time and a great tool to control the inventory and adjust the item reorder policy





