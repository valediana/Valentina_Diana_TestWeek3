create database Pizzeria;

create table Pizza(
IdPizza int not null identity(1,1),
CodicePizza char(5) not null,
Nome nvarchar(50) not null,
Prezzo decimal not null ,
constraint CK_Prezzo check(Prezzo>0),
constraint PK_Pizza primary key(IdPizza)
);

alter table Pizza alter column Prezzo decimal(5,2);

create table Ingrediente(
IdIngrediente int not null identity(1,1),
CodiceIngrediente char(5) not null,
Nome varchar(30) not null,
Costo decimal not null ,
ScorteMagazzino int not null,
constraint CK_Costo check(Costo>0),
constraint CK_Scorte check(ScorteMagazzino>=0),
constraint PK_Ingrediente primary key(IdIngrediente)
);

create table PizzaIngrediente(
IdPizza int not null Constraint FK_Pizza foreign key references Pizza(IdPizza),
IdIngrediente int not null Constraint FK_Ingrediente foreign key references Ingrediente(IdIngrediente),
QuantitaIngrediente int constraint check_qnt_positiva check (QuantitaIngrediente>=0)
constraint UNQ_Pizza_INGREDIENTE unique (IdPizza, IdIngrediente)
);

--inserimento dati
insert into Pizza values('MRG01','Margherita', 5);
insert into Pizza values('BFL01','Bufala', 7);
insert into Pizza values('DVL01','Diavola', 6);
insert into Pizza values('QTS01','Quattro stagioni', 6.5);
insert into Pizza values('PRC01','Porcini', 7);

insert into Pizza values('DNS01','Dioniso', 8);
insert into Pizza values('ORT01','Ortolana', 8);
insert into Pizza values('PTS01','Patate e salsiccia', 6);
insert into Pizza values('POM01','Pomodorini', 6);
insert into Pizza values('QTF01','Quattro formaggi', 7.5);
insert into Pizza values('CAP01','Caprese', 7.5);
insert into Pizza values('ZEU01','Zeus', 7.5);

insert into Ingrediente values('SALSA','Salsa di pomodoro', 1,100);
insert into Ingrediente values('MOZZ1','Mozzarella', 3,50);
insert into Ingrediente values('BUF00','Mozzarella di bufala', 5,50);
insert into Ingrediente values('FUNCH','Funghi champignon', 6,20);
insert into Ingrediente values('FUNPO','Funghi porcini', 8,10);
insert into Ingrediente values('CARC1','Carciofi', 3,10);
insert into Ingrediente values('COTTO','Prosciutto cotto', 5,1);
insert into Ingrediente values('BRESA','Bresaola', 6,1);

insert into PizzaIngrediente values(1,1,1);
insert into PizzaIngrediente values(1,2,1);
insert into PizzaIngrediente values(2,1,1);
insert into PizzaIngrediente values(2,3,1);
insert into PizzaIngrediente values(4,1,1);
insert into PizzaIngrediente values(4,2,1);
insert into PizzaIngrediente values(4,4,1);

insert into PizzaIngrediente values(5,1,1);
insert into PizzaIngrediente values(5,2,1);
insert into PizzaIngrediente values(5,5,1);

insert into PizzaIngrediente values(8,2,1);
insert into PizzaIngrediente values(8,9,1);
insert into PizzaIngrediente values(8,10,1);
insert into PizzaIngrediente values(9,12,1);
insert into PizzaIngrediente values(9,2,1);
insert into PizzaIngrediente values(11,12,1);
select * from Pizza;
select * from Ingrediente;

--queries

--1. Estrarre tutte le pizze con prezzo superiore a 6 euro.
select p.*
from Pizza p
where p.Prezzo>6;
--2. Estrarre la pizza/le pizze più costosa/e.
select max(Prezzo) as [Prezzo Maggiore]
from Pizza;
--3. Estrarre le pizze «bianche»
select distinct p.Nome
from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
where  p.Nome not in(select p.Nome
                 from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
where i.Nome='Salsa di pomodoro');

--4. Estrarre le pizze che contengono funghi (di qualsiasi tipo)
select p.*
from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
where i.Nome LIKE '%Funghi%';

--procedures
--1. Inserimento di una nuova pizza (parametri: nome, prezzo) 
create procedure InserisciPizza
@codicePizza char(5),
@nomePizza varchar(50),
@prezzoPizza decimal

as
insert into Pizza values(@codicePizza, @nomePizza, @prezzoPizza)
go
execute InserisciPizza 'MOR02', 'Mortadella e pistacchio', 12;

select * from Pizza;

--2. Assegnazione di un ingrediente a una pizza (parametri: nome pizza, nome 
--ingrediente) 
create procedure AssegnaIngrediente
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
go
execute AssegnaIngrediente 'Mortadella e pistacchio','mozzarella',2;

select *
from PizzaIngrediente;



--3. Aggiornamento del prezzo di una pizza (parametri: nome pizza e nuovo prezzo)
create procedure AggiornaPrezzo
@nomePizza varchar(50),
@nuovoPrezzo decimal
as
update Pizza set Pizza.Prezzo=@nuovoPrezzo where Pizza.Nome=@nomePizza
go
execute AggiornaPrezzo 'Mortadella e pistacchio', 20;

--4. Eliminazione di un ingrediente da una pizza (parametri: nome pizza, nome 
--ingrediente) 
create procedure EliminaIngrediente
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
go

execute EliminaIngrediente 'Mortadella e pistacchio', 'mozzarella';



--5. Incremento del 10% del prezzo delle pizze contenenti un ingrediente DA FINIRE
--(parametro: nome ingrediente)
--Questa procedura non fa ciò che dovrebbe
create procedure AumentaPrezzo
@nomeIngrediente varchar(30)
as
declare @nomePizza varchar(50)
--declare @nuovoPrezzo decimal


update Pizza set Prezzo=(Prezzo+((Prezzo*10)/100)) where (@nomePizza in (select p.Nome 
from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
where i.Nome=@nomeIngrediente))
go

--lancio procedura
execute AumentaPrezzo 'Mozzarella di bufala';

select * from Pizza


--funzioni
--1. Tabella listino pizze (nome, prezzo) (parametri: nessuno)
create function ListinoPizze ()
returns table
as
return 
Select p.Nome, p.Prezzo
from Pizza p


--richiamare una funzione table
select pdl.Nome, pdl.Prezzo from dbo.Pizza as pdl;

--2. Tabella listino pizze (nome, prezzo) contenenti un ingrediente (parametri: nome
--ingrediente)
create function ListinoPizzeIngrediente (@nomeIngrediente varchar(30))
returns table
as
return 

Select p.Nome, p.Prezzo
from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=piz.IdIngrediente
where i.Nome=@nomeIngrediente


--richiamare una funzione table
select pdi.Nome, pdi.Prezzo from dbo.ListinoPizzeIngrediente('mozzarella') as pdi;

--3. Tabella listino pizze (nome, prezzo) che non contengono un certo ingrediente
--(parametri: nome ingrediente)
--dovrebbe restituire nome e prezzo ma restituisce solo nome
create function ListinoPizzeIngredienteMancante (@nomeIngrediente varchar(30))
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

--richiamo funzione table
select lpm.Nome from dbo.ListinoPizzeIngredienteMancante('Salsa di pomodoro') as lpm;

--4. Calcolo numero pizze contenenti un ingrediente (parametri: nome ingrediente)
create function NumeroPizzeIngrediente (@nomeIngrediente varchar(30))
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

--richiamo funzione
select dbo.NumeroPizzeIngrediente ('Salsa di pomodoro') as [Numero Pizze];

--5. Calcolo numero pizze che non contengono un ingrediente (parametri: codice
--ingrediente)
create function NumeroPizzeIngrMancante (@IdIngrediente int)
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
--chiamo funzione
select dbo.NumeroPizzeIngrMancante (1) as [Numero Pizze];

--6. Calcolo numero ingredienti contenuti in una pizza (parametri: nome pizza)
create function NumeroIngredientiPizza (@nomePizza varchar(50))
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

--richiamare la funzione
select dbo.NumeroIngredientiPizza ('Margherita') as [Numero Ingredienti];

--view
--Realizzare una view che rappresenta il menù con tutte le pizze.

create view RiepologoMenu as
(select p.Nome as Nome, p.Prezzo as Prezzo, i.Nome as Ingredienti
from Pizza p join PizzaIngrediente piz on piz.IdPizza=p.IdPizza
     join Ingrediente i on i.IdIngrediente=piz.IdIngrediente )

select * from RiepologoMenu;