SELECT nombre, descripcion, estado FROM Hito;
SELECT deref(column_value).publico AS publico, deref(column_value).monto AS monto FROM THE (SELECT pago FROM HITO);