SELECT T1.[DocNum], T1.[DocDate], T1.[DocDueDate], T1.[DocTotalSy], T1.[CardCode], T1.[CardName], T0.[ItemCode], T0.[Dscription], T0.[Quantity], T0.[Price], T0.[LineTotal], T1.[DocTotal],  T3.TaxDate, T3.U_DocdueDate
FROM RDR1 T0  INNER JOIN ORDR T1 ON T0.[DocEntry] = T1.[DocEntry]
left outer join DLN1 T2 on T2.BaseEntry = T0.DocEntry and T2.BaseLine = T0.Linenum
left outer join ODLN T3 on T2.DocEntry = T3.DocEntry

WHERE T3.TaxDate> '01.01.2010'