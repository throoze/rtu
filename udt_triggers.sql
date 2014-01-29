--Hacer null la ref(turista) de las Rutas cuyo ref(turista) sea igual al turista a eliminar.
CREATE OR REPLACE TRIGGER eliminar_referencias_turista
BEFORE DELETE ON TURISTA
FOR EACH ROW
DECLARE
    CURSOR rutas IS
        SELECT VALUE(r)
        FROM RUTA r
        WHERE r.creador.username = :OLD.username;
    CURSOR conducidos IS
        SELECT VALUE(c)
        FROM CONDUCE c
        WHERE c.turista.username = :OLD.username;
    CURSOR guias IS
        SELECT VALUE(g)
        FROM GUIA g
        WHERE g.username = :OLD.username;
BEGIN
    FOR r in rutas LOOP
        r.creador := NULL;
    END LOOP;
    FOR c in conducidos LOOP
        DELETE c;
    END LOOP;
    FOR g in guias LOOP
        DELETE g;
    END LOOP;
END;
/

DROP FUNCTION index_of;
DROP FUNCTION rutas_iguales;


-- Compara dos rutas
CREATE OR REPLACE FUNCTION rutas_iguales(x ruta_t, y ruta_t) RETURN BOOLEAN IS
  BEGIN
    RETURN (x.fechaRegistro = y.fechaRegistro AND x.nombre = y.nombre);
  END;
/

-- Función que devuelve el primer índice de un elemento, en caso de existir en
-- una tabla de rutas. En caso contrario devuelve -1
CREATE OR REPLACE FUNCTION index_of(elem ruta_t, lista tabla_ruta_t) RETURN NUMBER IS
    r REF ruta_t;
    e ruta_t;
  BEGIN
    FOR i IN 1.. lista.COUNT
    LOOP
      r := lista(i);
      SELECT deref(r) INTO e FROM DUAL;
      IF (rutas_iguales(e, elem)) THEN
        RETURN i;
      END IF;
    END LOOP;

    RETURN -1;
  END;
/


-- Mantener referencia de una ruta con respecto a sus hitos. deberia ser
-- mantener inversas, deben cambiar algo el script para que tenga los refs de
-- un lado y del otro y haya que mantenerlos.
CREATE OR REPLACE TRIGGER mantener_refs_hito_a_ruta
AFTER INSERT OR UPDATE OR DELETE ON Ruta
FOR EACH ROW
DECLARE
  existence NUMBER;
  ind NUMBER;
  rutas  tabla_ruta_t;
BEGIN
  IF INSERTING THEN
    FOR h in 1.. :NEW.hitos.COUNT LOOP
      SELECT COUNT(1) INTO existence FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(:NEW.hitos(h));
      IF (existence = 1) THEN
        SELECT i.rutas INTO rutas FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(:NEW.hitos(h));
        rutas(rutas.COUNT) := REF(:NEW);
        UPDATE Inverso_hito_ruta i SET i.rutas = rutas WHERE deref(i.hito) = deref(:NEW.hitos(h));
      ELSE
        INSERT INTO Inverso_hito_ruta i (hito, rutas) VALUES (:NEW.hitos(h), tabla_ruta_t(REF(:NEW)));
      END IF;
    END LOOP;
  ELSIF DELETING THEN
    FOR h in 1.. :OLD.hitos.COUNT LOOP
      SELECT i.rutas INTO rutas FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(old.hitos(h))
      ind = index_of(new, rutas);
      IF ind > -1 THEN
        rutas.DELETE(ind);
        UPDATE Inverso_hito_ruta i SET i.rutas = rutas WHERE deref(i.hito) = deref(old.hitos(h));
      END IF;
    END LOOP;
  ELSIF UPDATING('hitos') THEN
   FOR h in 1.. :OLD.hitos.COUNT LOOP
      SELECT i.rutas INTO rutas FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(old.hitos(h))
      ind = index_of(new, rutas);
      IF ind > -1 THEN
        rutas.DELETE(ind);
        UPDATE Inverso_hito_ruta i SET i.rutas = rutas WHERE deref(i.hito) = deref(old.hitos(h));
      END IF;
    END LOOP;
    FOR h in 1.. :NEW.hitos.COUNT LOOP
      SELECT COUNT(1) INTO existence FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(new.hitos(h));
      IF (existence = 1) THEN
        SELECT i.rutas INTO rutas FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(new.hitos(h));
        rutas(rutas.COUNT) := REF(new);
        UPDATE Inverso_hito_ruta i SET i.rutas = rutas WHERE deref(i.hito) = deref(new.hitos(h));
      ELSE
        INSERT INTO Inverso_hito_ruta i (hito, rutas) VALUES (new.hitos(h), tabla_ruta_t(REF(new)));
      END IF;
    END LOOP;
  END IF;
END;
/

