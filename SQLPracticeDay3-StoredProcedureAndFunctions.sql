--Practice Exercises - DAY 3:	
-----------------------------STORED PROCEDURES AND FUNCTIONS----

USE EmployeeDatabase

----------Stored Procedures:

--Stored Procedure with no parameters:
-----To select or view all the employee table data
CREATE PROCEDURE SelectAllEmployees
AS
	SELECT * FROM Employee
GO;

EXEC SelectAllEmployees;


--Stored Procedure with one parameter:
-----To select or view all the employee's details from a particular department in the table
CREATE PROC SelectDepartmentEmployees
	@Department varchar(50)
AS
BEGIN
	SELECT * FROM Employee WHERE Department = @Department
END;

EXEC SelectDepartmentEmployees @Department = 'Management';


--Stored Procedure with multiple parameters:
-----To add new employee details to the table
CREATE PROCEDURE AddEmployee
	@EmployeeName varchar(100),
	@Age int,
	@Department varchar(50),
	@Salary varchar(50)
AS
BEGIN
	INSERT INTO Employee(EmployeeName, Age, Department, Salary) VALUES
	(@EmployeeName, @Age, @Department, @Salary)
END

EXEC AddEmployee @EmployeeName = 'Ankitha', @Age = 21, @Department = 'Marketing', @Salary = '95000';
SELECT * FROM Employee;


--Stored Procedure with output parameters:
-----To count the total number of Employees in a specified Department
CREATE PROC DepartmentEmployeeCount
	@Department varchar(50), --Input Parameter
	@EmployeeCount int OUTPUT  --Output Parameter
AS
BEGIN
	SELECT * FROM Employee WHERE Department = @Department
	SELECT @EmployeeCount = @@ROWCOUNT
END;

DECLARE @count int;  --Variable Declaration
EXEC DepartmentEmployeeCount @Department = 'Accounts', @EmployeeCount = @count OUTPUT;
SELECT @count AS 'Number Of Employees in Accounts Department';



----------Functions:
	------> System Functions Or Built-in Functions
	------> User Defined Functions

--User Defined Functions
	-->Scalar Functions
CREATE FUNCTION NetSales(
	@Quantity int,
	@Price DEC(10,2),
	@Discount DEC(3,2)
) RETURNS DEC(10,2)
AS
BEGIN
	RETURN @Quantity * @Price * (1 - @Discount)
END;

SELECT dbo.NetSales(25, 500, 0.2) AS Net_Sales; --DBO => Data Base Object


	-->Table Valued Functions
-----Inline Table Valued Function:
CREATE FUNCTION GetEmployee(
) RETURNS TABLE
AS
	RETURN (SELECT * FROM Employee)

SELECT * FROM GetEmployee();


------Multi-Statement Table Valued Function: (MSTVF)
CREATE FUNCTION Multivalue(
) RETURNS @Employee TABLE (
	Age int,
	EmployeeName varchar(50),
	Salary varchar(50)
) AS
BEGIN
	INSERT INTO @Employee
	SELECT E.Age, E.EmployeeName, E.Salary FROM Employee E
	UPDATE @Employee SET Age = 25 WHERE Age = 21
	RETURN 
END

SELECT * FROM Multivalue();
