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