-- DROP de tipos si existen
-- DROP TYPE tabla_compone_t FORCE;
-- DROP TYPE compone_t FORCE;
DROP TYPE ofrece_t FORCE;
DROP TYPE subhito_t FORCE;
DROP TYPE tabla_conduce_t FORCE;
DROP TYPE conduce_t FORCE;
DROP TYPE tabla_dirige_t FORCE;
DROP TYPE dirige_t FORCE;
DROP TYPE inverso_hito_ruta_t FORCE;
DROP TYPE tabla_ruta_t FORCE;
DROP TYPE ruta_t FORCE;
DROP TYPE tabla_hito_t FORCE;
DROP TYPE hito_t FORCE;
DROP TYPE tabla_servicio_t FORCE;
DROP TYPE servicio_t FORCE;
DROP TYPE tabla_tipoServicio_t FORCE;
DROP TYPE lista_dias_t FORCE;
DROP TYPE tabla_informacion_t FORCE;
DROP TYPE informacion_t FORCE;
DROP TYPE tabla_costo_t FORCE;
DROP TYPE lista_costos_t FORCE;
DROP TYPE costo_t FORCE;
DROP TYPE destino_t FORCE;
DROP TYPE tabla_guia_t FORCE;
DROP TYPE guia_t FORCE;
DROP TYPE tabla_turista_t FORCE;
DROP TYPE turista_t FORCE;
DROP TYPE tabla_telefonos_t FORCE;
DROP TYPE tabla_idiomas_t FORCE;
DROP TYPE tabla_tipoHito_t FORCE;

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
    EXECUTE IMMEDIATE 'DROP TABLE Turista';
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

DROP TABLE LISTADECOSTOS;


DROP PROCEDURE nuevoHito;


DROP FUNCTION index_of;
DROP FUNCTION rutas_iguales;
