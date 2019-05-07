create Database TimeCard
on
PRIMARY
(NAME='TimeCard_Primary',
	FILENAME=
		'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\TimeCard_Prm.mdf',
		SIZE=20MB,
		MAXSIZE=100MB,
		FILEGROWTH=4MB),
		FILEGROUP TimeCard_FG1
(NAME='TimeCard_FG1_Dat1',
	FILENAME=
		'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\TimeCard_FG_1.ndf',
		SIZE=20MB,
		MAXSIZE=100MB,
		FILEGROWTH=4MB),
(NAME='TimeCard_FG2_Dat2',
	FILENAME=
		'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\TimeCard_FG_2.ndf',
		SIZE=20MB,
		MAXSIZE=100MB,
		FILEGROWTH=4MB)
LOG ON
(NAME='TimeCard_log',
	FILENAME=
		'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\TimeCard.ldf',
		SIZE=20MB,
		MAXSIZE=100MB,
		FILEGROWTH=4MB)
GO

create schema CustomerDetails
go

create schema Payment
go

create schema ProjectDetails
go

create schema HumanResources
go



--1.) Creating Table 1:(CustomerDetails.Clients)--

create table CustomerDetails.Clients
(
ClientID int Identity(1,1) primary key,
CompanyName varchar(30) not null,
Address varchar(50) not null,
City varchar(30) not null,
State varchar(20) not null,
Zip int not null,
Country varchar(30) not null,
ContactPerson varchar(30) not null,
Phone varchar(30) not null CONSTRAINT chkPhone check(Phone like'[0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]')
);
go
		---Validate Table 1---
insert into CustomerDetails.Clients(CompanyName,Address,City,State,Zip,Country,ContactPerson,Phone) values
('Callistus and Sons', 'Lugbe', 'F.C.T','Abuja','900358','Nigeria','Callistus Ugonagbo','00-234-8102-621-300'),
('Habib Millets', 'LifeCamp', 'F.C.T','Abuja','900301','Nigeria','Hassan Habib','00-234-7030-387-779'),
('EduMalaysia', 'DeiDei', 'F.C.T', 'Abuja','400211', 'Nigeria', 'Nedu Kelechi','00-234-8031-342-561');

select * from CustomerDetails.Clients


----------------------------------------------------------------------------------------------------------------------------------------------


--2.) Creating Table2:(HumanResources.Employee)--

create table HumanResources.Employee
(
EmployeeID int Identity(100,1) primary key,
FirstName varchar(30) not null,
LastName varchar(30) not null,
Title varchar(20) CONSTRAINT chkTitle check (Title in('Trainee', 'Team Member', 'Team Leader', 'Project Manager', 'Senior Project Manager')),
Phone varchar(30) not null CONSTRAINT chkPhone check(Phone like'[0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'),
BillingRate int not null CONSTRAINT chkBill check(BillingRate>0)
);
go

		--Validate Table 2---

insert into HumanResources.Employee(FirstName,LastName,Title,Phone,BillingRate) values
('Paul', 'Walker', 'Project Manager', '00-199-4432-310-430', '500'),
('Vin', 'Diesel', 'Project Manager', '00-191-3242-333-412', '700'),
('Michelle', 'Rodriguez', 'Team Leader', '00-191-3233-310-311', '400'); 
select * from HumanResources.Employee

----------------------------------------------------------------------------------------------------------------------------------------------


--3.) Creating Table3:(ProjectDetails.Projects)--==>(HAS FOREIGN KEY related to CustomerDetails.Clients(ClientID))

create table ProjectDetails.Projects
(
ProjectID int Identity(200,1) primary key,
ClientID int not null foreign key references CustomerDetails.Clients(ClientID),
ProjectName varchar(30) not null,
ProjectDescription varchar(100) not null,
BillingEstimate money not null CONSTRAINT chkOWO check(BillingEstimate>0),
StartDate date not null,
EndDate date not null
);
go 

			---	validate Table 3 ---

insert into ProjectDetails.Projects(ClientID,ProjectName,ProjectDescription,BillingEstimate,StartDate,EndDate) values
('1', 'Fast and Furious 1', 'Undercover Cop', '$10000', '1/18/2018', '1/27/2018'),
('2', 'Fast and Furious 2', 'Thank God For fast cars', '$20000', '2/18/2009', '08/20/2009'),
('3', 'Fast and Furious 3', 'The drug deal', '$50000', '3/15/2010', '10/25/2010')

select * from ProjectDetails.Projects



----------------------------------------------------------------------------------------------------------------------------------------------


--4.) Creating Table 4:(Payment.PaymentMethod)--


create table Payment.PaymentMethod
(
PaymentMethodID int Identity(1,1) primary key,
Desrcription varchar(50) not null
)
go

		--Validate Table 4 ---

insert into Payment.PaymentMethod values
('Cash'),
('Cheque'),
('Transfer'),
('CreditCard')
go


----------------------------------------------------------------------------------------------------------------------------------------------


--5.) Creating Table 5:(Payment.Paymennts)--