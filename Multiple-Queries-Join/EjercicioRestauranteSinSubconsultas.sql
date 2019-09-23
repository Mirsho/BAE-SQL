--EjercicioRestauranteSinSubconsultas
--Adrián Perera Hernández

use Restaurante;
go

set dateformat dmy;
go

--Consulta de todos los registros uniendo todas las tablas:
select *
from comida
inner join Mesa 
	on comida.CodMesa=mesa.CodMesa
inner join detallecomida 
	on comida.IdComida=DetalleComida.IdComida
inner join Plato 
	on plato.CodPlato=DetalleComida.CodPlato
inner join TipoPlato 
	on plato.CodTipoPlato=tipoplato.CodTipoPlato;
go

--1.- Contar cuántos platos se han servido por Tipo de Plato (la descripción del Tipo de plato).

select TipoPlato, count(*) as PlatosServidos
from TipoPlato as tp
inner join Plato as p
	on tp.CodTipoPlato=p.CodTipoPlato
inner join DetalleComida as dc
	on p.CodPlato=dc.CodPlato
where servido = 'S'
group by TipoPlato
order by PlatosServidos desc;
go

--2.- Contar las comidas servidas en las mesas, sacando todas las mesas.

--Corrección:
select m.CodMesa, count(IdComida) as NumComidas
from Mesa as m
left join Comida as c
	on m.CodMesa=c.CodMesa
group by m.CodMesa;
go

--Corrección 2
select m.CodMesa, count(IdComida) as ComidasServidasMesa
from Mesa as m
left join Comida as c
	on m.CodMesa=c.CodMesa
group by m.CodMesa
order by ComidasServidasMesa desc;
go

select m.CodMesa, count(*) as ComidasServidasMesa
from Mesa as m
left join Comida as c
	on m.CodMesa=c.CodMesa
left join DetalleComida as dc
	on c.IdComida=dc.IdComida
where servido = 'S'
group by m.CodMesa
order by ComidasServidasMesa desc;
go

--3.- Dar la mesa y la fecha de la comida que más platos consumió del tipo de plato carnes, sacándolas todas si hay más de una.

select top 1 with ties count(servido) as PlatosServidos, m.CodMesa, Fecha
from Mesa as m
left join Comida as c
	on m.CodMesa=c.CodMesa
left join DetalleComida as dc
	on c.IdComida=dc.IdComida
left join Plato as p
	on dc.CodPlato=p.CodPlato
where (servido = 'S') and (CodTipoPlato=5)
group by m.CodMesa, Fecha, Servido
order by PlatosServidos desc;
go

--4.- Comidas pagadas (dando mesa y fecha) que han consumido algo de bebidas. 

select c.IdComida, CodMesa, fecha
from Comida as c
left join DetalleComida as dc
	on c.IdComida=dc.IdComida
left join Plato as p
	on dc.CodPlato=p.CodPlato
left join TipoPlato as tp
	on p.CodTipoPlato=tp.CodTipoPlato
where (Pagado = 'S') and (tp.Agrupa = 'Bebida')
group by c.IdComida, CodMesa, fecha;
go

--5.- Importe total de las comidas pagadas de las mesas que comienzan con A.

select sum(dc.PrecioPlato) as ImporteTotal, CodMesa
from Comida as c
left join DetalleComida as dc
	on c.IdComida=dc.IdComida
where (Pagado = 'S') and (CodMesa like 'A%')
group by CodMesa;
go

select sum(dc.PrecioPlato) as ImporteTotal
from Comida as c
left join DetalleComida as dc
	on c.IdComida=dc.IdComida
where (Pagado = 'S') and (CodMesa like 'A%')
go

--6.- Día de la semana con mayor facturación.

select top 1 datename(dw, Fecha) as DiaMaxFacturacion, sum(dc.PrecioPlato) as ImporteTotal
from Comida as c
left join DetalleComida as dc
	on c.IdComida=dc.IdComida
where (Pagado = 'S')
group by datename(dw, Fecha)			--es muy raro agrupar por Fecha.
order by ImporteTotal desc;
go

--7.- Tipo de plato (dando la descripción del tipo de plato) que no sea bebida y que menos veces se ha pedido.

select top 1 with ties TipoPlato, count(Servido) as MenosPedido	--count(*) as MenosPedido sería más correcto.
from TipoPlato as tp
inner join Plato as p
	on tp.CodTipoPlato=p.CodTipoPlato
inner join DetalleComida as dc
	on p.CodPlato=dc.CodPlato
where (servido = 'S') and (Agrupa != 'Bebida')	--El profesor puso el simbolo <> para "distinto de", este signo se usaba anteiguamente.
group by TipoPlato
order by MenosPedido asc;
go

--8.- Para cada plato, dando su nombre y sacándolos todos, indicar el nº de comidas en las que ha aparecido.

select Plato, count(distinct idComida) as ComidasServido
from Plato as p
left join DetalleComida as dc
	on p.CodPlato=dc.CodPlato
group by Plato
order by ComidasServido desc;
go

--CONSEJO: Ahorrarse las tablas de las cuales no necesitamos ningn dato.

--9.- Calcular el plato con mayor diferencia entre lo que se cobró y el precio actual (de la tabla Plato).

select top 1 Plato, (max(PrecioPlato) - Precio) as DiferenciaPrecio
from Plato as p
inner join DetalleComida as dc
	on p.CodPlato=dc.CodPlato
group by Plato, Precio, PrecioPlato		--No tiene porqué agruparse.
order by DiferenciaPrecio desc;
go

/*	CONSULTA DE COMPROBACIÓN
select top 1 Plato, max(PrecioPlato) as PrecioCobrado, Precio, (max(PrecioPlato) - Precio) as DiferenciaPrecio
from Plato as p
inner join DetalleComida as dc
	on p.CodPlato=dc.CodPlato
group by Plato, Precio, PrecioPlato
order by DiferenciaPrecio desc;
go
*/

--10.- Sacar la estadística por días, incluyendo nº platos (incluyendo bebidas), el nº de comidas realizadas y el importe de los platos (incluyendo bebidas).

select Fecha,  count(distinct c.IdComida) as TotalComidas, count(CodPlato) as TotalPlatos, sum(PrecioPlato) as PrecioTotal
from Comida as c
inner join DetalleComida as dc
	on c.IdComida=dc.IdComida
group by Fecha;
go

/* CONSULTAS DE COMPROBACIÓN - Día 18 del 2 del 2012
set dateformat dmy;
go
select Fecha,  count(dc.CodPlato), p.Plato, dc.PrecioPlato
from Comida as c
inner join DetalleComida as dc
	on c.IdComida=dc.IdComida
inner join Plato as p
	on dc.CodPlato=p.CodPlato
where (fecha =  '18/02/2012')
group by fecha, dc.CodPlato, p.Plato, dc.PrecioPlato;
go

set dateformat dmy;
go
select Fecha,  dc.CodPlato, p.Plato, dc.PrecioPlato
from Comida as c
inner join DetalleComida as dc
	on c.IdComida=dc.IdComida
inner join Plato as p
	on dc.CodPlato=p.CodPlato
where (fecha =  '18/02/2012')
order by p.Plato asc;
go
*/