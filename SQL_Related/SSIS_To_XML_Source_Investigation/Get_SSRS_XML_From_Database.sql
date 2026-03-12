


SELECT c.[Name]
     , c.[Type]
     , c.[Path]
     , CONVERT(XML, CONVERT(VARBINARY(MAX), c.Content))			AS reportXML
     , c.Content
     , c.*
FROM ReportServer.dbo.[Catalog] AS c WITH (NOLOCK)
WHERE C.Content IS NOT NULL
	AND C.[Type] = 2
	AND c.[Name] = 'BOLT_PurchaseAgreement'


--e.g., <CommandText>DWRaw_Qarik.usp_select_BOLT_PurchaseAgreementUserUWAI</CommandText>