DECLARE
	th tabla_hito_t;
	ct tabla_costo_t;
	it tabla_informacion_t;
	rt ruta_t;
	tu_c turista_t;
	tu_r REF turista_t;
	tabla tabla_servicio_t;

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

hito_t.crearHito('Biblioteca de la USB',
					'Biblioteca central',
					tabla_tipoHito_t('Academico'),
					'Abierto',
					lista_costos_t(costo_t('General',0)),
					'Todo publico',
					16,'Casual');

INSERT INTO Turista VALUES('Si','Perez','contrasena',SYSDATE, 'Hombre', 'correo@correo.com', tabla_tipoHito_t('Academico'), 'Pedro',
							'pedrito');
SELECT REF(t) INTO tu_r FROM Turista t WHERE username='pedrito';
SELECT REF(h) bulk collect into th FROM Hito h;
INSERT INTO Ruta VALUES (SYSDATE, 'Conoce la Simon', tabla_tipoHito_t('Academico','Cultural'),tu_r,th);

SELECT REF(c) bulk collect into ct FROM Costo c;
SELECT REF(i) bulk collect into it FROM Informacion i;
SELECT VALUE(r) into rt FROM Ruta r  WHERE nombre='Conoce la Simon';
INSERT INTO Servicio VALUES ('Un cafetin','Amper',ct, 'Abierto', it, tabla_tipoServicio_t('Cafetin','Banos'), lista_dias_t('Lunes','Martes'),SYSDATE,SYSDATE,SYSDATE,SYSDATE);
INSERT INTO Servicio VALUES ('Para estudiar','cubiculo',ct, 'Cerrado', it, tabla_tipoServicio_t('Cubiculos'), lista_dias_t('Miercoles','Jueves'),SYSDATE,SYSDATE,SYSDATE,SYSDATE);

tabla := rt.obtenerServicios();
END
;
/