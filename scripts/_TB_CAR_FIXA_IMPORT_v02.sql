--set identity_insert [DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_MOVEL] off

truncate table [DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_FIXA]

select * from [DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_FIXA]

BULK INSERT [DB_SISCOB].[FILE_CAR].[TB_TRATAMENTO_FIXA]
FROM '\\172.16.0.6\e\sftp_files\FTP_User\SISCOB\_RELATORIOS\TB_TRATAMENTO_FIXA_WEB\TB_TRATAMENTO_FIXA_WEB.TXT'
WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)



truncate table [DB_SISCOB].[FILE_CAR].[TB_CAR_FIXA_IMPORT]


BULK INSERT [DB_SISCOB].[FILE_CAR].[TB_CAR_FIXA_IMPORT]
FROM '\\172.16.0.6\e\sftp_files\FTP_User\SISCOB\_RELATORIOS\TB_CAR_FIXA_IMPORT_WEB\TB_CAR_FIXA_IMPORT_WEB.TXT'
WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

truncate table [DB_SISCOB].[FILE_CAR].[TB_CAR_MOVEL_IMPORT]


BULK INSERT [DB_SISCOB].[FILE_CAR].[TB_CAR_MOVEL_IMPORT]
FROM '\\172.16.0.6\e\sftp_files\FTP_User\SISCOB\_RELATORIOS\TB_CAR_MOVEL_IMPORT_WEB\TB_CAR_MOVEL_IMPORT_WEB.TXT'
WITH
(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)