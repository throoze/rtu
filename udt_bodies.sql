-- Método que devuelve todos los Hitos que componen esta ruta.
ALTER TYPE ruta_t ADD MEMBER FUNCTION obtenerHitos RETURN tabla_hito_t CASCADE;

-- Método que devuelve todas las Rutas de las cuales forma parte este Hito.
ALTER TYPE hito_t ADD MEMBER FUNCTION obtenerRutas RETURN tabla_ruta_t CASCADE;

-- Método que devuelve todos los Servicios ofrecidos en esta ruta esta ruta.
ALTER TYPE ruta_t ADD MEMBER FUNCTION obtenerServicios RETURN tabla_servicio_t CASCADE;

ALTER TYPE hito_t ADD STATIC PROCEDURE crearHito(descripcion IN VARCHAR2,
                                      nombre IN VARCHAR2,
                                      categorias IN tabla_tipoHito_t,
                                      estado IN VARCHAR2,
                                      cost IN lista_costos_t,
                                      publico IN VARCHAR2,
                                      temperatura IN NUMBER,
                                      vestimenta IN VARCHAR2) CASCADE;

DROP TABLE listaDeCostos;

CREATE GLOBAL TEMPORARY TABLE listaDeCostos (
  publico VARCHAR2(20),
  monto   NUMBER
);

DROP PROCEDURE nuevoHito;

CREATE OR REPLACE PROCEDURE nuevoHito(descripcion IN VARCHAR2,
                                      nombre IN VARCHAR2,
                                      categorias IN tabla_tipoHito_t,
                                      estado IN VARCHAR2,
                                      cost IN lista_costos_t,
                                      publico IN VARCHAR2,
                                      temperatura IN NUMBER,
                                      vestimenta IN VARCHAR2) AS
tabla_de_costos tabla_costo_t;
BEGIN
  FOR i IN cost.FIRST..cost.LAST
  LOOP
    INSERT INTO listaDeCostos VALUES (cost(i).publico,cost(i).monto);
  END LOOP;

  SELECT REF(c) bulk collect into tabla_de_costos FROM Costo c, listaDeCostos l
     WHERE c.publico = l.publico AND c.monto = l.monto;

INSERT INTO Hito VALUES (descripcion,nombre,categorias,estado,tabla_de_costos,publico,temperatura,vestimenta);
END nuevoHito;
/

CREATE TYPE BODY hito_t AS
  MEMBER FUNCTION obtenerRutas RETURN tabla_ruta_t IS
    r tabla_ruta_t;
  BEGIN
    RETURN r;
  END; 

  STATIC PROCEDURE crearHito(descripcion IN VARCHAR2,
                                      nombre IN VARCHAR2,
                                      categorias IN tabla_tipoHito_t,
                                      estado IN VARCHAR2,
                                      cost IN lista_costos_t,
                                      publico IN VARCHAR2,
                                      temperatura IN NUMBER,
                                      vestimenta IN VARCHAR2) IS 
  BEGIN
    nuevoHito(descripcion,nombre,categorias,estado,cost,publico,temperatura,vestimenta);
  END;

END;
/
CREATE TYPE BODY ruta_t AS
  --Método que calcula el costo total, dada la lista de costos del Guía y la lista de costos de los hitos.
  MEMBER FUNCTION calcularCostoTotal(costosGuia IN tabla_costo_t, costoHito IN tabla_costo_t) RETURN NUMBER IS
    n NUMBER := 0;
  BEGIN
    RETURN n;
  END;
  
  -- Argumento de entrada es Vias pero dicha tabla no esta creada, puesto que no forma parte de nuestro subconjunto.
  MEMBER FUNCTION calcularDistanciaTotal RETURN NUMBER IS
    n NUMBER := 0;
  BEGIN
    RETURN n;
  END;
  
  -- Método para obtener los guías que están disponibles para dirigir esta ruta.
  MEMBER FUNCTION guiasDisponibles RETURN tabla_guia_t IS
    g tabla_guia_t;
  BEGIN
    RETURN g;
  END;
  
  -- Método que devuelve todos los guías que han conducido esta ruta alguna vez.
  MEMBER FUNCTION guiasQueCondujeron RETURN tabla_guia_t IS
    g tabla_guia_t;
  BEGIN
    RETURN g;
  END;
  
  -- Método para obtener todos los guías que conducen esta ruta en una fecha dada.
  MEMBER FUNCTION guiasPorFecha(f IN DATE) RETURN tabla_guia_t IS
    g tabla_guia_t;
  BEGIN
    RETURN g;
  END;

  -- Método para obtener los guías que han conducido a un turista dado en esta ruta.
  MEMBER FUNCTION guiasPorTurista(t IN turista_t) RETURN tabla_guia_t IS
    g tabla_guia_t;
  BEGIN
    RETURN g;
  END;
  
  -- Metodo que devuelve todos los visitantes que han hecho esta ruta alguna vez.
  MEMBER FUNCTION obtenerVisitantes RETURN tabla_turista_t IS
    t tabla_turista_t;
  BEGIN
    RETURN t;
  END;
  
  -- Método que devuelve todos los turistas a los cuales un guía dado los condujo por esta ruta.
  MEMBER FUNCTION visitantesPorGuia(g IN guia_t) RETURN tabla_turista_t IS
    t tabla_turista_t;
  BEGIN
    RETURN t;
  END;

  -- Método que devuelve todos los Hitos que componen esta ruta.
  MEMBER FUNCTION obtenerHitos RETURN tabla_hito_t IS
  BEGIN
    RETURN SELF.hitos;
  END;

  -- Método que devuelve todos los Servicios ofrecidos en esta ruta esta ruta.
  MEMBER FUNCTION obtenerServicios RETURN tabla_servicio_t IS
    servicios tabla_servicio_t;
    hitos tabla_hito_t := SELF.obtenerHitos(); 
  BEGIN
    FOR h IN hitos.FIRST.. hitos.LAST
    LOOP
      SELECT deref(servicio) BULK COLLECT INTO servicios FROM Ofrece o WHERE o.hito = hitos(h);
    END LOOP;

    RETURN servicios;
  END;
END;
/
