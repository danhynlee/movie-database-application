use team55;
-- screen 3
DROP PROCEDURE IF EXISTS user_register;
DELIMITER $$
create definer = `root`@`localhost` PROCEDURE `user_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
		INSERT INTO user (username, password, firstname, lastname) 
        VALUES (i_username, MD5(i_password), i_firstname, i_lastname);
END$$
DELIMITER ;

-- screen 4
drop procedure if exists customer_only_register;
delimiter $$
create definer = `root`@`localhost` procedure `customer_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
begin
        insert into user(username, password, firstname, lastname) 
        values (i_username, md5(i_password), i_firstname, i_lastname);
        insert into customer (username) values (i_username);
end$$
delimiter ;

-- screen 4
drop procedure if exists customer_add_creditcard;
delimiter $$
create definer = `root`@`localhost` procedure `customer_add_creditcard`(in i_username varchar(50), in i_creditCardNum char(16)) 
begin
		insert into customercreditcard (creditCardNum, username) values (i_creditCardNum, i_username);
end$$
delimiter ;

-- screen 5
drop procedure if exists manager_only_register;
delimiter $$
create definer = `root`@`localhost` procedure `manager_only_register`(in i_username varchar(50), in i_password varchar(50), in i_firstname varchar(50), in i_lastname varchar(50), in i_comName varchar(50), in i_empStreet varchar(50), in i_empCity varchar(50), in i_empState varchar(50), i_empZipcode varchar(50))
begin
	insert into user(username, password, firstname, lastname) 
    values (i_username, md5(i_password), i_firstname, i_lastname);
    insert into employee(username) values (i_username);
    insert into manager(username, comName, manStreet, manCity, manState, manZipcode) 
    values (i_username, i_comName, i_empstreet, i_empCity, i_empState, i_empZipcode);
    
    
end$$
delimiter;

-- screen 6
drop procedure if exists manager_customer_register;
delimiter $$
create definer = `root`@`localhost` procedure `manager_customer_register`(in i_username varchar(50), in i_password varchar(50), in i_firstname varchar(50), in i_lastname varchar(50), in i_comName varchar(50), in i_empStreet varchar(50), in i_empCity varchar(50), in i_empState varchar(50), i_empZipcode varchar(50))
begin
		insert into user(username, password, firstname, lastname) 
		values (i_username, md5(i_password), i_firstname, i_lastname);
		insert into employee(username) values (i_username);
        insert into manager(username, comName, manStreet, manCity, manState, manZipcode) 
		values (i_username, i_comName, i_empstreet, i_empCity, i_empState, i_empZipcode);
		insert into customer(username) values (i_username);
end$$
delimiter ;

-- screen 6
drop procedure if exists manager_customer_add_creditcard;
delimiter $$
create definer = `root`@`localhost` procedure `manager_customer_add_creditcard`(in i_username varchar(50), in i_creditCardNum char(16)) 
begin
		insert into customercreditcard (creditCardNum, username) values (i_creditCardNum, i_username);
end$$
delimiter ;

-- screen 13
drop procedure if exists admin_approve_user;
delimiter $$
create definer = `root`@`localhost` procedure `admin_approve_user`(in i_username varchar(50))
begin
		update user set status = "Approved" where username = i_username;
end$$
delimiter ;

-- screen 13
drop procedure if exists admin_decline_user;
delimiter $$
create definer = `root`@`localhost` procedure `admin_decline_user`(in i_username varchar(50))
begin
		update user set status = "Declined" where username = i_username;
end$$
delimiter ;

-- screen 13
drop procedure if exists admin_filter_user;
delimiter $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_filter_user`(in i_username varchar(50), in i_status enum("Approved","Pending","Declined","ALL"), in i_sortBy enum("username","creditCardCount","userType","status"), in i_sortDirection enum("ASC","DESC"))
begin
	drop table if exists AdFilterUser;
    create table AdFilterUser
    select user.username, count(creditCardNum) as creditCardCount, (case
	when (user.username in (select username from customer) and user.username in (select username from admin))
	then "CustomerAdmin"
	when user.username in (select username from customer) and user.username in (select username from manager)
	then "CustomerManager" 
    when user.username in (select username from admin) and user.username not in (select username from customer) then "Admin" 
	when user.username in (select username from manager) and user.username not in (select username from customer) then "Manager" 
	when user.username in (select username from customer) and user.username not in (select username from admin) and user.username not in (select username from manager) then "Customer"
    else "User"
	end) as userType
	, status
	from user left join customercreditcard
	on user.username = customercreditcard.username
    where 
    (user.username = i_username or i_username = "") AND
    (status = i_status or i_status = "ALL")
    group by user.username
	ORDER BY  
	(CASE WHEN i_sortBy = "username" AND i_sortDirection = "ASC" THEN user.username END) ASC,    
	(CASE WHEN i_sortBy = "creditCardCount" AND i_sortDirection = "ASC" THEN creditCardCount END) ASC,    
	(CASE WHEN i_sortBy = "userType" AND i_sortDirection = "ASC" THEN userType END)ASC,    
	(CASE WHEN i_sortBy = "status" AND i_sortDirection = "ASC" THEN status END) ASC,
	(CASE WHEN i_sortBy = "username" AND i_sortDirection = "DESC" THEN user.username END) DESC,    
	(CASE WHEN i_sortBy = "creditCardCount" AND i_sortDirection = "DESC" THEN creditCardCount END) DESC,    
	(CASE WHEN i_sortBy = "userType" AND i_sortDirection = "DESC" THEN userType END) DESC,    
	(CASE WHEN i_sortBy = "status" AND i_sortDirection = "DESC" THEN status END) DESC,
	(CASE WHEN i_sortBy = ""  AND i_sortDirection = "" THEN user.username END) DESC;
end $$
delimiter ;
    
-- screen 14
drop procedure if exists admin_filter_company;
delimiter $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_filter_company`(in i_comName varchar(50), in i_minCity int, in i_maxCity int, in i_minTheater int, in i_maxTheater int, in i_minEmployee int, in i_maxEmployee int, in i_sortBy enum("comName","numCityCover", "numTheater","numEmployee"), in i_sortDirection enum("ASC","DESC"))
begin
		drop table if exists AdFilterCom;
		create table AdFilterCom
        select thdata.comName as comName, numCityCover, numTheater, numEmployee 
		from(
		(select comName,  count(distinct concat(thCity,thState)) as numCityCover, count(distinct thname) as numTheater
		from theater group by comName) as thdata
        inner join
		(select comName, count(distinct username) as numEmployee from manager group by comName) as mandata
		on thdata.comName = mandata.comName)
		where (thdata.comName = i_comname or i_comName = "ALL" or i_comName = "") and
		(i_minCity = "" or  numCityCover>= i_minCity or i_minCity is NULL) and
		(i_maxCity = "" or numCityCover <= i_maxCity or i_maxCity is NULL) and
		(i_minTheater = "" or numTheater >= i_minTheater or i_minTheater is NULL) and
		(i_maxTheater = "" or numTheater <= i_maxTheater or i_maxTheater is NULL) and
		(i_minEmployee = "" or numEmployee >= i_minEmployee or i_minEmployee is NULL) and 
		(i_maxEmployee = "" or numEmployee <= i_maxEmployee or i_maxEmployee is NULL)
		order by 
	(CASE WHEN i_sortBy = "comName" AND i_sortDirection = "ASC" THEN thdata.comName END) ASC,    
	(CASE WHEN i_sortBy = "numCityCover" AND i_sortDirection = "ASC" THEN numCityCover END) ASC,    
	(CASE WHEN i_sortBy = "numTheater" AND i_sortDirection = "ASC" THEN numTheater END)ASC,    
	(CASE WHEN i_sortBy = "numEmployee" AND i_sortDirection = "ASC" THEN numEmployee END) ASC,
	(CASE WHEN i_sortBy = "comName" AND i_sortDirection = "DESC" THEN thdata.comName END) DESC,    
	(CASE WHEN i_sortBy = "numCityCover" AND i_sortDirection = "DESC" THEN numCityCover END) DESC,    
	(CASE WHEN i_sortBy = "numTheater" AND i_sortDirection = "DESC" THEN numTheater END) DESC,    
	(CASE WHEN i_sortBy = "numEmployee" AND i_sortDirection = "DESC" THEN numEmployee END) DESC,
	(CASE WHEN i_sortBy = "" AND i_sortDirection = "" THEN thdata.comName END) DESC;
end$$
delimiter ;

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
CREATE definer = `root`@`localhost` PROCEDURE `manager_filter_th`(IN i_manUsername VARCHAR(50), IN i_movName VARCHAR(50), IN i_minMovDuration INT(50), IN i_maxMovDuration INT(50), IN i_minMovReleaseDate DATE, IN i_maxMovReleaseDate DATE, IN i_minMovPlayDate DATE, IN i_maxMovPlayDate DATE, IN i_includedNotPlay BOOL)
BEGIN
    DROP TABLE IF EXISTS ManFilterTh;
    CREATE TABLE ManFilterTh
	SELECT DISTINCT m.movName, duration AS movDuration, m.movReleaseDate, movPlayDate, i_includedNotPlay
    FROM movieplay as p
		RIGHT OUTER JOIN
        movie as m
        ON p.movName = m.movName
	WHERE
		(i_includedNotPlay IS NULL OR i_includedNotPlay != 1 OR i_includedNotPlay != TRUE) AND
		(m.movName = i_movName OR i_movName = "ALL" OR i_movName = "") AND
        (i_minMovDuration IS NULL OR duration >= i_minMovDuration) AND
        (i_maxMovDuration IS NULL OR duration <= i_maxMovDuration) AND
        (i_minMovPlayDate IS NULL OR movPlayDate >= i_minMovPlayDate) AND
        (i_maxMovPlayDate IS NULL OR movPlayDate <= i_maxMovPlayDate) AND 
		(thName IN (SELECT thName FROM theater WHERE manUsername = i_manUsername)) 
UNION
(SELECT movName, duration AS movDuration, movReleaseDate, NULL AS movPlayDate, i_includedNotPlay
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
