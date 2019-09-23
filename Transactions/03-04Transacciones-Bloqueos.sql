--Adrián Perera Hernández - 1DawC
--03Transacciones.sql
--04Bloqueos.sql

use master;
go

use PruebaSQL
go

if object_id('libros') is not null
	drop table libros;
create table libros(
	titulo varchar(40) primary key,
	autor varchar(30),
	editorial varchar(20),
	precio decimal(6,2)
	);

BEGIN TRANSACTION		--o BEGIN TRAN - Comienzo de la transacción.
	insert into libros values('Uno','Richard Bach','Planeta',15);
	insert into libros values('Ilusiones','Richard Bach','Planeta',10);
	insert into libros values('El aleph','Borges','Emece',25);
	insert into libros values('Aprenda PHP','Mario Molina','Siglo XXI',55);
	insert into libros values('Alicia en el pais','Lewis Carroll','Paidos',35);
	insert into libros values('Matematica estas ahi','Paenza','Nuevo siglo',25);

ROLLBACK TRANSACTION	--Anula las operaciones anteriores
select titulo, autor from libros;

COMMIT TRANSACTION		--Actualiza as operaciones anteriores
select titulo, autor from libros; 

--BEGIN TRAN con @VARIABLES @@VARIABLESDESISTEMA y sentencia de control IF
begin transaction
	declare @error integer
	declare @copiaerror integer
	set @error=0
	insert into libros values('Uno','Richard Bach','Planeta',15);
	set @copiaerror= @@error
	if @copiaerror <>0
		begin		--Siempre poner el BEGIN END para delimitar el bloque de sentencias.
		print 'primero'
		set @error=@copiaerror
		end
	insert into libros values('Ilusiones2','Richard Bach','Planeta',10);
	set @copiaerror= @@error
	if @copiaerror <>0
		begin
		print 'segundo'
		set @error=@copiaerror
		end
	if @error <>0
		begin
		print 'rollback'
		rollback transaction
		end
	else
		begin
		print 'commit'
		commit transaction
		end
	go