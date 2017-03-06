

drop table OutputHospital
go


/****** Object:  Table [dbo].OutputHospital    Script Date: 11/24/2011 17:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].OutputHospital(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LinkChartCode] [varchar](50) NULL,
	[LinkSeriesCode] [varchar](50) NULL,
	[Series] [varchar](100) NULL,
	[SeriesIdx] [int] NOT NULL,
	[Category] [varchar](50) NULL,
	[Product] [varchar](50) NULL,
	[Lev] [varchar](50) NULL,
	[ParentGeo] [varchar](50) NULL,
	[Geo] [varchar](50) NULL,
	[Currency] [varchar](50) NULL,
	[TimeFrame] [varchar](50) NULL,
	[X] [varchar](50) NULL,
	[XIdx] [int] NOT NULL,
	[Y] [varchar](50) NULL,
	[LinkedY] [varchar](200) NULL,
	[Size] [varchar](max) NULL,
	[OtherParameters] [varchar](1000) NULL,
	[Color] [varchar](10) NULL,
	[R] [bigint] NULL,
	[G] [bigint] NULL,
	[B] [bigint] NULL,
	[IsShow] [char](1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

alter table OutputRx drop column AddY
alter table OutputHospital add AddY float
go

alter table OutputRx add AddY float
go
