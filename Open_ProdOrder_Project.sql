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