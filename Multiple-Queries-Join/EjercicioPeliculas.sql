--EjercicioPeliculas
--Adri�n Perera Hern�ndez

use peliculas;
go

set dateformat dmy;
go

--1.- Mostrar para todos los pr�stamos, el t�tulo, el director, los apellidos y nombre del cliente, el tipo de pel�cula, y la fecha de pr�stamo

select pr.IdPrestamo, p.Titulo, p.Director, tp.Tipo,
	DATENAME(DW, pr.FechaPrestamo) + ' ' + DATENAME(Day, pr.FechaPrestamo) + ' de ' + DATENAME(MONTH, pr.FechaPrestamo) 
	+ ' del ' + DATENAME(year, pr.FechaPrestamo) as FechaPrestamo,
	c.Apellidos, c.Nombre
from Peliculas as p
inner join Prestamo as pr
	on p.idPelicula=pr.idpelicula
inner join Clientes as c
	on pr.idcliente=c.IdCliente
inner join TipoPelicula as tp
	on p.idTipo=tp.IdTipo
order by p.Titulo asc;
go

--2.- Pr�stamos de pel�culas de pa�s US, tipo Actualidad y efectuadas el mes de noviembre. Dar nombre de cliente, fecha de pr�stamo y t�tulo de la pel�cula.

select Nombre, Titulo,
	DATENAME(DW, pr.FechaPrestamo) + ' ' + DATENAME(Day, pr.FechaPrestamo) + ' de ' + DATENAME(MONTH, pr.FechaPrestamo) 
	+ ' del ' + DATENAME(year, pr.FechaPrestamo) as FechaPrestamo
from Prestamo as pr
inner join Peliculas as p
	on pr.idpelicula=p.idPelicula
inner join TipoPelicula as tp
	on p.idTipo=tp.IdTipo
inner join Clientes as c
	on pr.idcliente=c.IdCliente
where (Pais = 'US') and (Tipo = 'Actualidad') and (DATEPART(month, FechaPrestamo) = 11)
go

--3.- Dar para todos los clientes con a�o de alta mayor que el a�o 1990. Indicar DNI, nombre y apellidos del cliente (en �nico campo de salida) y n� de pr�stamos realizados.

select c.DNICliente, (c.Nombre + ' ' + c.Apellidos) as NombreApellidos, count(pr.IdPrestamo) as NPrestamos
from Clientes as c
left join Prestamo as pr
	on c.IdCliente=pr.idcliente
where DATEPART(YEAR, FechaAlta) > 1990
group by c.DNICliente, c.Nombre, c.Apellidos
go

/* CONSULTA DE COMPROBACI�N
select *
from Clientes as c
left join Prestamo as pr
	on c.IdCliente=pr.idcliente
where DATEPART(YEAR, FechaAlta) > 1990
go
*/

--4.- Mostrar el t�tulo, el director, los apellidos y nombre del cliente, el tipo de pel�cula, y la fecha de pr�stamo del pr�stamo siguiente
--en orden de fecha al de fecha 30 de julio de 2012. Pista: Solo 1 prestamo siguiente a la fecha indicada.

select top 1 Titulo, Director, Apellidos, Nombre, Tipo, FechaPrestamo /*MOSTRAR SOLO 1 FECHA*/
from Peliculas as p
inner join Prestamo as pr
	on p.idPelicula=pr.idpelicula
inner join Clientes as c
	on pr.idcliente=c.IdCliente
inner join TipoPelicula as tp
	on p.idTipo=tp.IdTipo
where (pr.FechaPrestamo>'30/07/2012')
		--convert(datetime, '30/07/2012')    <---- Esto es lo que hace el SQL autom�ticamente.
order by pr.FechaPrestamo;
go

--5.- Para cada tipo de pel�cula dar el N�mero de pr�stamo e importe (diferencia en d�as entre fechaprestamo y fecha devolucion) multiplicado por el preciodiaefectuado. 

select tp.Tipo, count(*) as NumPrestamos,	--Count(*) cada vez que no hayan 
	sum(datediff (day, pr.FechaPrestamo, pr.FechaDevolucion) * pr.PrecioDiaEfectuado) as SumaPrestamos
from TipoPelicula as tp
inner join Peliculas as p
	on tp.IdTipo=p.idTipo
inner join Prestamo as pr
	on p.idPelicula=pr.idpelicula
group by tp.Tipo;
go

--6.- Clientes sin pr�stamos, dando dombre, apellidos y DNICliente

select Nombre + ' ' + Apellidos as NomApellidos, DNICliente
from Clientes as c
left join Prestamo as p
	on c.IdCliente=p.idcliente
where IdPrestamo is null;		--apuntamos al id ya que siempre ser� un indicador mejor y no puede ser nulo (en su tabla original).
go

/*
select Nombre, Apellidos, DNICliente
from Clientes as c
inner join Prestamo as p
	on c.IdCliente != p.idcliente
go
*/

--7.- N�mero de pr�stamos por mes por su nombre, pero ordenados por meses correlativos (Enero, febrero, marzo,...).

select datename (month, FechaPrestamo) as Mes, count(idPrestamo) as NumPrestamos
from Prestamo
group by datename (month, FechaPrestamo),
		datepart (MONTH, FechaPrestamo)
order by datepart (MONTH, FechaPrestamo) asc;
go

--8.- Pel�cula alquilada m�s veces, dando t�tulo y tipo.



--9.- Pr�stamos no devueltos en plazo (dar nombre de cliente, fecha de pr�stamo y t�tulo de la pel�cula)