--Adrián Perera Hernández - 1DAWC
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

 --1.- Crear una función que devuelva cuántos libros hay de precio mayor que el que suministremos como parámetro.

 --2.  Crear una función escalar que tenga como parámetros el DNI y la letra del NIF y nos valide si es correcta o no. Usar la función con los datos de una tabla que contenga nombre, apellidos, fechanacimiento, dni y la letra del nif.

create table personas(
	nombre varchar(100),
	apellidos varchar(100),
	fechanacimiento datetime,
	dni char(8),
	letra char(1))

set dateformat dmy;
go

insert into personas values
	('Juan','Pérez','01/01/1970','56789443','M'),
	('María','Hernández','05/06/1985','45678432','L'),
	('Ana','Rodríguez','25/10/1991','42001982','A')
go

 --3. Crear una función que nos devuelva los años de diferencia respecto al actual a partir de la fecha pasada como parámetro. Usar la función con la tabla anterior.

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

--4.- Crear función que dada fecha como cadena de caracteres devuelva que no es correcta o en caso contrario el nombre del mes.

--El dato se pasa como varchar y luego se castea a dartetime

--5.- Crear una función de tabla que devuelva los libros de precio mayor que el que suministremos como parámetro.

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
--6.- Función que devuelva el máximo precio de la tabla libros

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

--También podría devolver el título del libro como función de tabla

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

--7.- Función que devuelva una tabla con el nombre y dni de las personas de
--dos tablas (personal y alumnado), pasando como parámetro: personal
--(saca sólo los de la tabla personal; alumnado (saca sólo los de la tabla alumnado;
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
	('Juan','Pérez'), ('María','Hernández'), ('Ana','Rodríguez');
insert into alumnado values
	('Juana','García'), ('María','Fernández'), ('Pedro','Rodríguez'), ('Marta','García');
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
go		--Relacionado con la pregunta de mantenimiento de bases de datos para hacer insert a través de un select.

--8.- Función que devuelva el nº de días del mes de una fecha pasada como parámetro.
select

--9.- Crear función que valide si una cadena de caracteres es un DNI correcto. Que contenga 8 dígitos y una letra y la letra se corresponda con la correcta.
--Probarlo con la tabla personas.
create function f_compruebaDNI(@dni varchar(9))
returns @respuesta
	begin
	if @dni not like
		'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][TRWAGMYFPDXBNJZSQVHLCKE]'
		

--Función de acceso a tabla. 2 PUNTOS DE EXAMEN
--2.- Función al que le pasemos como parámetro un número,
--si es uno devolverá la descripción de la tabla componente
--y si es dos devolverá el campo tipo de la tabla tipocomponente.
create function f_verTablas(@dato integer)
returns integer
if 
	begin
		--ordenes
	end
else
	begin
		declare @err int = 1/0 -- no deja raiserror
		--Alvaro encontró esta solución, dividir 1 entre 0 para que
		--el sistema pegue un estacaso y no procese los parámetro no válidos.
	end