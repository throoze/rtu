CREATE OR REPLACE TRIGGER eliminar_referencias_turista
BEFORE DELETE ON TURISTA
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


--Hacer null la ref(turista) de las Rutas cuyo ref(turista) sea igual al turista a eliminar.