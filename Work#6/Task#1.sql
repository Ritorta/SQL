Урок 6. SQL – Транзакции. Временные таблицы, управляющие конструкции, циклы

Создайте процедуру, которая принимает кол-во сек и формат их в кол-во дней часов. 
Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '


-----------
Вариант №1 - Через процедуру
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE PROCEDURE W6T1(seconds INT)

  BEGIN
    DECLARE days INT;
    DECLARE hours INT;
    DECLARE min INT;
    DECLARE sec INT;
      SET days = FLOOR(seconds / (60 * 60 * 24));
      SET hours = FLOOR((seconds % (60 * 60 * 24)) / (60 * 60));
      SET min = FLOOR((seconds % (60 * 60)) / 60);
      SET sec = FLOOR(seconds % 60);
      SET @result = CONCAT(days, ' дней ', hours, ' часов ', min, ' минут ', sec, ' секунды ');
  END //

DELIMITER ;

CALL W6T1(123456);

SELECT @result AS 'Day and Time';

-----------
Вариант №2 - Через функцию с помощью IF
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE FUNCTION W6T1(seconds int) 
RETURNS varchar(250)
DETERMINISTIC
	BEGIN
	  DECLARE result varchar(250);
	  DECLARE days_value int DEFAULT 0;
	  DECLARE hours_value int DEFAULT 0;
	  DECLARE minutes_value int DEFAULT 0;

	  -- считаем дни
	  IF seconds >= 86400 THEN
		SET days_value = seconds DIV 86400;
		SET seconds = seconds % 86400;
	  END IF;

	  -- считаем часы
	  IF seconds >= 3600 THEN
		SET hours_value = seconds DIV 3600;
		SET seconds = seconds % 3600; 
	  END IF;

	  -- считаем минуты / секунды
	  IF seconds >= 60 THEN
		SET minutes_value = seconds DIV 60;
		SET seconds = seconds % 60;
	  END IF;
    
	  SET result = CONCAT(
						CAST(days_value AS CHAR), ' дней ',
						CAST(hours_value AS CHAR), ' час ',
						CAST(minutes_value AS CHAR), 'мин.');
	  SET result = CONCAT(result, CAST(seconds AS CHAR), ' сек.');
	  
	  RETURN result;
	  
	END //

DELIMITER ;

SELECT W6T1(123456) time FROM DUAL;


-----------
Вариант №3 - Через функцию
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE FUNCTION W6T1(val INT)
	RETURNS char(15)
  DETERMINISTIC
	BEGIN
		DECLARE dd CHAR(3);
		DECLARE hh, mm, ss CHAR(2);
		DECLARE result CHAR(15);
			SET dd = cast(floor(val/60/60/24) AS CHAR(3));
			SET hh = cast(floor(mod(val/60/60/24,1)*24) AS CHAR(2));
			SET mm = cast(floor(mod(mod(val/60/60/24,1)*24,1)*60) AS CHAR(2));
			SET ss = cast(round(mod(mod(mod(val/60/60/24,1)*24,1)*60,1)*60) AS CHAR(2));
			SET result = concat(dd,'.',hh,':',mm,':',ss);
		RETURN result;
	END //

DELIMITER ;

SELECT W6T1(123456) AS 'Day and Time';


