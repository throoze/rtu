INSERT INTO Costo VALUES ('Ninos',200);
INSERT INTO Costo VALUES ('Adultos',300);
INSERT INTO Costo VALUES ('Viejos',400);

DROP TABLE listaDeCostos;

CREATE GLOBAL TEMPORARY TABLE listaDeCostos (
  publico VARCHAR2(20),
  monto   NUMBER
);

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

exec nuevoHito('La estatua del libertador','Estatua Simon Bolivar',tabla_tipoHito_t('Academico','Cultural'),'Abierto',lista_costos_t(costo_t('Ninos',200),costo_t('Adultos',300)),'Todo publico',20,'Formal');