--Adrián Perera Hernández - 1DawC
--Presentación SubconsultasNuevo.pdf

--Página 42 en adelante

use VideoJuegos;
go

set dateformat dmy;
go

--Subconsulta como tabla
--Suma del número de puntuaciones de cada tipo de juego.

select tipo, sum(npunt)
from tipo as t
inner join
	(select Juego, idtipo, COUNT(*) as npunt
	from Puntuacion as p
	inner join JuegoPlataforma as jp
		on p.idjuegoplataforma=jp.Id
	inner join juego as j
		on jp.IdJuego=j.IdJuego
	group by Juego, IdTipo) as jcuenta
	on t.IdTipo=jcuenta.IdTipo
group by tipo;
go

--Subconsulta den campos
--Distribuidor y desarrollador con más juegos.

select
	(select top 1 Desarrollador as dev
		from Desarrollador as d
		inner join JuegoPlataforma as jp
			on d.IdDesarrollador=jp.IdDesarrollador
		group by d.Desarrollador
		order by COUNT(distinct idjuego) desc) as desa,	--IMPORTANTE: La coma es fundamental para las subconsultas en campos.
	(select top 1 Distribuidor as distrib
		from Distribuidor as d
		inner join JuegoPlataforma as jp
			on d.IdDistribuidor=jp.IdDistribuidor
		group by d.Distribuidor
		order by COUNT(distinct IdJuego) desc) as distri
go

select
	(select top 1 Desarrollador as dev
		from Desarrollador as d
		inner join JuegoPlataforma as jp
			on d.IdDesarrollador=jp.IdDesarrollador
		group by d.Desarrollador
		order by count(distinct IdJuego) desc) as desa, --LA COMAAAA
	(select top 1 Distribuidor
		from Distribuidor as d
		inner join JuegoPlataforma as jp
			on d.IdDistribuidor=jp.IdDistribuidor
		group by d.Distribuidor
		order by count(distinct IdJuego) desc) as distri;
go

--Subconsulta en Where como valor
-- Puntuaciones, dando juego, plataforma y nombre de cliente con puntuación mayor que
--la media de las puntuaciones.

select Juego, Plataforma, Nombre, Puntuacion
from cliente as c
inner join Puntuacion as p
	on c.id=p.Idcliente
inner join JuegoPlataforma as jp
	on p.idjuegoplataforma=jp.Id
inner join  juego as j
	on jp.IdJuego=j.IdJuego
inner join Plataforma as plat
	on jp.IdPlataforma=plat.IdPlataforma
where Puntuacion >
	(select avg(puntuacion) from Puntuacion);
go

--Consulta de pruebas
select Juego, Plataforma, Nombre, Puntuacion
from cliente as c
inner join Puntuacion as p
	on c.id=p.Idcliente
inner join JuegoPlataforma as jp
	on p.idjuegoplataforma=jp.Id
inner join  juego as j
	on jp.IdJuego=j.IdJuego
inner join Plataforma as plat
	on jp.IdPlataforma=plat.IdPlataforma
where Puntuacion >
	(select avg(puntuacion) from Puntuacion)
order by juego;
go

--Subconsulta en el where mediante EXISTS y con enlace de campos.
--Juegos/plataformas cuyo distribuidor no exista en otro juego.

select Distribuidor, Juego, Plataforma
from Distribuidor as d
inner join JuegoPlataforma as jp
	on d.IdDistribuidor=jp.IdDistribuidor
inner join Juego as j
	on j.IdJuego=jp.IdJuego
inner join Plataforma as p
	on jp.IdPlataforma=p.IdPlataforma
where not exists
(select juego
from Distribuidor as d2
inner join JuegoPlataforma as jp2
	on d2.IdDistribuidor=jp.IdDistribuidor
inner join Juego as j2
	on j2.IdJuego=jp2.IdJuego
	where j2.IdJuego<>j.IdJuego
		and d2.IdDistribuidor=d.IdDistribuidor);
go	--REVISAR

--Subconsulta en el Where usando el in
--Juegos con tipo que tengan más de 1000 juegos

select Juego
from Juego
where IdTipo in
	(select t.IdTipo
		from Tipo as t
		inner join Juego as j
			on j.IdTipo=t.IdTipo
		group by t.IdTipo
		having count(*) > 1000)
go

--Consulta de pruebas: mostrar el tipo de juego.

select Juego, tp.Tipo
from Juego as j
inner join Tipo as tp
	on j.IdTipo=tp.IdTipo
where tp.IdTipo in
	(select t.IdTipo
		from Tipo as t
		inner join Juego as j
			on j.IdTipo=t.IdTipo
		group by t.IdTipo
		having count(*) > 1000)
go

--Subconsultas en Where mediante in
--Clientes que han votado a los 10 juegos con mayor puntuación media.

select Nombre
from Cliente as c
inner join Puntuacion as p
	on c.id=p.Idcliente
inner join JuegoPlataforma as jp
	on p.idjuegoplataforma=jp.Id
where jp.IdJuego in
	(select top 10 jp1.IdJuego
	from Puntuacion as p1
	inner join JuegoPlataforma as jp1
		on p1.idjuegoplataforma=jp1.Id
	group by jp1.IdJuego
	order by avg(puntuacion) desc)
group by Nombre;
go

--Subconsultas en Where usando any/some
--Juego con distribuidor igual a alguno de los del juego
--FIFA 10: Ultimate Team

select Distribuidor, Juego
from Distribuidor as d
inner join JuegoPlataforma as jp
	on d.IdDistribuidor=jp.IdDistribuidor
inner join juego as j
	on j.IdJuego=jp.IdJuego
where Distribuidor = any
(select Distribuidor
from Distribuidor as d2
inner join JuegoPlataforma as jp2
	on d2.IdDistribuidor=jp2.IdDistribuidor
inner join Juego as j2
	on j2.IdJuego=jp2.IdJuego
	where j2.Juego = 'FIFA 10: Ultimate Team')
group by Distribuidor, Juego;
go

--Subconsultas en el where usando all
--Juego programado por el mismo desarrollador en todas las plataformas:
select Desarrollador, juego
from Desarrollador as dev
inner join JuegoPlataforma as jp
	on dev.IdDesarrollador=jp.IdDesarrollador
inner join Juego as j
	on j.IdJuego=jp.IdJuego
where Desarrollador = all
		(select Desarrollador
		from Desarrollador as dev2
		inner join JuegoPlataforma as jp2
			on dev2.IdDesarrollador=jp.IdDesarrollador
		inner join juego as j2
			on j2.IdJuego=jp2.IdJuego
		where j2.IdJuego=j.IdJuego)
group by Desarrollador, Juego;
go

--Subconsulta con campos enlazados
--Para cada juego/plataforma dar el nombre del juego, la plataforma y el número
--total de juegos de esa plataforma
select Juego, Plataforma,
	(select COUNT(distinct IdJuego)
		from JuegoPlataforma as jp2
		where jp2.IdPlataforma=jp.idplataforma) as Ntotal
from Juego as j
inner join JuegoPlataforma as jp
	on j.IdJuego=jp.IdJuego
inner join Plataforma as p
	on p.IdPlataforma=jp.IdPlataforma;
go