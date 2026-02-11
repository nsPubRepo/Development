

IF (SELECT COUNT(*) FROM sys.objects WHERE [Name] = 'ufns_IsStringAlpha' AND [type_desc] = 'SQL_SCALAR_FUNCTION' AND [type] = 'FN') > 0
   DROP FUNCTION [DWReporting_DocHub].[ufns_IsStringAlpha];
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [DWReporting_DocHub].[ufns_IsStringAlpha] (@InputValue [VARCHAR](500) = NULL) RETURNS BIT
AS 
 BEGIN
	--/*************************************************************************************************************************************************************
	---------------------------------------------------------------------------------------------
	--  Name				:	[DWReporting_DocHub].[ufns_IsStringAlpha]
	--
	--  Developer			:	NStuart
	--
	--  Date Created		:   12/20/2024
	--
	--  Purpose				:   This function determines if there are any non-alpha characters passed in (via @InputValue) and returns '1' or '0' based on non-alpha presence ('1' = all alpha / '0' = non-alpha)
	--		    
	--	Business Unit		:	DocsAI
	--
	--	RDL					:	
	---------------------------------------------------------------------------------------------
	--                      M O D I F I C A T I O N     L O G
	---------------------------------------------------------------------------------------------
	-- NAME			    DATE			      COMMENTS
	---------------------------------------------------------------------------------------------
	-- NStuart          12/20/2024		      Function creation
	--*************************************************************************************************************************************************************/
	--DECLARE @OriginalString NVARCHAR(500) = REPLACE(TRIM(COALESCE(@InputValue, '')), ' ', '')	--set @OriginalValue to be the lower-case version of the @InputValue argument but with spaces REMOVED (because of the first WHILE loop below)
	DECLARE @OriginalString NVARCHAR(500) = TRIM(COALESCE(@InputValue, ''))
	DECLARE @ReturnValue BIT = 1	--default to '1' which means we're presuming the string passed into this function IS all alpha characters
          , @LoopIndex INT = 1
          , @LoopCeiling INT = LEN(@OriginalString)
          , @ASCIIValue INT = 0


	--Loop through the the entire @OriginalString 
		WHILE (@LoopIndex <= @LoopCeiling)
			BEGIN
				SET @ASCIIValue = ASCII(SUBSTRING(@OriginalString, @LoopIndex, 1))	--get the first character (if there is one) in the @OriginalString variable and convert that to an ASCII value

				IF (@ASCIIValue NOT BETWEEN '65' AND '90')
					AND (@ASCIIValue NOT BETWEEN '97' AND '122')
					AND (@ASCIIValue <> 32)
						BEGIN
							SET @ReturnValue = 0	--charater in question was NOT found to be an alpha character therefore set return value to be '0'
							BREAK	--bail out of the outter WHILE loop 'cause there's no need to go any further with regard to investigating if any other characters are non-alphas
						END	--IF (@ASCIIValue NOT BETWEEN '' AND '')...

				SET @LoopIndex = @LoopIndex + 1	--increment @LoopIndex 
			END	--WHILE (@LoopIndex <= @LoopCeiling)


		--*beep, beep, beep* the UPS / FedEx / Amazon truck is backing up to ship out the return value
			RETURN @ReturnValue

END	--CREATE FUNCTION [DWReporting_DocHub].[ufns_IsStringAlpha] (@InputValue [VARCHAR](500) = NULL) RETURNS BIT

/*select DWReporting_DocHub.ufns_IsStringAlpha('Hi!')
         , DWReporting_DocHub.ufns_IsStringAlpha('Hiasdajaajeiermcfkle')
	
*/


/*
	Dec 	Hex 	Oct 	Html 	Char
	---		---		---		----	----
	0 		0 		000 	N/A		NUL
	1 		1 		001 	N/A		SOH
	2 		2 		002 	N/A		STX
	3 		3 		003 	N/A		ETX
	4 		4 		004 	N/A		EOT
	5 		5 		005 	N/A		ENQ
	6 		6 		006 	N/A		ACK
	7 		7 		007 	N/A		BEL
	8 		8 		010 	N/A		BS
	9 		9 		011 	N/A		TAB
	10 		A 		012 	N/A		LF
	11 		B 		013 	N/A		VT
	12 		C 		014 	N/A		FF
	13 		D 		015 	N/A		CR
	14 		E 		016 	N/A		SO
	15 		F 		017 	N/A		SI
	16 		10 		020 	N/A		DLE
	17 		11 		021 	N/A		DC1
	18 		12 		022 	N/A		DC2
	19 		13 		023 	N/A		DC3
	20 		14 		024 	N/A		DC4
	21 		15 		025 	N/A		NAK
	22 		16 		026 	N/A		SYN
	23 		17 		027 	N/A		ETB
	24 		18 		030 	N/A		CAN
	25 		19 		031 	N/A		EM
	26 		1A 		032 	N/A		SUB
	27 		1B 		033 	N/A		ESC
	28 		1C 		034 	N/A		FS
	29 		1D 		035 	N/A		GS
	30 		1E 		036 	N/A		RS
	31 		1F 		037 	N/A		US
	32 		20 		040 	&#32; 	Space
	33 		21 		041 	&#33; 	!
	34 		22 		042 	&#34; 	\"
	35 		23 		043 	&#35; 	#
	36 		24 		044 	&#36; 	$
	37 		25 		045 	&#37; 	%
	38 		26 		046 	&#38; 	&
	39 		27 		047 	&#39; 	'
	40 		28 		050 	&#40; 	(
	41 		29 		051 	&#41; 	)
	42 		2A 		052 	&#42; 	*
	43 		2B 		053 	&#43; 	+
	44 		2C 		054 	&#44; 	,
	45 		2D 		055 	&#45; 	-
	46 		2E 		056 	&#46; 	.
	47 		2F 		057 	&#47; 	/
	48 		30 		060 	&#48; 	0
	49 		31 		061 	&#49; 	1
	50 		32 		062 	&#50; 	2
	51 		33 		063 	&#51; 	3
	52 		34 		064 	&#52; 	4
	53 		35 		065 	&#53; 	5
	54 		36 		066 	&#54; 	6
	55 		37 		067 	&#55; 	7
	56 		38 		070 	&#56; 	8
	57 		39 		071 	&#57; 	9
	58 		3A 		072 	&#58; 	:
	59 		3B 		073 	&#59; 	;
	60 		3C 		074 	&#60; 	<
	61 		3D 		075 	&#61; 	=
	62 		3E 		076 	&#62; 	>
	63 		3F 		077 	&#63; 	?
	64 		40 		100 	&#64; 	@
	65 		41 		101 	&#65; 	A
	66 		42 		102 	&#66; 	B
	67 		43 		103 	&#67; 	C
	68 		44 		104 	&#68; 	D
	69 		45 		105 	&#69; 	E
	70 		46 		106 	&#70; 	F
	71 		47 		107 	&#71; 	G
	72 		48 		110 	&#72; 	H
	73 		49 		111 	&#73; 	I
	74 		4A 		112 	&#74; 	J
	75 		4B 		113 	&#75; 	K
	76 		4C 		114 	&#76; 	L
	77 		4D 		115 	&#77; 	M
	78 		4E 		116 	&#78; 	N
	79 		4F 		117 	&#79; 	O
	80 		50 		120 	&#80; 	P
	81 		51 		121 	&#81; 	Q
	82 		52 		122 	&#82; 	R
	83 		53 		123 	&#83; 	S
	84 		54 		124 	&#84; 	T
	85 		55 		125 	&#85; 	U
	86 		56 		126 	&#86; 	V
	87 		57 		127 	&#87; 	W
	88 		58 		130 	&#88; 	X
	89 		59 		131 	&#89; 	Y
	90 		5A 		132 	&#90; 	Z
	91 		5B 		133 	&#91; 	[
	92 		5C 		134 	&#92; 	\
	93 		5D 		135 	&#93; 	]
	94 		5E 		136 	&#94; 	^
	95 		5F 		137 	&#95; 	_
	96 		60 		140 	&#96; 	`
	97 		61 		141 	&#97; 	a
	98 		62 		142 	&#98; 	b
	99 		63 		143 	&#99; 	c
	100 	64 		144 	&#100; 	d
	101 	65 		145 	&#101; 	e
	102 	66 		146 	&#102; 	f
	103 	67 		147 	&#103; 	g
	104 	68 		150 	&#104; 	h
	105 	69 		151 	&#105; 	i
	106 	6A 		152 	&#106; 	j
	107 	6B 		153 	&#107; 	k
	108 	6C 		154 	&#108; 	l
	109 	6D 		155 	&#109; 	m
	110 	6E 		156 	&#110; 	n
	111 	6F 		157 	&#111; 	o
	112 	70 		160 	&#112; 	p
	113 	71 		161 	&#113; 	q
	114 	72 		162 	&#114; 	r
	115 	73 		163 	&#115; 	s
	116 	74 		164 	&#116; 	t
	117 	75 		165 	&#117; 	u
	118 	76 		166 	&#118; 	v
	119 	77 		167 	&#119; 	w
	120 	78 		170 	&#120; 	x
	121 	79 		171 	&#121; 	y
	122 	7A 		172 	&#122; 	z
	123 	7B 		173 	&#123; 	{
	124 	7C 		174 	&#124; 	|
	125 	7D 		175 	&#125; 	}
	126 	7E 		176 	&#126; 	~
	127 	7F 		177 	&#127; 	DEL
*/