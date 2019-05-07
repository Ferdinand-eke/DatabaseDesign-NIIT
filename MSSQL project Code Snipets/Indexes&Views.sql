

---------7.)  CREATING INDEXES-------------------------------------------
----index A----
create view ProjectDetails.vwTimeCards with schemabinding
as 
select tc.TimeCardID, hr.FirstName, hr.LastName, hr.EmployeeID
from ProjectDetails.TimeCards tc join HumanResources.Employee hr
on tc.EmployeeID=hr.EmployeeID;
go


create unique clustered index idx_vwTimeCards
on ProjectDetails.vwTimeCards(TimeCardID, FirstName,LastName)
go


select * from ProjectDetails.vwTimeCards
go



-----index B------

create view ProjectDetails.vwExpenseDetails with schemabinding 
as
select ProjectID,ExpenseID,ExpenseAmount, ExpenseDescription
from ProjectDetails.TimeCardExpenses where TimeCardID between 0 and 5 
go


create unique nonclustered index idx_vwExpeDetails
on ProjectDetails.TimeCardExpenses(ProjectID,ExpenseID,ExpenseAmount,ExpenseDescription)
go


select * from ProjectDetails.vwExpenseDetails
go



------------index C------------------

create view ProjectDetails.vwProjEmpsWorked with schemabinding
as 
select hr.FirstName, hr.LastName,hr.EmployeeID,pp.ProjectName,pp.StartDate,pp.EndDate,pp.ClientID
from HumanResources.Employee hr join ProjectDetails.TimeCards pt
on hr.EmployeeID=pt.EmployeeID
join ProjectDetails.Projects pp
on pt.ProjectID=pp.ProjectID
go


create unique clustered index idx_vwProjEmpsWorked
on ProjectDetails.vwProjEmpsWorked(FirstName,LastName,EmployeeID,ProjectName,StartDate,EndDate,ClientID)
go

select * from ProjectDetails.vwProjEmpsWorked;




----------8) Perfor a Select Report---------------

select * from ProjectDetails.Projects
go


select * from ProjectDetails.Projects
where EndDate=getdate()
go


-------------9) Perform a select(JOIN) Report---------------


select pp.ProjectID, pp.ProjectName, hr.FirstName, hr.LastName, hr.Title
from ProjectDetails.Projects pp join ProjectDetails.TimeCards pt
on pp.ProjectID=pt.ProjectID
join HumanResources.Employee hr on pt.EmployeeID=hr.EmployeeID;



