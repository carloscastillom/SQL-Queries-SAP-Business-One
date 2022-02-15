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