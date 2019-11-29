drop database team55;
create database team55;
use team55;

CREATE TABLE Company (
	comName VARCHAR(50) NOT NULL UNIQUE,
	PRIMARY KEY (comName)
);
CREATE TABLE Movie (
	movName VARCHAR(50) NOT NULL UNIQUE,
	movReleaseDate DATE NOT NULL UNIQUE,
	duration INT NOT NULL,
	PRIMARY KEY (movName, movReleaseDate)
);
CREATE TABLE User (
	username VARCHAR(50) NOT NULL UNIQUE,
    status VARCHAR(50) NOT NULL,
    password VARCHAR(200) NOT NULL,
	firstname VARCHAR(50) NOT NULL,
	lastname VARCHAR(50) NOT NULL,
	PRIMARY KEY (Username)
);
CREATE TABLE Employee (
	username VARCHAR(50) NOT NULL,
	PRIMARY KEY (username),
	FOREIGN KEY (username)
		REFERENCES User (username)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
CREATE TABLE Customer (
	username VARCHAR(50) NOT NULL,
	PRIMARY KEY (username),
	FOREIGN KEY (username)
		REFERENCES User (username)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
CREATE TABLE Admin (
	username VARCHAR(50) NOT NULL,
	PRIMARY KEY (username),
	FOREIGN KEY (username)
		REFERENCES Employee (username)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
CREATE TABLE Manager (
	username VARCHAR(50) NOT NULL,
    comName VARCHAR(50) NOT NULL,
	manStreet VARCHAR(50) NOT NULL,
	manCity VARCHAR(50) NOT NULL,
	manState VARCHAR(50) NOT NULL,
	manZipcode VARCHAR(50) NOT NULL,
	PRIMARY KEY (username),
	FOREIGN KEY (username)
		REFERENCES Employee (username)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	FOREIGN KEY (comName)
		REFERENCES Company (comName)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
CREATE TABLE CustomerCreditCard (
	creditCardNum VARCHAR(16),
	username VARCHAR(50) NOT NULL,
	PRIMARY KEY (creditCardNum),
	FOREIGN KEY (username)
		REFERENCES Customer (username)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
CREATE TABLE Theater (
	thName VARCHAR(50) NOT NULL,
	comName VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
	thStreet VARCHAR(50) NOT NULL,
	thCity VARCHAR(50) NOT NULL,
	thState VARCHAR(50) NOT NULL,
	thZipcode VARCHAR(50) NOT NULL,
	manUsername VARCHAR(50) NOT NULL,
	PRIMARY KEY (thName, comName),
	FOREIGN KEY (comName)
		REFERENCES Company (comName)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	FOREIGN KEY (manUsername)
		REFERENCES Manager (username)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
CREATE TABLE MoviePlay (
	thName VARCHAR(50) NOT NULL,
    comName VARCHAR(50) NOT NULL,
	movName VARCHAR(50) NOT NULL,
	movReleaseDate DATE NOT NULL,
    movPlayDate DATE NOT NULL UNIQUE,
	PRIMARY KEY (thName, comName, movName, movReleaseDate, movPlayDate),
    FOREIGN KEY (thName, comName)
		REFERENCES Theater (thName, comName)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	FOREIGN KEY (movName, movReleaseDate)
		REFERENCES Movie (movName, movReleaseDate)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
CREATE TABLE VisitUserTheater (
	visitID VARCHAR(50) NOT NULL UNIQUE,
	username VARCHAR(50) NOT NULL,
	thName VARCHAR(50) NOT NULL,
	comName VARCHAR(50) NOT NULL,
    visitDate DATE NOT NULL,
	PRIMARY KEY (visitID),
	FOREIGN KEY (username)
		REFERENCES User (username)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	FOREIGN KEY (thName, comName)
		REFERENCES Theater (thName, comName)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);
CREATE TABLE CustomerViewMovie (
	creditCardNum VARCHAR(16),
    thName VARCHAR(50) NOT NULL,
    comName VARCHAR(50) NOT NULL,
	movName VARCHAR(50) NOT NULL,
	movReleaseDate DATE NOT NULL,
    movPlayDate DATE NOT NULL,
	PRIMARY KEY (creditCardNum, thName, comName, movName, movReleaseDate, movPlayDate),
	FOREIGN KEY (creditCardNum)
		REFERENCES CustomerCreditCard (creditCardNum)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	FOREIGN KEY (thName, comName, movName, movReleaseDate, movPlayDate)
		REFERENCES MoviePlay (thName, comName, movName, movReleaseDate, movPlayDate)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);


