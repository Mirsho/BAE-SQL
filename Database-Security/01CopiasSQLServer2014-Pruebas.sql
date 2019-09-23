--Adri�n Perera Hern�ndez 1DAWC

--Creaci�n de la base de datos para pruebas de copias de seguridad.
use Master;
go

begin try
	if (select name from master.sys.sysdatabases
	where name='PruebaCopiaSeg') is not null
	begin
		use master;
		ALTER DATABASE PruebaCopiaSeg
		SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
		print 'La Base de Datos PruebaCopiaSeg ser� eliminada.'
		drop database PruebaCopiaSeg
	end
end try
begin catch
	print 'La Base de Datos PruebaCopiaSeg no existe.';
end catch
go

print 'La Base de Datos PruebaCopiaSeg ser� creada de nuevo.'
create database PruebaCopiaSeg;
go

--Continua en la pagina 3