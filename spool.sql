SQL> @main.sql
SQL> /* CI-5311 Paradigmas de modelado de bases de datos
SQL>  * Septiembre-Diciembre 2013
SQL>  * Entrega 3
SQL>  *
SQL>  * Autores: Alberto Cols	 09-10177 <betocolsf@gmail.com>
SQL>  * 	 Victor De Ponte 05-38087 <rdbvictor19@gmail.com>
SQL>  * 	 Ivan Travecedo  08-11131 <ivantrave@gmail.com>
SQL>  *
SQL>  * Descripcion: Ejecuta los scripts de los documentos
SQL>  * 			     que tienen la implementacion de las
SQL>  * 			     distintas porciones del modelo elaborado
SQL>  */
SQL> 
SQL>  -- Main
SQL> 
SQL> @udt_types.sql
SQL> /* CI-5311 Paradigmas de modelado de bases de datos
SQL>  * Septiembre-Diciembre 2013
SQL>  * Entrega 3
SQL>  *
SQL>  * Autores: Alberto Cols	 09-10177 <betocolsf@gmail.com>
SQL>  * 	 Victor De Ponte 05-38087 <rdbvictor19@gmail.com>
SQL>  * 	 Ivan Travecedo  08-11131 <ivantrave@gmail.com>
SQL>  *
SQL>  * Descripcion: Contiene la creacion de los tipos de datos
SQL>  * 	     del modelo
SQL>  *
SQL>  */
SQL> 
SQL> -- DROP de tipos si existen
SQL> DROP TYPE tabla_compone_t FORCE;

Type dropped.

SQL> DROP TYPE compone_t FORCE;

Type dropped.

SQL> DROP TYPE ofrece_t FORCE;

Type dropped.

SQL> DROP TYPE subhito_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_conduce_t FORCE;

Type dropped.

SQL> DROP TYPE conduce_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_dirige_t FORCE;

Type dropped.

SQL> DROP TYPE dirige_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_ruta_t FORCE;

Type dropped.

SQL> DROP TYPE ruta_t FORCE;

Type dropped.

SQL> DROP TYPE hito_t FORCE;

Type dropped.

SQL> DROP TYPE servicio_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_tipoServicio_t FORCE;

Type dropped.

SQL> DROP TYPE lista_dias_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_informacion_t FORCE;

Type dropped.

SQL> DROP TYPE informacion_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_costo_t FORCE;

Type dropped.

SQL> DROP TYPE costo_t FORCE;

Type dropped.

SQL> DROP TYPE destino_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_guia_t FORCE;

Type dropped.

SQL> DROP TYPE guia_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_turista_t FORCE;

Type dropped.

SQL> DROP TYPE turista_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_telefonos_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_idiomas_t FORCE;

Type dropped.

SQL> DROP TYPE tabla_tipoHito_t FORCE;

Type dropped.

SQL> 
SQL> 
SQL> 
SQL> 
SQL> -- Tipo para manejar la coleccion de "tipos de hito" de un hito
SQL> CREATE OR REPLACE TYPE tabla_tipoHito_t AS TABLE of VARCHAR2(20);
  2  /

Type created.

SQL> 
SQL> -- Tipo para manejar la coleccion de idiomas de un guia
SQL> CREATE OR REPLACE TYPE tabla_idiomas_t AS TABLE of VARCHAR2(20);
  2  /

Type created.

SQL> 
SQL> -- Tipo para manejar la coleccion de numeros de telefono de
SQL> -- un guia
SQL> CREATE OR REPLACE TYPE tabla_telefonos_t AS TABLE of NUMBER;
  2  /

Type created.

SQL> 
SQL> -- Tipo objeto turista
SQL> CREATE OR REPLACE TYPE turista_t AS OBJECT (
  2    activo		   VARCHAR2(2),
  3    apellido 	   VARCHAR2(30),
  4    contrasena	   VARCHAR2(20),
  5    fechaRegistro	   DATE,
  6    genero		   VARCHAR2(6),
  7    mail		   VARCHAR2(30),
  8    tipoHitosPreferidos tabla_tipoHito_t,
  9    nombre		   VARCHAR2(30),
 10    username 	   VARCHAR2(20),
 11    MEMBER FUNCTION calcularExperiencia RETURN NUMBER
 12    --Argumento de entrada es Evaluable pero dicha tabla no esta creada puesto que no forma parte de nuestro subconjunto.
 13  ) NOT FINAL;
 14  /

Type created.

SQL> 
SQL> CREATE OR REPLACE TYPE tabla_turista_t AS TABLE of REF turista_t;
  2  /

Type created.

SQL> 
SQL> -- Tipo guia que hereda de turista
SQL> CREATE OR REPLACE TYPE guia_t UNDER turista_t (
  2    idiomas	 tabla_idiomas_t,
  3    telefonos tabla_telefonos_t
  4  );
  5  /

Type created.

SQL> 
SQL> CREATE OR REPLACE TYPE tabla_guia_t AS TABLE of REF guia_t;
  2  /

Type created.

SQL> 
SQL> -- Tipo objeto destino
SQL> CREATE OR REPLACE TYPE destino_t AS OBJECT (
  2    descripcion VARCHAR2(100),
  3    nombre	   VARCHAR2(30)
  4  ) NOT FINAL;
  5  /

Type created.

SQL> 
SQL> -- Tipo objeto para manejo de costos asociados
SQL> -- a un tipo de publico determinado
SQL> CREATE OR REPLACE TYPE costo_t AS OBJECT (
  2    publico VARCHAR2(20),
  3    monto   NUMBER
  4  );
  5  /

Type created.

SQL> -- Tipo para manejar una coleccion de referencias a costos
SQL> CREATE OR REPLACE TYPE tabla_costo_t AS TABLE of REF costo_t;
  2  /

Type created.

SQL> 
SQL> -- Tipo objeto para manejo de informacion de servicios
SQL> CREATE OR REPLACE TYPE informacion_t AS OBJECT (
  2    tipo	 VARCHAR2(20),
  3    contacto  VARCHAR2(100)
  4  );
  5  /

Type created.

SQL> 
SQL> -- Tipo para manejar una coleccion de referencias a
SQL> -- informacion de servicios
SQL> CREATE OR REPLACE TYPE tabla_informacion_t AS TABLE of REF informacion_t;
  2  /

Type created.

SQL> 
SQL> -- Tipo para manejar un VARRAY de dias de la semana
SQL> CREATE OR REPLACE TYPE lista_dias_t AS VARRAY(7) of VARCHAR2(10);
  2  /

Type created.

SQL> 
SQL> -- Tipo para manejar una coleccion de tipos de servicios
SQL> CREATE OR REPLACE TYPE tabla_tipoServicio_t AS TABLE of VARCHAR2(20);
  2  /

Type created.

SQL> 
SQL> -- Tipo para servicio, hereda del tipo destino
SQL> CREATE OR REPLACE TYPE servicio_t UNDER destino_t (
  2    costo		   tabla_costo_t,
  3    estado		   VARCHAR2(13),
  4    informacionContacto tabla_informacion_t,
  5    tipo		   tabla_tipoServicio_t,
  6    dia		   lista_dias_t,
  7    duracion 	   DATE,
  8    fechaInicio	   DATE,
  9    fechaFin 	   DATE,
 10    horaComienzo	   DATE
 11  );
 12  /

Type created.

SQL> 
SQL> -- Tipo para hito, hereda del tipo destino
SQL> CREATE OR REPLACE TYPE hito_t UNDER destino_t (
  2    categoria   tabla_tipoHito_t,
  3    estado	   VARCHAR2(30),
  4    pago	   tabla_costo_t,
  5    publico	   VARCHAR2(30),
  6    temperatura NUMBER,
  7    vestimenta  VARCHAR2(30)
  8  );
  9  /

Type created.

SQL> 
SQL> -- Tipo objeto para ruta
SQL> CREATE OR REPLACE TYPE ruta_t AS OBJECT (
  2    fechaRegistro  DATE,
  3    nombre	      VARCHAR2(30),
  4    tipo	      tabla_tipoHito_t,
  5    creador	      REF turista_t,
  6  
  7    --Método que calcula el costo total, dada la lista de costos del Guía y la lista de costos de los hitos.
  8    MEMBER FUNCTION calcularCostoTotal(costosGuia IN tabla_costo_t, costoHito IN tabla_costo_t) RETURN NUMBER,
  9  
 10    -- Argumento de entrada es Vias pero dicha tabla no esta creada, puesto que no forma parte de nuestro subconjunto.
 11    MEMBER FUNCTION calcularDistanciaTotal RETURN NUMBER,
 12  
 13    -- Método para obtener los guías que están disponibles para dirigir esta ruta.
 14    MEMBER FUNCTION guiasDisponibles RETURN tabla_guia_t,
 15  
 16    -- Método que devuelve todos los guías que han conducido esta ruta alguna vez.
 17    MEMBER FUNCTION guiasQueCondujeron RETURN tabla_guia_t,
 18  
 19    -- Método para obtener todos los guías que conducen esta ruta en una fecha dada.
 20    MEMBER FUNCTION guiasPorFecha(f IN DATE) RETURN tabla_guia_t,
 21  
 22    -- Método para obtener los guías que han conducido a un turista dado en esta ruta.
 23    MEMBER FUNCTION guiasPorTurista(t IN turista_t) RETURN tabla_guia_t,
 24  
 25    -- Metodo que devuelve todos los visitantes que han hecho esta ruta alguna vez.
 26    MEMBER FUNCTION obtenerVisitantes RETURN tabla_turista_t,
 27  
 28    -- Método que devuelve todos los turistas a los cuales un guía dado los condujo por esta ruta.
 29    MEMBER FUNCTION visitantesPorGuia(g IN guia_t) RETURN tabla_turista_t
 30  );
 31  /

Type created.

SQL> 
SQL> --Tipo que es una tabla de referencias a rutas para ser usado en
SQL> --la operacion buscarRutas()
SQL> CREATE OR REPLACE TYPE tabla_ruta_t AS TABLE of REF ruta_t;
  2  /

Type created.

SQL> 
SQL> -- Tipo objeto de la asociación dirige entre
SQL> -- guias y rutas
SQL> -- Guia dirige ruta
SQL> CREATE OR REPLACE TYPE dirige_t AS OBJECT (
  2    precios	     tabla_costo_t,
  3    guia	     REF guia_t,
  4    ruta	     REF ruta_t
  5  );
  6  /

Type created.

SQL> 
SQL> -- Colección de instancias de la relación dirige:
SQL> CREATE OR REPLACE TYPE tabla_dirige_t AS TABLE of REF dirige_t;
  2  /

Type created.

SQL> 
SQL> -- Tipo para la relación ternaria "conduce", entre Guia, Turista y Ruta:
SQL> -- Un Guia conduce a un Turista en una Ruta.
SQL> CREATE OR REPLACE TYPE conduce_t AS OBJECT (
  2    fecha	     DATE,
  3    horaInicio    DATE,
  4    guia	     REF guia_t,
  5    turista	     REF turista_t,
  6    ruta	     REF ruta_t
  7  );
  8  /

Type created.

SQL> 
SQL> -- Colección de instancias de la relación conduce:
SQL> CREATE OR REPLACE TYPE tabla_conduce_t AS TABLE of REF conduce_t;
  2  /

Type created.

SQL> 
SQL> -- Tipo objeto de la asociacion recursiva que describe
SQL> -- si un hito esta contenido dentro de otro hito
SQL> CREATE OR REPLACE TYPE subhito_t AS OBJECT (
  2    contiene  REF hito_t,
  3    contenido REF hito_t
  4  );
  5  /

Type created.

SQL> 
SQL> -- Tipo objeto de la asociacion ofrece entre hito
SQL> -- y servicio.
SQL> -- Un hito ofrece servicios
SQL> CREATE OR REPLACE TYPE ofrece_t AS OBJECT (
  2    hito	 REF hito_t,
  3    servicio  REF servicio_t
  4  );
  5  /

Type created.

SQL> 
SQL> -- Tipo objeto de la asociación "compone" entre hito y ruta
SQL> -- Uno o muchos hitos componen una o muchas rutas.
SQL> CREATE OR REPLACE TYPE compone_t AS OBJECT (
  2    hito	 REF hito_t,
  3    ruta	 REF ruta_t
  4  );
  5  /

Type created.

SQL> 
SQL> -- Colección de instancias de la relación conduce:
SQL> CREATE OR REPLACE TYPE tabla_compone_t AS TABLE of REF compone_t;
  2  /

Type created.

SQL> 
SQL> -- A continuación se especican más métodos que requieren de la pre existencia de algunos tipos para compilar correctamente:
SQL> 
SQL> -- Añadimos un método a turista_t, ahora que disponemos del tipo tabla_ruta_t.
SQL> -- Este método devuelve la lista de rutas en las cuales ha participado el turista.
SQL> ALTER TYPE turista_t ADD MEMBER FUNCTION buscarRutas RETURN tabla_ruta_t CASCADE;

Type altered.

SQL> 
SQL> -- Devuelve las rutas que el guia puede dirigir, junto con los costos asociados.
SQL> ALTER TYPE guia_t ADD MEMBER FUNCTION rutasDisponibles RETURN tabla_dirige_t CASCADE;

Type altered.

SQL> 
SQL> -- Devuelve todos los turistas guiados por el guia, junto a la ruta, fecha y hora asociada.
SQL> ALTER TYPE guia_t ADD MEMBER FUNCTION turistasGuiados RETURN tabla_conduce_t CASCADE;

Type altered.

SQL> 
SQL> -- Devuelve todos los turistas guiados en una fecha dada, junto a la ruta y hora asociada.
SQL> ALTER TYPE guia_t ADD MEMBER FUNCTION turistasPorFecha(f IN DATE) RETURN tabla_conduce_t CASCADE;

Type altered.

SQL> 
SQL> -- Devuelve todas las rutas guiadas por el guia, junto a los turistas, fecha y hora asociada.
SQL> ALTER TYPE guia_t ADD MEMBER FUNCTION rutasGuiadas RETURN tabla_conduce_t CASCADE;

Type altered.

SQL> 
SQL> -- Devuelve todas las rutas guiadas en una fecha dada, junto a los turistas y hora asociada.
SQL> ALTER TYPE guia_t ADD MEMBER FUNCTION rutasPorFecha(f IN DATE) RETURN tabla_conduce_t CASCADE;

Type altered.

SQL> 
SQL> -- Devuelve todas las rutas guiadas para un turista dado, junto a la fecha y hora asociada.
SQL> ALTER TYPE guia_t ADD MEMBER FUNCTION rutasPorTurista(r IN turista_t) RETURN tabla_conduce_t CASCADE;

Type altered.

SQL> 
SQL> -- Método que devuelve todos los Hitos que componen esta ruta.
SQL> ALTER TYPE ruta_t ADD MEMBER FUNCTION obtenerHitos RETURN tabla_compone_t CASCADE;

Type altered.

SQL> 
SQL> -- Método que devuelve todas las Rutas de las cuales forma parte este Hito.
SQL> ALTER TYPE hito_t ADD MEMBER FUNCTION obtenerRutas RETURN tabla_compone_t CASCADE;

Type altered.

SQL> @udt_tables.sql
SQL> /* CI-5311 Paradigmas de modelado de bases de datos
SQL>  * Septiembre-Diciembre 2013
SQL>  * Entrega 3
SQL>  *
SQL>  * Autores: Alberto Cols	 09-10177 <betocolsf@gmail.com>
SQL>  * 	 Victor De Ponte 05-38087 <rdbvictor19@gmail.com>
SQL>  * 	 Ivan Travecedo  08-11131 <ivantrave@gmail.com>
SQL>  *
SQL>  * Descripcion: Creacion de las tablas del modelo. Todos los
SQL>  * 	     tipos aqui definidos se encuentran en el
SQL>  * 	     archivo udt_types.sql
SQL>  */
SQL> 
SQL>  -- Tables
SQL> 
SQL> -- Drop para tablas
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Ofrece';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Subhito';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Dirige';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Conduce';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Compone';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Turista';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Hito';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Servicio';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Destino';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Ruta';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Guia';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Ofrece';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> BEGIN
  2  	 EXECUTE IMMEDIATE 'DROP TABLE Subhito';
  3  EXCEPTION
  4  	 WHEN OTHERS THEN
  5  	   IF SQLCODE != -942 THEN
  6  	      RAISE;
  7  	   END IF;
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> 
SQL> -- Tabla Turista de objetos de tipo turista_t
SQL> -- Contiene NESTED TABLE correspondiente a
SQL> --    coleccion de hitos preferidos por el turista
SQL> CREATE TABLE Turista OF turista_t (
  2    activo		   NOT NULL,
  3    apellido 	   NOT NULL,
  4    contrasena	   NOT NULL,
  5    fechaRegistro	   NOT NULL,
  6    genero		   NOT NULL,
  7    mail		   NOT NULL,
  8    nombre		   NOT NULL,
  9    username 	   NOT NULL,
 10    CONSTRAINT PK_TURISTA PRIMARY KEY (username),
 11    CONSTRAINT C_TURISTA_APELLIDO CHECK (apellido LIKE '^[a-zA-Z]{1,20}'),		       --String valido
 12    CONSTRAINT C_TURISTA_CONTRASENA CHECK (contrasena LIKE '^[a-zA-Z]{1,8}'),	       --String valido
 13    -- CONSTRAINT C_TURISTA_ CHECK (fechaRegistro <= (SELECT CURRENT_DATE FROM dual)),      --fechaRegistro menor o igual que fecha actual
 14    CONSTRAINT C_TURISTA_GENERO CHECK (genero IN ('Hombre', 'Mujer')),
 15    CONSTRAINT C_TURISTA_MAIL CHECK (mail LIKE '([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})'), --Mail valido
 16    CONSTRAINT C_TURISTA_NOMBRE CHECK (nombre LIKE '^[a-zA-Z]{1,20}'),		       --String valido
 17    CONSTRAINT C_TURISTA_USERNAME CHECK (username LIKE '^[a-zA-Z]{1,20}')		       --String valido
 18  ) OBJECT ID PRIMARY KEY
 19    NESTED TABLE tipoHitosPreferidos STORE AS turista_hitos;

Table created.

SQL> 
SQL> -- Tabla Hito de objetos de tipo hito_t
SQL> -- Contiene NESTED TABLE correspondiente a la
SQL> -- coleccion de pagos del hito
SQL> -- Contiene NESTED TABLE correspondiente a la
SQL> -- coleccion de categorias a las que pertenece
SQL> CREATE TABLE Hito OF hito_t (
  2    estado	   NOT NULL,
  3    publico	   NULL,
  4    temperatura NOT NULL,
  5    vestimenta  NOT NULL,
  6    CONSTRAINT  PK_HITO PRIMARY KEY (nombre),
  7    CONSTRAINT C_HITO_ESTADO CHECK (estado IN ('Abierto', 'Cerrado Permanentemente', 'Cerrado Temporalmente'))
  8  ) OBJECT ID PRIMARY KEY
  9    NESTED TABLE pago STORE AS hito_pago
 10    NESTED TABLE categoria STORE AS hito_categoria;

Table created.

SQL> 
SQL> -- Tabla Servicio de objetos de tipo servicio_t
SQL> -- Contiene NESTED TABLE correspondiente a coleccion de:
SQL> --    costos del servicio
SQL> --    informaciones de contacto del servicio
SQL> --    tipos del servicio
SQL> CREATE TABLE Servicio OF servicio_t (
  2    estado		   NOT NULL,
  3    duracion 	   NULL,
  4    fechaInicio	   NULL,
  5    fechaFin 	   NULL,
  6    horaComienzo	   NOT NULL,
  7    dia		   NULL,
  8    CONSTRAINT PK_SERVICIO PRIMARY KEY (nombre),
  9    CONSTRAINT C_SERVICIO_ESTADO CHECK (estado IN ('Disponible', 'No Disponible')),
 10    CONSTRAINT C_SERVICIO_FECHAS CHECK (fechaInicio <= fechaFin)
 11  ) OBJECT ID PRIMARY KEY
 12    NESTED TABLE costo STORE AS servicio_costo
 13    NESTED TABLE informacionContacto STORE AS servicio_informacion
 14    NESTED TABLE tipo STORE AS servicio_tipo;

Table created.

SQL> 
SQL> -- Tabla Destino de objetos de tipo destino_t
SQL> CREATE TABLE Destino OF destino_t (
  2    descripcion	   NOT NULL,
  3    nombre		   NOT NULL,
  4    CONSTRAINT PK_DESTINO PRIMARY KEY (nombre)
  5  )OBJECT ID PRIMARY KEY;

Table created.

SQL> 
SQL> -- Tabla Ruta de objetos de tipo ruta_t
SQL> -- Contiene NESTED TABLE correspondiente a:
SQL> --    coleccion de tipos de hitos presentes en la ruta
SQL> CREATE TABLE Ruta OF ruta_t (
  2    fechaRegistro	   NOT NULL,
  3    nombre		   NOT NULL,
  4    CONSTRAINT PK_RUTA PRIMARY KEY (nombre),
  5    CONSTRAINT C_RUTA_FECHA_REGISTRO CHECK (nombre LIKE '^[a-zA-Z]{1,20}')	  --String valido
  6  ) OBJECT ID PRIMARY KEY
  7    NESTED TABLE tipo STORE AS ruta_tipoHito;

Table created.

SQL> 
SQL> -- Tabla Guia de objetos de tipo guia_t
SQL> -- Contiene NESTED TABLE correspondiente a coleccion de:
SQL> --    tipo de hitos que prefiere el guia
SQL> --    idiomas que maneja el guia
SQL> --    telefonos del guia
SQL> CREATE TABLE Guia OF guia_t (
  2    CONSTRAINT PK_GUIA PRIMARY KEY (username)
  3  ) OBJECT ID PRIMARY KEY
  4    NESTED TABLE tipoHitosPreferidos STORE AS guia_hitos_preferidos
  5    NESTED TABLE idiomas STORE AS guia_idiomas
  6    NESTED TABLE telefonos STORE AS guia_telefonos;

Table created.

SQL> 
SQL> -- Tabla para manejar la relacion N:M entre hito y los
SQL> -- servicios que este ofrece
SQL> CREATE TABLE Ofrece OF ofrece_t (
  2    CONSTRAINT FK_HITO FOREIGN KEY (hito) references Hito,
  3    CONSTRAINT FK_SERVICIO FOREIGN KEY (servicio) references Servicio
  4  );

Table created.

SQL> 
SQL> -- Tabla para manejar la relacion N:M entre hito y otros hitos
SQL> -- que este contiene
SQL> CREATE TABLE Subhito OF subhito_t (
  2    CONSTRAINT FK_Subhito_contiene FOREIGN KEY (contiene) references Hito,
  3    CONSTRAINT FK_Subhito_contenido FOREIGN KEY (contenido) references Hito
  4  );

Table created.

SQL> 
SQL> -- Tabla para manejar la relación N:M entre guía y ruta, especificada por el
SQL> -- tipo dirige_t
SQL> CREATE TABLE Dirige OF dirige_t (
  2    CONSTRAINT FK_DIRIGE_GUIA FOREIGN KEY (guia) REFERENCES Guia,
  3    CONSTRAINT FK_DIRIGE_RUTA FOREIGN KEY (ruta) REFERENCES Ruta
  4  ) NESTED TABLE precios STORE AS dirige_precios;

Table created.

SQL> 
SQL> -- Tabla para manejar la relación ternaria que existe entre Guia, Ruta y
SQL> -- Turista
SQL> CREATE TABLE Conduce OF conduce_t (
  2    fecha		   NOT NULL,
  3    horaInicio	   NOT NULL,
  4    CONSTRAINT FK_CONDUCE_GUIA FOREIGN KEY (guia) REFERENCES Guia,
  5    CONSTRAINT FK_CONDUCE_TURISTA FOREIGN KEY (turista) REFERENCES Turista,
  6    CONSTRAINT FK_CONDUCE_RUTA FOREIGN KEY (ruta) REFERENCES Ruta
  7  );

Table created.

SQL> 
SQL> -- Tabla que maneja la relación N:M "compone" entre Hito y Ruta.
SQL> CREATE TABLE Compone OF compone_t (
  2    CONSTRAINT FK_COMPONE_HITO FOREIGN KEY (hito) REFERENCES Hito,
  3    CONSTRAINT FK_COMPONE_RUTA FOREIGN KEY (ruta) REFERENCES Ruta
  4  );

Table created.

SQL> SPOOL off;
