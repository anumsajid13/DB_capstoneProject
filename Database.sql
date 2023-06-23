use littlelemondb;
################## Week 2 ###########################
## Create View Query
create view OrdersView AS
select OrderId, Quantity, TotalCost 
from littlelemondb.order
where Quantity>2;

Select * from OrdersView;

## join Query 
select C.CustomerId, C.CustomerName, O.OrderId, O.TotalCost, M.Name, MI.Course, MI.Starter 
from customer as C inner join littlelemondb.order as O on C.CustomerId=O.CustomerId 
inner join menu as M on O.MenuId=M.MenuId 
inner join menucontent as MC on M.MenuId=MC.MenuId 
inner join menuitems as MI on MC.MenuItemId=MI.MenuItemId 
where O.TotalCost>500;

## Nested Query 
select Name 
from menu
 where MenuId=any (select MenuId 
				   from littlelemondb.order 
				    where Quantity>2);
## Stored Procedure
create procedure GetMaxQuantity() 
select max(Quantity) as MaxQuantity from littlelemondb.order;
call GetMaxQuantity();

##Pepared Statements
prepare GetOrderDetail from 'select OrderID, Quantity, TotalCost from littlelemondb.order where OrderId=?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

## Stored Procedure
delimiter //
create procedure CancelOrder(OrderID int) 
begin
delete from littlelemondb.order 
where OrderId=OrderID;
select concat("Order ", OrderID, " is cancelled") as Status;
end//
delimiter ;
SET SQL_SAFE_UPDATES = 0;
call CancelOrder(5);

select * from booking;

Insert into customer(CustomerId,CustomerName)
Values(1,'Anum');
Insert into customer(CustomerId,CustomerName)
Values(2,'Emaan');
Insert into customer(CustomerId,CustomerName)
Values(3,'Shayan');


## 
CREATE PROCEDURE CheckBooking5(Booking_Date DATE,Table_Number INT)
	SELECT CONCAT("Table ",Table_Number, " is already booked") as status
    WHERE exists (select * from booking where BookingDate = Booking_Date and TableNo = Table_Number);
CALL CheckBooking5("2022-11-12", 3);

#Valid Booking 

DELIMITER $$
CREATE FUNCTION Validate(RecordsFound INTEGER, message VARCHAR(255)) RETURNS INTEGER DETERMINISTIC
BEGIN
    IF RecordsFound IS NOT NULL OR RecordsFound > 0 THEN
        SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = message;
    END IF;
    RETURN RecordsFound;
END$$

CREATE PROCEDURE AddValidBooking(IN Booking_Date DATE, IN TableNumber INT)
	BEGIN
		DECLARE `_rollback` BOOL DEFAULT 0;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
		START TRANSACTION;
        
        SELECT Validate(COUNT(*), CONCAT("Table ", TableNumber, " is already booked"))
        FROM booking
        WHERE BookingDate = Booking_Date AND TableNo= TableNumber;
        
		INSERT INTO booking (BookingDate,TableNo)
		VALUES (Booking_Date, TableNumber);
		
		IF `_rollback` THEN
			SELECT CONCAT("Table ", TableNumber, " is already booked - booking cancelled") AS "Booking status";
			ROLLBACK;
		ELSE
			COMMIT;
		END IF;
    END$$
    
DELIMITER ;

#CALL AddValidBooking("2022-12-17", 6);

# Add booking
DELIMITER $$
CREATE PROCEDURE AddBooking(IN BookingID INT, IN Customer_ID INT, IN TableNumber INT, IN Booking_Date DATE)
BEGIN 
INSERT INTO booking (BookingId, CustomerID, TableNo, BookingDate) VALUES (BookingID, Customer_ID, TableNumber, Booking_Date); 
SELECT "New booking added" AS "Confirmation Status";
END$$ 
DELIMITER ; 
CALL AddBooking(9, 3, 4, "2022-12-30");

##Update Booking
DELIMITER $$ 
CREATE PROCEDURE UpdateBooking(IN BookingID INT, IN Booking_Date DATE) 
BEGIN
UPDATE booking SET BookingDate = Booking_Date WHERE BookingId = BookingID; 
SELECT CONCAT("Booking ", BookingID, " updated") AS "Confirmation"; 
END$$ 
DELIMITER ; 
CALL UpdateBooking(9, "2022-12-17");

#Delete booking
DELIMITER $$
CREATE PROCEDURE CancelBooking(IN BookingID INT) 
BEGIN 
DELETE FROM booking WHERE BookingId = BookingID; SELECT CONCAT("Booking ", BookingID, " cancelled") AS "Confirmation Status"; 
END$$ 
DELIMITER ; 
CALL CancelBooking(9);