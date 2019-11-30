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
	(CASE WHEN i_sortBy = "comName" AND i_sortDirection = "ASC" THEN theaterinfo.comName END) ASC,    
	(CASE WHEN i_sortBy = "numCityCover" AND i_sortDirection = "ASC" THEN numCityCover END) ASC,    
	(CASE WHEN i_sortBy = "numTheater" AND i_sortDirection = "ASC" THEN numTheater END)ASC,    
	(CASE WHEN i_sortBy = "numEmployee" AND i_sortDirection = "ASC" THEN numEmployee END) ASC,
	(CASE WHEN i_sortBy = "comName" AND i_sortDirection = "DESC" THEN theaterinfo.comName END) DESC,    
	(CASE WHEN i_sortBy = "numCityCover" AND i_sortDirection = "DESC" THEN numCityCover END) DESC,    
	(CASE WHEN i_sortBy = "numTheater" AND i_sortDirection = "DESC" THEN numTheater END) DESC,    
	(CASE WHEN i_sortBy = "numEmployee" AND i_sortDirection = "DESC" THEN numEmployee END) DESC,
	(CASE WHEN i_sortBy = "" AND i_sortDirection = "" THEN theaterinfo.comName END) DESC;
end$$
delimiter ;
