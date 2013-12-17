CREATE OR REPLACE TYPE fecha OBJECT(
	dia VARCHAR(2),
	mes VARCHAR(3),
  	año VARCHAR(4)
);
/
CREATE OR REPLACE TYPE direccion OBJECT(
	calle VARCHAR(50),
	ciudad VARCHAR(50),
  	estado VARCHAR(50)
	codPost VARCHAR(50),
	pais VARCHAR(50)
);
/
CREATE OR REPLACE TYPE visitante  OBJECT(
	nombre1 VARCHAR(50),
	nombre2 VARCHAR(50),
	ci VARCHAR(10),
	email VARCHAR(50),
	fecha_nac fecha,
	sexo VARCHAR(1),
	ocupacion VARCHAR(50),
	tlf movil VARCHAR(11),
	flf fijo VARCHAR(11),
	direccion direccion,
	nacionalidad VARCHAR(50),
	edo_civil VARCHAR(50)
		
);
/
CREATE OR REPLACE TYPE ruta OBJECT(
	nombre VARCHAR(50),
	ciudad VARCHAR(50),
	disponible VARCHAR(10),
	tiempo_recorrido VARCHAR(50),
	total_visitas VARCHAR(1),
	horario_recom VARCHAR(50),
	fecha_reg_bd fecha,
	rating VARCHAR(11)
		
);
/
CREATE OR REPLACE TYPE hito OBJECT(
	nombre VARCHAR(50),
	categoria VARCHAR(50),
	horario VARCHAR(10),
	estado VARCHAR(50),
	total_visitas VARCHAR(1),
	fecha_apertura fecha,
	fecha_cierre fecha
);
/
CREATE OR REPLACE TYPE via OBJECT(
	nombre VARCHAR(50),
	tipo VARCHAR(50),
	abierto VARCHAR(10),
	peatones VARCHAR(50),
	automoviles VARCHAR(50)
		
);
/
CREATE OR REPLACE TYPE ubicacion OBJECT(
	coordenada VARCHAR(50),
	altura VARCHAR(50)
		
);
/
CREATE OR REPLACE TYPE ubicacion OBJECT(
	tipo VARCHAR(50),
	reportado VARCHAR(50)
		
);
/