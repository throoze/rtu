INSERT INTO Costo VALUES ('Ninos',200);
INSERT INTO Costo VALUES ('Adultos',300);
INSERT INTO Costo VALUES ('Viejos',400);

INSERT INTO Hito VALUES
('La estatua del libertador','Estatua Simon Bolivar',tabla_tipoHito_t('Academico','Cultural','Historico'),'Abierto',
  (SELECT tabla_costo_t(REF(c)) FROM Costo c WHERE publico='Ninos' AND monto=200),
  'Todo publico',20,'Deportiva');

--descripcion
--nombre
--categoria
--estado
--pago
--publico
--temperatura
--vestimenta