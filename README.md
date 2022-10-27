# SQL Queries - SAP Business One
Using SAP business as our ERP I have implemented the following SQL queries which are functional for Operations and Sales control. This SQL queries are use maily for reporting. I will explain what every uploaded query does and why is it useful for the company 

https://blogs.sap.com/2016/01/14/sap-business-one-tables/

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

```
SELECT T0.[ItemCode], T0.[ItemName], T1.[WhsCode], T1.[OnHand], T2.[WhsName] 
FROM OITM T0  
INNER JOIN OITW T1 ON T0.[ItemCode] = T1.[ItemCode] 
INNER JOIN OWHS T2 ON T1.[WhsCode] = T2.[WhsCode] 
WHERE T1.[OnHand]>0 AND T1.[WhsCode]>xxx AND T1.[WhsCode]<xxx
ORDER BY T1.[WhsCode]
```

-Inventory of Specific group of items
creates a table with the current status of the itmes with the serial numbers that contains a certain string, can also be used with regex as well

```
SELECT osri.itemcode, OITM.itemName, osri.WhsCode, OSRI.IntrSerial
from osri LEFT JOIN OITM on OSRI.ItemCode = OITM.ItemCode
WHERE OSRI.Status = 0 AND OSRI.IntrSerial  LIKE '% x %'
ORDER BY OSRI.IntrSerial
```


## Production

- [Open_ProdOrder_Project](https://github.com/carloscastillom/SQL-Queries-SAP-Business-One/blob/main/Open_ProdOrder_Project.sql)
The SQL Query keeps track of the company´s open production orders and the percentage of materials issued. It prints all open production orders throughout the company, with the percentage of material already issued. the percentage of materials issed is calculated as  the amount  of items issued, divided by the total number of items. This is an overview of the work in process for the current week. 

```
SELECT T1.[Project], T0.[PrjName],T1.[DocNum], T1.[ItemCode], T2.[ItemName],T1.[PlannedQty] as 'Qty', T4.[PercentageIssued] AS '% Issued', T1.[StartDate], T1.[DueDate],T5.[DocDueDate] AS 'SO Due Date',T1.[Comments]

/*Tables used are a combination of standard from the ERP and user defined tables*/

FROM [dbo].[OPRJ]  T0 

RIGHT JOIN OWOR T1 ON T0.[PrjCode] = T1.[Project]
INNER JOIN OITM T2 ON T1.[ItemCode] = T2.[ItemCode]

/*User Defined table to obtain the due date of the project*/
LEFT JOIN
(SELECT T10.project, max(T10.DueDate) AS 'MaxDueDate'  FROM OWOR T10  WHERE T10.[Status]='P' OR T10.[Status]='R'   GROUP BY T10.project) T3 
ON T3.[Project] = T1.[Project]

/*User Defined table to obtain the percentage issued, calculated as number of items issued/ total of items*/
LEFT JOIN 
(SELECT T20.[DocNum], (CAST(T22.[NoItemsIssued] AS float) /CAST(T22.[NumOfRows] AS float))AS PercentageIssued
FROM OWOR T20  
INNER JOIN WOR1 T21 ON T20.[DocEntry] = T21.[DocEntry] 

/*User Defined table to obtain the amount of items issued*/
LEFT JOIN
(SELECT T23.[DocEntry], COUNT(CASE WHEN T23.[IssuedQty] > 0 THEN 1 END) AS NoItemsIssued , COUNT(CASE WHEN T23.[BaseQty] > 0 THEN 1 END) AS NumOfRows   FROM WOR1 T23  GROUP BY T23.[DocEntry] ) T22  ON T20.[DocEntry] = T22.[DocEntry] 
WHERE T20.[Status]='R' OR T20.[Status]='P'
GROUP BY T20.[DocNum], T20.[ItemCode], T20.[Status], T22.[NoItemsIssued], T22.[NumOfRows])
 T4 ON T4.[DocNum] = T1.[DocNum]

LEFT JOIN ORDR T5 ON T1.[OriginNum] = T5.[DocNum]

WHERE T1.[Status]='P' OR T1.[Status]='R'
```

## Procurement

- [Open_Purchase_Order](https://github.com/carloscastillom/SQL-Queries-SAP-Business-One/blob/main/Open_Purchase_Order.sql)
The SQL Query reports the items that the company is waiting on the suppliers to send. It can be used once a week or more frequently depending on the business dynamics. It prints the expected delivery date which helps in controlling the suppliers fulfillment

```
SELECT T3.DocNum, T0.LineStatus, T0.ItemCode, T0.Dscription, T0.Quantity AS 'Ordered Quantity', T0.OpenQty , T0.ShipDate , T0.BaseCard, T1.CardName, T0.Project, T2.PrjName
FROM POR1 T0
LEFT JOIN OCRD T1 
    ON T0.BaseCard = T1.CardCode
LEFT JOIN OPRJ T2 
      ON T0.Project = T2.PrjCode
LEFT JOIN OPOR T3 
      ON T0.DocEntry = T3.DocEntry

WHERE T0.LineStatus = 'O'
ORDER BY  T0.ShipDate
```

- [Supplier_Lead_Time](https://github.com/carloscastillom/SQL-Queries-SAP-Business-One/blob/main/Open_ProdOrder_Project.sql)
The SQL Query links tables related to the purchase Order and the delivery time of the items. The information is used to calculate the suppliers lead time and a great tool to control the inventory and adjust the item reorder policy

```
SELECT T0.DocEntry,  T4.DocDate AS "PO Date", T0.ItemCode,  CAST(T0.Quantity AS int) as Q, T0.ShipDate AS "Estimated Delivery Date", T0.BaseCard AS "BP Code", T2.CardName AS "BP Name", T1.DocEntry AS "Goods Receipt Internal ID", CAST(T1.Quantity AS int) as Q_r, T1.ActDelDate AS "Goods Receipt Posting Date", T5.taxDate AS "Goods Receipt Document Date", T6.DocEntry As Goods_Returned
 FROM 
 POR1 T0 
    LEFT JOIN PDN1 T1 
     ON T0.DocEntry = T1.BaseEntry AND T0.LineNum = T1.BaseLine
    LEFT JOIN OCRD T2 
      ON T0.BaseCard = T2.CardCode
     INNER JOIN OPOR T4 
      ON T0.DocEntry = T4.DocEntry
     LEFT JOIN OPDN T5 
      ON T1.DocEntry = T5.DocEntry
     LEFT JOIN RPD1 T6 
      ON T1.DocEntry = T6.BaseEntry AND T1.LineNum = T6.BaseLine
ORDER BY T0.DocEntry
```


