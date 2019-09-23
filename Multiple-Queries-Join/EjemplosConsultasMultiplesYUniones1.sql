--Adrián Perera Hernández
--1DAWC

--EjemplosConsultasMultiplesYUniones1

--BD Videojuegos
--Cliente - Desarrollador

use VideoJuegos;
go

set dateformat dmy;
go

select nombre, desarrollador
from Cliente as c
inner join Puntuacion as p
	on c.id=p.idcliente
inner join JuegoPlataforma as jp
	on p.idjuegoplataforma=jp.id
inner join Desarrollador as d
	on jp.IdDesarrollador=d.IdDesarrollador;
go

--Tipo - Distribuidor

select Tipo, Distribuidor
from Tipo as t
inner join Juego as j
	on t.IdTipo=j.IdTipo
inner join JuegoPlataforma as jp
	on j.IdJuego=jp.IdJuego
inner join Distribuidor as d
	on jp.IdDistribuidor=d.IdDistribuidor;
go

/* Consulta de comprobación:
select Tipo, Distribuidor, juego, Plataforma
from Tipo as t
inner join Juego as j
	on t.IdTipo=j.IdTipo
inner join JuegoPlataforma as jp
	on j.IdJuego=jp.IdJuego
inner join Plataforma as p
	on jp.IdPlataforma=p.IdPlataforma
inner join Distribuidor as d
	on jp.IdDistribuidor=d.IdDistribuidor;
go
*/

--BD EmpresasInformaticas
--Tienda - TipoComponent

use EmpresasInformaticas;
go

set dateformat dmy;
go

select NombreTienda, Tipo
from Tienda as t
inner join Factura as f
	on t.IdTienda=f.idTienda
inner join FacturaComponente as fc
	on f.NFactura=fc.NFactura
inner join Componente as c
	on fc.CodComponente=c.clave
inner join TipoComponente as tc
	on c.CodTipo=tc.CodTipo;
go

--BD Discos
--Interprete (TODO) - Tipos

--Página 64
--Número de idiomas en cada país especificado de la BD Mundo.

use Mundo;
go

set dateformat dmy;
go

select Name, count(distinct language) as Idiomas
from CountryLanguage as CL
inner join Country as C
	on CL.CountryCode=C.Code
group by Name;
go

/*
select Name, language
from CountryLanguage as CL
inner join Country as C
	on CL.CountryCode=C.Code
group by Name, language;
go
*/

--Número de juegos por plataforma y tipo

--Cuántos clientes han votado a cada juego, sacando todos los juegos

use VideoJuegos;
go

set dateformat dmy;
go

select Juego, count(distinct Puntuacion) as ClientesPuntuadores
from Juego as J
left join JuegoPlataforma as JP
	on J.IdJuego=JP.IdJuego
left join Puntuacion as P
	on JP.Id=P.idjuegoplataforma
/*inner join Cliente as C
	on P.Idcliente=C.id				No se pone ya que el enlace se hace con puntuación*/
group by juego
go

select *
from Juego as J
left join JuegoPlataforma as JP
	on J.IdJuego=JP.IdJuego
left join Puntuacion as P
	on JP.Id=P.idjuegoplataforma;
go


--Cuántos tipos tiene cada disco dando el título

use Discos;
go

set dateformat dmy;
go

/*
select *
from Disco as D
left join DiscoTipo as DT
	on D.IdDisco=DT.IdDisco
left join Tipo as T
	on DT.IdTipo=T.IdTipo
go

select Titulo, count(*), count(tipo), count(distinct tipo)
from Disco as D
left join DiscoTipo as DT
	on D.IdDisco=DT.IdDisco
left join Tipo as T
	on DT.IdTipo=T.IdTipo
group by Titulo;
go

select titulo, tipo
from Disco as D
left join DiscoTipo as DT
	on D.IdDisco=DT.IdDisco
left join Tipo as T
	on DT.IdTipo=T.IdTipo
group by titulo, tipo;
go*/

select Titulo, count(distinct IdTipo) as TotalTipo
from Disco as D
left join DiscoTipo as DT
	on D.IdDisco=DT.IdDisco
group by Titulo;
go

--Cuántas puntuaciones, suma y media tiene cada disco dando el título

use Discos;
go

set dateformat dmy;
go

/*
select *
from Disco as D
left join Puntuacion as P
	on D.IdDisco=P.iddisco;
go

select titulo, Puntuacion
from Puntuacion as P
left join Disco as D
	on P.iddisco=D.IdDisco
order by titulo
go
*/

select Titulo, count(Id) as TotalPuntuaciones, sum(Puntuacion) as SumaPuntuaciones, avg(Puntuacion) as MediaPuntuaciones
from Disco as D
left join Puntuacion as P
	on D.IdDisco=P.iddisco
group by titulo, Puntuacion
order by SumaPuntuaciones desc;
go

--Igual sacando todos los discos