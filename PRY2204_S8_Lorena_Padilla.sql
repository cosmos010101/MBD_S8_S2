CREATE TABLE SERVICIO
    (
    id_servicio NUMBER(3),
    descripcion VARCHAR2(100) NOT NULL,
    costo NUMBER(7) NOT NULL,
    CONSTRAINT PK_SERVICIO PRIMARY KEY (id_servicio)
    );
    
CREATE TABLE PAIS
    (
    id_pais NUMBER(3)GENERATED ALWAYS AS IDENTITY
    START WITH 9
    INCREMENT BY 3,
    nom_pais VARCHAR2(30) NOT NULL,
    CONSTRAINT PK_PAIS PRIMARY KEY (id_pais)
    );
    
CREATE TABLE CIUDAD
    (
    id_ciudad NUMBER(3),
    nom_ciudad VARCHAR2(30) NOT NULL,
    cod_pais NUMBER(3) NOT NULL,
    CONSTRAINT PK_CIUDAD PRIMARY KEY (id_ciudad),
    CONSTRAINT FK_CIUDAD_PAIS FOREIGN KEY (cod_pais) REFERENCES PAIS (id_pais)
    );
    
CREATE TABLE SUCURSAL
    (
    id_sucursal CHAR(3),
    nom_sucursal VARCHAR2(20) NOT NULL,
    calle VARCHAR2(20) NOT NULL,
    num_calle NUMBER(4) NOT NULL,
    cod_ciudad NUMBER(3) NOT NULL,
    CONSTRAINT PK_SUCURSAL PRIMARY KEY (id_sucursal),
    CONSTRAINT FK_SUCURSAL_CIUDAD FOREIGN KEY (cod_ciudad) REFERENCES CIUDAD (id_ciudad)
    );
    
CREATE TABLE MECANICO
    (
    cod_mecanico NUMBER(5) GENERATED ALWAYS AS IDENTITY
    START WITH 460
    INCREMENT BY 7,
    pnombre VARCHAR2(20) NOT NULL,
    snombre VARCHAR2(20) NOT NULL,
    apaterno VARCHAR2(20) NOT NULL,
    amaterno VARCHAR2(20) NOT NULL,
    bono_jefatura NUMBER(10),
    sueldo NUMBER(10) NOT NULL,
    monto_impuestos NUMBER(10) NOT NULL,
    cod_supervisor NUMBER(5),
    CONSTRAINT PK_MECANICO PRIMARY KEY (cod_mecanico),
    CONSTRAINT FK_MECANICO_MECANICO FOREIGN KEY (cod_supervisor) REFERENCES MECANICO (cod_mecanico)
    );
    
CREATE TABLE MARCA
    (
    id_marca NUMBER(2),
    descripcion VARCHAR2(20) NOT NULL,
    CONSTRAINT PK_MARCA PRIMARY KEY (id_marca)
    );
    
CREATE TABLE MODELO
    (
    id_modelo NUMBER(5),
    marca_id NUMBER(2) NOT NULL,
    descripcion VARCHAR2(20) NOT NULL,
    CONSTRAINT FK_MODELO_MARCA FOREIGN KEY (marca_id) REFERENCES MARCA (id_marca),
    CONSTRAINT PK_MODELO PRIMARY KEY (id_modelo, marca_id)
    );
    
CREATE TABLE TIPO_AUTOMOVIL
    (
    id_tipo CHAR(3),
    descripcion VARCHAR2(20) NOT NULL,
    CONSTRAINT PK_TIPO_AUTOMOVIL PRIMARY KEY (id_tipo)
    );
    
CREATE TABLE CLIENTE
    (
    rut NUMBER(8),
    dv CHAR(1) NOT NULL,
    pnombre VARCHAR2(20) NOT NULL,
    snombre VARCHAR2(20),
    apaterno VARCHAR2(20) NOT NULL,
    amaterno VARCHAR2(20) NOT NULL,
    telefono VARCHAR2(12),
    email VARCHAR2(40),
    tipo_cli CHAR(1), 
    CONSTRAINT PK_CLIENTE PRIMARY KEY (rut),
    CONSTRAINT CK_CLIENTE_TIPO_CLI CHECK (tipo_cli IN ('E', 'P'))
    );
    
CREATE TABLE ESTANDAR
    (
    cl_rut NUMBER(8),
    puntake_fidelidad NUMBER(10) NOT NULL,
    CONSTRAINT FK_ESTANDAR_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut),
    CONSTRAINT PK_ESTANDAR PRIMARY KEY (cl_rut)
    );
    
CREATE TABLE PREMIUM
    (
    cl_rut NUMBER(8),
    pesos_clientes NUMBER(10) NOT NULL,
    monto_credito NUMBER(10),
    CONSTRAINT FK_PREMIUM_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut),
    CONSTRAINT PK_PREMIUM PRIMARY KEY (cl_rut)
    );
    
CREATE TABLE AUTOMOVIL
    (
    patente CHAR(8),
    annio NUMBER(4) NOT NULL,
    cant_puertas NUMBER(1) NOT NULL,
    km NUMBER(6) NOT NULL,
    color VARCHAR2(30) NOT NULL,
    cod_tipo_auto CHAR(3) NOT NULL,
    cod_model NUMBER(5) NOT NULL,
    cod_marca NUMBER(2) NOT NULL,
    cl_rut NUMBER(8) NOT NULL,
    CONSTRAINT PK_AUTOMOVIL PRIMARY KEY (patente),
    CONSTRAINT FK_AUTOMOVIL_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut),
    CONSTRAINT FK_AUTOMOVIL_MODELO FOREIGN KEY (cod_model, cod_marca) REFERENCES MODELO (id_modelo, marca_id),
    CONSTRAINT FK_AUTOMOVIL_TIPO FOREIGN KEY  (cod_tipo_auto) REFERENCES TIPO_AUTOMOVIL (id_tipo)
    );
    
CREATE TABLE MANTENCION
    (
    num_mantencion NUMBER(4),
    cod_sucursal CHAR(3) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_salida DATE,
    patente_auto CHAR(8),
    cod_mecanico NUMBER(5) NOT NULL,
    costo_total NUMBER(7) NOT NULL,
    estado VARCHAR2(15),
    CONSTRAINT FK_MANTENCION_AUTOMOVIL FOREIGN KEY (patente_auto) REFERENCES AUTOMOVIL (patente),
    CONSTRAINT FK_MANTENCION_MECANICO FOREIGN KEY (cod_mecanico) REFERENCES MECANICO (cod_mecanico),
    CONSTRAINT FK_MANTENCIO_SUCURSAL FOREIGN KEY (cod_sucursal) REFERENCES SUCURSAL (id_sucursal),
    CONSTRAINT PK_MANTENCION PRIMARY KEY (num_mantencion)
    );
    
CREATE TABLE DETALLE_SERVICIO
    (
    mantencion_num NUMBER(4) NOT NULL,
    cod_servicio NUMBER(3) NOT NULL,
    descuento_serv NUMBER(4,3) NOT NULL,
    cantidad NUMBER(3),
    CONSTRAINT FK_DETALLE_SERVICIO FOREIGN KEY (cod_servicio) REFERENCES SERVICIO (id_servicio),
    CONSTRAINT FK_DETALLE_MANTENCION FOREIGN KEY (mantencion_num) REFERENCES MANTENCION (num_mantencion), --ESTE CAMBIARÁ
    CONSTRAINT PK_DETALLE_SERVICIO PRIMARY KEY (mantencion_num, cod_servicio)
    );
    
--caso 2.1
ALTER TABLE MANTENCION DROP COLUMN costo_total;
--caso 2.2 cod_sucursal no puede ser NOT NULL para convertirse en PK, no puede existir una constraint pk en una tabla anteriormente para agregar otro pk--
ALTER TABLE MANTENCION MODIFY cod_sucursal CHAR(3) NULL;
ALTER TABLE DETALLE_SERVICIO DROP CONSTRAINT FK_DETALLE_MANTENCION;
ALTER TABLE MANTENCION DROP CONSTRAINT PK_MANTENCION;
ALTER TABLE MANTENCION ADD CONSTRAINT PK_MANTENCION PRIMARY KEY (num_mantencion, cod_sucursal);
ALTER TABLE DETALLE_SERVICIO ADD (cod_sucursal CHAR(3));
ALTER TABLE DETALLE_SERVICIO 
    ADD CONSTRAINT FK_DETALLE_MANTENCION FOREIGN KEY (mantencion_num, cod_sucursal) 
    REFERENCES MANTENCION (num_mantencion, cod_sucursal);
--caso 2.3
ALTER TABLE CLIENTE ADD CONSTRAINT UN_EMAIL UNIQUE (email);
--caso 2.4
ALTER TABLE CLIENTE ADD CONSTRAINT ck_rut CHECK (dv IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'k'));
--caso 2.5
ALTER TABLE MECANICO ADD CONSTRAINT ck_sueldo CHECK (sueldo >= 510000);
--caso 2.6
ALTER TABLE MANTENCION ADD CONSTRAINT ck_estado CHECK (estado IN ('Reserva', 'Ingresado', 'Entregado', 'Anulado'));
--caso 3.1
CREATE SEQUENCE seq_servicio
START WITH 400
INCREMENT BY 2;

CREATE OR REPLACE TRIGGER id_servicio_tg
BEFORE INSERT ON SERVICIO
FOR EACH ROW 
WHEN (NEW.id_servicio IS NULL)
BEGIN
    :NEW.id_servicio := seq_servicio.NEXTVAL;
END;

--caso 3.2
CREATE SEQUENCE seq_ciudad
START WITH 165
INCREMENT BY 5;

CREATE OR REPLACE TRIGGER id_ciudad_tg
BEFORE INSERT ON CIUDAD
FOR EACH ROW
WHEN (NEW.id_ciudad IS NULL)
BEGIN
    :NEW.id_ciudad := seq_ciudad.NEXTVAL;
END;

--caso 3.3

--1 servicio
INSERT INTO SERVICIO (descripcion, costo) VALUES
('Cambio Luces', 45000),
('Desabolladura', 67000),
('Revisión Frenos', 30000),
('Cambio Puerta Trasera', 30000);

--2 pais
INSERT INTO PAIS (nom_pais) VALUES
('Chile'),
('Perú'),
('Colombia');

--3 ciudad
INSERT INTO CIUDAD (nom_ciudad, cod_pais) VALUES ('Santiago', 9);
INSERT INTO CIUDAD (nom_ciudad, cod_pais) VALUES ('Lima', 12);
INSERT INTO CIUDAD (nom_ciudad, cod_pais) VALUES ('Bogota', 15);
-- SI NO FUNCIONA EL INSERT DE CIUDAD, EJECUTAR TRIGGER DE SEQ_CIUDAD NUEVAMENTE

--4 sucursal
INSERT INTO SUCURSAL (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad) VALUES
('S01','Providencia', 'Av. A. Varas', 234, 165),
('S02','Las 4 esquinas', 'Av. Latina', 669, 170),
('S03', 'El cafetero', 'Ab. El Faro', 900, 175);

--5 mecanico
INSERT INTO MECANICO (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor) VALUES
('Jorge', 'Pablo', 'Soto', 'Sierpe', 5400000, 2759000, 223580, null),
('Pedro', 'Jose', 'Manriquez', 'Corral', null, 759000, 23980, null),
('Sandra', 'Josefa', 'Letelier', 'S.', 0, 659000, 22358, 460),
('Felipe', 'M.', 'Vidal', 'A.', null, 759000, 23580, 460),
('Jose', 'Miguel', 'Troncoso', 'B.', null, 659000, 44580, 474),
('Juan', 'Pablo', 'Sanchez', 'R.', null, 859000, 23380, 474),
('Carlos', 'Felipe', 'Soto', 'J.', 0, 597000, 23580, 474),
('Alberto', 'P.', 'Cerda', 'Ramirez', null, 559000, 22380, 460),
('Alejandra', 'Gabriela', 'Infanti', 'R.', null, 659000, 22380, 460),
('Roberto', 'Patricio', 'Gutierrez', 'Sosa', null, 859000, 22380, 460);

--6 mantencion
INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado) VALUES
(101, 'S01', TO_DATE('12-04-2026', 'DD-MM-YYYY'), NULL, NULL, 481, 'Reserva');
INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado) VALUES
(102, 'S02', TO_DATE('21-02-2023', 'DD-MM-YYYY'), TO_DATE('12-04-2023', 'DD-MM-YYYY'), NULL, 502, 'Entregado');
INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado) VALUES
(103, 'S02', TO_DATE('09-10-2023', 'DD-MM-YYYY'), NULL, NULL, 502, 'Anulado');
INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado) VALUES
(104, 'S03', TO_DATE('11-08-2023', 'DD-MM-YYYY'), TO_DATE('12-04-2023', 'DD-MM-YYYY'), NULL, 509, 'Entregado');
INSERT INTO MANTENCION (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado) VALUES
(105, 'S03', TO_DATE('03-12-2023', 'DD-MM-YYYY'), NULL, NULL, 509, 'Ingresado');

--caso 3 informe 1
SELECT 
    cod_mecanico AS "ID MECANICO",
    pnombre || ' ' || apaterno AS "NOMBRE MECANICO",
    sueldo AS "SALARIO",
    monto_impuestos AS "IMPUESTO ACTUAL",
    (monto_impuestos / 5) *4 AS "IMPUESTO REBAJADO",
    sueldo - ((monto_impuestos / 5) *4) AS "SUELDO CON REBAJA IMPUESTOS"
FROM MECANICO
ORDER BY monto_impuestos DESC, pnombre ASC;

--caso 3 informe 2
SELECT 
    cod_mecanico AS "IDENTIFICADOR",
    pnombre || ' ' || snombre || ' ' || apaterno AS "MECANICO",
    sueldo AS "SALARIO ACTUAL",
    sueldo /20 AS "AJUSTE",
    sueldo + (sueldo/20) AS "SUELDO_REAJUSTADO"
    FROM MECANICO
    ORDER BY sueldo ASC, pnombre DESC;
