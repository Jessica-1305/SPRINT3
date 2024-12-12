		-- NIVEL 1 --
-- Ejercicio1
CREATE TABLE credit_card (
	id VARCHAR (15) NOT NULL PRIMARY KEY,
	iban VARCHAR (50) NOT NULL,
	pan VARCHAR(50) NOT NULL,
	pin VARCHAR (10) NOT NULL,
	cvv VARCHAR (6) NOT NULL,
	expiring_date VARCHAR (15) NOT NULL
);

SELECT COUNT(*) FROM credit_card;

ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

SELECT * FROM credit_card;

-- Ejercicio2:
SELECT id, iban FROM credit_card WHERE id = 'CcU-2938';

UPDATE credit_card
SET iban = 'R323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT id, iban FROM credit_card WHERE id = 'CcU-2938';

-- Ejercicio3:
SELECT COUNT(*) FROM user;

INSERT INTO company (id) VALUES ('b-9999');
SELECT * FROM company WHERE id = 'b-9999';

INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date)
VALUES ('CcU-9999', '0', '0', '0', '0', '2025-01-01');

INSERT INTO transaction
	(id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
    VALUES 
    ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', 829.999, -117.999, 111.11, 0);
    
SELECT * FROM transaction WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

-- Ejercicio 4
ALTER TABLE credit_card
DROP COLUMN pan;

SELECT * FROM credit_card;

		-- NIVEL 2 --
-- Ejercicio1: Borrar la transaction con id 02C6201E-D90A-1859-B4EE-88D2986D3B02
-- Comprobar antes con select
SELECT * FROM transaction WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

DELETE FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

-- Compruebo que se ha eliminado el registro
SELECT * FROM transaction WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

-- Ejercicio2
CREATE VIEW VistaMarketing  AS
SELECT 
	c.company_name, 
    c.phone, 
    c.country, 
    AVG(t.amount) AS average_sales
FROM 
	company AS c
INNER JOIN 
	transaction AS t
ON c.id = t.company_id
GROUP BY company_name, phone, country
ORDER BY average_sales DESC; 

SELECT * FROM VistaMarketing;

-- Ejercicio 3

SELECT * FROM vistamarketing
WHERE country = 'Germany';

		-- NIVEL 3 --
-- Ejericio 1

-- Creamos la tabla user
CREATE INDEX idx_user_id ON transaction(user_id);
 
CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)
);

SELECT COUNT(*) FROM user;

-- Renombrado de tablas, campos, y drop columns
ALTER TABLE user RENAME to data_user;
ALTER TABLE data_user RENAME COLUMN email to personal_email;
-- Hago este insert porque sino al agregar la FK no se podria realizar..., ya que saldria foreign key violada
INSERT INTO data_user (id) VALUES (9999);
ALTER TABLE transaction
	ADD CONSTRAINT
	FOREIGN KEY (user_id) REFERENCES data_user(id);
ALTER TABLE company DROP COLUMN website;
ALTER TABLE credit_card ADD COLUMN fecha_actual DATE;
ALTER TABLE credit_card MODIFY id VARCHAR(20);
ALTER TABLE credit_card MODIFY pin VARCHAR(4);
ALTER TABLE credit_card MODIFY cvv INT;
ALTER TABLE credit_card MODIFY expiring_date VARCHAR(20);

-- Ejercicio2

CREATE VIEW InformeTecnico AS
SELECT 
	t.id AS id_transaction,
    du.name AS nombre_usuario,
    du.surname AS apellido_usuario,
    cc.iban, 
    c.company_name AS compañia
FROM transaction as t
INNER JOIN data_user AS du ON t.user_id = du.id
INNER JOIN credit_card AS cc ON t.credit_card_id = cc.id
INNER JOIN company AS c ON t.company_id = c.id 
ORDER BY id_transaction DESC;

SELECT * FROM InformeTecnico;
