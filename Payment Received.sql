SELECT T2.[DocDate] AS 'Posting Date',T2.[DocNum] AS 'Document Number',T2.[CardCode] AS 'Customer/Vendor Code', T2.[CardName] AS 'Customer/Vendor Name', T1.[SumApplied], T0.[DocNum], T3.[Country]  

FROM [dbo].[OINV] T0 

INNER JOIN [dbo].[RCT2] T1 ON T1.[DocEntry] = T0.[DocEntry]
INNER JOIN [dbo].[ORCT] T2 ON T2.[DocNum] = T1.[DocNum]
INNER JOIN [dbo].[OCRD] T3 ON T3.[CardCode] = T2.[CardCode]

