USE [DB_G_CASH_BBRIL]
GO

/****** Object:  Table [sch_Auxiliar].[Tbl_Empresas]    Script Date: 4/26/2017 4:20:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

--DROP TABLE [sch_Auxiliar].[Tbl_Empresas]

CREATE TABLE [sch_Auxiliar].[Tbl_Empresas](
	--[ID]			INT IDENTITY(1,1) NOT NULL,
	[COD_EMPRESA]	int NOT NULL,
	[NOME_EMPRESA]  varchar(80) NULL,
	[ATIVO]			BIT NOT NULL
PRIMARY KEY CLUSTERED 
(
	[COD_EMPRESA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


SET ANSI_PADDING OFF
GO

