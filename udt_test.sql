BEGIN
INSERT INTO Costo VALUES ('Ninos',200);
INSERT INTO Costo VALUES ('Adultos',300);
INSERT INTO Costo VALUES ('Viejos',400);
INSERT INTO Costo VALUES ('General',0);
INSERT INTO Informacion VALUES('Telefono','04123333333');
INSERT INTO Informacion VALUES('FAX','04123333335');
INSERT INTO Informacion VALUES('Mail','hola@chao.com');
hito_t.crearHito('La estatua del libertador',
					'Estatua Simon Bolivar',
					tabla_tipoHito_t('Academico','Cultural'),
					'Abierto',
					lista_costos_t(costo_t('Ninos',200),
					costo_t('Adultos',300)),
					'Todo publico',
					20,'Formal');
END
;
/