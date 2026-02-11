

DECLARE @first VARCHAR(100) = 'LOMBARDOS ENTERPRISES LLC'
      , @second VARCHAR(100) = 'Lombardos Enterprises  LLC'
      , @third VARCHAR(100) = 'ABC'
      , @forth VARCHAR(100) = 'abc'



SELECT CASE
			WHEN @first = @second
				THEN '@first = @second'

			WHEN @third COLLATE SQL_Latin1_General_CP1_CI_AS = @forth COLLATE SQL_Latin1_General_CP1_CI_AS
				THEN '@third = @forth'

			ELSE
				'Everyone''s Different!'
       END


/*
	SQL_Latin1_General_CP1_CI_AS = the "CI" means "Case Insensitive"
	SQL_Latin1_General_CP1_CS_AS = the "CS" means "Case Sensitive"
*/