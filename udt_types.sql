/* CI-5311 Paradigmas de modelado de bases de datos
 * Septiembre-Diciembre 2013
 * Entrega 3
 *
 * Autores: Alberto Cols    09-10177 <betocolsf@gmail.com>
 *          Victor De Ponte 05-38087 <rdbvictor19@gmail.com>
 *          Ivan Travecedo  08-11131 <ivantrave@gmail.com>
 *
 * Descripcion: Contiene la creacion de los tipos de datos
 *              del modelo
 * 
 */

-- DROP de tipos si existen
DROP TYPE tabla_compone_t FORCE;
DROP TYPE compone_t FORCE;
DROP TYPE ofrece_t FORCE;
DROP TYPE subhito_t FORCE;
DROP TYPE tabla_conduce_t FORCE;
DROP TYPE conduce_t FORCE;
DROP TYPE tabla_dirige_t FORCE;
DROP TYPE dirige_t FORCE;
DROP TYPE tabla_ruta_t FORCE;
DROP TYPE ruta_t FORCE;
DROP TYPE hito_t FORCE;
DROP TYPE servicio_t FORCE;
DROP TYPE tabla_tipoServicio_t FORCE;
DROP TYPE lista_dias_t FORCE;
DROP TYPE tabla_informacion_t FORCE;
DROP TYPE informacion_t FORCE;
DROP TYPE tabla_costo_t FORCE;
DROP TYPE costo_t FORCE;
DROP TYPE destino_t FORCE;
DROP TYPE tabla_guia_t FORCE;
DROP TYPE guia_t FORCE;
DROP TYPE tabla_turista_t FORCE;
DROP TYPE turista_t FORCE;
DROP TYPE tabla_telefonos_t FORCE;
DROP TYPE tabla_idiomas_t FORCE;
DROP TYPE tabla_tipoHito_t FORCE;




-- Tipo para manejar la coleccion de "tipos de hito" de un hito
CREATE OR REPLACE TYPE tabla_tipoHito_t AS TABLE of VARCHAR2(20);
/

-- Tipo para manejar la coleccion de idiomas de un guia
CREATE OR REPLACE TYPE tabla_idiomas_t AS TABLE of VARCHAR2(20);
/

-- Tipo para manejar la coleccion de numeros de telefono de 
-- un guia
CREATE OR REPLACE TYPE tabla_telefonos_t AS TABLE of NUMBER;
/

-- Tipo objeto turista
CREATE OR REPLACE TYPE turista_t AS OBJECT (
  activo              VARCHAR2(2),
  apellido            VARCHAR2(30),
  contrasena          VARCHAR2(20),
  fechaRegistro       DATE,
  genero              VARCHAR2(6),
  mail                VARCHAR2(30),
  tipoHitosPreferidos tabla_tipoHito_t,
  nombre              VARCHAR2(30),
  username            VARCHAR2(20),
  MEMBER FUNCTION calcularExperiencia RETURN NUMBER
  --Argumento de entrada es Evaluable pero dicha tabla no esta creada puesto que no forma parte de nuestro subconjunto.
) NOT FINAL;
/

CREATE OR REPLACE TYPE tabla_turista_t AS TABLE of REF turista_t;
/

-- Tipo guia que hereda de turista
CREATE OR REPLACE TYPE guia_t UNDER turista_t (
  idiomas   tabla_idiomas_t,
  telefonos tabla_telefonos_t
);
/

CREATE OR REPLACE TYPE tabla_guia_t AS TABLE of REF guia_t;
/

-- Tipo objeto destino
CREATE OR REPLACE TYPE destino_t AS OBJECT (
  descripcion VARCHAR2(100),
  nombre      VARCHAR2(30)
) NOT FINAL;
/

-- Tipo objeto para manejo de costos asociados
-- a un tipo de publico determinado
CREATE OR REPLACE TYPE costo_t AS OBJECT (
  publico VARCHAR2(20),
  monto   NUMBER
);
/
-- Tipo para manejar una coleccion de referencias a costos
CREATE OR REPLACE TYPE tabla_costo_t AS TABLE of REF costo_t;
/

-- Tipo objeto para manejo de informacion de servicios
CREATE OR REPLACE TYPE informacion_t AS OBJECT (
  tipo      VARCHAR2(20),
  contacto  VARCHAR2(100)
);
/

-- Tipo para manejar una coleccion de referencias a
-- informacion de servicios
CREATE OR REPLACE TYPE tabla_informacion_t AS TABLE of REF informacion_t;
/

-- Tipo para manejar un VARRAY de dias de la semana
CREATE OR REPLACE TYPE lista_dias_t AS VARRAY(7) of VARCHAR2(10);
/

-- Tipo para manejar una coleccion de tipos de servicios
CREATE OR REPLACE TYPE tabla_tipoServicio_t AS TABLE of VARCHAR2(20);
/

-- Tipo para servicio, hereda del tipo destino
CREATE OR REPLACE TYPE servicio_t UNDER destino_t (
  costo               tabla_costo_t,
  estado              VARCHAR2(13),
  informacionContacto tabla_informacion_t,
  tipo                tabla_tipoServicio_t,
  dia                 lista_dias_t,
  duracion            DATE,
  fechaInicio         DATE,
  fechaFin            DATE,
  horaComienzo        DATE
);
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

-- Tipo objeto para ruta
CREATE OR REPLACE TYPE ruta_t AS OBJECT (
  fechaRegistro  DATE,
  nombre         VARCHAR2(30),
  tipo           tabla_tipoHito_t,
  creador        REF turista_t,
  
  --Método que calcula el costo total, dada la lista de costos del Guía y la lista de costos de los hitos.
  MEMBER FUNCTION calcularCostoTotal(costosGuia IN tabla_costo_t, costoHito IN tabla_costo_t) RETURN NUMBER,
  
  -- Argumento de entrada es Vias pero dicha tabla no esta creada, puesto que no forma parte de nuestro subconjunto.
  MEMBER FUNCTION calcularDistanciaTotal RETURN NUMBER,
  
  -- Método para obtener los guías que están disponibles para dirigir esta ruta.
  MEMBER FUNCTION guiasDisponibles RETURN tabla_guia_t,
  
  -- Método que devuelve todos los guías que han conducido esta ruta alguna vez.
  MEMBER FUNCTION guiasQueCondujeron RETURN tabla_guia_t,
  
  -- Método para obtener todos los guías que conducen esta ruta en una fecha dada.
  MEMBER FUNCTION guiasPorFecha(f IN DATE) RETURN tabla_guia_t,

  -- Método para obtener los guías que han conducido a un turista dado en esta ruta.
  MEMBER FUNCTION guiasPorTurista(t IN turista_t) RETURN tabla_guia_t,
  
  -- Metodo que devuelve todos los visitantes que han hecho esta ruta alguna vez.
  MEMBER FUNCTION obtenerVisitantes RETURN tabla_turista_t,
  
  -- Método que devuelve todos los turistas a los cuales un guía dado los condujo por esta ruta.
  MEMBER FUNCTION visitantesPorGuia(g IN guia_t) RETURN tabla_turista_t,
);
/

--Tipo que es una tabla de referencias a rutas para ser usado en 
--la operacion buscarRutas()
CREATE OR REPLACE TYPE tabla_ruta_t AS TABLE of REF ruta_t;
/

-- Tipo objeto de la asociación dirige entre
-- guias y rutas
-- Guia dirige ruta
CREATE OR REPLACE TYPE dirige_t AS OBJECT (
  precios       tabla_costo_t,
  guia          REF guia_t,
  ruta          REF ruta_t
);
/

-- Colección de instancias de la relación dirige:
CREATE OR REPLACE TYPE tabla_dirige_t AS TABLE of REF dirige_t;
/

-- Tipo para la relación ternaria "conduce", entre Guia, Turista y Ruta:
-- Un Guia conduce a un Turista en una Ruta.
CREATE OR REPLACE TYPE conduce_t AS OBJECT (
  fecha         DATE,
  horaInicio    DATE,
  guia          REF guia_t,
  turista       REF turista_t,
  ruta          REF ruta_t
);
/

-- Colección de instancias de la relación conduce:
CREATE OR REPLACE TYPE tabla_conduce_t AS TABLE of REF conduce_t;
/

-- Tipo objeto de la asociacion recursiva que describe
-- si un hito esta contenido dentro de otro hito
CREATE OR REPLACE TYPE subhito_t AS OBJECT (
  contiene  REF hito_t,
  contenido REF hito_t
);
/

-- Tipo objeto de la asociacion ofrece entre hito
-- y servicio.
-- Un hito ofrece servicios
CREATE OR REPLACE TYPE ofrece_t AS OBJECT (
  hito      REF hito_t,
  servicio  REF servicio_t
);
/

-- Tipo objeto de la asociación "compone" entre hito y ruta
-- Uno o muchos hitos componen una o muchas rutas.
CREATE OR REPLACE TYPE compone_t AS OBJECT (
  hito      REF hito_t,
  ruta      REF ruta_t
);
/

-- Colección de instancias de la relación conduce:
CREATE OR REPLACE TYPE tabla_compone_t AS TABLE of REF compone_t;
/

-- A continuación se especican más métodos que requieren de la pre existencia de algunos tipos para compilar correctamente:

-- Añadimos un método a turista_t, ahora que disponemos del tipo tabla_ruta_t.
-- Este método devuelve la lista de rutas en las cuales ha participado el turista.
ALTER TYPE turista_t ADD MEMBER FUNCTION buscarRutas RETURN tabla_ruta_t CASCADE;

-- Devuelve las rutas que el guia puede dirigir, junto con los costos asociados.
ALTER TYPE guia_t ADD MEMBER FUNCTION rutasDisponibles RETURN tabla_dirige_t CASCADE;

-- Devuelve todos los turistas guiados por el guia, junto a la ruta, fecha y hora asociada.
ALTER TYPE guia_t ADD MEMBER FUNCTION turistasGuiados RETURN tabla_conduce_t CASCADE;

-- Devuelve todos los turistas guiados en una fecha dada, junto a la ruta y hora asociada.
ALTER TYPE guia_t ADD MEMBER FUNCTION turistasPorFecha(f IN DATE) RETURN tabla_conduce_t CASCADE;

-- Devuelve todas las rutas guiadas por el guia, junto a los turistas, fecha y hora asociada.
ALTER TYPE guia_t ADD MEMBER FUNCTION rutasGuiadas RETURN tabla_conduce_t CASCADE;

-- Devuelve todas las rutas guiadas en una fecha dada, junto a los turistas y hora asociada.
ALTER TYPE guia_t ADD MEMBER FUNCTION rutasPorFecha(f IN DATE) RETURN tabla_conduce_t CASCADE;

-- Devuelve todas las rutas guiadas para un turista dado, junto a la fecha y hora asociada.
ALTER TYPE guia_t ADD MEMBER FUNCTION rutasPorTurista(r IN turista_t) RETURN tabla_conduce_t CASCADE;

-- Método que devuelve todos los Hitos que componen esta ruta.
ALTER TYPE ruta_t ADD MEMBER FUNCTION obtenerHitos RETURN tabla_compone_t CASCADE;

-- Método que devuelve todas las Rutas de las cuales forma parte este Hito.
ALTER TYPE hito_t ADD MEMBER FUNCTION obtenerRutas RETURN tabla_compone_t CASCADE;