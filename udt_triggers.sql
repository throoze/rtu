--Hacer null la ref(turista) de las Rutas cuyo ref(turista) sea igual al turista a eliminar.
CREATE OR REPLACE TRIGGER eliminar_referencias_turista
BEFORE DELETE ON TURISTA
FOR EACH ROW
DECLARE
    CURSOR rutas IS
        SELECT *
        FROM Ruta r
        WHERE r.creador.username == :OLD.username;
    CURSOR conducidos IS
        SELECT *
        FROM Conduce c
        WHERE c.turitsa.username == :OLD.username;
    CURSOR guias IS
        SELECT *
        FROM Guia g
        WHERE g.username == :OLD.username;
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

-- Función que devuelve el primer índice de un elemento, en caso de existir en
-- una tabla de rutas. En caso contrario devuelve -1
CREATE OR REPLACE FUNCTION index_of(elem ruta_t, lista tabla_ruta_t) RETURN NUMBER IS
  BEGIN
    FOR i IN lista.FIRST.. lista.LAST
    LOOP
      IF deref(lista(i)) = elem THEN
      RETURN i;
    END LOOP;

    RETURN -1;
  END;


-- Mantener referencia de una ruta con respecto a sus hitos. deberia ser
-- mantener inversas, deben cambiar algo el script para que tenga los refs de
-- un lado y del otro y haya que mantenerlos.
CREATE OR REPLACE TRIGGER mantener_referencias_de_hito_hacia_ruta
AFTER INSERT OR UPDATE OR DELETE ON Ruta
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  exists NUMBER;
  index NUMBER;
  rutas  tabla_ruta_t;
BEGIN
  IF INSERTING THEN
    FOR hito in new.hitos LOOP
      SELECT COUNT(1) INTO exists FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(hito);
      IF (exists = 1) THEN
        SELECT i.rutas INTO rutas FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(hito);
        rutas(rutas.COUNT) := REF(new);
        UPDATE Inverso_hito_ruta i SET i.rutas = rutas WHERE deref(i.hito) = deref(hito);
      ELSE
        INSERT INTO Inverso_hito_ruta i (hito, rutas) VALUES (hito, tabla_ruta_t(REF(new)));
      END IF;
    END FOR;
  ELSIF DELETING THEN
    FOR hito in old.hitos LOOP
      SELECT i.rutas INTO rutas FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(hito)
      index = index_of(new, rutas);
      IF index > -1 THEN
        rutas.DELETE(index)
        UPDATE Inverso_hito_ruta i SET i.rutas = rutas WHERE deref(i.hito) = deref(hito);
      END IF;
    END FOR;
  ELSIF UPDATING('hitos') THEN
    FOR hito in old.hitos LOOP
      SELECT i.rutas INTO rutas FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(hito)
      index = index_of(new, rutas);
      IF index > -1 THEN
        rutas.DELETE(index)
        UPDATE Inverso_hito_ruta i SET i.rutas = rutas WHERE deref(i.hito) = deref(hito);
      END IF;
    END FOR;
    FOR hito in new.hitos LOOP
      SELECT COUNT(1) INTO exists FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(hito);
      IF (exists = 1) THEN
        SELECT i.rutas INTO rutas FROM Inverso_hito_ruta i WHERE deref(i.hito) = deref(hito);
        rutas(rutas.COUNT) := REF(new);
        UPDATE Inverso_hito_ruta i SET i.rutas = rutas WHERE deref(i.hito) = deref(hito);
      ELSE
        INSERT INTO Inverso_hito_ruta i (hito, rutas) VALUES (hito, tabla_ruta_t(REF(new)));
      END IF;
    END FOR;
  END IF;
END;


