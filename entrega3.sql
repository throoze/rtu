/* Entrega 3
 * Autores: Alberto Cols
 *          Victor De Ponte
 *          Ivan Travecedo  08-11131
 *
 *
 * NOTA: REVISAR NULL/NOT NULL para atributos y colocarlos
 *       La temperatura estara expresada en en un numero sin unidades?
 *       No he colocado ninguno de los atributos derivados
 *       Add constrains para primary key
 */

-- Tipo de datos

DROP TYPE tabla_tipoHito FORCE;
DROP TYPE tabla_idiomas FORCE;
DROP TYPE tabla_telefonos FORCE;
DROP TYPE turista FORCE;
DROP TYPE guia FORCE;
DROP TYPE destino FORCE;
DROP TYPE costo FORCE;
DROP TYPE tabla_costo FORCE;
DROP TYPE informacion FORCE;
DROP TYPE tabla_informacion FORCE;
DROP TYPE lista_dias FORCE;
DROP TYPE servicio FORCE;
DROP TYPE hito FORCE;
DROP TYPE ruta FORCE;


-- Tipo que es una tabla de referencias a tipos de hito
CREATE OR REPLACE TYPE tabla_tipoHito_t AS TABLE of VARCHAR2(20);
/

-- Tipo que es una tabla de referencias a idiomas
CREATE OR REPLACE TYPE tabla_idiomas_t AS TABLE of VARCHAR2(20);
/

-- Tipo que es una tabla de referencias a telefonos
CREATE OR REPLACE TYPE tabla_telefonos_t AS TABLE of NUMBER;
/

-- Tipo turista
CREATE OR REPLACE TYPE turista_t AS OBJECT (
  activo              VARCHAR2(2),
  apellido            VARCHAR2(30),
  contrasena          VARCHAR2(20),
  fechaRegistro       DATE,
  genero              VARCHAR2(6),
  mail                VARCHAR2(30),
  tipoHitosPreferidos tabla_tipoHito_t,
  nombre              VARCHAR2(30),
  username            VARCHAR2(20)
) NOT FINAL;
/


-- Tipo guia
CREATE OR REPLACE TYPE guia_t UNDER turista_t (
  idiomas   tabla_idiomas_t,
  telefonos tabla_telefonos_t
);
/

-- Tipo destino
CREATE OR REPLACE TYPE destino_t AS OBJECT (
  descripcion VARCHAR2(100),
  nombre      VARCHAR2(30)
) NOT FINAL;
/

-- Tipo para tipos de hito
CREATE OR REPLACE TYPE costo_t AS OBJECT (
  publico VARCHAR2(20),
  monto   NUMBER
);
/
-- Tipo que es una tabla de referencias a costos
CREATE OR REPLACE TYPE tabla_costo_t AS TABLE of REF costo_t;
/

-- Tipo para tipos de hito
CREATE OR REPLACE TYPE informacion_t AS OBJECT (
  tipo      VARCHAR2(20),
  contacto  VARCHAR2(100)
);
/

-- Tipo que es una tabla de referencias a costos
CREATE OR REPLACE TYPE tabla_informacion_t AS TABLE of REF informacion_t;
/

CREATE OR REPLACE TYPE lista_dias_t AS VARRAY(7) of VARCHAR2(10);
/

-- Tipo para servicio
CREATE OR REPLACE TYPE servicio_t UNDER destino_t (
  costo               tabla_costo_t,
  estado              VARCHAR2(13),
  informacionContacto tabla_informacion_t,
  tipo                VARCHAR2(20),
  dia                 lista_dias_t,
  duracion            DATE,
  fechaInicio         DATE,
  fechaFin            DATE,
  horaComienzo        DATE
);
/

-- Tipo para hito
CREATE OR REPLACE TYPE hito_t AS OBJECT (
  categoria   tabla_tipoHito_t,
  estado      VARCHAR2(30),
  pago        tabla_costo_t,
  publico     VARCHAR2(30),
  temperatura NUMBER,
  vestimenta  VARCHAR2(30)
);
/

-- Tipo para ruta
CREATE OR REPLACE TYPE ruta_t AS OBJECT (
  fechaRegistro  DATE,
  nombre         VARCHAR2(30),
  tipo           tabla_tipoHito_t,
  creador        REF turista_t
);
/