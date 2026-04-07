

SELECT msg.*
FROM sys.messages AS msg
WHERE msg.message_id = (SELECT MAX(message_id) FROM sys.messages WHERE language_id = 1033)		--1033 = English
	AND msg.language_id = 1033		--1033 = English