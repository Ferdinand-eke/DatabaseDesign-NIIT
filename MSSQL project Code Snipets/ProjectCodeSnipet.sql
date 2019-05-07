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

select * from Payment.PaymentMethod
----------------------------------------------------------------------------------------------------------------------------------------------


--5.) Creating Table 5:(Payment.Paymennts)-- 


create table Payment.Payments
(
PaymentID int Identity(1000,1) primary key,
ProjectID int not null foreign key references ProjectDetails.Projects(ProjectID),
PaymentMethodID int foreign key references Payment.PaymentMethod(PaymentMethodID),
PaymentAmount int CONSTRAINT chkAmount check(PaymentAmount > 0),
PaymentDue int null,
CreditCardNumber varchar(30),
CardHoldersName varchar(30),
CreditCardExpDate date,
PaymentDate date

--check(CreditCardNumber is null and CardHoldersName is null and CreditCardExpDate is null and PaymentMethodID not in(1, 2, 3) or
-- (CreditCardNumber is not null and CardHoldersName is not null and CreditCardExpDate is not null and PaymentMethodID in (4) and creditcardexpdate > getdate()))
)
go



-------End of Table Manipulation-------


--Drop table Payment.Payments---

---------------Trigger for Table create -------------------

create trigger trg_PaymentMethod
on Payment.Payments
for insert
as 
declare @MethodID int
select @MethodID = PaymentMethodID
from inserted
if (@MethodID = 1 or @MethodID = 2 or @MethodID =3)
begin
Update Payment.Payments
set CreditCardNumber = null,
	CardHoldersName = null,
	CreditCardExpDate = null
	end

-----------------------------------------------------------------------------------------------------------------------------------
	alter table Payment.Payments
add constraint chkPaymtdue  check(paymentdue < paymentamount)

-----------------------------------------------------
alter table Payment.Payments
nocheck constraint chkPaymtdue;

alter table Payment.Payments
check constraint chkPaymtdue;
--------------------------------------------------------
alter table Payment.Payments
add constraint ChkCreditCard check (CreditCardExpDate > PaymentDate)

select* from Payment.Payments

sp_help 'Payment.Payments'
---------------------------------------------------------------------------------------------------------------------------------------
			-----Validate Table------

Insert Into Payment.Payments(ProjectID,PaymentMethodID,PaymentAmount,PaymentDue,CreditcardNumber,CardHoldersName, CreditCardExpDate,PaymentDate)
Values('201','2','11','3','0568007','Kaydee','08/01/2020','08/5/2018')


Insert Into Payment.Payments(ProjectID,PaymentMethodID,PaymentAmount,PaymentDue,CreditcardNumber,CardHoldersName, CreditCardExpDate,PaymentDate)
Values('200','4','17','10','0324867','Callistus','07/03/2019','03/05/2018')





----------------------------------------------------------------------------------------------------------------------------------------------


----6.) Creating Table 6:(ProjectDetails.WorkCodes)---

 
 create table ProjectDetails.WorkCodes
 (
 WorkCoedID int Identity(500,1) primary key,
 Description varchar(100) not null
 )
 go

		------Validate Table 6--------------

Insert into ProjectDetails.WorkCodes values
('Movie Scene Architectural Designs'),
('Costumes'),
('Music writing'),
('Photography and Camera Shoot')


select * from ProjectDetails.WorkCodes
go


----------------------------------------------------------------------------------------------------------------------------------------------


----7.) Creating Table 7:(ProjectDetails.ExpenseDetails)---


create table ProjectDetails.ExpenseDetails
(
ExpenseID int Identity(5000,1) primary key,
Description varchar(100) not null
)
go

		--------Validate Table 7----------

insert into ProjectDetails.ExpenseDetails values
('Transportation and logistics'),
('Accommodatio'),
('Feeding'),
('Miscelleneous')

select * from ProjectDetails.ExpenseDetails


----------------------------------------------------------------------------------------------------------------------------------------------


----8.) Creating Table 8:(ProjectDetails.TimeCards)---


create table ProjectDetails.TimeCards
(
TimeCardID int Identity(1,1) primary key,
EmployeeID int not null foreign key references HumanResources.Employee(EmployeeID),
WorkCoedID int not null foreign key references ProjectDetails.WorkCodes(WorkCoedID),
ProjectID int not null foreign key references ProjectDetails.Projects(ProjectID),
DateIssued date not null,
DaysWorked int not null CONSTRAINT chkDays check(DaysWorked > 0),
WorkDescription varchar(100),
BillableHours int not null CONSTRAINT chkBill check(BillableHours > 0),
TotalCost int 
);
go



		-----Trigger for table 8 @@TotalCost---------

----------------------------------------------------------
---trigger 8.1-------------------
create trigger trgtotalcost
on ProjectDetails.TimeCards
after insert
as
begin
update ProjectDetails.TimeCards
set
  TotalCost =
  BillingRate * BillableHours 
    from HumanResources.Employee h join ProjectDetails.Timecards p on
	h.EmployeeID = p.EmployeeID 
	end
	go

 --trigger 8.2--
 Create trigger trgdateissued
 on ProjectDetails.TimeCards
 for insert
 as 
    declare @dateissued date
	declare @enddate date
	select @dateissued = DateIssued from inserted 
	select @enddate = EndDate from ProjectDetails.projects 
	join ProjectDetails.TimeCards on ProjectDetails.TimeCards.ProjectID = ProjectDetails.Projects.ProjectID
	where   DateIssued = @dateissued
	if (@enddate > @dateissued) 
	begin
	print 'The DateIssued should be greater than the end date.
	Hence insert operation unsuccessful.'
	Rollback transaction 
	end
return
go
	 
--trigger 8.3
Create trigger trgdatacurrent 
 on ProjectDetails.TimeCards
 for insert
 as 
    declare @dateissued date
	select @dateissued = DateIssued from inserted 
	if ( @dateissued < getdate() )
	begin 
	print 'The DateIssued should be greater than the current date.
	Hence, insert operation unsuccessful!.'
	Rollback transaction
end
 Return
 go

------------------------------------------------------------



sp_help 'ProjectDetails.TimeCards'

		-----------------Validate Table------------------

insert into ProjectDetails.TimeCards(EmployeeID,WorkCoedID,ProjectID,DateIssued,DaysWorked,WorkDescription,BillableHours) values
('101','501','201','08/08/2018','9','Operations','5'),
('102','502','202','07/09/2018','3','Logistics','3')

select * from ProjectDetails.TimeCards



drop table ProjectDetails.TimeCards
----------------------------------------------------------------------------------------------------------------------------------------------



----9.) Creating Table 9:(ProjectDetails.TimeCardExpenses)---


create table ProjectDetails.TimeCardExpenses
(
TimeCardExpensesID int Identity (1,1) primary key,
TimeCardID int not null foreign key references ProjectDetails.TimeCards(TimeCardID),
ProjectID int not null foreign key references ProjectDetails.Projects(ProjectID),
ExpenseID int not null foreign key references ProjectDetails.ExpenseDetails(ExpenseID),
ExpenseDate date not null,
ExpenseAmount money not null CONSTRAINT chkMoney check(ExpenseAmount >0),
ExpenseDescription varchar(100) not null
);
go




--------------------------------------------------------------------------
		--trigger for table 9-----------------
		
		 create trigger trgExpAmount
  ON ProjectDetails.TimecardExpenses
  for insert 
  as 
    declare @enddate date
	declare @expensedate date
	select @expensedate = ExpenseDate from inserted 
	select @enddate = EndDate from ProjectDetails.projects 
	join ProjectDetails.TimecardExpenses on ProjectDetails.TimecardExpenses.ProjectID = ProjectDetails.Projects.ProjectID
	where @expensedate = ExpenseDate 
	if (@enddate < @expenseDate)
	begin
	print 'The ExpenseDate should be less than the EndDate.
	Hence insert operation unsuccessful!.'
	Rollback transaction 
	end
return
go
		



				----------------Validate Table---------------

insert into ProjectDetails.TimeCardExpenses (TimeCardID,ProjectID,ExpenseID,ExpenseDate,ExpenseAmount,ExpenseDescription) values
('1','201','5001','08/02/2007','701','Allowances'),
('2','202','5002','08/03/2007','702','Welfare')
go

--------------------------------------------------------------------------- 

select * from ProjectDetails.TimeCardExpenses