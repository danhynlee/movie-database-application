-- screen 4
drop procedure if exists customer_only_register;
delimiter $$
create definer = `root`@`localhost` procedure `customer_only_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
begin
        insert into user(Username, Firstname, Lastname, Password) 
        values (i_username, i_firstname, i_lastname, md5(i_password));
        insert into customer (Username) values (i_username);
end$$
delimiter ;

-- screen 4
drop procedure if exists customer_add_creditcard;
delimiter $$
create definer = `root`@`localhost` procedure `customer_add_creditcard`(in i_username varchar(50), in i_creditCardNum char(16)) 
begin
		insert into creditcard (CreditCardnum, Cusername) values (i_creditCardNum, i_username);
end$$
delimiter ;

-- screen 5
drop procedure if exists manager_only_register;
delimiter $$
create definer = `root`@`localhost` procedure `manager_only_register`(in i_username varchar(50), in i_password varchar(50), in i_firstname varchar(50), in i_lastname varchar(50), in i_comName varchar(50), in i_empStreet varchar(50), in i_empCity varchar(50), in i_empState varchar(50), i_empZipcode varchar(50))
begin
	insert into user(username, firstname, lastname, password) 
    values (i_username, i_firstname, i_lastname, md5(i_password));
    insert into employee(Username) values (i_username);
    insert into manager(Username, MngStreet, MngCity, MngState, MngZipcode, CoName) 
    values (i_username, i_empstreet, i_empCity, i_empState, i_empZipcode, i_comName);
    
    
end$$
delimiter;

-- screen 6
drop procedure if exists manager_customer_register;
delimiter $$
create definer = `root`@`localhost` procedure `manager_customer_register`(in i_username varchar(50), in i_password varchar(50), in i_firstname varchar(50), in i_lastname varchar(50), in i_comName varchar(50), in i_empStreet varchar(50), in i_empCity varchar(50), in i_empState varchar(50), i_empZipcode varchar(50))
begin
		insert into user(username, firstname, lastname, password) 
		values (i_username, i_firstname, i_lastname, md5(i_password));
		insert into employee(Username) values (i_username);
        insert into manager(Username, MngStreet, MngCity, MngState, MngZipcode, CoName) 
		values (i_username, i_empstreet, i_empCity, i_empState, i_empZipcode, i_comName);
		insert into customer(Username) values (i_username);
end$$
delimiter ;

-- screen 6
drop procedure if exists manager_customer_add_creditcard;
delimiter $$
create definer = `root`@`localhost` procedure `manager_customer_add_creditcard`(in i_username varchar(50), in i_creditCardNum char(16)) 
begin
		insert into creditcard (CreditCardnum, Cusername) values (i_creditCardNum, i_username);
end$$
delimiter ;

-- screen 13
drop procedure if exists admin_approve_user;
delimiter $$
create definer = `root`@`localhost` procedure `admin_approve_user`(in i_username varchar(50))
begin
		update user set status = "Approved" where Username = i_username;
end$$
delimiter ;

-- screen 13
drop procedure if exists admin_decline_user;
delimiter $$
create definer = `root`@`localhost` procedure `admin_decline_user`(in i_username varchar(50))
begin
		update user set status = "Declined" where Username = i_username;
end$$
delimiter ;

-- screen 13
drop procedure if exists admin_filter_user;
delimiter $$
create definer = `root`@`localhost` procedure `admin_filter_user`(in i_username varchar(50), in i_status enum("Approved","Pending","Declined","ALL"), in i_sortBy enum("username","creditCardCount","userType","status"), in i_sortDirection enum("ASC","DESC"))
begin
	drop table if exists AdFilterUser;
    create table AdFilterUser
    select username, count(creditcardnum) as creditCardCount, case
	when i_username in (select username from admin) then "Admin" 
	when i_username in (select customer.username from customer, admin where customer.username = admin.username)
	then "CustomerAdmin"
	when i_username in (select customer.username from customer, manager where customer.username = manager.username)
	then "CustomerManager" 
	when i_username in (select username from manager) then "Manager" 
	when i_username in (select username from customer) then "Customer"
	else "User"
	end as userType
	, status
	from user left join creditcard
	on username = cusername
	group by username
	ORDER BY    
	(CASE WHEN i_sortBy = "username" AND i_sortDirection = "ASC" THEN username END) ASC,    
	(CASE WHEN i_sortBy = "creditCardCount" AND i_sortDirection = "ASC" THEN creditCardCount END) ASC,    
	(CASE WHEN i_sortBy = "userType" AND i_sortDirection = "ASC" THEN userType END)ASC,    
	(CASE WHEN i_sortBy = "status" AND i_sortDirection = "ASC" THEN status END) ASC,
	(CASE WHEN i_sortBy = "username" AND i_sortDirection = "DESC" THEN username END) DESC,    
	(CASE WHEN i_sortBy = "creditCardCount" AND i_sortDirection = "DESC" THEN creditCardCount END) DESC,    
	(CASE WHEN i_sortBy = "userType" AND i_sortDirection = "DESC" THEN userType END) DESC,    
	(CASE WHEN i_sortBy = "status" AND i_sortDirection = "DESC" THEN status END) DESC,
	(CASE WHEN i_sortBy = "" AND i_sortDirection = "" THEN username END) DESC;
end $$
delimiter ;
    
-- screen 14
drop procedure if exists admin_filter_company;
delimiter $$
create definer = `root`@`localhost` procedure `admin_filter_company`(in I_comName varchar(50), in i_minCity int, in i_masCity int, in i_minTheater int, in i_maxTheater int, in i_minEmployee int, in i_maxEmployee int, in i_sortBy enum("comName","numCityCover", "numTheater","numEmployee"), in i_sortDirection enum("ASC","DESC"))
begin
		drop table if exists AdFilterCom;
		create table AdFilterCom
        select companyname as comName,  count(concat(thtrCity," ",thtrState)) as numCityCover, count(distinct name) as numTheater, count(distinct username) as numEmployee
		from theater inner join manager
		on companyname = coname
		group by companyname
		order by 
	(CASE WHEN i_sortBy = "comName" AND i_sortDirection = "ASC" THEN comName END) ASC,    
	(CASE WHEN i_sortBy = "numCityCover" AND i_sortDirection = "ASC" THEN numCityCover END) ASC,    
	(CASE WHEN i_sortBy = "numTheater" AND i_sortDirection = "ASC" THEN numTheater END)ASC,    
	(CASE WHEN i_sortBy = "numEmployee" AND i_sortDirection = "ASC" THEN numEmployee END) ASC,
	(CASE WHEN i_sortBy = "comName" AND i_sortDirection = "DESC" THEN comName END) DESC,    
	(CASE WHEN i_sortBy = "numCityCover" AND i_sortDirection = "DESC" THEN numCityCover END) DESC,    
	(CASE WHEN i_sortBy = "numTheater" AND i_sortDirection = "DESC" THEN numTheater END) DESC,    
	(CASE WHEN i_sortBy = "numEmployee" AND i_sortDirection = "DESC" THEN numEmployee END) DESC,
	(CASE WHEN i_sortBy = "" AND i_sortDirection = "" THEN comName END) DESC;
end$$
delimiter ;

DROP PROCEDURE IF EXISTS user_register;
DELIMITER $$
create definer = `root`@`localhost` PROCEDURE `user_register`(IN i_username VARCHAR(50), IN i_password VARCHAR(50), IN i_firstname VARCHAR(50), IN i_lastname VARCHAR(50))
BEGIN
		INSERT INTO user (username, firstname, lastname, password) 
        VALUES (i_username, i_firstname, i_lastname, MD5(i_password));
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS user_filter_th;
DELIMITER $$
create definer = `root`@`localhost` PROCEDURE `user_filter_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_city VARCHAR(50), IN i_state VARCHAR(3))
BEGIN
    DROP TABLE IF EXISTS UserFilterTh;
    CREATE TABLE UserFilterTh
	SELECT Name, thtrStreet, thtrCity, thtrState, thtrZipcode, CompanyName 
    FROM Theater
    WHERE 
		(thtrName = i_thName OR i_thName = "ALL") AND
        (companyName = i_comName OR i_comName = "ALL") AND
        (thtrCity = i_city OR i_city = "") AND
        (thtrState = i_state OR i_state = "ALL");
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS user_visit_th;
DELIMITER $$
create definer = `root`@`localhost` PROCEDURE `user_visit_th`(IN i_thName VARCHAR(50), IN i_comName VARCHAR(50), IN i_visitDate DATE, IN i_username VARCHAR(50))
BEGIN
    INSERT INTO visit (Date, username, theaterName, coName)
    VALUES (i_visitDate, i_username, i_thName, i_comName);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS user_filter_visitHistory;
DELIMITER $$
create definer = `root`@`localhost` PROCEDURE `user_filter_visitHistory`(IN i_username VARCHAR(50), IN i_minVisitDate DATE, IN i_maxVisitDate DATE)
BEGIN
    DROP TABLE IF EXISTS UserVisitHistory;
    CREATE TABLE UserVisitHistory
	SELECT thtrName, thtrStreet, thtrCity, thtrState, thtrZipcode, coName, Date
    FROM visit
		NATURAL JOIN
        Theater
	WHERE
		(username = i_username) AND
        (i_minVisitDate IS NULL OR Date >= i_minVisitDate) AND
        (i_maxVisitDate IS NULL OR Date <= i_maxVisitDate);
END$$
DELIMITER ;