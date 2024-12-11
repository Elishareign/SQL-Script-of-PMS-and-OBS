USE webapp

-- Create Room Type Table
CREATE TABLE RoomType(
	RoomTypeID INT IDENTITY(1,1) PRIMARY KEY,
	RoomTypeName VARCHAR(20) NOT NULL,
	BasePrice DECIMAL(10, 2) NOT NULL,
	Capacity INT NOT NULL,
	RoomDescription VARCHAR(255),
	RoomSize INT,
	ImagePath VARBINARY(MAX)
)

-- Create Room Table
CREATE TABLE Room(
	RoomID INT IDENTITY(1,1) PRIMARY KEY,
	RoomNumber VARCHAR(20) NOT NULL,
    FloorNumber INT NOT NULL,
    Status VARCHAR(20) NOT NULL,
	RoomTypeID INT NOT NULL	
		CONSTRAINT FK_RoomTypeID FOREIGN KEY 
    	REFERENCES RoomType(RoomTypeID)
)

-- Create Amenity Category Table
CREATE TABLE AmenityCategory (
    AmenityCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    AmenityCategoryName VARCHAR(255) NOT NULL
)

-- Create Amenity Table
CREATE TABLE Amenity (
    AmenityID INT IDENTITY(1,1) PRIMARY KEY,  
    AmenityName VARCHAR(255) NOT NULL,
    Description VARCHAR(255),
    Chargeable BOOLEAN NOT NULL,  
    AmenityPrice DECIMAL(10, 2),
    BillingType VARCHAR(50), 
	AmenityCategoryID INT NOT NULL
		CONSTRAINT FK_AmenityCategoryID FOREIGN KEY
        REFERENCES AmenityCategory(AmenityCategoryID)
		CONSTRAINT chk_AmenityPrice CHECK (
			(Chargeable = TRUE AND AmenityPrice IS NOT NULL) OR
			(Chargeable = FALSE AND AmenityPrice IS NULL)
    	)
)

-- Create Room Type Amenity Table 
CREATE TABLE RoomTypeAmenity (
    RoomTypeID INT NOT NULL,  
    AmenityID INT NOT NULL,   
    PRIMARY KEY (RoomTypeID, AmenityID),
    FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID),
    FOREIGN KEY (AmenityID) REFERENCES Amenity(AmenityID)
)

 
-- Create Facility Type Table
CREATE TABLE FacilityType (
    FacilityTypeID INT IDENTITY(1,1) PRIMARY KEY,
    FacilityTypeName VARCHAR(100) NOT NULL
)

-- Create Facility Table
CREATE TABLE Facility (
    FacilityID INT IDENTITY(1,1) PRIMARY KEY,
    FacilityName VARCHAR(100) NOT NULL,
    FacilityDescription TEXT,
    Location VARCHAR(255) NOT NULL,
	Capacity INT NOT NULL,
	ImagePath VARBINARY(MAX),
	FacilityTypeID INT NOT NULL
		CONSTRAINT FK_FacilityTypeID FOREIGN KEY
		REFERENCES FacilityType(FacilityTypeID)
)


-- Create Facility Operation Table
CREATE TABLE FacilityOperation (
    FacilityOperationID INT IDENTITIY (1,1) PRIMARY KEY,
    FacilityID INT NOT NULL,
    OpeningTime TIME,
    Pricing DECIMAL(10, 2),
    BillingType VARCHAR(50),
    ClosingTime TIME,
    OperationalDays VARCHAR(100), 
    FOREIGN KEY (FacilityID) REFERENCES Facility(FacilityID)
)	

-- Create Room Type Facility Table
CREATE TABLE RoomTypeFacility (
    RoomTypeID INT NOT NULL,
    FacilityID INT NOT NULL,
    PRIMARY KEY (RoomTypeID, FacilityID),
    FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID),
    FOREIGN KEY (FacilityID) REFERENCES Facility(FacilityID)
)

-- Create Guest Table
CREATE TABLE Guest (
    GuestID INT IDENTITY(1,1) PRIMARY KEY,
    GuestName VARCHAR(255) NOT NULL,
    GuestContactNo VARCHAR(20) NOT NULL,  
    GuestEmailAddress VARCHAR(100) NOT NULL  
)

-- Create Booking Table
CREATE TABLE Booking (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    NumberOfGuests INT NOT NULL,
    CheckInDateAndTime DATETIME NOT NULL,
    CheckOutDateAndTime DATETIME NOT NULL,
    BookingDate DATETIME NOT NULL,
    SpecialRequest VARCHAR(255),  
    BookingStatus VARCHAR(50) CHECK (Status IN ('Confirmed', 'Pending', 'Checked-In', 'Checked-Out', 'Cancelled')),
	GuestID INT NOT NULL,  
		CONSTRAINT FK_GuestID FOREIGN KEY
        REFERENCES Guest(GuestID),
	RoomID INT NOT NULL
		CONSTRAINT FK_RoomID FOREIGN KEY
 		REFERENCES Room(RoomID)
)

-- Create Invoice Table
CREATE TABLE Invoice (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,   
    InvoiceDate DATETIME NOT NULL,
    PaymentStatus VARCHAR(50) CHECK (PaymentStatus IN ('Paid', 'Underpaid', 'Pending')),
    TotalAmount DECIMAL(10, 2) NOT NULL, 
    PaidAmount DECIMAL(10, 2) NOT NULL,  
    RemainingAmount DECIMAL(10, 2) NOT NULL,  
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID)
)

-- Create Payment Method Table
CREATE TABLE PaymentMethod (
    PaymentMethodName VARCHAR(50) CHECK (PaymentMethodName IN ('CashPayment', 'CreditCardPayment', 'DebitCardPayment', 'Gcash'))
)   PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
 
-- Create Payment Table
CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceID INT NOT NULL,  
    PaymentMethodID INT NOT NULL,  
    PaymentDate DATETIME NOT NULL,
    PaymentAmount DECIMAL(10, 2) NOT NULL,  
    FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID)
)

-- Create Staff Table
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    StaffName VARCHAR(255) NOT NULL,
    RoleType VARCHAR(50) NOT NULL,  
    HiredDateTime DATETIME NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,  
    StaffAddress VARCHAR(255) NOT NULL,  
    ShiftTime VARCHAR(20) CHECK (ShiftTime IN ('Morning', 'Afternoon', 'Evening')) NOT NULL  
)

-- Create Room Maintenance Log Table
CREATE TABLE RoomMaintenanceLog (
    MaintenanceID INT IDENTITY(1,1) PRIMARY KEY,
    RoomID INT NOT NULL,  
    StaffID INT NOT NULL,  
    Description TEXT NOT NULL,
    MaintenanceDate DATETIME NOT NULL,
    	FOREIGN KEY (RoomID) REFERENCES Room(RoomID),
   		FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
)

-- Create Housekeeping Task Table
CREATE TABLE HousekeepingTask (
    HousekeepingTaskID INT IDENTITY(1,1) PRIMARY KEY,
    RoomID INT NOT NULL,  
    TaskDescription TEXT NOT NULL,
    TaskStatus VARCHAR(50) CHECK (Task_Status IN ('Clean', 'In Progress', 'Pending', 'Dirty', 'Need Maintenance', 'Inspection')) NOT NULL,
    TaskDateTime DATETIME NOT NULL,
    Priority VARCHAR(20) CHECK (Priority IN ('Low', 'Medium', 'High')) NOT NULL,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
)

-- Create Schedule Table
CREATE TABLE Schedule (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT NOT NULL,  
    HousekeepingTaskID INT NOT NULL,  
    Assigndatetime DATETIME NOT NULL,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (HousekeepingTaskID) REFERENCES HousekeepingTask(HousekeepingTaskID)
)


CREATE TABLE StaffLogin (
    LoginID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT NOT NULL,  
    Email VARCHAR(100) NOT NULL, 
    Password VARCHAR(255) NOT NULL, 
    Role VARCHAR(50) NOT NULL,  
    LastLogin DATETIME NULL, 
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
)

CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT NOT NULL, 
    Timestamp DATETIME NOT NULL,
    TaskType VARCHAR(100) NOT NULL,  
    Details TEXT,  
    EventDescription TEXT NOT NULL,  
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
)

INSERT INTO RoomType (RoomTypeName, BasePrice, Capacity, RoomDescription, RoomSize) VALUES
('Standard', 100.00, 2, 'Basic room with essential amenities.', 25),
('Deluxe', 150.00, 2, 'Luxurious room with additional comfort.', 35),
('Suite', 250.00, 4, 'Spacious room with premium amenities and a separate living area.', 60),
('Presidential', 500.00, 4, 'Lavish suite with exceptional luxury and services.', 100),
('Economy', 80.00, 1, 'Affordable single room for budget-conscious travelers.', 20),
('Family', 180.00, 5, 'Room for families with kids, featuring extra beds.', 45),
('Penthouse', 1000.00, 5, 'Top-floor luxury with a breathtaking view.', 120),
('Studio', 120.00, 2, 'Compact room with kitchenette for extended stays.', 30),
('Executive', 300.00, 2, 'Exclusive room for business travelers with workspaces.', 40),
('Honeymoon', 200.00, 2, 'Romantic room for newlyweds, featuring premium amenities.', 35);

INSERT INTO AmenityCategory (AmenityCategoryName) VALUES
('Spa'),
('Gym'),
('Entertainment'),
('Dining'),
('Parking');


INSERT INTO Amenity (AmenityName, Description, Chargeable, AmenityPrice, BillingType, AmenityCategoryID) VALUES
('Sauna', 'Relaxing sauna for guests', TRUE, 25.00, 'Per Use', 1),
('Massage', 'Full body massage', TRUE, 50.00, 'Per Use', 1),
('Gym Access', 'Access to the hotel gym', FALSE, NULL, 'Free', 2),
('Swimming Pool', 'Access to the hotel pool', FALSE, NULL, 'Free', 3),
('Buffet Breakfast', 'All-you-can-eat breakfast buffet', TRUE, 15.00, 'Per Person', 4),
('Parking', 'Secure parking space for guests', TRUE, 10.00, 'Per Day', 5),
('Wi-Fi', 'High-speed internet access', FALSE, NULL, 'Free', 2),
('Room Service', 'Order food and beverages to the room', TRUE, 20.00, 'Per Order', 4),
('Laundry Service', 'Laundry and dry cleaning services', TRUE, 5.00, 'Per Item', 4),
('Car Rental', 'Rent a car for your travels', TRUE, 100.00, 'Per Day', 5);


INSERT INTO FacilityType (FacilityTypeName) VALUES
('Spa'),
('Gym'),
('Restaurant'),
('Pool'),
('Parking');


INSERT INTO Facility (FacilityName, FacilityDescription, Location, Capacity, ImagePath, FacilityTypeID) VALUES
('Wellness Spa', 'A luxurious spa offering various treatments.', '1st Floor', 50, NULL, 1),
('Fitness Center', 'Fully equipped gym for fitness enthusiasts.', '2nd Floor', 30, NULL, 2),
('Restaurant', 'Fine dining with a variety of cuisines.', 'Ground Floor', 100, NULL, 3),
('Outdoor Pool', 'Heated outdoor pool with a scenic view.', 'Roof Top', 40, NULL, 4),
('Underground Parking', 'Secure underground parking for guests.', 'Basement', 100, NULL, 5);


INSERT INTO FacilityOperation (FacilityID, OpeningTime, Pricing, BillingType, ClosingTime, OperationalDays) VALUES
(1, '09:00', 50.00, 'Per Use', '18:00', 'Monday-Saturday'),
(2, '06:00', 0.00, 'Free', '22:00', 'Daily'),
(3, '08:00', 15.00, 'Per Person', '22:00', 'Daily'),
(4, '06:30', 0.00, 'Free', '22:00', 'Daily'),
(5, '00:00', 10.00, 'Per Day', '23:59', 'Daily');


INSERT INTO Room (RoomNumber, FloorNumber, Status, RoomTypeID) VALUES
('101', 1, 'Available', 1),
('102', 1, 'Occupied', 2),
('201', 2, 'Available', 3),
('202', 2, 'Occupied', 4),
('301', 3, 'Available', 5),
('302', 3, 'Available', 6),
('303', 3, 'Occupied', 7),
('304', 3, 'Available', 8),
('401', 4, 'Occupied', 9),
('402', 4, 'Available', 10);


INSERT INTO RoomTypeFacility (RoomTypeID, FacilityID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 1),
(7, 3),
(8, 4),
(9, 2),
(10, 5);


INSERT INTO RoomTypeAmenity (RoomTypeID, AmenityID) VALUES
(1, 1),
(1, 3),
(2, 2),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10);




