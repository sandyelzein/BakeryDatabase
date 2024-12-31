 --it is said:
CREATE DATABASE BakeryShop4;
USE BakeryShop4;

CREATE TABLE Role (
  RoleID int NOT NULL default(2),
  Name varchar(20)  NOT NULL default('Customer'),
  PRIMARY KEY (RoleID)
);

CREATE TABLE Users(
  UserID int identity(1, 1) NOT NULL,
  Name varchar(20) NOT NULL,
  Email varchar(20) NOT NULL,
  Password varchar(20) NOT NULL,
  RoleID int NOT NULL,
  PRIMARY KEY (UserID),
  FOREIGN KEY (RoleID) REFERENCES Role (RoleID) ON Delete Cascade ON Update Cascade
);

CREATE TABLE Category (
  CategoryID int identity(1, 1)NOT NULL,
  Name varchar(100) NOT NULL,
  Description varchar(500) NOT NULL,
  PRIMARY KEY (CategoryID)
);
CREATE TABLE FoodItem (
  FoodItemID int identity(1, 1),
  CategoryID int NOT NULL,
  Name varchar(100) NOT NULL,
  Description varchar(1000) NOT NULL,
  Price money NOT NULL default(0),
  image_01 varchar(100) NOT NULL,
  image_02 varchar(100) NOT NULL,
  image_03 varchar(100) NOT NULL,
  UserID int NOT NULL,
  PRIMARY KEY (FoodItemID),
  FOREIGN KEY (CategoryID) REFERENCES Category (CategoryID) ON Delete Cascade ON Update Cascade,
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON Delete Cascade ON Update Cascade
);

CREATE TABLE Orders (
  OrderID int identity(1, 1),
  FName varchar(20) NOT NULL,
  LName varchar(20) NOT NULL,
  PhoneNumber varchar(10) NOT NULL,
  City varchar(500) NOT NULL,
  Street varchar(500) NOT NULL,
  AddressNum int NOT NULL,
  TotalProducts int default(0),
  TotalAmount money default(0),
  placed_on date NOT NULL,
  PaymentMethod varchar(50) NOT NULL,
  OrderStatus varchar(20) NOT NULL DEFAULT 'pending',
  WholeSaleDiscount float NOT NULL,
  UserID int NOT NULL,
  PRIMARY KEY (OrderID),
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON Delete Cascade ON Update Cascade
);

CREATE TABLE orderDetails (
  OrderID int NOT NULL,
  Quantity int NOT NULL default(1),
  FoodItemID int NOT NULL,
  FOREIGN KEY (OrderID) REFERENCES Orders (OrderID) ON Delete Cascade ON Update Cascade,
  FOREIGN KEY (FoodItemID) REFERENCES FoodItem (FoodItemID)
);


CREATE TABLE Cart (
  CartID int identity(1, 1),
  UserID int NOT NULL,
  TotalPrice money default(0),
  Quantity int default(0),
  PRIMARY KEY (CartID),
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON Delete Cascade ON Update Cascade
);

CREATE TABLE CartIncludes (
  CartID int NOT NULL,
  FoodItemID int NOT NULL,
  Quantity int NOT NULL default(0),
  PRIMARY KEY (CartID, FoodItemID),
  FOREIGN KEY (CartID) REFERENCES Cart (CartID),
  FOREIGN KEY (FoodItemID) REFERENCES FoodItem (FoodItemID)
);

CREATE TABLE wishlist (
  wishListID int identity(1, 1),
  UserID int NOT NULL,
  PRIMARY KEY (wishListID),
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON Delete Cascade ON Update Cascade
);

CREATE TABLE wishContains (
  wishListID int NOT NULL,
  FoodItemID int NOT NULL,
  Quantity int NOT NULL default(0),
  PRIMARY KEY (wishListID, FoodItemID),
  FOREIGN KEY (wishListID) REFERENCES wishlist (wishListID),
  FOREIGN KEY (FoodItemID) REFERENCES FoodItem (FoodItemID)
);

CREATE TABLE Reviews (
  ReviewsID int identity(1, 1),
  Rating float NOT NULL check(Rating >0 and Rating <=5),
  Comment varchar(100) NOT NULL,
  UserID int NOT NULL,
  PRIMARY KEY (ReviewsID),
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON Delete Cascade ON Update Cascade
);
CREATE TABLE Messages (
  MsgID int identity(1, 1),
  UserID int NOT NULL,
  message varchar(500) NOT NULL,
  PRIMARY KEY (msgID),
  FOREIGN KEY (UserID) REFERENCES Users (UserID) ON Delete Cascade ON Update Cascade
);


-- TotalProducts: Order
CREATE VIEW OrderTotalProductsView AS
Select o.UserID, O.OrderID, Sum(Od.Quantity) AS TotalProducts From Orders As O
Join orderDetails Od On O.OrderID = Od.OrderID
Group By O.UserID, O.OrderID;


UPDATE Orders SET TotalProducts = v.TotalProducts From OrderTotalProductsView As v
Where Orders.UserID = v.UserID AND Orders.OrderID = v.OrderID;


--TotalAmount: Order
CREATE VIEW OrderTotalPriceView AS
Select O.UserID, O.OrderID, Sum((Od.Quantity * F.Price) * (1 - O.WholeSaleDiscount)) As TotalAmount From Orders AS O
Join orderDetails AS Od ON O.OrderID = Od.OrderID
Join FoodItem AS F ON Od.FoodItemID = F.FoodItemID
Group By O.UserID, O.OrderID, O.WholeSaleDiscount;


UPDATE Orders SET TotalAmount = v.TotalAmount From OrderTotalPriceView As v
Where Orders.UserID = v.UserID AND Orders.OrderID = v.OrderID;

SELECT * FROM Orders


-- Quantity: Cart
CREATE VIEW CartTotalQuantityView AS
Select c.UserID, Sum(Ci.Quantity) AS TotalQuantity From Cart AS C
Join CartIncludes AS Ci ON C.CartID = Ci.CartID
Group By c.UserID;

Update Cart Set Quantity = v.TotalQuantity From CartTotalQuantityView As v
Where Cart.UserID = v.UserID;


-- TotalPrice: Cart
CREATE VIEW CartTotalPriceView AS
Select C.UserID, Sum(Ci.Quantity * F.Price) AS TotalPrice From Cart AS C
Join CartIncludes As Ci ON C.CartID = Ci.CartID
Join FoodItem F On Ci.FoodItemID = F.FoodItemID
Group By C.UserID;

UPDATE Cart SET TotalPrice = v.TotalPrice FROM CartTotalPriceView As v
Where Cart.UserID = v.UserID;




INSERT INTO ROLE (ROLEID, Name) VALUES
(1, 'Admin'),
(2, 'Customer');

INSERT INTO Users (Name, Email, Password, RoleID) VALUES
('Admin', 'candy@gmail.com', '111', 1),
('Amani', 'many@gmail.com', '111', 1),
('Lorance', 'laury@gmail.com', '111', 1);

INSERT INTO Users (Name, Email, Password, RoleID) VALUES
('Lynn', 'Lynn@gmail.com', '654321', 2),
('Jad', 'Jad@gmail.com', '765432', 2),
('Moamen', 'Moamen@gmail.com', '876543', 2),
('Farah', 'Farah@gmail.com', '987654', 2),
('Darine', 'Darine@gmail.com', '098765', 2),
('AbdelAziz', 'AbdelAziz@gmail.com', '109876', 2),
('Ezzeldine', 'Ezzeldine@gmail.com', '210987', 2),
('Adnan', 'Adnan@gmail.com', '212002', 2),
('Dana', 'Dana@gmail.com', '321098', 2),
('Mhmd', 'Mhmd@gmail.com', '648643', 2),
('Sanaa', 'Sanaa@gmail.com' , '978445', 2),
('Lama', 'Lama@gmail.com', '432109', 2),
('Roa', 'Roa@gmail.com', '543210', 2);


INSERT INTO Category (Name, Description) VALUES
('Croissant', 'Butter croissant'),
('Cookies', 'Butter cookies'),
('Donuts', 'doughnut'),
('Bread', 'French & Lebanese bread'),
('Choux Pastry', 'French Choux Pastry'),
('Cakes', 'Cakes & Cupcakes'),
('Cheesecake', 'New York Cheesecakes');


INSERT INTO FoodItem (Name, description, price, CategoryID, UserID, image_01, image_02, image_03) VALUES
('croissant', 'Classic butter croissant with soft, flaky layers and a golden-brown crust.', 3, 1, 1,'210228-GFJulesCroissants-R.MoraPhotography-6201-copy-720x720.webp', '722aef4487a43a74e90ec6822a73a7aa.jpg', 'cf1771e4dfb7357420141f27bde281a8.jpg'),
('donuts', 'Old-fashioned doughnut with a variety of glazes and toppings', 2, 3, 1, 'e0c197059ac98f9ea24c4112a34fe38b.jpg', '8eb272c94b526844adbcace9ef454c27.jpg', 'e0544c2485237c140710f0c3bd28f6b0.jpg'),
('chocolate chip cookies', 'Semisweet chocolate chips mixed in a thick, chewy cookie, soft on the inside and crunchy on the outside.', 1, 2, 1, 'Classic Toll House Cookies Recipe.jpg', '3b265e60f4eb5e5551e153612139fdc9.jpg', 'c6d5b665ca6f36e2051bc4302bcf326a.jpg'),
('double chocolate cookies', 'Double Chocolate Chip Cookies that are soft and fudgy and filled to the brim with chocolate. ', 2, 2, 1, 'b9587b0b4d728c235439d36dd6055441.jpg', 'f23416af24d110af4aa58380544eb92b.jpg', '85571b5f700dab925666032eac637306.jpg'),
('Lotus cookies', 'Biscoff butter cookies with a surprisingly crunchy bite and caramelized flavor.', 3, 2, 1, 'e8bd50dfa7ee7b57d2e9fe2577d11f21.jpg', '28caad976ad8ad37117e1e12d6a08bde.jpg', '693d91e0d51358865ea710810fef3fd0.jpg'),
('pain au chocolat croissant', 'Golden French Croissant with a rich dark chocolate filling.', 4, 1, 1, 'b899218bfb6112c3c37e108ec280c052.jpg', '7f9d871e53e6190a1b55c003777aa4e8.jpg', '388c394cfaa0767924ad989b86255499.jpg'),
('baguette bread', 'French bread, hard and crusty on the outside, with a light and soft crumb.', 1, 4, 1, 'bb6d61d14c0dd63708a1710aefbbe5c2.jpg', '351a60075ce9f322bd5c53f7c3e0b33b.jpg', '9dc13c912ae476ea207d122e7b885aea.jpg'),
('Kaak bread', 'A ring shaped savory roll covered with sesame seeds, crispy on the outside and chewy a bit when eating', 2, 4, 1, '93bdf31d146096cebef7778afca6c2bc.jpg', 'e17ff156547e71c23efa3a060543d801 (1).jpg', 'kaak.jpg'),
('Eclair', 'French choux pastry éclair,  filled with  pastry cream  and topped with chocolate ganache.', 4, 5, 1, '62e7665cf57796b4753a83c202b8313c.jpg', '8c4888473d32c7f7680d573f15dde947.jpg', '02308669acc3b2bd856b40f43231380b.jpg'),
('profiteroles eclaire', 'Choux pastries filled with crème pâtissière and coated in chocolate sauce.\r\n', 2, 5, 1, '068b7215ba921bf31fee7cdad4fa5d89.jpg', '626b16e0e22a7c17d4c87857ed7d5810.jpg', '53ef17e90ba6ee4ce08d7e91ed54159b.jpg'),
('Vanillia cake', 'Soft dreamy Vanilla Cake topped with vanilla buttercream', 8, 6, 1, '91e3c174536f4d26f4edd971159f9528.jpg', 'f66206cb63de41ed7e217a423b514de9.jpg', 'a0173549d43278b4dcd177ead9ab6902.jpg'),
('chocolate cake', 'Moist chocolate cake with a rich butter cream filling, chocolate sauce and Belgian chocolate ganache', 10, 6, 1, 'Salted-Caramel Six-Layer Chocolate Cake.jpg', '80e21cf0f9e37c578512d29e48c90b32.jpg', 'Salted Caramel Chocolate Cake.jpg'),
('cup cakes', 'Double classic chocolate cupcake with lot of chocolate chips. ', 2, 6, 1, '3494c2b1572fe41c357aa5672609574e.jpg', '6a822c3814ed6454598c4f4cd3bfebb3.jpg', 'a47e421586166916f39f8d7a10bf88a6.jpg'),
('blueberry cheesecake', 'This blueberry cheesecake starts with a buttery graham cracker crust, a creamy cheesecake center, and a tangy blueberry swirl.', 12, 7, 1, '5ce3668ff940d6b6d00ef1094da47f52.jpg', '28dc25fef89eae3f540813f53cf32837.jpg', '5746b8f83f3106d949b381221164edc1.jpg'),
('lotus cheesecake', 'This Biscoff cheesecake uses Biscoff cookies for the crust, cookie butter in the cheesecake and topped with a gorgeous cookie butter swirl.', 12, 7, 1, 'c886b39062f72760e6d15971ae8392fe.jpg', 'b8b9f68b71bb6be85584a14b3d199480.jpg', 'c0333a450a3be84f98494daf3da43521.jpg'),
('raspberry cheesecake', 'This raspberry cheesecake starts with a buttery graham cracker crust, a creamy cheesecake center, and a tangy raspberry swirl.', 12, 7, 1, 'ef18cd8c1fb988b2235bb5085ce0ba57.jpg', '17262b5b92981f22fa0d958a4ce45a74.jpg', '059f2f570464889d15e46b6c7d6545cb.jpg'),
('Bomboloni donuts', 'Light and delicious Italian doughnuts that are fried, coated in granulated sugar, and traditionally stuffed with pastry cream.', 4, 3, 1, 'caa048f02b1936e883bca18749de729c.jpg', '365b6dc91d0d11be82cd409ef53ff170.jpg', '151145e757e3b015e62ccb9fcab34cd9.jpg'),
('mini Fruit tart', 'Fresh fruit slices and a sweet custard filling on top of a bite-sized cookie shell.', 2, 5, 1, 'fd409ad9246d93ca80e01cd043156057.jpg', '660ec6685178a2547595c018778fe123.jpg', 'f010cf2f2ccaf635fe14805d86ec073d.jpg'),
('mini chocolate tart', 'mini chocolate Tartlets that start with a buttery shortbread crust and filled with rich chocolate ganache', 2 ,5, 1, '99eb89ecfebbc929afbc4930321e2108.jpg', 'a5503cf464577718c391e0b6f3ea1990.jpg', 'cd15bea98556095802eedb4b4d6bcc4c.jpg');


INSERT INTO messages(UserID, message) VALUES (4, 'Hello, I have a suggestion for your menu. Have you considered adding gluten-free options for those with dietary restrictions?'),
(5, 'Good afternoon! I wanted to express my appreciation as the pastries were absolutely delightful.'), 
(7, 'Hi, do you have any special deals for large orders? I am planning a birthday party and need a lot of sweets.'), 
(8, 'Hello! Can you please recommend some popular items from your bakery. I am having trouble deciding.'),
(9, 'Hey, I wanted to leave a review for the cupcakes I ordered last week. They were phenomenal!'),
(13, 'Hello, do you offer gift wrapping for orders? I would like to send some pastries as presents to my friend.')



INSERT INTO wishlist(UserID) SELECT UserID FROM Users;
INSERT INTO wishContains (wishListID, FoodItemID, Quantity) VALUES
(1, 1, 2), (1, 2, 1), (1, 3, 3), (1, 4, 1), (1, 6, 2), (1, 10, 1),
(2, 1, 5), (2, 2, 1), (2, 4, 4),(2, 8, 1), (2, 12, 1),
(3, 1, 1),(3, 2, 1), (3, 3, 1),(3, 4, 1),(3, 5, 1),(3, 6, 1), (3, 7, 1),(3, 8, 1),(3, 9, 1),(3, 10, 1), (3, 11, 1),(3, 12, 1), (3, 13, 1), (3, 14, 1),
(4, 2, 1),(4, 6, 2),(4, 9, 2), (4, 10, 3),(4, 11, 1), (4, 15, 1),
(5, 1, 1), (5, 3, 1),(5, 4, 2), (5, 8, 1),(5, 12, 3),
(6, 2, 1),(6, 5, 2),(6, 9, 5),(6, 10, 2),(6, 11, 1),(6, 12, 3),(6, 13, 1),(6, 14, 1),(6, 15, 1),
(7, 6, 6), (7, 7, 4), (7, 10, 3), (7, 12, 2), (7, 13, 1), (7, 14, 1), (7, 15, 1), (7, 16, 1), (7, 17, 1), (7, 18, 1), (7, 19, 1),
(8, 4, 5), (8, 7, 3), (8, 11, 2), (8, 15, 5),
(9, 1, 6), (9, 3, 1), (9, 8, 2), (9, 9, 1), (9, 12, 10), (9, 18, 4), (9, 19, 3),
(10, 2, 1), (10, 6, 2), (10, 9, 4), (10, 14, 1), (10, 16, 4), (10, 17, 5), (10, 18, 1),
(11, 4, 1), (11, 5, 2), (11, 10, 3), (11, 11, 1), (11, 15, 4), (11, 18, 2), (11, 19, 3),
(12, 2, 1), (12, 9, 1), (12, 10, 4), (12, 13, 3), (12, 14, 1),
(13, 5, 1), (13, 10, 2), (13, 13, 3), (13, 17, 4), (13, 19, 1),
(14, 2, 1), (14, 8, 2), (14, 14, 5),
(15, 1, 5), (15, 5, 2), (15, 10, 3), (15, 15, 1), (15, 17, 3),
(16, 3, 3), (16, 9, 1), (16, 12, 2), (16, 17, 4), (16, 18, 1);


INSERT INTO Cart (UserID) SELECT UserID FROM Users;
INSERT INTO CartIncludes (CartID, FoodItemID, Quantity) VALUES
(1, 1, 1), (1, 3, 2), (1, 5, 1), (1, 6, 2), (1, 12, 4), (1, 15, 1),
(2, 1, 2), (2, 4, 3),(2, 8, 4),(2, 10, 2), (2, 12, 3),
(3, 1, 1),(3, 2, 1), (3, 3, 1),(3, 4, 1),(3, 5, 1),(3, 6, 1), (3, 7, 1),(3, 8, 1),(3, 9, 1),(3, 10, 1), (3, 11, 1),(3, 12, 1), (3, 13, 1), (3, 14, 1),
(4, 3, 2),(4, 4, 1),(4, 8, 3), (4, 10, 2),(4, 12, 3), (4, 18, 4),
(5, 1, 1), (5, 3, 2), (5, 4, 2), (5, 7, 3), (5, 8, 6),(5, 10, 2) ,(5, 12, 1),(5, 15, 3),
(6, 5, 2),(6, 9, 3),(6, 10, 2), (6, 12, 2),(6, 13, 1), (6, 15, 1),
(7, 1, 2), (7, 3, 1), (7, 7, 3), (7, 11, 3), (7, 14, 2), (7, 15, 1), (7, 17, 1), (7, 19, 2),
(8, 4, 5), (8, 7, 4),(8, 8, 3), (8, 11, 2),(8, 15, 4), (8, 18, 6),
(9, 1, 3), (9, 3, 1), (9, 7, 2), (9, 8, 4), (9, 12, 3), (9, 15, 2), (9, 17, 1),
(10, 2, 4), (10, 5, 2), (10, 10, 1), (10, 14, 1), (10, 16, 2), (10, 19, 3),
(11, 8, 1), (11, 9, 2), (11, 10, 3), (11, 11, 1), (11, 15, 4), (11, 17, 2), (11, 19, 3),
(12, 2, 2), (12, 5, 2), (12, 8, 3), (12, 10, 3), (12, 15, 1),
(13, 3, 1), (13, 7, 2), (13, 10, 3), (13, 15, 2), (13, 19, 1),
(14, 2, 2), (14, 8, 1), (14, 14, 2),
(15, 1, 3), (15,6, 1), (15, 12, 2), (15, 15, 3), (15, 18, 2),
(16, 3, 2), (16, 10, 1), (16, 12, 2), (16, 16, 2), (16, 18, 1);


INSERT INTO Orders(FName,LName,PhoneNumber,City,Street,AddressNum,placed_on,PaymentMethod,OrderStatus, WholeSaleDiscount, UserID) VALUES
('Lynn', 'Noureddine', '03111222', 'Beirut', 'Hamra Street', 123, '2024-04-01', 'Credit Card', 'pending', 0.1, 4),
('Jad', 'Moghrabi', '03444555', 'Saida', 'Al-Najmeh Square', 456, '2024-04-02', 'PayPal', 'pending', 0.15, 5),
('Farah', 'Hamzeh', '03123456', 'Saida', 'Al-Najmeh Square', 789, '2024-04-03', 'Cash', 'pending', 0.05, 7),
('Darine', 'Chames', '03789654', 'Beirut', 'Mar Mikhael Street', 1011, '2024-04-04', 'Credit Card', 'pending', 0.1, 8),
('AbdelAziz', 'Mustapha', '03632541', 'Tripoli', 'Al-Mina Street', 1213, '2024-04-05', 'Credit Card', 'pending',0, 9),
('Roa', 'Bou Khashfi', '03211366', 'Tripoli', 'Al-Mina Street', 1415, '2024-04-06', 'PayPal', 'pending', 0, 13),
('David', 'Khalil', '03678954', 'Beirut', 'Mar Mikhael Street', 1617, '2024-04-07', 'Credit Card', 'pending', 0.1, 12),
('Jennifer', 'Nour', '03447885', 'Tyre', 'Al-Qalaa Street', 1819, '2024-04-08', 'Cash', 'pending', 0.15, 12),
('Rawan', 'Wehbi', '70111546', 'Tyre', 'Al-Qalaa Street', 2021, '2024-04-09', 'Credit Card', 'pending', 0.05, 9),
('Sally', 'Hashem', '71421542', 'Beirut', 'Gemmayzeh Street', 2223, '2024-04-10', 'Credit Card', 'pending', 0.05, 6),
('Sarah', 'Khalil', '03666321', 'Saida', 'Al-Najmeh Square', 2425, '2024-04-11', 'PayPal', 'pending', 0.1, 7),
('Mohammad', 'Khalil', '71845963', 'Beirut', 'Gemmayzeh Street', 123, '2024-04-12', 'Credit Card', 'pending', 0.05, 8),
('Sara', 'Merhi', '81546987', 'Beirut', 'Gemmayzeh Street', 456, '2024-04-13', 'PayPal', 'pending', 0.15, 10),
('Sandy', 'Khalil', '81032023', 'Tyre', 'Al-Mina Street', 789, '2024-04-14', 'Cash', 'pending', 0.1, 11),
('Sandy', 'El Zein', '81032023', 'Zaarouriyeh', 'Al-Zaarouriyeh Street', 789, '2024-04-14', 'Cash', 'pending', 0.3, 1),
('Sara', 'Khalifeh', '03123962', 'Tyre', 'Al-Mina Street', 1011, '2024-04-15', 'Credit Card', 'pending', 0.05, 10),
('Amani', 'Khalifeh', '81546879', 'Saida ', 'Al-Zeitoun Street', 1213, '2024-04-16', 'Credit Card', 'pending', 0.1, 4),
('Angelina', 'Hashem', '81555945', 'Beirut', 'Bliss Street', 1415, '2024-04-17', 'PayPal', 'pending', 0.05, 6),
('Loren', 'Hashem', '81050540', 'Beirut', 'Hamra Street', 1617, '2024-04-18', 'Credit Card', 'pending', 0.15, 5),
('Kate', 'Khalifeh', '81045500', 'Beirut', 'Hamra Street', 1819, '2024-04-19', 'Cash', 'pending', 0, 7),
('Zainab', 'Merhi', '71724241', 'Saida', 'Al-Najmeh Square', 2021, '2024-04-20', 'Credit Card', 'pending', 0, 8),
('Lama', 'Affara', '81458851', 'Saida', 'Al-Najmeh Square', 2021, '2024-04-20', 'Credit Card', 'pending', 0.72, 15),
('Roaa', 'Abou Khachfeh', '03147906', 'Barja', 'Barja Street', 2021, '2024-04-21', 'Credit Card', 'pending', 0.82, 16),
('Sarah', 'Hashem', '03724241', 'Saida', 'Al-Najmeh Square', 2223, '2024-04-21', 'Credit Card', 'pending', 0 , 9),
('Mohammad', 'Khalil', '03613002', 'Saida', 'Al-Najmeh Square', 2425, '2024-04-22', 'PayPal', 'pending', 0, 10),
('Diana', 'Said', '71819151', 'Tyre', 'Al-Mina Street', 123, '2024-04-23', 'Credit Card', 'pending', 0, 11),
('Sara', 'Zein', '71445664', 'Beirut', 'Hamra Street', 456, '2024-04-24', 'PayPal', 'pending', 0.5, 12),
('Roa', 'Zein', '032223223', 'Saida', 'Al-Najmeh Square', 789, '2024-04-25', 'Cash', 'pending', 0.15, 13),
('Ahmad', 'Khalil', '70544220', 'Saida', 'Al-Najmeh Square', 1011, '2024-04-26', 'Credit Card', 'pending', 0.01, 5),
('Shaza', 'Mourad', '71645645', 'Beirut', 'Mar Mikhael Street', 1213, '2024-04-27', 'Credit Card', 'pending', 0, 8),
('Khalil', 'Khalifeh', '71000333', 'Beirut', 'Mar Mikhael Street', 1415, '2024-04-28', 'PayPal', 'pending',0.15, 10),
('Hasan', 'Merhi', '70520520', 'Beirut', 'Mar Mikhael Street', 1617, '2024-04-29', 'Credit Card', 'pending',0.20, 12);


INSERT INTO orderDetails(OrderID,Quantity,FoodItemID) VALUES
-- For OrderID 1
(1, 2, 1),   
(1, 3, 2),  
(1, 1, 3),  
-- For OrderID 2
(2, 1, 4),  
(2, 2, 5),  
(2, 1, 6),  
-- For OrderID 3
(3, 3, 7),   
(3, 2, 8),  
-- For OrderID 4
(4, 1, 9),   
(4, 1, 10), 
-- For OrderID 5
(5, 2, 11),  
(5, 1, 12), 
-- For OrderID 6
(6, 3, 13), 
(6, 1, 14),
-- For OrderID 7
(7, 2, 15),  
(7, 1, 16), 
-- For OrderID 8
(8, 1, 17),  
(8, 2, 18), 
-- For OrderID 9
(9, 3, 19), 
-- For OrderID 10
(10, 2, 1),  
(10, 3, 2),  
(10, 1, 3),  
-- For OrderID 11
(11, 1, 4),  
(11, 2, 5),  
(11, 1, 6), 
-- For OrderID 12
(12, 3, 7),  
(12, 2, 8),  
-- For OrderID 13
(13, 1, 9),  
(13, 1, 10), 
-- For OrderID 14
(14, 2, 11),
(14, 1, 12),
-- For OrderID 15
(15, 3, 13),  
(15, 1, 14), 
-- For OrderID 16
(16, 2, 15),  
(16, 1, 16), 
-- For OrderID 17
(17, 1, 17),  
(17, 2, 18), 
-- For OrderID 18
(18, 3, 19),  
-- For OrderID 19
(19, 2, 1),  
(19, 1, 2), 
-- For OrderID 20
(20, 1, 3),  
(20, 3, 4), 
-- For OrderID 21
(21, 2, 5),  
(21, 1, 6), 
-- For OrderID 22
(22, 3, 7),  
(22, 1, 8), 
-- For OrderID 23
(23, 1, 9),  
(23, 2, 10), 
-- For OrderID 24
(24, 3, 11),  
(24, 1, 12), 
-- For OrderID 25
(25, 2, 13),  
(25, 1, 14), 
-- For OrderID 26
(26, 1, 15), 
(26, 2, 16), 
-- For OrderID 27
(27, 3, 17), 
(27, 1, 18), 
-- For OrderID 28
(28, 2, 19),  
(28, 1, 2), 
-- For OrderID 29
(29, 3, 1), 
(29, 1, 2), 
-- For OrderID 30
(30, 3, 1), 
(30, 1, 2),
(30, 2, 13),  
(30, 1, 14),
-- For OrderID 31
(31, 3, 11),  
(31, 5, 12), 
-- For OrderID 32
(32, 4, 17),  
(32, 2, 18); 



INSERT INTO Reviews(Rating, Comment, UserID) Values 
(5, 'Absolutely loved the bakery items!', 12),
(5, 'Best bakery in town!', 13),
(4.5, 'Quick service and amazing taste!', 10),
(4.75, 'Wow! Super cute place with amazing pastries. The staff was also super nice and welcoming.', 8),
(5, 'The food is excellent, especially the glazed donuts. Also the delivery is fast', 7),
(4.75, 'Just got back from Europe and missing fresh baked French bread? This is the place to go', 5),
(5, 'What a great bakery! One of my favorites. Amazing selection of baked goods', 9),
(4.5, 'Great bakery.If you love sweet treats, you need to visit', 13);

