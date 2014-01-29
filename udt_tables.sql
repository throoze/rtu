/* CI-5311 Paradigmas de modelado de bases de datos
 * Septiembre-Diciembre 2013
 * Entrega 3
 *
 * Autores: Alberto Cols    09-10177 <betocolsf@gmail.com>
 *          Victor De Ponte 05-38087 <rdbvictor19@gmail.com>
 *          Ivan Travecedo  08-11131 <ivantrave@gmail.com>
 *
 * Descripcion: Creacion de las tablas del modelo. Todos los
 *              tipos aqui definidos se encuentran en el 
 *              archivo udt_types.sql
 */

 -- Tables

-- Drop para tablas
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

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Dirige';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Conduce';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

-- BEGIN
--     EXECUTE IMMEDIATE 'DROP TABLE Compone';
-- EXCEPTION
--     WHEN OTHERS THEN
--       IF SQLCODE != -942 THEN
--          RAISE;
--       END IF;
-- END;
-- /

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
    EXECUTE IMMEDIATE 'DROP TABLE Inverso_hito_ruta';
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

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Costo';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Informacion';
EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

-- Tabla Turista de objetos de tipo turista_t
-- Contiene NESTED TABLE correspondiente a
--    coleccion de hitos preferidos por el turista
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
  --CONSTRAINT C_TURISTA_APELLIDO CHECK (apellido LIKE '^[a-zA-Z]{1,20}'),                  --String valido
  --CONSTRAINT C_TURISTA_CONTRASENA CHECK (contrasena LIKE '^[a-zA-Z]{1,8}'),               --String valido
  -- CONSTRAINT C_TURISTA_ CHECK (fechaRegistro <= (SELECT CURRENT_DATE FROM dual)),      --fechaRegistro menor o igual que fecha actual
  CONSTRAINT C_TURISTA_GENERO CHECK (genero IN ('Hombre', 'Mujer'))                   
  --CONSTRAINT C_TURISTA_MAIL CHECK (mail LIKE '([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})'), --Mail valido
  --CONSTRAINT C_TURISTA_NOMBRE CHECK (nombre LIKE '^[a-zA-Z]{1,20}')                      --String valido
  --CONSTRAINT C_TURISTA_USERNAME CHECK (username LIKE '^[a-zA-Z]{1,20}')                   --String valido
) OBJECT ID PRIMARY KEY
  NESTED TABLE tipoHitosPreferidos STORE AS turista_hitos;

-- Tabla Hito de objetos de tipo hito_t
-- Contiene NESTED TABLE correspondiente a la
-- coleccion de pagos del hito
-- Contiene NESTED TABLE correspondiente a la
-- coleccion de categorias a las que pertenece
CREATE TABLE Hito OF hito_t (
  estado      NOT NULL,
  publico     NULL,
  temperatura NOT NULL,
  vestimenta  NOT NULL,
  CONSTRAINT  PK_HITO PRIMARY KEY (nombre),
  CONSTRAINT C_HITO_ESTADO CHECK (estado IN ('Abierto', 'Cerrado Permanentemente', 'Cerrado Temporalmente'))
) OBJECT ID PRIMARY KEY
  NESTED TABLE pago STORE AS hito_pago 
  NESTED TABLE categoria STORE AS hito_categoria;

-- Tabla Servicio de objetos de tipo servicio_t
-- Contiene NESTED TABLE correspondiente a coleccion de:
--    costos del servicio
--    informaciones de contacto del servicio
--    tipos del servicio
CREATE TABLE Servicio OF servicio_t (
  estado              NOT NULL,              
  duracion            NULL,
  fechaInicio         NULL,
  fechaFin            NULL,
  horaComienzo        NOT NULL,
  dia                 NULL,
  CONSTRAINT PK_SERVICIO PRIMARY KEY (nombre),
  CONSTRAINT C_SERVICIO_ESTADO CHECK (estado IN ('Disponible', 'No Disponible')),
  CONSTRAINT C_SERVICIO_FECHAS CHECK (fechaInicio <= fechaFin)
) OBJECT ID PRIMARY KEY
  NESTED TABLE costo STORE AS servicio_costo
  NESTED TABLE informacionContacto STORE AS servicio_informacion
  NESTED TABLE tipo STORE AS servicio_tipo;

-- Tabla Destino de objetos de tipo destino_t
CREATE TABLE Destino OF destino_t (
  descripcion         NOT NULL,
  nombre              NOT NULL,
  CONSTRAINT PK_DESTINO PRIMARY KEY (nombre)
)OBJECT ID PRIMARY KEY;

-- Tabla Ruta de objetos de tipo ruta_t
-- Contiene NESTED TABLE correspondiente a:
--    coleccion de tipos de hitos presentes en la ruta
CREATE TABLE Ruta OF ruta_t (
  fechaRegistro       NOT NULL,
  nombre              NOT NULL,
  CONSTRAINT PK_RUTA PRIMARY KEY (nombre),
  CONSTRAINT C_RUTA_FECHA_REGISTRO CHECK (nombre LIKE '^[a-zA-Z]{1,20}'),
  CONSTRAINT FK_RUTA_HITO FOREIGN KEY (creador) REFERENCES Turista
) OBJECT ID PRIMARY KEY
  NESTED TABLE tipo STORE AS ruta_tipoHito
  NESTED TABLE hitos STORE AS ruta_to_hitos;

-- ALTER TABLE Ruta ADD SCOPE FOR (creador) IS Turista;

-- Tabla Guia de objetos de tipo guia_t
-- Contiene NESTED TABLE correspondiente a coleccion de:
--    tipo de hitos que prefiere el guia
--    idiomas que maneja el guia
--    telefonos del guia
CREATE TABLE Guia OF guia_t (
  CONSTRAINT PK_GUIA PRIMARY KEY (username)
) OBJECT ID PRIMARY KEY
  NESTED TABLE tipoHitosPreferidos STORE AS guia_hitos_preferidos
  NESTED TABLE idiomas STORE AS guia_idiomas
  NESTED TABLE telefonos STORE AS guia_telefonos;

-- Tabla para manejar la relacion N:M entre hito y los
-- servicios que este ofrece
CREATE TABLE Ofrece OF ofrece_t (
  CONSTRAINT FK_HITO FOREIGN KEY (hito) references Hito,
  CONSTRAINT FK_SERVICIO FOREIGN KEY (servicio) references Servicio
);

-- Tabla para manejar la relacion N:M entre hito y otros hitos
-- que este contiene
CREATE TABLE Subhito OF subhito_t (
  CONSTRAINT FK_Subhito_contiene FOREIGN KEY (contiene) references Hito,
  CONSTRAINT FK_Subhito_contenido FOREIGN KEY (contenido) references Hito
);

-- Tabla para manejar la relación N:M entre guía y ruta, especificada por el 
-- tipo dirige_t
CREATE TABLE Dirige OF dirige_t (
  CONSTRAINT FK_DIRIGE_GUIA FOREIGN KEY (guia) REFERENCES Guia,
  CONSTRAINT FK_DIRIGE_RUTA FOREIGN KEY (ruta) REFERENCES Ruta
) NESTED TABLE precios STORE AS dirige_precios;

-- Tabla para manejar la relación ternaria que existe entre Guia, Ruta y
-- Turista
CREATE TABLE Conduce OF conduce_t (
  fecha               NOT NULL,
  horaInicio          NOT NULL,
  CONSTRAINT FK_CONDUCE_GUIA FOREIGN KEY (guia) REFERENCES Guia,
  CONSTRAINT FK_CONDUCE_TURISTA FOREIGN KEY (turista) REFERENCES Turista,
  CONSTRAINT FK_CONDUCE_RUTA FOREIGN KEY (ruta) REFERENCES Ruta
);

-- Tabla que maneja la relación N:M "compone" entre Hito y Ruta.
-- CREATE TABLE Compone OF compone_t (
--   CONSTRAINT FK_COMPONE_HITO FOREIGN KEY (hito) REFERENCES Hito,
--   CONSTRAINT FK_COMPONE_RUTA FOREIGN KEY (ruta) REFERENCES Ruta
-- );

CREATE TABLE Inverso_hito_ruta OF inverso_hito_ruta_t (
  CONSTRAINT FK_Inverso_hito_ruta FOREIGN KEY (hito) REFERENCES Hito
) NESTED TABLE rutas STORE AS Inverso_hito_ruta_rutas;

-- Tabla NUEVA para tener una tabla de costos
CREATE TABLE Costo of costo_t(
  publico NOT NULL,
  monto   NOT NULL,
  CONSTRAINT PK_COSTO PRIMARY KEY (publico, monto)
);

-- Tabla NUEVA para tener una tabla de costos
CREATE TABLE Informacion of informacion_t(
  tipo NOT NULL,
  contacto   NOT NULL,
  CONSTRAINT PK_Informacion PRIMARY KEY (tipo,contacto)
);