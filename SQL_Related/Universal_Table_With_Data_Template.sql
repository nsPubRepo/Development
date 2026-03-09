


DECLARE @NewUniqueID AS UNIQUEIDENTIFIER = NEWID()
      , @StartDate AS DATE = CAST(GETDATE() AS DATE)
      , @RecordCreatedModified AS DATETIME2 = GETDATE()
      , @User AS VARCHAR(50) = SYSTEM_USER



CREATE TABLE #TempTable
	(
		UserGUID                UNIQUEIDENTIFIER NOT NULL
      , First_Name              VARCHAR(50)          NULL
      , LastName                VARCHAR(50)          NULL
      , [Address]               VARCHAR(50)          NULL
      , City                    VARCHAR(50)          NULL
      , [State]                 VARCHAR(50)          NULL
      , Work_License            VARCHAR(50)          NULL
      , Is_Active               BIT              NOT NULL
      , Soft_Delete             BIT              NOT NULL
      , Emergency_Contact_Name  VARCHAR(50)          NULL
      , Emergency_Contact_Phone VARCHAR(50)          NULL
      , [Start_Date]            DATE                 NULL
      , End_Date                DATE                 NULL
      , Pay_Amount              MONEY                NULL
      , PayIntervalID           INT                  NULL
      , RecordCreatedDate       DATETIME2        NOT NULL
      , RecordCreatedBy         VARCHAR(50)      NOT NULL
      , RecordModifiedDate      DATETIME2        NOT NULL
      , RecordModifiedBy        VARCHAR(50)      NOT NULL
	)



CREATE TABLE #PayInterval
	(
		PayIntervalID INT         NOT NULL
      , [Description] VARCHAR(100) NOT NULL
	)



INSERT INTO #PayInterval (PayIntervalID, [Description]) VALUES (1, 'Annual')
INSERT INTO #PayInterval (PayIntervalID, [Description]) VALUES (2, 'Hourly')



INSERT INTO #TempTable
	(
		UserGUID
      , First_Name
      , LastName
      , [Address]
      , [City]
      , [State]
      , Work_License
      , Is_Active
      , Soft_Delete
      , Emergency_Contact_Name
      , Emergency_Contact_Phone
      , [Start_Date]
      , End_Date
      , Pay_Amount
      , PayIntervalID
      , RecordCreatedDate
      , RecordCreatedBy
      , RecordModifiedDate
      , RecordModifiedBy
	)
		VALUES
			(
				@NewUniqueID
              , 'Bob'
              , 'Smith'
              , '111 Main St.'
              , 'Flint'
              , 'Michigan'
              , 'ABC123'
              , 1
              , 0
              , NULL
              , NULL
              , @StartDate
              , NULL
              , 123456
              , 1
              , @RecordCreatedModified
              , @User
              , @RecordCreatedModified
              , @User
			)



SELECT * FROM #PayInterval
SELECT * FROM #TempTable

DROP TABLE #TempTable
DROP TABLE #PayInterval