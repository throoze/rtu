/* CI-5311 Paradigmas de modelado de bases de datos
 * Septiembre-Diciembre 2013
 * Entrega 3
 *
 * Autores: Alberto Cols    09-10177 <betocolsf@gmail.com>
 *          Victor De Ponte 05-38087 <rdbvictor19@gmail.com>
 *          Ivan Travecedo  08-11131 <ivantrave@gmail.com>
 *
 */

 -- Tables

-- Drop para tablas
BEGIN
	EXECUTE IMMEDIATE 'DROP TABLE Turista';
	EXECUTE IMMEDIATE 'DROP TABLE Hito';
	EXECUTE IMMEDIATE 'DROP TABLE NON_EXISTENT_TABLE';
EXCEPTION
	WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

CREATE TABLE Turista OF turista_t (
  activo              NOT NULL,
  apellido            NOT NULL,
  contrasena          NOT NULL,
  fechaRegistro       NOT NULL,
  genero              NOT NULL,
  mail                NOT NULL,
  nombre              NOT NULL,
  username            NOT NULL
) NESTED TABLE tipoHitosPreferidos STORE AS turista_hitos;