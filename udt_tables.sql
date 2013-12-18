/* CI-5311 Paradigmas de modelado de bases de datos
 * Septiembre-Diciembre 2013
 * Entrega 3
 *
 * Autores: Alberto Cols    09-10177 <betocolsf@gmail.com>
 *          Victor De Ponte 05-38087 <rdbvictor19@gmail.com>
 *          Ivan Travecedo  08-11131 <ivantrave@gmail.com>
 *
 */

 -- Tables

-- Drop para tablas
BEGIN
    -- Colocar aqui todos los drops de la forma:
    -- EXECUTE IMMEDIATE 'DROP TABLE <nombre_de_la_tabla>';
    EXECUTE IMMEDIATE 'DROP TABLE Turista';
    EXECUTE IMMEDIATE 'DROP TABLE Hito';
    EXECUTE IMMEDIATE 'DROP TABLE Servicio';
    EXECUTE IMMEDIATE 'DROP TABLE Destinos';
    EXECUTE IMMEDIATE 'DROP TABLE Rutas';
    EXECUTE IMMEDIATE 'DROP TABLE Guia';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE Turista OF turista_t (
  activo              NOT NULL,
  apellido            NOT NULL,
  contrasena          NOT NULL,
  fechaRegistro       NOT NULL,
  genero              NOT NULL,
  mail                NOT NULL,
  nombre              NOT NULL,
  username            NOT NULL,
  CONSTRAINT PK_TURISTA PRIMARY KEY (username),
  CHECK (apellido LIKE '^[a-zA-Z]{1,20}'),                      --String valido
  CHECK (contrasena LIKE '^[a-zA-Z]{1,8}'),                     --String valido
  -- CHECK (fechaRegistro <= (SELECT CURRENT_DATE FROM dual)),                           --fechaRegistro menor o igual que fecha actual
  CHECK (genero IN ('Hombre', 'Mujer')),                   
  CHECK (mail LIKE '([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})'), --Mail valido
  CHECK (nombre LIKE '^[a-zA-Z]{1,20}'),                        --String valido
  CHECK (username LIKE '^[a-zA-Z]{1,20}')                       --String valido
) NESTED TABLE tipoHitosPreferidos STORE AS turista_hitos;

CREATE TABLE Hito OF hito_t (
  estado      NOT NULL,
  publico     NULL,
  temperatura NOT NULL,
  vestimenta  NOT NULL,
  CHECK (estado IN ('Abierto', 'Cerrado Permanentemente', 'Cerrado Temporalmente'))
) NESTED TABLE pago STORE AS hito_pago 
  NESTED TABLE categoria STORE AS hito_categoria;

CREATE TABLE Servicio OF servicio_t (
  estado              NOT NULL,              
  duracion            NULL,
  fechaInicio         NULL,
  fechaFin            NULL,
  horaComienzo        NOT NULL,
  dia                 NULL,
  CHECK (estado IN ('Disponible', 'No Disponible')),
  CHECK (fechaInicio <= fechaFin)
) NESTED TABLE costo STORE AS servicio_costo
  NESTED TABLE informacionContacto STORE AS servicio_informacion
  NESTED TABLE tipo STORE AS servicio_tipo;

CREATE TABLE Destinos OF destino_t (
  descripcion         NOT NULL,
  nombre              NOT NULL
);

CREATE TABLE Rutas OF ruta_t (
  fechaRegistro       NOT NULL,
  nombre              NOT NULL,
  -- CHECK (fechaRegistro <= (SELECT CURRENT_DATE FROM dual)),       --fechaRegistro menor o igual que fecha actual
  CHECK (nombre LIKE '^[a-zA-Z]{1,20}')     --String valido
) NESTED TABLE tipo STORE AS rutas_tipoHito;

CREATE TABLE Guia OF guia_t (
) NESTED TABLE idiomas STORE AS guia_idiomas
  NESTED TABLE telefonos STORE AS guia_telefonos;

