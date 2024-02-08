Урок 6. SQL – Транзакции. Временные таблицы, управляющие конструкции, циклы

Создайте функцию, которая выводит только четные числа от 1 до 10. Пример: 2,4,6,8,10 

-----------
Вариант №1 - Фунция WHILE
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE FUNCTION W6T2(num INT)
RETURNS VARCHAR(100)
DETERMINISTIC
	BEGIN
		DECLARE i INT DEFAULT 2;
		DECLARE result VARCHAR(100) DEFAULT '';
			WHILE i <= num DO
				IF i % 2 = 0 THEN
					SET result = CONCAT(result, CAST(i AS CHAR), ' ');
				END IF;
			SET i = i + 2; 
			END WHILE;
		RETURN result;
    END //
DELIMITER ;

SELECT W6T2(10) AS 'num';


-----------
Вариант №2 - Фунция REPEAT
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE FUNCTION W6T2(num INT)
RETURNS VARCHAR(100)
DETERMINISTIC
	BEGIN
		DECLARE i INT DEFAULT 2;
		DECLARE result VARCHAR(100) DEFAULT '';
			REPEAT
				IF i % 2 = 0 THEN
					SET result = CONCAT(result, CAST(i AS CHAR), ' ');
				END IF;
			SET i = i + 2;
            UNTIL  i > num
			END REPEAT;
		RETURN result;
    END //
DELIMITER ;

SELECT W6T2(10) AS 'num';


-----------
Вариант №3 - Фунция LOOP
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE FUNCTION W6T2(num INT)
RETURNS VARCHAR(100)
DETERMINISTIC
	BEGIN
		DECLARE i INT DEFAULT 2;
		DECLARE result VARCHAR(100) DEFAULT '';
			cycle : LOOP
				IF i % 2 = 0 THEN
					SET result = CONCAT(result, i, ' ');
				END IF;
				SET i = i + 2;
                IF i > num THEN
					LEAVE cycle;
                END IF;
			END LOOP cycle;
		RETURN result;
    END //
DELIMITER ;

SELECT W6T2(10) AS 'num';

-----------
Вариант №4 - Через процедуру
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE PROCEDURE W6T2(IN num INT, OUT result VARCHAR(100))

	BEGIN
		DECLARE i INT DEFAULT 2;
		
        SET result = '';
			WHILE i <= num DO
				SET result = CONCAT(result, CAST(i AS CHAR), ' ');
			SET i = i + 2; 
			END WHILE;
    END //
DELIMITER ;


CALL W6T2(10, @result);
SELECT @result AS 'num';

-----------
Вариант №4 - Через процедуру используя временную таблицу
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE PROCEDURE W6T2(num INT)

	BEGIN
		DECLARE i INT DEFAULT 2;
		CREATE TEMPORARY TABLE IF NOT EXISTS temp (value VARCHAR(100));
        
			WHILE i <= num DO
				INSERT INTO temp (value) VALUES (CAST(i AS CHAR));
			SET i = i + 2; 
			END WHILE;
    END //
DELIMITER ;


CALL W6T2(10);
SELECT * FROM temp;

-----------
Вариант №5 - Через процедуру используя таблицу
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DROP DATABASE IF EXISTS temp;
CREATE TABLE IF NOT EXISTS temp (value VARCHAR(100));

DELIMITER //

CREATE PROCEDURE W6T2(num INT)

	BEGIN
		DECLARE i INT DEFAULT 2;
			WHILE i <= num DO
				INSERT INTO temp (value) VALUES (CAST(i AS CHAR));
			SET i = i + 2; 
			END WHILE;
    END //
    
DELIMITER ;

CALL W6T2(10);
SELECT * FROM temp;