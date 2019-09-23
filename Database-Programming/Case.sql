--Adrián Perera Hernández - 1DAWC
--Procedimientos almacenados

--Case que muestre registros que contengan:
--ACER - Nº
--BROTHER - Nº
--REDSTONE - Nº
--OTROS - Nº

use EmpresasInformaticas;
go

select count(*),
case
	when descripcion like '%ACER%' then 'NºACER'
	when descripcion like '%BROTHER%' then 'NºBROTHER'
	when descripcion like '%KINGSTON%' then 'NºKINGSTON'
	else 'OTROS'
end as productosmarca
from Componente
group by
case
	when descripcion like '%ACER%' then 'NºACER'
	when descripcion like '%BROTHER%' then 'NºBROTHER'
	when descripcion like '%KINGSTON%' then 'NºKINGSTON'
	else 'OTROS'
end
;

--Suma de los precios por marca.
SUM(CASE acer then precio
else 0
end)

--Concatenar descripcion de componentes
use EmpresasInformaticas;
go

if OBJECT_ID('concatenar_componentes') is not null
	drop procedure concatenar_componentes;
	go
create procedure concatenar_componentes
 as
	declare @delimitador varchar, @componentes varchar(max)
	set @delimitador = ','
	set @componentes = ''
	select @componentes=@componentes +@delimitador+descripcion
	from componente
	select substring(@componentes, 2, len(@componentes)) as componentes
 go

exec concatenar_componentes
select descripcion from Componente

--CONTROL DE ERRORES
if objet_id('libros') is not null
	drop table libros;
go

create table libros(
	idlibro int primary key, titulo Varchar(40),
	autor varchar(30), editorial varchar(15),
	precio float, cantidad integer
	);
go

if OBJECT_ID('insertar_libros') is not null
	drop procedure insertar_libros;
	go
create procedure insertar_libros
	@idlibro integer, @idtitulo varchar(40)




EXEC Dice_Hola;	--Ejecutamos el procedimiento almacenado Dice_Hola.

CREATE PROCEDURE Dice_Palabra
@palabra CHAR(30)
AS
PRINT @palabra;
GO

EXEC Dice_Palabra 'Hola Perengano';
EXEC Dice_Palabra 'Adiós Fulanita';
EXEC Dice_Palabra;
EXEC Dice_Palabra 15843;	--SQL hace un cast de integer a char.

CREATE PROCEDURE Dice_PalabraDef
@palabra CHAR(30)='No indicó nada'	--Establecemos un mensaje por dejecto asignando un valor a CHAR(30)
AS
PRINT @palabra;
GO

EXEC Dice_PalabraDef'Hola Perengano';
EXEC Dice_PalabraDef 'Adiós Fulanita';
EXEC Dice_PalabraDef;

use master;
go

CREATE DATABASE PruebaSP;
go

use PruebaSP;
go

set dateformat dmy;
go

create table Fulanitos
(nombre varchar(30),
monedero integer)

insert into Fulanitos
values ('Perengano', 60), ('Mengano', 30), ('Fulano', 10), ('Sulano', 20);
go

select nombre, monedero from Fulanitos;

CREATE PROCEDURE Ricos @minimo integer	--Configuramos un parámetro al procedimiento almacenado.
AS
select nombre, monedero from Fulanitos
where monedero>=@minimo;	--El where se ejecuta en base al parámetro que le pasemos en el exec.
go

exec Ricos 30;	--Pasamos el parámetro @minimo (integer) en el exec.
go

CREATE PROCEDURE RicosInicial @minimo integer, @inicial varchar(30)	--Configuramos un parámetro al procedimiento almacenado.
AS
select nombre, monedero from Fulanitos
where monedero>=@minimo and nombre like @inicial;	--El where se ejecuta en base los parámetro que le pasemos en el exec.
go

exec RicosInicial 20, 'M%';	--Pasamos el parámetro @minimo (integer) en el exec.
go

--drop procedure RicosInicial

CREATE PROCEDURE  ContarRegistros
	@limite integer,
	@filtro varchar(30) ='%',
	@resultado integer output
AS
select @resultado=(select count(*)from Fulanitos where monedero>=@limite and nombre like @filtro)	--La variable @resultado obtiene su valor a partir de la consulta select.
go

DECLARE @valor AS integer;
EXEC ContarRegistros  1,'%',@valor  OUTPUT;
PRINT @valor;
go

CREATE PROCEDURE  ContarRegistros2
	@limite integer,
	@filtro varchar(30) ='%',
	@resultado integer output
AS
select @resultado=monedero from Fulanitos	--La variable @resultado se va "machacando" y..
go

DECLARE @valor AS integer;
EXEC ContarRegistros2  1,'%',@valor  OUTPUT;	--..en el OUT nos muestra el dato del último registro de la tabla.
PRINT @valor;
go



if object_id('ver_texto') is not null
	drop procedure ver_texto;
	go
		create procedure ver_texto
			@texto varchar(20)
		as
		IF @texto like 'A%'
			BEGIN
				PRINT @texto + ' comienza con A'
			END
		ELSE
			BEGIN
				PRINT @texto + ' no comienza con A'
			END
		GO

exec ver_texto 'hola';
exec ver_texto 'adriangano';

if object_id('detecta_pares') is not null
	drop procedure detecta_pares;
	go
		create procedure detecta_pares
			@numero int
		as
		IF (@numero % 2) = 0
			BEGIN
				PRINT cast (@numero AS varchar) + ' es par'
			END
		ELSE
			BEGIN
				PRINT cast (@numero AS varchar) + ' es impar'
			END
		GO
exec detecta_pares 22
exec detecta_pares 15
exec detecta_pares 13
exec detecta_pares 84
exec detecta_pares -4

if object_id('detecta_pares2') is not null
	drop procedure detecta_pares2;
	go
		create procedure detecta_pares2
			@numero int,
			@salida varchar(30)  output
		as
		IF (@numero % 2) = 0
			BEGIN
				SET @salida='es par'
			END
		ELSE
			BEGIN
				SET @salida='es impar'
			END
		GO

DECLARE @resultado varchar(30)
exec detecta_pares2 22,@resultado OUTPUT
print @resultado
exec detecta_pares2 15,@resultado OUTPUT
print @resultado
exec detecta_pares2 13,@resultado OUTPUT
print @resultado
exec detecta_pares2 84,@resultado OUTPUT
print @resultado
exec detecta_pares2 -4,@resultado OUTPUT
print @resultado


if object_id('libros') is not null
	drop table libros;
go
create table libros(
	titulo varchar(40),
	autor varchar(30),
	editorial varchar(15),
	precio float,
	cantidad integer
);
go
insert into libros (titulo,autor,editorial,precio,cantidad)
	values ('El aleph','Borges','Emece',25.50,100);
insert into libros (titulo,autor,editorial,precio,cantidad)
	values ('Alicia en el pais de las maravillas','Lewis Carroll','Atlantida',10,200);
insert into libros (titulo,autor,editorial,precio,cantidad)
	values ('Matematica estas ahi','Paenza','Siglo XXI',18.8,200);
go

if object_id('actualizar_autor') is not null
	drop procedure actualizar_autor;
go
create procedure actualizar_autor
	@autoranterior varchar(30),
	@autornuevo varchar(30),
	@cuenta integer
as
IF 
	EXISTS(SELECT titulo,autor,editorial,precio,cantidad FROM libros
		WHERE autor = @autoranterior)
	BEGIN
		update libros
		set autor = @autornuevo
		where autor = @autoranterior 
	END
ELSE
	BEGIN
		print 'El autor indicado no está'
	END
select @cuenta = count(*) from libros
IF @cuenta < 0
	BEGIN
		update --RELLENAR
	END
ELSE
	BEGIN
		print 'No se ha encontrado ningún autor.'
	END

go
SELECT titulo,autor,editorial,precio,cantidad FROM libros
exec actualizar_autor 'Borges','Jorge Luis Borges'
SELECT titulo,autor,editorial,precio,cantidad FROM libros
exec actualizar_autor 'Cervantes','Miguel de Cervantes'

--Nº de registros modificados 0 - ninguno