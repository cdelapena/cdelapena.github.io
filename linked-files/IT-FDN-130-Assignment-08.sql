--*************************************************************************--
-- Title: Assignment08
-- Author: Chris_DelaPena
-- Desc: This file demonstrates how to use Stored Procedures
-- Change Log: When,Who,What
-- 2017-01-01,Chris_DelaPena,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment08DB_Chris_DelaPena')
	 Begin 
	  Alter Database [Assignment08DB_Chris_DelaPena] set Single_user With Rollback Immediate;
	  Drop Database Assignment08DB_Chris_DelaPena;
	 End
	Create Database Assignment08DB_Chris_DelaPena;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment08DB_Chris_DelaPena;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
-- NOTE: We are starting without data this time!

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count] From dbo.Inventories;
go

/********************************* Questions and Answers *********************************/
/* NOTE:Use the following template to create your stored procedures and plan on this taking ~2-3 hours

Create Procedure <pTrnTableName>
 (<@P1 int = 0>)
 -- Author: <Chris_DelaPena>
 -- Desc: Processes <Desc text>
 -- Change Log: When,Who,What
 -- <2019-11-26>,<Chris Dela Pena>,Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	-- Transaction Code --
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
*/

-- Question 1 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Categories table?
--Create Procedure pInsCategories
--< Place Your Code Here!>--
Create Proc pInsCategories
 (@CategoryName nvarchar(100)
 )
As
 Begin
 Declare @RC int = 0;
  Begin Try
   Begin Tran;
    Insert Into Categories (CategoryName)
     Values (@CategoryName);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdCategories
--< Place Your Code Here!>--
CREATE Proc pUpdCategories
 (@CategoryID int
 ,@CategoryName nvarchar(100)
 )
As
 Begin
 Declare @RC int = 0;
 Begin Try
   Begin Transaction
   Update Categories 
    Set CategoryName = @CategoryName
     Where CategoryID = @CategoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelCategories
--< Place Your Code Here!>--
Create Proc pDelCategories
 (@CategoryID int
 )
As
 Begin
 Declare @RC int = 0;
  Begin Try
   Begin Transaction
   Delete 
    From Categories 
     Where CategoryID = @CategoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 2 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Products table?
--Create Procedure pInsProducts
--< Place Your Code Here!>--
Create Proc pInsProducts
 (@ProductName nvarchar(100)
 ,@CategoryID int
 ,@UnitPrice money
 )
As
 Begin
 Declare @RC int = 0;
  Begin Try
   Begin Transaction
    Insert Into Products (ProductName, CategoryID, UnitPrice)
     Values (@ProductName, @CategoryID, @UnitPrice);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdProducts
--< Place Your Code Here!>--
Create Proc pUpdProducts
 (@ProductID int
 ,@ProductName nvarchar(100)
 ,@CategoryID int
 ,@UnitPrice money
 )
As
 Begin
 Declare @RC int = 0;
  Begin Try
   Begin Transaction
   Update Products
    Set ProductName = @ProductName
		,CategoryID = @CategoryID
		,UnitPrice = @UnitPrice
     Where ProductID = @ProductID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
  Set @RC = -1
  End Catch
  RETURN @RC;
 End
go

--Create Procedure pDelProducts
--< Place Your Code Here!>--
Create Proc pDelProducts
 (@ProductID int
 )
As
 Begin
 Declare @RC int = 0;
  Begin Try
   Begin Transaction
   Delete 
    From Products
     Where ProductID = @ProductID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  RETURN @RC;
 End
go


-- Question 3 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Employees table?
--Create Procedure pInsEmployees
--< Place Your Code Here!>--
Create Proc pInsEmployees
 (@EmployeeFirstName nvarchar(100)
 ,@EmployeeLastName nvarchar(100)
 ,@ManagerID int
 )
As
 Begin
 Declare @RC int = 0;
  Begin Try
   Begin Transaction
    Insert Into Employees (EmployeeFirstName, EmployeeLastName, ManagerID)
     Values (@EmployeeFirstName, @EmployeeLastName, @ManagerID);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdEmployees
--< Place Your Code Here!>--
Create Proc pUpdEmployees
 (@EmployeeID int
 ,@EmployeeFirstName nvarchar(100)
 ,@EmployeeLastName nvarchar(100)
 ,@ManagerID int
 )
As
 Begin
 Declare @RC int = 0;
  Begin Try
   Begin Transaction
   Update Employees
    Set EmployeeFirstName = @EmployeeFirstName
		,EmployeeLastName = @EmployeeLastName
		,ManagerID = @ManagerID
     Where EmployeeID = @EmployeeID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go


--Create Procedure pDelEmployees
--< Place Your Code Here!>--
Create Proc pDelEmployees
 (@EmployeeID int
 )
As
 Begin
 Declare @RC int = 0;
  Begin Try
   Begin Transaction
   Delete 
    From Employees
     Where EmployeeID = @EmployeeID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 4 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Inventories table?
--Create Procedure pInsInventories
--< Place Your Code Here!>--
Create Proc pInsInventories
 (@InventoryDate Date
 ,@EmployeeID int
 ,@ProductID int
 ,@Count int
 )
As
 Begin
 Declare @RC int = 0;
  Begin Try
   Begin Transaction
    Insert Into Inventories (InventoryDate, EmployeeID, ProductID, [Count])
     Values (@InventoryDate, @EmployeeID, @ProductID, @Count);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdInventories
--< Place Your Code Here!>--
Create Proc pUpdInventories
 (@InventoryID int
 ,@InventoryDate Date
 ,@EmployeeID int
 ,@ProductID int
 ,@Count int
 )
As
 Begin
 Declare @RC int = 0;
  Begin Try
   Begin Transaction
   Update Inventories
    Set InventoryDate = @InventoryDate
		,EmployeeID = @EmployeeID
		,ProductID = @ProductID
		,Count = @Count
     Where InventoryID = @InventoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelInventories
--< Place Your Code Here!>--
Create Proc pDelInventories
 (@InventoryID int
 )
As
 Begin
 Declare @RC int = 0
  Begin Try
   Begin Transaction
   Delete 
    From Inventories
     Where InventoryID = @InventoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print 'There was a error.' 
   Print Error_Number();  
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 5 (20 pts): How can you Execute each of your Insert, Update, and Delete stored procedures? 
-- Include custom messages to indicate the status of each sproc's execution.

-- To Help you, I am providing this template:
/*
Declare @Status int;
Exec @Status = <SprocName>
                @ParameterName = 'A'
Select Case @Status
  When +1 Then '<TableName> Insert was successful!'
  When -1 Then '<TableName> Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From <ViewName> Where ColID = 1;
go
*/


--< Test Insert Sprocs >--
-- Test [dbo].[pInsCategories]
Declare @Status int;
Exec @Status = pInsCategories
               @CategoryName = 'A';
Select Case @Status
  When +1 Then 'Categories Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
Select * From vCategories Where CategoryID = @@IDENTITY;
go

-- Test [dbo].[pInsProducts]
Declare @Status int;
Exec @Status = pInsProducts
			   @ProductName = 'A'
			   ,@CategoryID = 1
			   ,@UnitPrice = 9.99;
Select Case @Status
  When +1 Then 'Products insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
Select * From vProducts Where ProductID = @@IDENTITY;
go

-- Test [dbo].[pInsEmployees]
Declare @Status int;
Exec @Status = pInsEmployees
			   @EmployeeFirstName = 'Abe'
			   ,@EmployeeLastName = 'Archer'
			   ,@ManagerID = 1;
Select Case @Status
  When +1 Then 'Employees insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
Select * From vEmployees Where EmployeeID = @@IDENTITY;
go

-- Test [dbo].[pInsInventories]
Declare @Status int;
Exec @Status = pInsInventories
			   @InventoryDate = '2017-01-01'
			   ,@EmployeeID = 1
			   ,@ProductID = 1
			   ,@Count = 42;
Select Case @Status
  When +1 Then 'Inventories update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data'
  End as [Status]
Select * From vInventories Where InventoryID = @@IDENTITY;
go

--< Test Update Sprocs >--
-- Test Update [dbo].[pUpdCategories]
Declare @Status int;
Exec @Status = pUpdCategories
                @CategoryID = @@IDENTITY
               ,@CategoryName = 'B';
Select Case @Status
  When +1 Then 'Categories update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foriegn Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From vCategories Where CategoryID = @@IDENTITY;
go

-- Test [dbo].[pUpdProducts]
Declare @Status int;
Exec @Status = pUpdProducts
                @ProductID = @@IDENTITY
               ,@ProductName = 'B'
			   ,@CategoryID = 1
			   ,@UnitPrice = 1.00;
Select Case @Status
  When +1 Then 'Products update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foriegn Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From vProducts Where ProductID = @@IDENTITY;
go

-- Test [dbo].[pUpdEmployees]
Declare @Status int;
Exec @Status = pUpdEmployees
                @EmployeeID = @@IDENTITY
               ,@EmployeeFirstName = 'Abe'
			   ,@EmployeeLastName = 'Arch'
			   ,@ManagerID = 1
Select Case @Status
  When +1 Then 'Employees update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foriegn Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From vEmployees Where EmployeeID = @@IDENTITY;
go

-- Test [dbo].[pUpdInventories]
Declare @Status int;
Exec @Status = pUpdInventories
				@InventoryID = @@IDENTITY
               ,@InventoryDate = '2017-01-02'
			   ,@EmployeeID = 1
			   ,@ProductID = 1
			   ,@Count = 43;
Select Case @Status
  When +1 Then 'Inventories update was successful!'
  When -1 Then 'Update failed! Common Issues: Duplicate Data or Foriegn Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From vInventories Where InventoryID = @@IDENTITY;
go

--< Test Delete Sprocs >--
-- Test [dbo].[pDelInventories]
Declare @Status int;
Exec @Status = pDelInventories
                @InventoryID = @@IDENTITY
Select Case @Status
  When +1 Then 'Inventories delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From vInventories Where InventoryID = @@IDENTITY;
go

-- Test [dbo].[pDelEmployees]
Declare @Status int;
Exec @Status = pDelEmployees
                @EmployeeID = @@IDENTITY
Select Case @Status
  When +1 Then 'Employees delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From vEmployees Where EmployeeID = @@IDENTITY;
go

-- Test [dbo].[pDelProducts]
Declare @Status int;
Exec @Status = pDelProducts
                @ProductID = @@IDENTITY
Select Case @Status
  When +1 Then 'Products delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From vProducts Where ProductID = @@IDENTITY;
go

-- Test [dbo].[pDelCategories]
Declare @Status int;
Exec @Status = pDelCategories
                @CategoryID = @@IDENTITY
Select Case @Status
  When +1 Then 'Categories delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
  End as [Status]; -- Will be Null unless we add a Return Code to this Sproc!
Select * From vCategories Where CategoryID = @@IDENTITY;
go

--{ IMPORTANT!!! }--
-- To get full credit, your script must run without having to highlight individual statements!!!  

/***************************************************************************************/