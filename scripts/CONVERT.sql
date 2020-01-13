
SELECT CONVERT(VARCHAR(10),GETDATE(),12)+'_'+replace(Convert(varchar(5), GetDate(), 108),':','') -- 161206_0834

SELECT CONVERT(VARCHAR(50),GETDATE(),106) -- 06 Dec 2016
SELECT CONVERT(VARCHAR(10),GETDATE(),12) -- 161206
SELECT CONVERT(VARCHAR(10),GETDATE(),20) -- 2016-12-06

SELECT replace(Convert(varchar(5), GetDate(), 108),':','') -- 0830


SELECT LEFT(CONVERT(VARCHAR,GetDate(),108),5) -- 08:30

DECLARE @yourdate DATETIME = GETDATE()   ; 
SELECT CONVERT(datetime, CONVERT(varchar, @yourdate, 13)) -- 2016-12-06 08:27:33.260
SELECT CONVERT(DATE, @yourdate) -- 2016-12-06



PRINT '1) Date/time in format MON DD YYYY HH:MI AM (OR PM): ' + CONVERT(CHAR(19),GETDATE())  
PRINT '2) Date/time in format MM-DD-YY: ' + CONVERT(CHAR(8),GETDATE(),10)  
PRINT '3) Date/time in format MM-DD-YYYY: ' + CONVERT(CHAR(10),GETDATE(),110) 
PRINT '4) Date/time in format DD MON YYYY: ' + CONVERT(CHAR(11),GETDATE(),106)
PRINT '5) Date/time in format DD MON YY: ' + CONVERT(CHAR(9),GETDATE(),6) 
PRINT '6) Date/time in format DD MON YYYY HH:MM:SS:MMM(24H): ' + CONVERT(CHAR(24),GETDATE(),113)


SELECT CONVERT(VARCHAR(10),CONVERT(DATE,GETDATE(),106),103) -- 06/12/2016