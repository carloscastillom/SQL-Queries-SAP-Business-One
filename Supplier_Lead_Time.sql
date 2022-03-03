SELECT T0.DocEntry,  T4.DocDate AS "PO Date", T0.ItemCode, T0.Dscription, T0.Quantity, T0.ShipDate AS "Estimated Delivery Date", T0.BaseCard AS "BP Code", T2.CardName AS "BP Name", T1.DocEntry AS "Goods Receipt Internal ID", T1.Quantity, T1.ActDelDate AS "Goods Receipt Posting Date", T5.taxDate AS "Goods Receipt Document Date", T6.DocEntry
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