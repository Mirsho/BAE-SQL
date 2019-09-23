--Adri�n Perera Hern�ndez - 1DAWC
--07EjerciciosFunciones01

use master;
go

create database PruebaFunciones;
go

use PruebaFunciones;
go

set dateformat dmy;
go

if object_id('libros') is not null  drop table libros;
 create table libros(  
	codigo int identity,
	titulo varchar(40),
	autor varchar(30),
	editorial varchar(20),
	precio decimal(5,2) );
go

insert into libros values('Alicia en el pais de las maravillas','Lewis Carroll','Emece',20.00);
insert into libros values('Alicia en el pais de las maravillas','Lewis Carroll','Plaza',35.00);
insert into libros values('Aprenda PHP','Mario Molina','Siglo XXI',40.00);
insert into libros values('El aleph','Borges','Emece',10.00);
insert into libros values('Ilusiones','Richard Bach','Planeta',15.00);
insert into libros values('Java en 10 minutos','Mario Molina','Siglo XXI',50.00);
insert into libros values('Martin Fierro','Jose Hernandez','Planeta',20.00);
insert into libros values('Martin Fierro','Jose Hernandez','Emece',30.00);
insert into libros values('Uno','Richard Bach','Planeta',10.00);

 --1.- Crear una funci�n que devuelva cu�ntos libros hay de precio mayor que el que suministremos como par�metro.

 --2.  Crear una funci�n escalar que tenga como par�metros el DNI y la letra del NIF y nos valide si es correcta o no. Usar la funci�n con los datos de una tabla que contenga nombre, apellidos, fechanacimiento, dni y la letra del nif.

create table personas(
	nombre varchar(100),
	apellidos varchar(100),
	fechanacimiento datetime,
	dni char(8),
	letra char(1))

set dateformat dmy;
go

insert into personas values
	('Juan','P�rez','01/01/1970','56789443','M'),
	('Mar�a','Hern�ndez','05/06/1985','45678432','L'),
	('Ana','Rodr�guez','25/10/1991','42001982','A')
go

 --3. Crear una funci�n que nos devuelva los a�os de diferencia respecto al actual a partir de la fecha pasada como par�metro. Usar la funci�n con la tabla anterior.

 create function f_aniosdiferencia
	(@fechaini datetime,
	@anios datetime
	)
returns datetime
as
begin
	declare @fecha datetime
	set @fechaini = date(
end

--4.- Crear funci�n que dada fecha como cadena de caracteres devuelva que no es correcta o en caso contrario el nombre del mes.

--El dato se pasa como varchar y luego se castea a dartetime

--5.- Crear una funci�n de tabla que devuelva los libros de precio mayor que el que suministremos como par�metro.

use PruebaFunciones;
go

create function f_verlibrosPecioMayor(@limite decimal(5,2))
returns table
as
return
(select titulo, autor, precio
from libros
where precio > @limite
);
go

select titulo, autor, precio
	from dbo.f_verlibrosPecioMayor(10);
select titulo, autor, precio
	from dbo.f_verlibrosPecioMayor(9);
select titulo, autor, precio
	from dbo.f_verlibrosPecioMayor(20);
go
--6.- Funci�n que devuelva el m�ximo precio de la tabla libros

create function f_precioMaximo ()
	returns decimal(5,2)
as
	begin
		declare @maximo decimal(5,2)
		select @maximo=MAX(precio) from libros
		return @maximo
	end
go

print dbo.f_precioMaximo();

--Tambi�n podr�a devolver el t�tulo del libro como funci�n de tabla

create function f_tablaPrecioMaximo ()
	returns table
as
return
(
	select top 1 titulo, precio
	from libros
	order by precio desc
)
go

select 

--7.- Funci�n que devuelva una tabla con el nombre y dni de las personas de
--dos tablas (personal y alumnado), pasando como par�metro: personal
--(saca s�lo los de la tabla personal; alumnado (saca s�lo los de la tabla alumnado;
--ambos (saca los de ambas tablas).

if object_id ('personal') is not null
drop table personal;
go
if object_id ('alumnado') is not null
drop table alumnado;
go
create table personal ( nombre varchar(100),  apellidos varchar(100))
go
create table alumnado ( nom varchar(50),  apell varchar(50))
go
insert into personal values
	('Juan','P�rez'), ('Mar�a','Hern�ndez'), ('Ana','Rodr�guez');
insert into alumnado values
	('Juana','Garc�a'), ('Mar�a','Fern�ndez'), ('Pedro','Rodr�guez'), ('Marta','Garc�a');
go

--select con insert sobre la tabla, estructura en memoria
create function f_personal_alumnado(@filtro char(15))
returns @datos table --Actua como "tipo de dato"
	--formato de la tabla
	(nombre varchar(100),
	apellido varchar(100))
as
	if @filtro = 'personal' or @filtro = 'ambos'
		begin
			insert @datos
				select nombre, apellidos from personal
		end
	if @filtro = 'alumnado' or @filtro = 'ambos'
		begin
			insert @datos
				select nom, apell from alumnado	--En esto insert metemos los datos del select.
		end
return
end;
go		--Relacionado con la pregunta de mantenimiento de bases de datos para hacer insert a trav�s de un select.

--8.- Funci�n que devuelva el n� de d�as del mes de una fecha pasada como par�metro.
select

--9.- Crear funci�n que valide si una cadena de caracteres es un DNI correcto. Que contenga 8 d�gitos y una letra y la letra se corresponda con la correcta.
--Probarlo con la tabla personas.
create function f_compruebaDNI(@dni varchar(9))
returns @respuesta
	begin
	if @dni not like
		'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][TRWAGMYFPDXBNJZSQVHLCKE]'
		

--Funci�n de acceso a tabla. 2 PUNTOS DE EXAMEN
--2.- Funci�n al que le pasemos como par�metro un n�mero,
--si es uno devolver� la descripci�n de la tabla componente
--y si es dos devolver� el campo tipo de la tabla tipocomponente.
create function f_verTablas(@dato integer)
returns integer
if 
	begin
		--ordenes
	end
else
	begin
		declare @err int = 1/0 -- no deja raiserror
		--Alvaro encontr� esta soluci�n, dividir 1 entre 0 para que
		--el sistema pegue un estacaso y no procese los par�metro no v�lidos.
	end