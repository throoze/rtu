-- Tipo objeto para manejo de costos asociados
-- a un tipo de publico determinado
CREATE OR REPLACE TYPE costo_t AS OBJECT (
  publico VARCHAR2(20),
  monto   NUMBER
);
/

-- Tipo para manejar la coleccion de "tipos de hito" de un hito
CREATE OR REPLACE TYPE tabla_tipoHito_t AS TABLE of VARCHAR2(20);
/


-- Tipo para manejar una coleccion de referencias a costos
CREATE OR REPLACE TYPE tabla_costo_t AS TABLE of REF costo_t;
/

-- Tipo objeto destino
CREATE OR REPLACE TYPE destino_t AS OBJECT (
  descripcion VARCHAR2(100),
  nombre      VARCHAR2(30)
) NOT FINAL;
/


-- Tipo para hito, hereda del tipo destino
CREATE OR REPLACE TYPE hito_t UNDER destino_t (
  categoria   tabla_tipoHito_t,
  estado      VARCHAR2(30),
  pago        tabla_costo_t,
  publico     VARCHAR2(30),
  temperatura NUMBER,
  vestimenta  VARCHAR2(30)
);
/

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