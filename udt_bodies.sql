-- Método que devuelve todos los Hitos que componen esta ruta.
ALTER TYPE ruta_t ADD MEMBER FUNCTION obtenerHitos RETURN tabla_hito_t CASCADE;

-- Método que devuelve todas las Rutas de las cuales forma parte este Hito.
ALTER TYPE hito_t ADD MEMBER FUNCTION obtenerRutas RETURN tabla_compone_t CASCADE;

-- Método que devuelve todos los Servicios ofrecidos en esta ruta esta ruta.
ALTER TYPE ruta_t ADD MEMBER FUNCTION obtenerServicios RETURN tabla_compone_t CASCADE;

CREATE TYPE BODY ruta_t AS
  MEMBER FUNCTION obtenerHitos RETURN tabla_hito_t IS
    hitos tabla_hito_t;
  BEGIN
    SELECT hito INTO hitos FROM Compone WHERE ruta = SELF;
    RETURN hitos;
  END;
END;
