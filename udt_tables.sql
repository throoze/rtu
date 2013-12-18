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
    EXECUTE IMMEDIATE 'DROP TABLE Turista';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Hito';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Servicio';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Destino';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Ruta';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Guia';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Ofrece';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Subhito';
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
  CONSTRAINT C_TURISTA_APELLIDO CHECK (apellido LIKE '^[a-zA-Z]{1,20}'),                  --String valido
  CONSTRAINT C_TURISTA_CONTRASENA CHECK (contrasena LIKE '^[a-zA-Z]{1,8}'),               --String valido
  -- CONSTRAINT C_TURISTA_ CHECK (fechaRegistro <= (SELECT CURRENT_DATE FROM dual)),      --fechaRegistro menor o igual que fecha actual
  CONSTRAINT C_TURISTA_GENERO CHECK (genero IN ('Hombre', 'Mujer')),                   
  CONSTRAINT C_TURISTA_MAIL CHECK (mail LIKE '([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})'), --Mail valido
  CONSTRAINT C_TURISTA_NOMBRE CHECK (nombre LIKE '^[a-zA-Z]{1,20}'),                      --String valido
  CONSTRAINT C_TURISTA_USERNAME CHECK (username LIKE '^[a-zA-Z]{1,20}')                   --String valido
) NESTED TABLE tipoHitosPreferidos STORE AS turista_hitos;

CREATE TABLE Hito OF hito_t (
  estado      NOT NULL,
  publico     NULL,
  temperatura NOT NULL,
  vestimenta  NOT NULL,
  CONSTRAINT C_HITO_ESTADO CHECK (estado IN ('Abierto', 'Cerrado Permanentemente', 'Cerrado Temporalmente'))
) NESTED TABLE pago STORE AS hito_pago 
  NESTED TABLE categoria STORE AS hito_categoria;

CREATE TABLE Servicio OF servicio_t (
  estado              NOT NULL,              
  duracion            NULL,
  fechaInicio         NULL,
  fechaFin            NULL,
  horaComienzo        NOT NULL,
  dia                 NULL,
  CONSTRAINT C_SERVICIO_ESTADO CHECK (estado IN ('Disponible', 'No Disponible')),
  CONSTRAINT C_SERVICIO_FECHAS CHECK (fechaInicio <= fechaFin)
) NESTED TABLE costo STORE AS servicio_costo
  NESTED TABLE informacionContacto STORE AS servicio_informacion
  NESTED TABLE tipo STORE AS servicio_tipo;

CREATE TABLE Destino OF destino_t (
  descripcion         NOT NULL,
  nombre              NOT NULL,
  CONSTRAINT PK_DESTINO PRIMARY KEY (nombre),
);

CREATE TABLE Ruta OF ruta_t (
  fechaRegistro       NOT NULL,
  nombre              NOT NULL,
  -- CONSTRAINT C_RUTA_FECHA_REGISTRO CHECK (fechaRegistro <= (SELECT CURRENT_DATE FROM dual)),       --fechaRegistro menor o igual que fecha actual
  CONSTRAINT PK_RUTA PRIMARY KEY (nombre),
  CONSTRAINT C_RUTA_FECHA_REGISTRO CHECK (nombre LIKE '^[a-zA-Z]{1,20}')     --String valido
) NESTED TABLE tipo STORE AS ruta_tipoHito;

CREATE TABLE Guia OF guia_t (
  CONSTRAINT PK_GUIA PRIMARY KEY (username)
) NESTED TABLE idiomas STORE AS guia_idiomas
  NESTED TABLE telefonos STORE AS guia_telefonos;


CREATE TABLE Ofrece (
  hito      REF hito_t SCOPE IS Hito,
  servicio  REF servicio_t SCOPE IS Servicio,
  CONSTRAINT FK_HITO FOREIGN KEY (hito),
  CONSTRAINT FK_SERVICIO FOREIGN KEY (servicio)
);

CREATE TABLE Subhito (
  contiene  REF hito_t SCOPE IS Hito,
  contenido REF hito_t SCOPE IS Hito,
  CONSTRAINT FK_HITO_CONTIENE FOREIGN KEY (contiene),
  CONSTRAINT FK_HITO_CONTENIDO FOREIGN KEY (contenido)
);