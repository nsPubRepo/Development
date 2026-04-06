

--PRINT RAND()	--random float value that's < 1
--PRINT NEWID()	--random GUID / 32 characters long not counting dashes
--PRINT REPLACE(NEWID(), '-', '')	--random GUID with dashes removed
--PRINT LEFT(REPLACE(NEWID(), '-', ''), 10)	--first 10 digits of random GUID with dashes removed
--PRINT CAST((128 - 48 ) * RAND() + 48  AS INTEGER)	--returns random integer within the set [48, 127] (this range is of usable alpha-numeric ASCII characters)
--PRINT CHAR(CAST((128 - 48) * RAND() + 48 AS INTEGER))	--returns random alpha-numeric character who's ASCII value is within the set [48, 127]
--PRINT LEN(ABS(CHECKSUM(NEWID())))	--returns random integer between 9 and 10 values long
--PRINT CHAR(48 + ABS(CHECKSUM(NEWID())) % 80)	--returns random alpha-numeric character who's ASCII value is within the set [48, 127]
--PRINT CRYPT_GEN_RANDOM(1)	--returns random HEX value who's length is specified via the argument -- NOTE that this argument is HOW MANY BYTES LONG to generate HEX value







--https://learn.microsoft.com/en-us/sql/t-sql/functions/rand-transact-sql?view=sql-server-ver17




--Randomly generate 0 or 1
	SELECT ROUND(RAND(), 0) AS ZeroOrOne_01
         , ROUND(RAND(), 0) AS ZeroOrOne_02
         , ROUND(RAND(), 0) AS ZeroOrOne_03
         , ROUND(RAND(), 0) AS ZeroOrOne_04



--Generate random numbers greater than 1
	DECLARE @Constant AS INT;
	SET @Constant = 10;

	SELECT @Constant * RAND() AS RandomNumber;






--Generate random integers
		DECLARE @Constant AS INT;
		SET @Constant = 10;

		SELECT ROUND(@Constant * RAND(), 0) AS FirstRandomInteger,
			   FLOOR(@Constant * RAND()) AS SecondRandomInteger,
			   CEILING(@Constant * RAND()) AS ThirdRandomInteger





--Insert random values into a table
	DECLARE @RandomTable TABLE
		(
			RandomIntegers INT,
			RandomFloats FLOAT,
			RandomBits BIT
		);

	DECLARE @RowCount AS INT;
	DECLARE @Counter AS INT;

	SET @RowCount = 10;
	SET @Counter = 1;

	WHILE @Counter <= @RowCount
		BEGIN
			INSERT INTO @RandomTable
			VALUES (ROUND(10 * RAND(), 0), RAND(), CAST (ROUND(RAND(), 0) AS BIT));
			SET @Counter = @Counter + 1;
		END

	SELECT *
	FROM @RandomTable;
