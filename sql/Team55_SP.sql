use team55;
DROP PROCEDURE IF EXISTS user_login;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `user_login`(IN i_username VARCHAR(50), IN i_password VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS UserLogin;
    CREATE TABLE UserLogin
	SELECT username, status, IF((SELECT COUNT(*) FROM Customer WHERE username = i_username) > 0, 1, 0) AS isCustomer, IF((SELECT COUNT(*) FROM Admin WHERE username = i_username) > 0, 1, 0) AS isAdmin, IF((SELECT COUNT(*) FROM Manager WHERE username = i_username) > 0, 1, 0) AS isManager
    FROM user
    WHERE
		(username = i_username) AND
        (password = i_password);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS user_register;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `user_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
		INSERT INTO user (username, password, firstname, lastname) VALUES (i_username, MD5(i_password), i_firstname, i_lastname);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS admin_create_theater;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `admin_create_theater`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_thStreet VARCHAR(50), IN i_thCity VARCHAR(50), IN i_thState CHAR(2), IN i_thZipcode CHAR(5), IN i_capacity INT(50), IN i_manUsername VARCHAR(50))
BEGIN
		INSERT INTO theater (thName, comName, thStreet, thCity, thState, thZipcode, capacity, manUsername) VALUES (i_thName, i_comName, i_thStreet, i_thCity, i_thState, i_thZipcode, i_capacity, i_manUsername);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS admin_view_comDetail_emp;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `admin_view_comDetail_emp`(IN i_comName VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS AdComDetailEmp;
    CREATE TABLE AdComDetailEmp
	SELECT firstname AS empFirstname, lastname As empLastname
	FROM user
	WHERE username IN
	(SELECT username
    FROM Manager
	WHERE (comName = i_comName));
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS admin_view_comDetail_th;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `admin_view_comDetail_th`(IN i_comName VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS AdComDetailTh;
    CREATE TABLE AdComDetailTh
	SELECT thName, manUsername AS thManagerUsername, thCity, thState, capacity AS thCapacity
    FROM theater
	WHERE
		(comName = i_comName OR i_comName = "ALL");
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS admin_create_mov;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `admin_create_mov`(IN i_movName VARCHAR(50), IN i_movDuration INT(50), IN i_movReleaseDate DATE)
BEGIN
		INSERT INTO movie (movName, movReleaseDate, duration) VALUES (i_movName, i_movReleaseDate, i_movDuration);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS manager_filter_th;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `manager_filter_th`(IN i_manUsername VARCHAR(50), IN i_movName VARCHAR(50), IN i_minMovDuration INT(50), IN i_maxMovDuration INT(50), IN i_minMovReleaseDate DATE, IN i_maxMovReleaseDate DATE, IN i_minMovPlayDate DATE, IN i_maxMovPlayDate DATE, IN i_includedNotPlay BOOLEAN)
BEGIN
    DROP TABLE IF EXISTS ManFilterTh;
    CREATE TABLE ManFilterTh
	SELECT DISTINCT m.movName, duration AS movDuration, m.movReleaseDate, movPlayDate
    FROM movieplay as p
		RIGHT OUTER JOIN
        movie as m
        ON p.movName = m.movName
	WHERE
		(m.movName = i_movName OR i_movName = "ALL" OR i_movName = "") AND
        (i_minMovDuration IS NULL OR duration >= i_minMovDuration) AND
        (i_maxMovDuration IS NULL OR duration <= i_maxMovDuration) AND
        (i_minMovPlayDate IS NULL OR movPlayDate >= i_minMovPlayDate) AND
        (i_maxMovPlayDate IS NULL OR movPlayDate <= i_maxMovPlayDate) AND 
		(thName IN (SELECT thName FROM theater WHERE manUsername = i_manUsername)) 
        AND (i_includedNotPlay != TRUE OR i_includedNotPlay = NULL OR i_includedNotPlay = FALSE)
UNION
(SELECT movName, duration AS movDuration, movReleaseDate, NULL AS movPlayDate
FROM movie
WHERE movName NOT IN 
	(SELECT movName 
	FROM movieplay 
	WHERE thName IN 
		(SELECT thName FROM theater WHERE manUsername = i_manUsername)));
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS manager_schedule_mov;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `manager_schedule_mov`(IN i_manUsername VARCHAR(50), IN i_movName VARCHAR(50), IN i_movReleaseDate DATE, IN i_movPlayDate DATE)
BEGIN
		INSERT INTO movieplay (movPlayDate, movName, movReleaseDate, thName, comName)
		SELECT i_movPlayDate, i_movName, i_movReleaseDate, theater.thName, theater.ComName
		FROM theater
		WHERE mngUsername = i_manUsername;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS customer_filter_mov;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `customer_filter_mov`(IN i_movName VARCHAR(50), IN i_comName VARCHAR(50), IN i_city VARCHAR(50), IN i_state VARCHAR(3), IN i_minMovPlayDate DATE, IN i_maxMovPlayDate DATE)
BEGIN
    DROP TABLE IF EXISTS CosFilterMovie;
    CREATE TABLE CosFilterMovie
	SELECT movName, thName, thStreet, thCity, thState, thZipcode, comName, movPlayDate, movReleaseDate
    FROM Theater
    NATURAL JOIN
    MoviePlay
    WHERE
		(movName = i_movName OR i_movName = "ALL") AND
        (comName = i_comName OR i_comName = "ALL") AND
        (thCity = i_city OR i_city = "") AND
        (thState = i_state OR i_state = "ALL") AND
        (i_minMovPlayDate IS NULL OR movPlayDate >= i_minMovPlayDate) AND
        (i_maxMovPlayDate IS NULL OR movPlayDate <= i_maxMovPlayDate);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS customer_view_mov;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `customer_view_mov`(IN i_creditCardNum CHAR(11), IN i_movName VARCHAR(50), IN i_movReleaseDate DATE, IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_movPlayDate DATE)
BEGIN
		INSERT INTO used (creditCardNum, movPlayDate, movName, movReleaseDate, thName, comName) VALUES (i_creditCardNum, i_movPlayDate, i_movName, i_movReleaseDate, i_thName, i_comName);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS user_filter_th;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `user_filter_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_city VARCHAR(50), IN i_state VARCHAR(3))
BEGIN
    DROP TABLE IF EXISTS UserFilterTh;
    CREATE TABLE UserFilterTh
	SELECT thName, thStreet, thCity, thState, thZipcode, comName
    FROM Theater
    WHERE
		(thName = i_thName OR i_thName = "ALL") AND
        (comName = i_comName OR i_comName = "ALL") AND
        (thCity = i_city OR i_city = "") AND
        (thState = i_state OR i_state = "ALL");
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS customer_view_history;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `customer_view_history`(IN i_cusUsername VARCHAR(50))
BEGIN
    DROP TABLE IF EXISTS CosViewHistory;
    CREATE TABLE CosViewHistory
	SELECT movName, thName, comName, creditCardNum, movPlayDate
    FROM CustomerViewMovie
	WHERE creditCardNum IN
		(SELECT CreditCardNum
		FROM customercreditcard
		WHERE username = i_cusUsername);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS user_visit_th;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `user_visit_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_visitDate DATE, IN i_username VARCHAR(50))
BEGIN
    INSERT INTO UserVisitTheater (thName, comName, visitDate, username)
    VALUES (i_thName, i_comName, i_visitDate, i_username);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS user_filter_visitHistory;
DELIMITER $$
CREATE definer = `root`@`localhost` PROCEDURE `user_filter_visitHistory`(IN i_username VARCHAR(50), IN i_minVisitDate DATE, IN i_maxVisitDate DATE)
BEGIN
    DROP TABLE IF EXISTS UserVisitHistory;
    CREATE TABLE UserVisitHistory
	SELECT thName, thStreet, thCity, thState, thZipcode, comName, visitDate
    FROM UserVisitTheater
		NATURAL JOIN
        Theater
	WHERE
		(username = i_username) AND
        (i_minVisitDate IS NULL OR visitDate >= i_minVisitDate) AND
        (i_maxVisitDate IS NULL OR visitDate <= i_maxVisitDate);
END$$
DELIMITER ;
