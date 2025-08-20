-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS transporte_camiones;
USE transporte_camiones;

-- Tabla de clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    empresa VARCHAR(100),
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    direccion VARCHAR(200),
    ciudad VARCHAR(50),
    provincia VARCHAR(50),
    codigo_postal VARCHAR(10),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de vehículos
CREATE TABLE vehiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    anio INT,
    capacidad DECIMAL(10,2) COMMENT 'Capacidad en toneladas',
    tipo_vehiculo ENUM('Remolque', 'Refrigerado', 'Volquete', 'Cisterna', 'Plataforma') NOT NULL,
    estado ENUM('Disponible', 'En mantenimiento', 'En ruta', 'Baja') DEFAULT 'Disponible',
    kilometraje DECIMAL(10,1),
    ultima_revision DATE,
    prox_revision DATE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de conductores
CREATE TABLE conductores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    direccion VARCHAR(200),
    licencia VARCHAR(20),
    categoria_licencia VARCHAR(5),
    vencimiento_licencia DATE,
    estado ENUM('Activo', 'Inactivo', 'Vacaciones', 'Licencia') DEFAULT 'Activo',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de rutas
CREATE TABLE rutas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    origen VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    distancia_km DECIMAL(10,1),
    tiempo_estimado_horas DECIMAL(5,1),
    peajes DECIMAL(10,2) DEFAULT 0,
    ruta_alternativa VARCHAR(100),
    notas TEXT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de pedidos/transportes
CREATE TABLE transportes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    origen VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    fecha_recoleccion DATETIME,
    fecha_entrega_estimada DATETIME,
    fecha_entrega_real DATETIME,
    tipo_carga VARCHAR(100),
    peso DECIMAL(10,2) COMMENT 'En toneladas',
    volumen DECIMAL(10,2) COMMENT 'En m3',
    valor_flete DECIMAL(12,2),
    estado ENUM('Pendiente', 'En ruta', 'Entregado', 'Cancelado') DEFAULT 'Pendiente',
    notas TEXT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de asignaciones vehículo-conductor
CREATE TABLE asignaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transporte_id INT NOT NULL,
    vehiculo_id INT NOT NULL,
    conductor_id INT NOT NULL,
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    estado ENUM('Activo', 'Completado', 'Cancelado') DEFAULT 'Activo',
    kilometraje_inicial DECIMAL(10,1),
    kilometraje_final DECIMAL(10,1),
    FOREIGN KEY (transporte_id) REFERENCES transportes(id),
    FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id),
    FOREIGN KEY (conductor_id) REFERENCES conductores(id),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla para registrar contactos de WhatsApp
CREATE TABLE contactos_whatsapp (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    servicio VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    estado ENUM('Nuevo', 'Contactado', 'Proceso', 'Cerrado') DEFAULT 'Nuevo',
    atendido_por VARCHAR(100),
    notas TEXT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de usuarios del sistema
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    rol ENUM('Admin', 'Supervisor', 'Operador') NOT NULL,
    estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo',
    ultimo_acceso TIMESTAMP NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insertar datos iniciales
INSERT INTO clientes (nombre, empresa, telefono, email, direccion, ciudad, provincia, codigo_postal) VALUES 
('Juan Pérez', 'Distribuidora Alimentos S.A.', '5491112345678', 'jperez@alimentos.com', 'Av. Industrial 123', 'Buenos Aires', 'Buenos Aires', 'B1708'),
('María González', 'Importadora Textil', '5491145678912', 'm.gonzalez@importadora.com', 'Calle 45 N° 678', 'Córdoba', 'Córdoba', 'X5000'),
('Transportes del Litoral', 'Transportes del Litoral SRL', '5491134567890', 'ventas@transporte.com', 'Ruta 9 Km 123', 'Rosario', 'Santa Fe', 'S2000');

INSERT INTO vehiculos (matricula, modelo, marca, anio, capacidad, tipo_vehiculo, estado, kilometraje, ultima_revision, prox_revision) VALUES 
('ABC123', 'FH16', 'Volvo', 2020, 50.00, 'Remolque', 'Disponible', 125000.5, '2023-05-15', '2023-11-15'),
('XYZ987', 'Actros', 'Mercedes', 2021, 15.00, 'Refrigerado', 'En ruta', 78000.3, '2023-06-20', '2023-12-20'),
('DEF456', 'T8', 'Scania', 2019, 8.00, 'Volquete', 'Disponible', 145200.7, '2023-04-10', '2023-10-10');

INSERT INTO conductores (dni, nombre, apellido, telefono, email, direccion, licencia, categoria_licencia, vencimiento_licencia, estado) VALUES 
('30123456', 'Carlos', 'López', '5491156781234', 'c.lopez@transporte.com', 'Av. Rivadavia 456', 'A12345678', 'B2', '2025-08-31', 'Activo'),
('32234567', 'Pedro', 'Martínez', '5491167892345', NULL, 'Calle Falsa 123', 'B23456789', 'D1', '2024-05-15', 'Activo'),
('28345678', 'Ana', 'Sánchez', '5491178912345', 'a.sanchez@transporte.com', 'Belgrano 789', 'C34567890', 'C', '2026-03-20', 'Vacaciones');

INSERT INTO usuarios (username, password_hash, nombre, email, rol) VALUES 
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrador', 'admin@transporte.com', 'Admin'),
('supervisor1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Supervisor 1', 'supervisor@transporte.com', 'Supervisor'),
('operador1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Operador 1', 'operador@transporte.com', 'Operador');

-- Creación de vistas útiles
CREATE VIEW vista_vehiculos_disponibles AS 
SELECT * FROM vehiculos WHERE estado = 'Disponible';

CREATE VIEW vista_transportes_pendientes AS
SELECT t.id, c.nombre AS cliente, t.origen, t.destino, t.fecha_recoleccion, t.fecha_entrega_estimada, t.estado
FROM transportes t
JOIN clientes c ON t.cliente_id = c.id
WHERE t.estado = 'Pendiente';

CREATE VIEW vista_contactos_sin_atender AS
SELECT * FROM contactos_whatsapp WHERE estado = 'Nuevo' ORDER BY creado_en DESC;

-- Creación de procedimientos almacenados
DELIMITER //
CREATE PROCEDURE registrar_nuevo_contacto(
    IN p_nombre VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_servicio VARCHAR(100),
    IN p_mensaje TEXT
)
BEGIN
    INSERT INTO contactos_whatsapp (nombre, telefono, servicio, mensaje)
    VALUES (p_nombre, p_telefono, p_servicio, p_mensaje);
END //
DELIMITER ;

CREATE TRIGGER before_vehiculo_update
BEFORE UPDATE ON vehiculos
FOR EACH ROW
BEGIN
    IF NEW.kilometraje < OLD.kilometraje THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El kilometraje no puede disminuir';
    END IF;
END;
