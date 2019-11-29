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
