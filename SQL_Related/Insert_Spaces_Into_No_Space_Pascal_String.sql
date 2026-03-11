


--DECLARE @String AS VARCHAR(100) = 'AreAllContractAddendaPresent'
DECLARE @String AS VARCHAR(100) = 'WallaWallaDingDong'
DECLARE @Index AS INT = 1
      , @Length AS INT = LEN(@String)
      , @Output AS VARCHAR(200) = ''



WHILE (@Index <= @Length)
	BEGIN

		SET @Output = CONCAT(@Output, SUBSTRING(@String, @Index, 1))	--grab the next character in @String, regardless if it's upper or lower, and concat it to @Output

			--determine if, at a given starting location within @String, the next character is a upper or lower case letter (if next applicable letter is upper, insert space before concatenating the next, upper, letter)
				IF ASCII(SUBSTRING(@String, @Index, 1)) BETWEEN 97 AND 122				--lower / if we're currently sitting on a lower case letter...
					AND ASCII(SUBSTRING(@String, @Index + 1)) BETWEEN 65 AND 90			--upper / ... and the next letter is an upper case...
						BEGIN
							SET @Output = CONCAT(@Output, ' ')	--... then concat a space after the lower case letter before concatenating the next (upper case) letter
						END

		SET @Index = @Index + 1		--gotta do this so we don't end up in an infinate loop
	END		--WHILE (@Index <= @Length)



SELECT @Output