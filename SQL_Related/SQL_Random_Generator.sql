

--PRINT RAND()	--random float value that's < 1
--PRINT NEWID()	--random GUID / 32 characters long not counting dashes
--PRINT REPLACE(NEWID(), '-', '')	--random GUID with dashes removed
--PRINT LEFT(REPLACE(NEWID(), '-', ''), 10)	--first 10 digits of random GUID with dashes removed
--PRINT CAST((128 - 48 ) * RAND() + 48  AS INTEGER)	--returns random integer within the set [48, 127] (this range is of usable alpha-numeric ASCII characters)
--PRINT CHAR(CAST((128 - 48) * RAND() + 48 AS INTEGER))	--returns random alpha-numeric character who's ASCII value is within the set [48, 127]
--PRINT LEN(ABS(CHECKSUM(NEWID())))	--returns random integer between 9 and 10 values long
--PRINT CHAR(48 + ABS(CHECKSUM(NEWID())) % 80)	--returns random alpha-numeric character who's ASCII value is within the set [48, 127]
--PRINT CRYPT_GEN_RANDOM(1)	--returns random HEX value who's length is specified via the argument -- NOTE that this argument is HOW MANY BYTES LONG to generate HEX value

