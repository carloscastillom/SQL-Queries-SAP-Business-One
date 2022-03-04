SELECT T0.[ItemCode], T0.[ItemName], T1.[WhsCode], T1.[OnHand], T2.[WhsName] 
FROM OITM T0  
INNER JOIN OITW T1 ON T0.[ItemCode] = T1.[ItemCode] 
INNER JOIN OWHS T2 ON T1.[WhsCode] = T2.[WhsCode] 
WHERE T1.[OnHand]>0 AND T1.[WhsCode]>800 AND T1.[WhsCode]<900
ORDER BY T1.[WhsCode]