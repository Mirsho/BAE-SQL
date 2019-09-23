--Adrián Perera Hernández - 1DAWC
--Procedimientos almacenados 02

--1.- Crear un procedimiento almacenado que le pasemos como parámetro un texto y que devuelva
--en un parámetro de salida los símbolos que no sean las vocales (con o sin acento).
--Hacer un ejemplo de ejecución.

use VideoJuegos;
go

set dateformat dmy;
go

if object_id('P_sinvocales') is not null
	drop procedure P_sinvocales;
go
create procedure P_sinvocales
	@texto varchar (255),
	@salida varchar (255) OUTPUT
as
	declare @cont int = 1
	set @salida = ''
	while @cont <= len(@texto)
		begin
			if (lower(substring(@texto, @cont, 1)) not in
				('a','á','e','é','i','í','o','ó','u','ú'))
				BEGIN
					set @salida = @salida + SUBSTRING(@texto, @cont, 1)
				END
			set @cont = @cont + 1
		end
go

DECLARE @s varchar(255)
EXEC P_sinvocales 'Hola que Tal?', @s OUTPUT
PRINT @s;

--Procedimiento mes. Parametro: nombre mes, si es correcto -> salida = Nº facturas if no correcto --> -1
if object_id('P_facturasmes') is not null
	drop procedure P_facturasmes
go
create procedure P_facturasmes
	@mes varchar(20),
	@nfacturas int OUTPUT
as
IF LOWER(@mes) not in ('enero','febrero','marzo','abril','mayo','junio','julio',



exec sp_helplanguage;
go

--tabla de sistema: sys.syslanguage
select months
from sys.syslanguages
where alias = 'Spanish' --o name = 'Español'
go

--Función realizada por Álvaro con la tabla de sistema: sys.syslanguage
--en base a mi pregunta sobre usar dicha tabla
--tras explicar que podemos comparar registros de cualquier tabla.
declare @mes varchar(100);
set @mes = 'julio';
declare @res int;
if CHARINDEX(',', @mes ) <> 0
	begin
		set @res = 0;
	end
else
	begin
		select charindex(@mes + ',', months + ',')
		from sys.syslanguages
		where alias = 'Spanish'; --o name = 'Español';
		print @res
	end
go

--Mejora utilizando la variable de sistema @@LANGUAGE para adaptarse a cualquier idioma.
declare @mes varchar(100);
set @mes = 'julio';
declare @res int;
if CHARINDEX(',', @mes ) <> 0
	begin
		set @res = 0;
	end
else
	begin
		select charindex(',' + @mes + ',', ',' + months + ',')
		from sys.syslanguages
		where name = @@LANGUAGE; --Utilizando la variable de sistema, nos extrae la lista de meses en el idioma que sea.
		print @res
	end
go

use EmpresasInformaticas;
go

--Procedimiento almacenado utilizando la tabla de sistema sys.language
if object_id('P_facturasmes') is not null
	drop procedure P_facturasmes
go
create procedure P_facturasmes
	@mes varchar(20),
	@nfacturas int OUTPUT
as
declare @res int
IF CHARINDEX(',', @mes) <> 0
	begin
		set @res = 0;
	end
ELSE
	begin
		select charindex(',' + @mes + ',', ',' + months + ',')
		from sys.syslanguages
		where name = @@LANGUAGE; --Utilizando la variable de sistema, nos extrae la lista de meses en el idioma que sea.
	end
if @res = 0
	begin
		set @nfacturas = -1;
	end
else
	begin
		set @nfacturas = (select count(NFactura) from Factura);
	end
go

use EmpresasInformaticas;
go

declare @facturas int
exec P_facturasmes 'diciembre', @facturas output	--REVISAR
print @facturas;

DECLARE @s varchar(255)
EXEC P_sinvocales 'Hola que Tal?', @s OUTPUT
PRINT @s;

--1.- Crear un procedimiento almacenado, pasamos texto, salida nº de clientes cuyo nombre = texto.

use Discos;
go

set dateformat dmy;
go

if object_id('P_numclientes') is not null
	drop procedure P_numclientes;
go
create procedure P_numclientes
	@texto varchar (255),
	@salida int OUTPUT
as
	select count(*) from Cliente
	where Nombre = '%' + @texto + '%';
go

DECLARE @sal int
EXEC P_numclientes 'sa', @sal OUTPUT
PRINT @sal;

--TODO lo que se precompila (tablas, campos, etc.) no se puede nombrar con variables.

--2.- entrada texto salida Nclientes empiezan por cada letra de texto

if object_id('P_numclientesini') is not null
	drop procedure P_numclientesini;
go
create procedure P_numclientesini
	@texto varchar (255),
	@suma int OUTPUT
as
	declare @cont int = 1
	declare @cuenta int
	set @suma = 0

	while @cont <= len(@texto)
		begin
			select @cuenta = count(*) from Cliente
			where substring(Nombre, @cont, 1) = substring(@texto, @cont, 1);
			set @cont = @cont + 1
			set @suma = @suma + @cuenta
		end
go

DECLARE @sal int
EXEC P_numclientesini 'ef', @sal OUTPUT
PRINT @sal;

--3.- Parametros: id,Nombre, email y fechanaci ---> Tabla Cliente
--validar que el año de la fechanaci sea anterior al año actual menos 18. Mensaje de error si no lo es.
--Añadir el registro fecharegistro = fecha actual.

insert into libros (titulo,autor,editorial,precio,cantidad)
	values ('El aleph','Borges','Emece',25.50,100);
insert into libros (titulo,autor,editorial,precio,cantidad)
	values ('Alicia en el pais de las maravillas','Lewis Carroll','Atlantida',10,200);
insert into libros (titulo,autor,editorial,precio,cantidad)
	values ('Matematica estas ahi','Paenza','Siglo XXI',18.8,200);
go

if object_id('P_validanacimiento') is not null
	drop procedure P_validanacimiento;
go
create procedure P_validanacimiento
	@id varchar(255),
	@Nombre varchar(255),
	@email varchar(255),
	@fechanaci datetime
as
IF 
	--ARREGLAR Y TERMINAR.
	SELECT @id, FROM libros
		WHERE datepart(year, @fechanaci) > datepart(year, SYSDATETIME);
	BEGIN
		insert into Cliente
			values (@id, @Nombre,@email,@fechanaci,GETDATE())
	END
ELSE
	BEGIN
		print 'ERROR: El usuario a registrar no tiene la edad suficiente.'
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

--Tablas auxiliares o de maniobra para trabajar con cursores.
--Esta parte es de cursores. Creo una nueva query.

--2.- Crear una tabla que contenga lo siguiente:
/*	Tabla
	Federacion
	Club Organizador
	
	Crear un procedimiento almacenado que recorra la tabla mediante un cursor que permita crear
	una restricción unique en cada tabla para el campo que se llama como la tabla y con denominación
	de la restricción U_ y el nombre de la tabla. Eliminarla previamente si existe.
	Hacer ejemplo de ejecución.*/

--Estructura básica de un procedimiento almacenado con cursor.

/*	Declarar cursor
		select..
	abrir
	leer primero (fetch next)
	mientras haya datos...
		procesar el registro
		leer siguiente (fecth next)
	fin mientras
	cerrar
	sacar de memoria
*/

--EXA3ev
--Pregunta mantenimiento avanzado, select into, json, etc
--1 Indice, 1 Vista, 1 Restricción(unique, check, añadir campo, mod. longitud campo, quitar campo, etc). SEGURO
--1 proc. almacenado
--1 cursor
--1 tabla en linea
--1 función de select
--1 función de insert dentro de la misma función