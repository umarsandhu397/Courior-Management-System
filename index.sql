create database Assignment3;
use Assignment3;

create table Customer (
    CustomerId int primary key identity(11),
    Name varchar(50),
    Address varchar(50),
    ContactNo varchar(25),
    PaymentInfo varchar(50)
);

create table Shipment (
    ShipmentId int primary key identity(11),
    SenderId int,
    ReceiverId int,
    Weight varchar(10),
    SenderAddress varchar(50),
    ReceiverAddress varchar(50),
    PickupDate varchar(10),
    DeliveryDate varchar(10),
    foreign key (SenderId) references Customer(CustomerId),
    foreign key (ReceiverId) references Customer(CustomerId)
);

create table TrackingHistory (
    TrackingId int primary key identity(11),
    ShipmentId int,
    foreign key (ShipmentId) references Shipment(ShipmentId)
);

create table CourierService (
    CourierServiceId int primary key identity(11),
    Name varchar(50),
    ContactInfo varchar(50),
    Address varchar(50),
    DeliveryCoverageArea varchar(50)
);

create table Billing (
    InvoiceId int primary key identity(11),
    CustomerId int,
    ShipmentId int,
    TotalAmount varchar(10),
    PaymentStatus varchar(50),
    foreign key (CustomerId) references Customer(CustomerId),
    foreign key (ShipmentId) references Shipment(ShipmentId)
);
-- View to get details of all shipments
create view ShipmentDetails as
select s.ShipmentId, 
       c1.Name as SenderName, 
       c2.Name as ReceiverName, 
       s.Weight, 
       s.SenderAddress, 
       s.ReceiverAddress, 
       s.PickupDate, 
       s.DeliveryDate
from Shipment s
join Customer c1 on s.SenderId = c1.CustomerId
join Customer c2 on s.ReceiverId = c2.CustomerId;

-- View to get billing information
create view BillingDetails as
select b.InvoiceId, 
       c.Name as CustomerName, 
       s.ShipmentId, 
       b.TotalAmount, 
       b.PaymentStatus
from Billing b
join Customer c on b.CustomerId = c.CustomerId
join Shipment s on b.ShipmentId = s.ShipmentId;
-- Trigger to update tracking history when a new shipment is created
create trigger after_insert_shipment
after insert on Shipment
for each row
begin
    insert into TrackingHistory (ShipmentId) values (new.ShipmentId);
end;

-- Trigger to update payment status to 'Paid' once the total amount is entered
create trigger after_update_totalamount
after update on Billing
for each row
when new.TotalAmount is not null
begin
    update Billing set PaymentStatus = 'Paid' where InvoiceId = new.InvoiceId;
end;
-- Stored procedure to add a new customer
create procedure AddCustomer(
    in p_Name varchar(50),
    in p_Address varchar(50),
    in p_ContactNo varchar(25),
    in p_PaymentInfo varchar(50)
)
begin
    insert into Customer (Name, Address, ContactNo, PaymentInfo)
    values (p_Name, p_Address, p_ContactNo, p_PaymentInfo);
end;

-- Stored procedure to create a new shipment
create procedure CreateShipment(
    in p_SenderId int,
    in p_ReceiverId int,
    in p_Weight varchar(10),
    in p_SenderAddress varchar(50),
    in p_ReceiverAddress varchar(50),
    in p_PickupDate varchar(10),
    in p_DeliveryDate varchar(10)
)
begin
    insert into Shipment (SenderId, ReceiverId, Weight, SenderAddress, ReceiverAddress, PickupDate, DeliveryDate)
    values (p_SenderId, p_ReceiverId, p_Weight, p_SenderAddress, p_ReceiverAddress, p_PickupDate, p_DeliveryDate);
end;

-- Stored procedure to update billing information
create procedure UpdateBilling(
    in p_InvoiceId int,
    in p_CustomerId int,
    in p_ShipmentId int,
    in p_TotalAmount varchar(10),
    in p_PaymentStatus varchar(50)
)
begin
    update Billing 
    set CustomerId = p_CustomerId, 
        ShipmentId = p_ShipmentId, 
        TotalAmount = p_TotalAmount, 
        PaymentStatus = p_PaymentStatus 
    where InvoiceId = p_InvoiceId;
end;
-- Procedure to add a new customer
create procedure AddCustomer(
    in p_Name varchar(50),
    in p_Address varchar(50),
    in p_ContactNo varchar(25),
    in p_PaymentInfo varchar(50)
)
begin
    insert into Customer (Name, Address, ContactNo, PaymentInfo)
    values (p_Name, p_Address, p_ContactNo, p_PaymentInfo);
end;

-- Procedure to create a new shipment
create procedure CreateShipment(
    in p_SenderId int,
    in p_ReceiverId int,
    in p_Weight varchar(10),
    in p_SenderAddress varchar(50),
    in p_ReceiverAddress varchar(50),
    in p_PickupDate varchar(10),
    in p_DeliveryDate varchar(10)
)
begin
    insert into Shipment (SenderId, ReceiverId, Weight, SenderAddress, ReceiverAddress, PickupDate, DeliveryDate)
    values (p_SenderId, p_ReceiverId, p_Weight, p_SenderAddress, p_ReceiverAddress, p_PickupDate, p_DeliveryDate);
end;

-- Procedure to add billing information
create procedure AddBilling(
    in p_CustomerId int,
    in p_ShipmentId int,
    in p_TotalAmount varchar(10),
    in p_PaymentStatus varchar(50)
)
begin
    insert into Billing (CustomerId, ShipmentId, TotalAmount, PaymentStatus)
    values (p_CustomerId, p_ShipmentId, p_TotalAmount, p_PaymentStatus);
end;
-- Procedure to get customer details by ID
create procedure GetCustomerDetails(
    in p_CustomerId int
)
begin
    select * from Customer where CustomerId = p_CustomerId;
end;

-- Procedure to get shipment details by ID
create procedure GetShipmentDetails(
    in p_ShipmentId int
)
begin
    select * from ShipmentDetails where ShipmentId = p_ShipmentId;
end;

-- Procedure to get billing details by invoice ID
create procedure GetBillingDetails(
    in p_InvoiceId int
)
begin
    select * from BillingDetails where InvoiceId = p_InvoiceId;
end;