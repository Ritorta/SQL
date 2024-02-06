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
    DECLARE dd INT;
    DECLARE hh INT;
    DECLARE mm INT;
    DECLARE ss INT;
      SET dd = FLOOR(seconds / (60 * 60 * 24));
      SET hh = FLOOR((seconds % (60 * 60 * 24)) / (60 * 60));
      SET mm = FLOOR((seconds % (60 * 60)) / 60);
      SET ss = FLOOR(seconds % 60);
      SET @result = CONCAT(dd, ' days ', hh, ' hours ', mm, ' min ', ss, ' sec ');
  END //

DELIMITER ;

CALL W6T1(123456);

SELECT @result AS 'Day and Time';

-----------
Вариант №1.1 - Через фунцию
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE FUNCTION W6T1(seconds INT)

RETURNS VARCHAR(30)
DETERMINISTIC
  BEGIN
    DECLARE dd INT;
    DECLARE hh INT;
    DECLARE mm INT;
    DECLARE ss INT;
    DECLARE result VARCHAR(30);
      SET dd = FLOOR(seconds / (60 * 60 * 24));
      SET hh = FLOOR((seconds % (60 * 60 * 24)) / (60 * 60));
      SET mm = FLOOR((seconds % (60 * 60)) / 60);
      SET ss = FLOOR(seconds % 60);
      SET result = CONCAT(dd, ' days ', hh, ' hours ', mm, ' min ', ss, ' sec ');
      RETURN result;
  END //

DELIMITER ;

SELECT W6T1(123456) AS 'Day and Time';

-----------
Вариант №2 - Через процедуру
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE PROCEDURE W6T1(seconds INT)

	BEGIN
		DECLARE dd INT;
		DECLARE hh, mm, ss INT;
			SET dd = CAST(FLOOR(seconds/60/60/24) AS CHAR(3));
			SET hh = CAST(FLOOR(mod(seconds/60/60/24,1)*24) AS CHAR(2));
			SET mm = CAST(FLOOR(mod(mod(seconds/60/60/24,1)*24,1)*60) AS CHAR(2));
			SET ss = CAST(ROUND(mod(mod(mod(seconds/60/60/24,1)*24,1)*60,1)*60) AS CHAR(2));
			SET @result = CONCAT(dd,' day ', hh,' hors ', mm,' min ', ss, ' sec');
	END //

DELIMITER ;

CALL W6T1(18400000);

SELECT @result AS 'Day and Time';

-----------
Вариант №2.1 - Через функцию
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE FUNCTION W6T1(seconds INT)

RETURNS VARCHAR(30)
DETERMINISTIC
	BEGIN
		DECLARE dd INT;
		DECLARE hh, mm, ss INT;
		DECLARE result VARCHAR(30);
			SET dd = CAST(FLOOR(seconds/60/60/24) AS CHAR(3));
			SET hh = CAST(FLOOR(mod(seconds/60/60/24,1)*24) AS CHAR(2));
			SET mm = CAST(FLOOR(mod(mod(seconds/60/60/24,1)*24,1)*60) AS CHAR(2));
			SET ss = CAST(ROUND(mod(mod(mod(seconds/60/60/24,1)*24,1)*60,1)*60) AS CHAR(2));
			SET result = CONCAT(dd,' day ', hh,' hors ', mm,' min ', ss, ' sec');
		RETURN result;
	END //

DELIMITER ;

SELECT W6T1(123456) AS 'Day and Time';

-----------
Вариант №3 - Через процедуру с помощью IF
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE PROCEDURE W6T1(seconds int) 

	BEGIN
	  DECLARE days_value INT;
	  DECLARE hours_value INT;
	  DECLARE minutes_value INT;
	  -- параметр "DIV" тоже деление но работает более коректно нежели просто символ "/" в данном случае

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
      
      -- склеиваем дни/часы/минуты/секунды
	  SET @result = CONCAT(CAST(days_value AS CHAR), ' дней ', CAST(hours_value AS CHAR), ' час ', CAST(minutes_value AS CHAR), ' мин ', CAST(seconds AS CHAR), ' сек.');
	   
	END //

CALL W6T1(123456);

SELECT @result AS 'Day and Time';

-----------
Вариант №3.1 - Через функцию с помощью IF
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

DELIMITER //

CREATE FUNCTION W6T1(seconds int)

RETURNS VARCHAR(20)
DETERMINISTIC
	BEGIN
	  DECLARE result VARCHAR(20);
	  DECLARE days_value INT;
	  DECLARE hours_value INT;
	  DECLARE minutes_value INT;
	  -- параметр "DIV" тоже деление но работает более коректно нежели просто символ "/" в данном случае

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
      
      -- склеиваем дни/часы/минуты/секунды
	  SET result = CONCAT(CAST(days_value AS CHAR), ' дней ', CAST(hours_value AS CHAR), ' час ', CAST(minutes_value AS CHAR), ' мин ', CAST(seconds AS CHAR), ' сек.');
	  RETURN result; 
	END //

DELIMITER ;

SELECT W6T1(123456) AS 'Day and Time';

-----------
Вариант №4 - Готовая формула с гугла
-----------

DROP DATABASE IF EXISTS work_6;
CREATE DATABASE IF NOT EXISTS work_6;
USE work_6;

SELECT
  DATE_FORMAT(DATE('1970-12-31 23:59:59')
   + interval 123456 SECOND,'%j days %Hh:%im:%ss') AS result;