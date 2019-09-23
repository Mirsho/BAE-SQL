--Adri�n Perera Hern�ndez - 1DAWC
--Cursores

--Tablas auxiliares o de maniobra para trabajar con cursores.

--Estructura b�sica de un procedimiento almacenado con cursor.

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

--ESTRUCTURA BASE
declare @variable varchar(100)

declare CUR cursor for
	--Sentencia select

open CUR
print 'Comienzo del cursor'
fetch next from CUR -- Leer el primero (siguiente) desde la posici�n del cursor.
	into @variable
while @@FETCH_STATUS=0 --Esta variable de sistema devuelve 0 cuando hay datos. Cualquier otro valor cuando NO los hay.
	begin
		--�rdenes para procesar el regristro
		print @variable
		fetch next from CUR
			into @variable
	end
print 'Fin del listado'
close CUR --Cerramos el cursor
deallocate CUR --Lo sacamos de memoria.

--2.- Crear una tabla que contenga lo siguiente:
/*	Tabla
		Federacion
		Club
		Organizador
	
	Crear un procedimiento almacenado que recorra la tabla mediante un cursor que permita crear
	una restricci�n unique en cada tabla para el campo que se llama como la tabla y con denominaci�n
	de la restricci�n U_ y el nombre de la tabla. Eliminarla previamente si existe.
	Hacer ejemplo de ejecuci�n.*/

use ciclismo;
go

set dateformat dmy;
go

if OBJECT_ID('P_CrearUniqueCiclismo') is not null
	drop procedure P_CrearUniqueCiclismo;
go
if OBJECT_ID('TablaUniqueCiclismo') is not null
	drop table TablaUniqueCiclismo;
go
create table TablaUniqueCiclismo	--Revisar
	(Tabla nvarchar(100))
--insertamos los datos
	insert into TablaUniqueCiclismo(Tabla)
		values ('Federacion'),('Club'),('Organizador'); --Pasa los nombres de las tablas de la DB como par�metro.

declare @sentencia nvarchar(max)
declare @Tabla nvarchar(100)

declare CUR cursor for
	select Tabla
	from ciclismo.dbo.TablaUniqueCiclismo;	--revisar
open CUR

print 'Comienzo del cursor'
fetch next from CUR -- Leer el primero (siguiente) desde la posici�n del cursor.
	into @Tabla
while @@FETCH_STATUS=0 --Esta variable de sistema devuelve 0 cuando hay datos. Cualquier otro valor cuando NO los hay.
	begin
		--�rdenes para procesar el regristro
		set @sentencia = 'alter table' +@Tabla+
							'drop constraint U_' +@Tabla --Primero eliminamos la constratint unique si existe previamente.
		--print @sentencia
		--Hacemos un TRY CATCH para posibles errores con la base de datos.
		BEGIN TRY
			exec (@sentencia)
		END TRY
		BEGIN CATCH
			print 'ERROR: El �ndice no existe U_'+@tabla
		END CATCH
		--Comenzamos la creaci�n de la restricci�n unique con la denominaci�n U_
		set @sentencia = 'alter table' +@Tabla+
					'drop constraint U_' +@Tabla
		set @sentencia += 'unique ' + '('+@Tabla+');'
		exec (@sentencia)
		fetch next from CUR
			into @Tabla
	end
print 'Fin del listado'
close CUR --Cerramos el cursor
deallocate CUR --Lo sacamos de memoria.
exec sp_helpconstraint TablaUniqueCiclismo

--3.- 

--ESTRUCTURA BASE
declare @variable varchar(100)

declare CUR cursor for
	--Sentencia select

open CUR
print 'Comienzo del cursor'
fetch next from CUR -- Leer el primero (siguiente) desde la posici�n del cursor.
	into @variable
while @@FETCH_STATUS=0 --Esta variable de sistema devuelve 0 cuando hay datos. Cualquier otro valor cuando NO los hay.
	begin
		--�rdenes para procesar el regristro
		print @variable
		fetch next from CUR
			into @variable
	end
print 'Fin del listado'
close CUR --Cerramos el cursor
deallocate CUR --Lo sacamos de memoria.

-- 4.-Crear una tabla con un �nico campo llamado t de tipo varchar(100). Insertar en la tabla creada los valores 'Cliente',
--'Puntuacion', 'Disco' e Interprete' Hacer un procedimiento almacenado que contenga un cursor que recorra la tabla creada
--y nos muestre los tres primeros registros de la tabla con el nombre le�do. Hacer una prueba de ejecuci�n.

use Discos;
go
set dateformat dmy;
go

if OBJECT_ID('Tabla3registros') is not null
	drop table Tabla3registros;
go
create table Tabla3registros
	(t varchar(100))
--insertamos los datos
	insert into Tabla3registros(t)
		values (N'Cliente'),(N'Nombre'),
		(N'Puntuacion'),(N'Fecha'),
		(N'Disco'),(N'Titulo'),
		(N'Interprete'),(N'Interprete'); --Pasa los nombres de las tablas de la DB como par�metro.

if OBJECT_ID('P_TresPrimerosRegistos') is not null
	drop procedure P_TresPrimerosRegistos;
go
create procedure P_TresPrimerosRegistos
as
declare @tabla varchar(100)
declare @campo varchar(100)
declare @sentencia varchar(max)

declare CUR cursor for
	select t from Discos.dbo.Tabla3registros;
open CUR

print 'Comienzo del cursor'
fetch next from CUR -- Leer el primero (siguiente) desde la posici�n del cursor.
	into @tabla, @campo
while @@FETCH_STATUS=0 --Esta variable de sistema devuelve 0 cuando hay datos. Cualquier otro valor cuando NO los hay.
	begin
		--�rdenes para procesar el regristro
		set @sentencia = N'select top 3 '+@campo
		+N' from '+@tabla
		+N' order by '+@campo
		--print @sentencia
		/* Si el procedimiento lo requiriera...
		--Hacemos un TRY CATCH para posibles errores con la base de datos.
		BEGIN TRY
			exec (@sentencia)
		END TRY
		BEGIN CATCH
			print 'ERROR: La tabla '+@tabla+' no existe o no es accesible.';
		END CATCH
		si queremos admitir posibles datos err�neos en la sentencia, lo incluimos en el procedimiento.*/
		exec sp_executesql @sentencia
		fetch next from CUR
			into @tabla,@campo
	end
print 'Fin del listado'
close CUR --Cerramos el cursor
deallocate CUR --Lo sacamos de memoria.
go

exec P_TresPrimerosRegistos

--nvarchar ----- cadenas de caracteres del alfabeto internacional.
exec (@variable) --La variable es de tipo varchar. Admite valores de caracteres est�ndar en la variable.
exec sp_executesql @variable --La variable es de tipo nvarchar, que admite cadenas de caracteres del alfabteo internacional,
							  --como el chino, el ruso y el �rabe. UTF-16
--Las cadenas de caracteres Unicode se deben declarar con una N may�scula delante. Por ejemplo: N'Cadena'


--�ndice para cada tabla, nombre I_

use tenis;
go
set dateformat dmy;
go

if OBJECT_ID('TablaIndices') is not null
	drop table TablaIndices;
go
create table TablaIndices
	(t varchar(100))
--insertamos los datos
	insert into TablaIndices(t)
		values (N'EdicionTorneo'),(N'Estadio'),
		(N'Jugador'),(N'Pais'),
		(N'Superficie'),(N'TipoTorneo'),
		(N'Torneo'); --Pasa los nombres de las tablas de la DB como par�metro.

if OBJECT_ID('P_CrearIndices') is not null
	drop procedure P_CrearIndices;
go
create procedure P_CrearIndices
as
declare @tabla varchar(200)
declare @sentencia varchar(max)

declare CUR cursor for
	select t from tenis.dbo.TablaIndices;
open CUR

print 'Comienzo del cursor'
fetch next from CUR -- Leer el primero (siguiente) desde la posici�n del cursor.
	into @tabla
while @@FETCH_STATUS=0 --Esta variable de sistema devuelve 0 cuando hay datos. Cualquier otro valor cuando NO los hay.
	begin
		--�rdenes para procesar el regristro
		set @sentencia = 'DROP index [I_'+@tabla+'] on dbo.'+@tabla;
		--print @sentencia
		--Hacemos un TRY CATCH para posibles errores con la base de datos.
		BEGIN TRY
			exec (@sentencia)
		END TRY
		BEGIN CATCH
			print 'ERROR: La tabla '+@tabla+' no existe o no es accesible.';
		END CATCH
		set @sentencia = N'create nonclustered index I_'+ @tabla +' on ' +@tabla+ '('+@tabla+'); ' --cambiar por '('+@campo+'); '
		exec (@sentencia)
		fetch next from CUR
			into @tabla
	end
print 'Fin del listado'
close CUR --Cerramos el cursor
deallocate CUR --Lo sacamos de memoria.
go

exec P_CrearIndices

--