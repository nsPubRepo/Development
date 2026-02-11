

WITH cteRecursiveTesting AS
	(
		--initialization section (gotta seed the return row(s) with the first entry... every journey starts with a single step...)
			SELECT dt1.DocumentTypeId
				 , dt1.ParentDocumentTypeId
				 , dt1.[Name]
			FROM DWRaw_DocHub.DocumentType dt1
			WHERE dt1.[Name] = 'Bank Statement'

				UNION ALL

		--recursion section
			SELECT dt2.DocumentTypeId
				 , dt2.ParentDocumentTypeId
				 , dt2.[Name]
			FROM DWRaw_DocHub.DocumentType dt1
				INNER JOIN DWRaw_DocHub.DocumentType dt2
					ON dt1.ParentDocumentTypeId = dt2.DocumentTypeId
			WHERE dt1.[Name] = 'Bank Statement'
	)	--cteRecursiveTesting


SELECT * FROM cteRecursiveTesting