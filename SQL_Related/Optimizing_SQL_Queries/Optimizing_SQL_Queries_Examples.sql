--pp. 6
--SET STATISTICS IO ON
--SET STATISTICS TIME ON

--	SELECT TOP 1000 *
--	FROM [dbo].[loan_conditions]
--	WHERE loanrecordid = 21534067
--	ORDER BY categoryid

--SET STATISTICS IO OFF
--SET STATISTICS TIME OFF





--pp. 9
--SET STATISTICS IO ON
--SET STATISTICS TIME ON

--	SELECT TOP 1000 *
--	FROM [dbo].[loan_conditions]
--	WHERE loanrecordid = 21534067
--	ORDER BY categoryid

--	SELECT TOP 1000 *
--	FROM [dbo].[loan_conditions]
--	WHERE lenderdatabaseid = 1
--		AND loanrecordid = 21534067
--	ORDER BY categoryid

--SET STATISTICS IO OFF
--SET STATISTICS TIME OFF



----pp. 14
----De-optimized:
--SET STATISTICS IO ON
--SET STATISTICS TIME ON

--	SELECT *
--	FROM dbo.USFS_OrgChart uoc WITH(NOLOCK)
--	WHERE uoc.userid = 22316

--	--Optimized
--		SELECT o.FullName
--			  ,o.JobTitle
--			  ,o.manager_FullName
--		FROM dbo.USFS_OrgChart o WITH(NOLOCK)
--		WHERE o.domainname = 'jhalim'
--			AND o.userid = 22316

--SET STATISTICS IO OFF
--SET STATISTICS TIME OFF


--pp. 15
--de-optimized:
--SET STATISTICS IO ON
--SET STATISTICS TIME ON

--	SELECT re.[name]
--	      ,re.alias2
--	      ,re.entityid
--	FROM dbo.rolodex_entity re WITH(NOLOCK)
--	WHERE re.lenderdatabaseid = 1
--		AND re.entityid = 89;

--SET STATISTICS IO OFF
--SET STATISTICS TIME OFF



--pp. 18
--De-Optimized:
--Loans Currently in Submission status. We want to grab the Loan number, Borrowers name and the Senior UW on the loan.
--SET STATISTICS IO ON
--SET STATISTICS TIME ON

--	SELECT lm.loanid
--		  ,CONCAT(cm.firstname, ' ', cm.lastname) BorrowerName
--		  ,CONCAT(rc.firstname, ' ', rc.lastname) srUWName

--	FROM dbo.customer_main cm WITH (NOLOCK)

--		INNER JOIN dbo.customer_group cg WITH (NOLOCK)
--			ON cg.customerrecordid = cm.customerrecordid
--				AND cg.lenderdatabaseid = cm.lenderdatabaseid

--		INNER JOIN dbo.loan_main lm WITH (NOLOCK)
--			ON lm.customergroupid = cg.customergroupid
--				AND lm.lenderdatabaseid = cg.lenderdatabaseid

--		INNER JOIN dbo.loan_status ls WITH (NOLOCK)
--			ON ls.lenderdatabaseid = lm.lenderdatabaseid
--				AND ls.statusid = lm.statusid
--				AND ls.loanrecordid = lm.loanrecordid

--		INNER JOIN dbo.loan_channelcontacts LC WITH (NOLOCK)
--			ON lc.loanrecordid = ls.loanrecordid
--				AND lc.lenderdatabaseid = LS.LENDERDATABASEID
--				AND lc.contactcategoryid = 8 --senior underwriter

--		INNER JOIN dbo.rolodex_contacts rc WITH (NOLOCK)
--			ON rc.contactid = lc.contactid
--				AND rc.entityid = lc.entityid

--		INNER JOIN dbo.usfs_testloanindicator T WITH (NOLOCK)
--			ON t.lenderdatabaseid = lm.lenderdatabaseid
--				AND t.loanrecordid = lm.loanrecordid
--				AND t.testloanind = 0 --removing test loans

--	WHERE ls.statusid IN ( 2, 49 ) --UW status/submission




----pp. 18
----Optimized:
--	SELECT lm.loanid
--	      ,CONCAT(cm.firstname, ' ', cm.lastname) BorrowerName
--          ,CONCAT(rc.firstname, ' ', rc.lastname) srUWName
--	FROM dbo.loan_main lm WITH (NOLOCK)

--		INNER JOIN dbo.customer_group cg WITH (NOLOCK)
--			ON cg.lenderdatabaseid = lm.lenderdatabaseid
--				AND cg.customergroupid = lm.customergroupid

--		INNER JOIN dbo.customer_main cm WITH (NOLOCK)
--			ON lm.lenderdatabaseid = lm.lenderdatabaseid
--				AND cg.customerrecordid = cm.customerrecordid

--		INNER JOIN dbo.loan_channelcontacts lc WITH (NOLOCK)
--			ON lc.loanrecordid = lm.loanrecordid
--				AND lc.lenderdatabaseid = lm.lenderdatabaseid
--				AND lc.contactcategoryid = 8 --srUW

--		INNER JOIN dbo.rolodex_contacts rc WITH (NOLOCK)
--			ON rc.lenderdatabaseid = lc.lenderdatabaseid
--				AND rc.entityid = lc.entityid
--				AND rc.contactlenderdatabaseid = lc.contactlenderdatabaseid
--				AND rc.contactid = lc.contactid

--	WHERE lm.statusid IN ( 2, 49 );


--SET STATISTICS IO OFF
--SET STATISTICS TIME OFF




--pp. 20
--SET STATISTICS IO ON
--SET STATISTICS TIME ON

----Deoptimized
--	SELECT lm.loanid
--		  ,CONCAT(cm.firstname, ' ', cm.lastname) BorrowerName
--		  ,CONCAT(rc.firstname, ' ', rc.lastname) srUWName

--	FROM dbo.loan_main lm WITH (NOLOCK)

--		JOIN dbo.customer_group cg WITH (NOLOCK)
--			ON cg.customergroupid = lm.customergroupid

--		JOIN dbo.customer_main cm WITH (NOLOCK)
--			ON cg.customerrecordid = cm.customerrecordid

--		JOIN dbo.loan_channelcontacts lcc WITH (NOLOCK)
--			ON lcc.loanrecordid = lm.loanrecordid
--				AND lcc.contactcategoryid = 8 --loan officer

--		JOIN dbo.rolodex_contacts rc WITH (NOLOCK)
--			ON rc.contactid = lcc.contactid

--		JOIN dbo.USFS_TestLoanIndicator t WITH (NOLOCK)
--			ON t.LoanRecordID = lm.loanrecordid
--				AND t.TestLoanIND = 0 --removing test loans

--	WHERE lm.statusid IN ( 2, 49 );




----Optimized
--	SELECT lm.loanid
--		  ,CONCAT(cm.firstname, ' ', cm.lastname) BorrowerName
--		  ,CONCAT(rc.firstname, ' ', rc.lastname) srUWName

--	FROM dbo.loan_main lm WITH (NOLOCK)

--		JOIN dbo.USFS_TestLoanIndicator t WITH (NOLOCK)	--1,284,137
--			ON t.LenderDatabaseID = lm.lenderdatabaseid
--				AND t.LoanRecordID = lm.loanrecordid
--				AND t.TestLoanIND = 0 --removing test loans

--		JOIN dbo.customer_group cg WITH (NOLOCK)	--2,328,498
--			ON cg.lenderdatabaseid = lm.lenderdatabaseid
--				AND cg.customergroupid = lm.customergroupid
--				AND lm.statusid IN ( 2, 49 )

--		JOIN dbo.customer_main cm WITH (NOLOCK)	--2,403,656
--			ON cm.lenderdatabaseid = cm.lenderdatabaseid
--				AND cm.customerrecordid = cg.customerrecordid

--		JOIN dbo.loan_channelcontacts lcc WITH (NOLOCK)	--13,249,528
--			ON lcc.lenderdatabaseid = lm.lenderdatabaseid
--				AND lcc.loanrecordid = lm.loanrecordid
--				AND lcc.contactcategoryid = 8 --loan officer

--		JOIN dbo.rolodex_contacts rc WITH (NOLOCK)	--174,695
--			ON rc.lenderdatabaseid = lcc.lenderdatabaseid
--				AND rc.entityid = lcc.entityid
--				AND rc.contactlenderdatabaseid = lcc.contactlenderdatabaseid
--				AND rc.contactid = lcc.contactid

--SET STATISTICS IO OFF
--SET STATISTICS TIME OFF




--pp. 21
--SET STATISTICS IO ON
--SET STATISTICS TIME ON

----De-optimized:
--	SELECT lcd.debtid
--         , cd.name
--         , cd.numberofpayments
--         , lcd.exclusionreason
--         , cd.debttype
--         , lcd.includepayment
--         , lcd.includebalance
--         , cd.balance
--         , cd.payment
--         , cd.lienposition
--         , lcd.payoffrequired
--	FROM loan_customerdebt lcd

--		JOIN loan_main lm
--			ON lm.loanrecordid = lcd.loanrecordid

--		JOIN customer_debt cd
--			ON cd.debtid = lcd.debtid
--				AND cd.debtldid = lcd.debtldid

--	WHERE lcd.loanrecordid = 21493577



----Optimized:
--	SELECT lcd.debtid
--         , cd.name
--         , cd.numberofpayments
--         , lcd.exclusionreason
--         , cd.debttype
--         , lcd.includepayment
--         , lcd.includebalance
--         , cd.balance
--         , cd.payment
--         , cd.lienposition
--         , lcd.payoffrequired
--	FROM loan_customerdebt lcd

--		JOIN loan_main lm	--1,497,470
--			ON lm.lenderdatabaseid = lcd.lenderdatabaseid
--				AND lm.loanrecordid = lcd.loanrecordid
--				AND lm.loanrecordid = 21493577

--		JOIN customer_debt cd	--7,675,718
--			ON cd.debtldid = lcd.debtldid
--				AND cd.debtid = lcd.debtid

--	--WHERE lcd.loanrecordid = 21493577


--SET STATISTICS IO OFF
--SET STATISTICS TIME OFF




--pp. 22
--SET STATISTICS IO ON
--SET STATISTICS TIME ON

----De-optimized:
--	SELECT lm.lenderdatabaseid AS LenderDatabaseID
--         , lm.loanrecordid AS LoanRecordID
--         , lm.loanid AS LoanNumber
--         , clm.ContactEmailAddress
--	FROM dbo.loan_main lm
	
--		JOIN dbo.custom_loanmain clm
--			ON clm.loanrecordid = lm.loanrecordid
--				AND clm.lenderdatabaseid = lm.lenderdatabaseid

--	WHERE lm.loanrecordid = 21475838



----Optimized:
--	SELECT lm.lenderdatabaseid AS LenderDatabaseID
--         , lm.loanrecordid AS LoanRecordID
--         , lm.loanid AS LoanNumber
--         , clm.ContactEmailAddress
--	FROM dbo.loan_main lm	--1,497,470
	
--		JOIN dbo.custom_loanmain clm	--1,487,309
--			ON clm.lenderdatabaseid = lm.lenderdatabaseid
--				AND clm.loanrecordid = lm.loanrecordid
--				AND clm.loanrecordid = 21475838

--	--WHERE lm.loanrecordid = 21475838

--SET STATISTICS IO OFF
--SET STATISTICS TIME OFF




--pp. 23
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

--de-optimized
	SELECT lm.lenderdatabaseid
	      ,lm.loanrecordid
	      ,lm.loanid
	      ,lpc.dispositiondate
	      ,sls.statusdescription
	      ,p.productdescription

	FROM dbo.loan_main AS lm WITH (NOLOCK)

		JOIN dbo.loan_postclosing AS lpc WITH (NOLOCK)
			ON lpc.loanrecordid = lm.loanrecordid
				AND lpc.disposition = 1

		JOIN dbo.property_main AS pm WITH (NOLOCK)
			ON pm.propertyrecordid = lm.propertyrecordid
				AND pm.state = 'ND'

		JOIN dbo.loan_huditem AS lhi WITH (NOLOCK)
			ON lhi.loanrecordid = lm.loanrecordid
				AND lhi.lenderdatabaseid = lm.lenderdatabaseid
				AND lhi.currenthudnumber IN ( 804, 805 )

		JOIN dbo.setups_loanstatus sls WITH (NOLOCK)
			ON sls.statusid = lm.statusid

		JOIN dbo.product_main p WITH (NOLOCK)
			ON p.productid = lm.productid;



--Optimized
	SELECT lm.lenderdatabaseid
	      ,lm.loanrecordid
	      ,lm.loanid
	      ,lpc.dispositiondate
	      ,sls.statusdescription
	      ,p.productdescription

	FROM dbo.loan_main AS lm WITH (NOLOCK)

		JOIN dbo.setups_loanstatus sls WITH (NOLOCK)	--60
			ON sls.statusid = lm.statusid

		JOIN dbo.product_main p WITH (NOLOCK)	--521
			ON p.productid = lm.productid

		JOIN dbo.loan_postclosing AS lpc WITH (NOLOCK)	--1,551,858
			ON lpc.lenderdatabaseid = lm.lenderdatabaseid
				AND lpc.loanrecordid = lm.loanrecordid
				AND lpc.disposition = 1

		JOIN dbo.property_main AS pm WITH (NOLOCK)	--1,560,831
			ON pm.lenderdatabaseid = lm.lenderdatabaseid
				AND pm.propertyrecordid = lm.propertyrecordid
				AND pm.state = 'ND'

		JOIN dbo.loan_huditem AS lhi WITH (NOLOCK)	--17,545,660
			ON lhi.lenderdatabaseid = lm.lenderdatabaseid
				AND lhi.loanrecordid = lm.loanrecordid
				AND lhi.currenthudnumber IN ( 804, 805 )

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
