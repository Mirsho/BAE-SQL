--Adrián Perera Hernández 1DAWC
--SQLSimEXA03Seguridad.sql

--Cargamos la base de datos ciclismo con el script de creación de base de datos 19CrearCiclismo.sql suministrado por el profesor.

use ciclismo;
go

set datetime dmy;
go

--1.- Crear un índice clustered para la tabla Campeonato por el campo inicio. Decir qué ocurre y si se produce error cómo podríamos evitarlo.

create clustered index ix_Inicio
on Campeonato(Inicio);
go

/*	Al intentar crear el índice, el Sistema Gestor nos avisa del siguiente error:
	Msg 1902, Level 16, State 3, Line 11
	No se pueden crear varios índices clúster en tabla 'Campeonato'. Quite el índice clúster existente 'PK__Campeona__3214EC077F14DEA9'
	antes de crear otro.
	
	Esto significa que ya existe otro índice clustered en la tabla 'Campeonato' generado para la Primary key 'Id', por lo que no se puede
	crear otro índice agrupado en dicha tabla (Las tablas solo pueden tener 1 índice clustered en SQL Server).

	Por tanto, procedemos a modificar la constraint de la Primary Key de Campeonato 'Id' con nombre 'PK__Campeona__3214EC077F14DEA9' para que 
	genere un índice nonclustered y así podemos generar un índice clustered para el campo 'Inicio', como nos pide el ennunciado:
*/

--Pasos:
--1.1 Comprobamos los índices de la tabla Campeonato y EquipoCampeonato (que posee una Foreign Key de Campeonato):
sp_helpindex Campeonato;
go

exec sp_helpconstraint Campeonato;
go

exec sp_helpconstraint EquipoCampeonato;
go

--1.2 Eliminamos la restricción Foreign Key en la tabla EquipoCampeonato 
alter table EquipoCampeonato
drop constraint FK_equipocampeonato_campeonato;
go

--1.3 Eliminamos la restricción Primary Key
alter table Campeonato
drop constraint PK__Campeona__3214EC077F14DEA9;
go

--1.4 Generamos de nuevo la constraint PK pero nonclustered
alter table Campeonato
add constraint PK__Campeona__3214EC077F14DEA9
primary key nonclustered (Id);	--Con esta orden generamos el índece nonclustered
go

/*	Órden para regenerar el índice nonclustered 'PK__Campeona__3214EC077F14DEA9'
	create nonclustered index PK__Campeona__3214EC077F14DEA9
	on Campeonato(Id)
	with drop_existing;
	go
*/

--1.5 Volvemos a generar la FK en EquipoCampeonato
alter table EquipoCampeonato
add constraint FK_equipocampeonato_campeonato
foreign key (idcampeonato)
references campeonato (id);
go

--1.6 Creamos el índice clustered para Inicio
create clustered index ix_Inicio
on Campeonato(Inicio);
go

/*	Órden para regenerar el índice clustered 'ix_Inicio'
	create clustered index ix_Inicio
	on Campeonato(Inicio)
	with drop_existing;
	go
*/

--1.7 Comprobamos que los índices se han generado correctamente y tienen la agrupación adecuada.
sp_helpindex Campeonato;
go

--Fin del enunciado 1.

--2.- Crear una vista que nos muestre el nombre de cada campeonato, el número de participantes total y el nombre del organizador.

create view Camp_NPart_Org
as
select Campeonato, sum(Nparticipantes) as TotalParticipantes, Organizador
from Campeonato as c
inner join EquipoCampeonato as ec
	on ec.idcampeonato=c.Id
inner join Organizador as o
	on o.Id=c.IdOrganizador
group by Campeonato, Organizador
go


--3.- Recuperar copia de seguridad indicando objetos que contiene del tipo indicado en la lista:

/*	Para restaurar la base de datos con el archivo de copia prueba3ev_b.bak debemos ubicarlo en el servidor linux:
	Ya que se trata de una máquina virtual, lo transferimos mediante la carpeta compartida SQLDatos.

	En el servidor Linux, ejecutamos los siguientes comandos:

		1. sudo su			--para poder acceder y hacer cambios en los permisos
		2. cd /media/		--para acceder a las carpetas compartidas
		3. ls				--para ver los nombres de las carpetas compartidas que tenemos
		4. ls sf_SQLDatos	--para ver el contenido de la carpeta compartida donde pusimos el archivo.bak
		5. chmod 777 sf_SQLDatos/	--para dar permisos de lectura, escritura y ejecución al directorio
		6. chmod 777 sf_SQLDatos/prueba3ev_b.bak	--para dar permisos de lectura, escritura y ejecución al archivo
		7. ls -l sf_SQLDatos/	--para comprobar que los permisos se han aplicado correctamente
*/

--script generado durante la recuperación:
USE [master]
RESTORE DATABASE [prueba3ev_b02] FROM  DISK = N'/SQLDatos/prueba3ev_b.bak' WITH  FILE = 1, 
MOVE N'prueba3ev_b' TO N'/var/opt/mssql/data/prueba3ev_b02.mdf',
MOVE N'prueba3ev_b_log' TO N'/var/opt/mssql/data/prueba3ev_b02_log.ldf',
NOUNLOAD,  STATS = 5
GO

--3.1 Tablas de usuario y nº de registros
use prueba3ev_b02;
go

exec sp_help;
go

select count(*)	--Utilizamos *asterisco para contar todos los registros de la formá más eficiente...
from Familia as f
full join Planta as p	--...puesto que la hacer un full join agregamos todos los registros sean coincidentes(sin repetirlos) o no.
	on p.CodFamilia=f.CodFamilia
go

--3.2 Índices
exec sp_helpindex Familia;
go

exec sp_helpindex Planta;
go

--3.3 Claves y Foreign key


--3.4 Funciones de usuario


--3.5 Procedimientos almacenados de usuario




--4.- Crear un usuario us_ciclismo de sólo lectura que sólo acceda a la base de datos ciclismo. Dar las instrucciones que lo hacen.

USE [master]
GO
CREATE LOGIN [us_ciclismo] WITH PASSWORD=N'123456', DEFAULT_DATABASE=[ciclismo], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [ciclismo]
GO
CREATE USER [us_ciclismo] FOR LOGIN [us_ciclismo]
GO
USE [ciclismo]
GO
ALTER USER [us_ciclismo] WITH DEFAULT_SCHEMA=[dbo]
GO
USE [ciclismo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [us_ciclismo]
GO

--5.- Generar una tabla (FederacionClubs) a partir de una consulta que devuelva el nombre de la federación y el número de clubs de la misma.



--6.- Añadir un campo Direccion varchar(100) a la tabla federacion.