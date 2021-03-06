USE [master]
GO
/****** Object:  Database [Pizzeria]    Script Date: 17/12/2021 15:14:18 ******/
CREATE DATABASE [Pizzeria]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Pizzeria', FILENAME = N'C:\Users\valentina.diana\Pizzeria.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Pizzeria_log', FILENAME = N'C:\Users\valentina.diana\Pizzeria_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Pizzeria] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Pizzeria].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Pizzeria] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Pizzeria] SET ARITHABORT OFF 
GO
ALTER DATABASE [Pizzeria] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Pizzeria] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Pizzeria] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Pizzeria] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Pizzeria] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Pizzeria] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Pizzeria] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Pizzeria] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Pizzeria] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Pizzeria] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Pizzeria] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Pizzeria] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Pizzeria] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Pizzeria] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Pizzeria] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Pizzeria] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Pizzeria] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Pizzeria] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Pizzeria] SET  MULTI_USER 
GO
ALTER DATABASE [Pizzeria] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Pizzeria] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Pizzeria] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Pizzeria] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Pizzeria] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Pizzeria] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Pizzeria] SET QUERY_STORE = OFF
GO
USE [Pizzeria]
GO
/****** Object:  UserDefinedFunction [dbo].[NumeroIngredientiPizza]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NumeroIngredientiPizza] (@nomePizza varchar(50))
returns int
as
Begin

    declare @numeroIngredienti int

	select @numeroIngredienti=count(i.Nome)
	     from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
	     join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
	     where p.Nome=@nomePizza

return @numeroIngredienti
end
GO
/****** Object:  UserDefinedFunction [dbo].[NumeroPizzeIngrediente]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NumeroPizzeIngrediente] (@nomeIngrediente varchar(30))
returns int
as
Begin

    declare @numeroPizze int

	select @numeroPizze=count(p.Nome)
	     from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
	     join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
	     where i.Nome=@nomeIngrediente

return @numeroPizze
end
GO
/****** Object:  UserDefinedFunction [dbo].[NumeroPizzeIngrMancante]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NumeroPizzeIngrMancante] (@IdIngrediente int)
returns int
as
Begin

    declare @numeroPizze int

	select @numeroPizze=count(p.Nome)
	     from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
	     join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
	     where  p.Nome not in(select p.Nome
                 from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
	             join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
	             where i.IdIngrediente=@IdIngrediente)


return @numeroPizze
end
GO
/****** Object:  Table [dbo].[Pizza]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pizza](
	[IdPizza] [int] IDENTITY(1,1) NOT NULL,
	[CodicePizza] [char](5) NOT NULL,
	[Nome] [nvarchar](50) NOT NULL,
	[Prezzo] [decimal](5, 2) NULL,
 CONSTRAINT [PK_Pizza] PRIMARY KEY CLUSTERED 
(
	[IdPizza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizze]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizze] ()
returns table
as
return 
Select p.Nome, p.Prezzo
from Pizza p
GO
/****** Object:  Table [dbo].[Ingrediente]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingrediente](
	[IdIngrediente] [int] IDENTITY(1,1) NOT NULL,
	[CodiceIngrediente] [char](5) NOT NULL,
	[Nome] [varchar](30) NOT NULL,
	[Costo] [decimal](18, 0) NOT NULL,
	[ScorteMagazzino] [int] NOT NULL,
 CONSTRAINT [PK_Ingrediente] PRIMARY KEY CLUSTERED 
(
	[IdIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PizzaIngrediente]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PizzaIngrediente](
	[IdPizza] [int] NOT NULL,
	[IdIngrediente] [int] NOT NULL,
	[QuantitaIngrediente] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeIngrediente]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeIngrediente] (@nomeIngrediente varchar(30))
returns table
as
return 

Select p.Nome, p.Prezzo
from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
where i.Nome=@nomeIngrediente
GO
/****** Object:  View [dbo].[RiepologoMenu]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[RiepologoMenu] as
(select p.Nome as Nome, p.Prezzo as Prezzo, i.Nome as Ingredienti
from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
     join Ingrediente i on i.IdIngrediente=piz.IdIngrediente )
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeIngredienteMancante]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeIngredienteMancante] (@nomeIngrediente varchar(30))
returns table
as
return 

select distinct p.Nome
from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
where  p.Nome not in(select p.Nome
                 from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
where i.Nome=@nomeIngrediente)
GO
SET IDENTITY_INSERT [dbo].[Ingrediente] ON 

INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (1, N'SALSA', N'Salsa di pomodoro', CAST(1 AS Decimal(18, 0)), 100)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (2, N'MOZZ1', N'Mozzarella', CAST(3 AS Decimal(18, 0)), 50)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (3, N'BUF00', N'Mozzarella di bufala', CAST(5 AS Decimal(18, 0)), 50)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (4, N'FUNCH', N'Funghi champignon', CAST(6 AS Decimal(18, 0)), 20)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (5, N'FUNPO', N'Funghi porcini', CAST(8 AS Decimal(18, 0)), 10)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (6, N'CARC1', N'Carciofi', CAST(3 AS Decimal(18, 0)), 10)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (7, N'COTTO', N'Prosciutto cotto', CAST(5 AS Decimal(18, 0)), 1)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (8, N'BRESA', N'Bresaola', CAST(6 AS Decimal(18, 0)), 1)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (9, N'SALSI', N'Salsiccia', CAST(10 AS Decimal(18, 0)), 5)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (10, N'PATA1', N'Patate', CAST(2 AS Decimal(18, 0)), 4)
INSERT [dbo].[Ingrediente] ([IdIngrediente], [CodiceIngrediente], [Nome], [Costo], [ScorteMagazzino]) VALUES (12, N'POM02', N'Pomodorini', CAST(4 AS Decimal(18, 0)), 4)
SET IDENTITY_INSERT [dbo].[Ingrediente] OFF
GO
SET IDENTITY_INSERT [dbo].[Pizza] ON 

INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (1, N'MRG01', N'Margherita', CAST(6.60 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (2, N'BFL01', N'Bufala', CAST(8.80 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (3, N'DVL01', N'Diavola', CAST(7.70 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (4, N'QTS01', N'Quattro stagioni', CAST(7.15 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (5, N'PRC01', N'Porcini', CAST(8.80 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (6, N'DNS01', N'Dioniso', CAST(9.90 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (7, N'ORT01', N'Ortolana', CAST(9.90 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (8, N'PTS01', N'Patate e salsiccia', CAST(7.70 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (9, N'POM01', N'Pomodorini', CAST(7.70 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (10, N'QTF01', N'Quattro formaggi', CAST(8.25 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (11, N'CAP01', N'Caprese', CAST(8.25 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (12, N'ZEU01', N'Zeus', CAST(8.25 AS Decimal(5, 2)))
INSERT [dbo].[Pizza] ([IdPizza], [CodicePizza], [Nome], [Prezzo]) VALUES (13, N'MOR02', N'Mortadella e pistacchio', CAST(24.20 AS Decimal(5, 2)))
SET IDENTITY_INSERT [dbo].[Pizza] OFF
GO
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (1, 1, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (1, 2, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (2, 1, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (2, 3, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (4, 1, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (4, 2, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (4, 4, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (5, 1, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (5, 2, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (5, 5, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (8, 2, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (8, 9, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (8, 10, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (9, 12, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (9, 2, 1)
INSERT [dbo].[PizzaIngrediente] ([IdPizza], [IdIngrediente], [QuantitaIngrediente]) VALUES (11, 12, 1)
GO
/****** Object:  Index [UNQ_Pizza_INGREDIENTE]    Script Date: 17/12/2021 15:14:18 ******/
ALTER TABLE [dbo].[PizzaIngrediente] ADD  CONSTRAINT [UNQ_Pizza_INGREDIENTE] UNIQUE NONCLUSTERED 
(
	[IdPizza] ASC,
	[IdIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PizzaIngrediente]  WITH CHECK ADD  CONSTRAINT [FK_Ingrediente] FOREIGN KEY([IdIngrediente])
REFERENCES [dbo].[Ingrediente] ([IdIngrediente])
GO
ALTER TABLE [dbo].[PizzaIngrediente] CHECK CONSTRAINT [FK_Ingrediente]
GO
ALTER TABLE [dbo].[PizzaIngrediente]  WITH CHECK ADD  CONSTRAINT [FK_Pizza] FOREIGN KEY([IdPizza])
REFERENCES [dbo].[Pizza] ([IdPizza])
GO
ALTER TABLE [dbo].[PizzaIngrediente] CHECK CONSTRAINT [FK_Pizza]
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD  CONSTRAINT [CK_Costo] CHECK  (([Costo]>(0)))
GO
ALTER TABLE [dbo].[Ingrediente] CHECK CONSTRAINT [CK_Costo]
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD  CONSTRAINT [CK_Scorte] CHECK  (([ScorteMagazzino]>=(0)))
GO
ALTER TABLE [dbo].[Ingrediente] CHECK CONSTRAINT [CK_Scorte]
GO
ALTER TABLE [dbo].[Pizza]  WITH CHECK ADD  CONSTRAINT [CK_Prezzo] CHECK  (([Prezzo]>(0)))
GO
ALTER TABLE [dbo].[Pizza] CHECK CONSTRAINT [CK_Prezzo]
GO
ALTER TABLE [dbo].[PizzaIngrediente]  WITH CHECK ADD  CONSTRAINT [check_qnt_positiva] CHECK  (([QuantitaIngrediente]>=(0)))
GO
ALTER TABLE [dbo].[PizzaIngrediente] CHECK CONSTRAINT [check_qnt_positiva]
GO
/****** Object:  StoredProcedure [dbo].[AggiornaPrezzo]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AggiornaPrezzo]
@nomePizza varchar(50),
@nuovoPrezzo decimal
as
update Pizza set Pizza.Prezzo=@nuovoPrezzo where Pizza.Nome=@nomePizza
GO
/****** Object:  StoredProcedure [dbo].[AssegnaIngrediente]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AssegnaIngrediente]
@nomePizza varchar(50),
@nomeIngrediente varchar(30),
@quantita int
as
   declare @ID_INGREDIENTE int
   declare @ID_Pizza int 

	select @ID_INGREDIENTE= i.IdIngrediente
	from Ingrediente i 
	where i.Nome=@nomeIngrediente

	select @ID_Pizza=p.IdPizza
	from Pizza p
	where p.Nome=@nomePizza

	insert into PizzaIngrediente values (@ID_Pizza, @ID_INGREDIENTE, @quantita);
GO
/****** Object:  StoredProcedure [dbo].[AumentaPrezzo]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AumentaPrezzo]
@nomeIngrediente varchar(30)
as
declare @nomePizza varchar(50)
--declare @nuovoPrezzo decimal


update Pizza set Prezzo=(Prezzo+((Prezzo*10)/100)) where (@nomePizza in (select p.Nome 
from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
where i.Nome=@nomeIngrediente))
GO
/****** Object:  StoredProcedure [dbo].[EliminaIngrediente]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[EliminaIngrediente]
@nomePizza varchar(50),
@nomeIngred varchar(30)
as
   declare @ID_INGREDIENTE int
   declare @ID_Pizza int 

	select @ID_INGREDIENTE= i.IdIngrediente
	from Ingrediente i 
	where i.Nome=@nomeIngred

	select @ID_Pizza=p.IdPizza
	from Pizza p
	where p.Nome=@nomePizza

delete from PizzaIngrediente
where (PizzaIngrediente.IdIngrediente=@ID_INGREDIENTE and PizzaIngrediente.IdPizza=@ID_Pizza)
GO
/****** Object:  StoredProcedure [dbo].[InserisciPizza]    Script Date: 17/12/2021 15:14:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciPizza]
@codicePizza char(5),
@nomePizza varchar(50),
@prezzoPizza decimal

as
insert into Pizza values(@codicePizza, @nomePizza, @prezzoPizza)
GO
USE [master]
GO
ALTER DATABASE [Pizzeria] SET  READ_WRITE 
GO
