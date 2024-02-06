Урок 6. SQL – Транзакции. Временные таблицы, управляющие конструкции, циклы

Создайте функцию, которая выводит только четные числа от 1 до 10. Пример: 2,4,6,8,10 

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