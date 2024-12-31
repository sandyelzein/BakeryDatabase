USE BakeryShop2;


-- FOOD ITEM AND CATEGORY RELATED


--1. Retrieve the name, description, and price of all baked goods available on the website.
Select F.Name, F.Description, F.price From FoodItem as F;

--2. List all categories of baked goods available.
Select * From Category;

--3. List the number of food items in each category of baked goods.
Select C.CategoryID, count(F.FoodItemID) as 'Number of Food Items' From Category as C
Right Join FoodItem as F On F.CategoryID = C.CategoryID
Group By C.CategoryID;

--4. Display all baked goods along with their corresponding categories.
Select F.Name AS FoodItem, F.Description, F.Price, C.Name AS 'Category'
From FoodItem as F
Left Outer Join Category C On F.CategoryID = C.CategoryID;

--5. Retrieve all baked goods that belong to the 'Cookies' category
Select F.Name As 'Food Item Name', F.Price As 'Price Of Item', C.Name as 'Category Name' From FoodItem as F
Inner Join Category as C On F.CategoryID = C.CategoryID
WHERE C.Name = 'Cookies';

--6. Display the category with the least amount of food items
Select Top 1 C.Name As 'Category Name', Count(*) As 'Food Item Count' FROM Category As C
Left Join FoodItem AS F On C.CategoryID = F.CategoryID
Group By C.Name Order By Count(*) ASC;

--7. Retrieve all baked goods that belong to the category with the least amount of food items
Select F.Name As 'Food Item Name', F.Price As 'Price Of Item', C.Name as 'Category Name' From FoodItem As F, Category as C
Left Outer Join (Select Top 1 CategoryID, COUNT(*) As 'FoodItemCount' From FoodItem
Group By CategoryID Order By FoodItemCount ASC) As LeastFoodCategory 
On C.CategoryID = LeastFoodCategory.CategoryID
WHERE F.CategoryID = LeastFoodCategory.CategoryID;

--8. Search for the available cheesecakes in the bakery
 Select F.Name As 'Food Item Name', F.Price As 'Price Of Item' From FoodItem as F
WHERE F.Name LIKE '%cake%';

--9. Retrieve all baked goods sorted by their price from cheapest to the most expensive.
Select F.Name AS FoodItem, F.Description, F.Price As 'Price Of Item' From FoodItem as F
Order By Price;

--10. Get the details of the top 5 food items that are the most ordered by customers 
-- Note: based on the number of times they have been ordered
Select Top 5 F.FoodItemID, F.Name, F.Description, F.Price, COUNT(Od.FoodItemID) AS 'TotalOrders'
From FoodItem F
Join orderDetails as Od On F.FoodItemID = Od.FoodItemID
Group By F.FoodItemID, F.Name, F.Description, F.Price
Order By TotalOrders DESC;

--11. Display the name and price of the food items having the word 'tart' in their name and having a price higher than or equal to $2.
Select F.Name As 'Food Item Name', F.Price As 'Price Of Item' From FoodItem as F
Where F.Name LIKE '%tart%' and F.Price >= 2;

--12. Retrieve the name and price of the least expensive baked good.
Select Top 1 F.Name As 'Food Item Name', F.Price As 'Least Expensive Item'
From FoodItem As F 
Order by F.Price;

--13. Display all baked goods with a price between $10 and $15.
Select F.Name, F.Price From FoodItem As F
Where Price BETWEEN 10 AND 15;

--14. Get the details of the top 5 food items that are the least ordered by customers
Select Top 5 F.Name, F.Description, F.Price, COUNT(Od.FoodItemID) AS 'TotalOrders'
From FoodItem F
Left Join orderDetails as Od On F.FoodItemID = Od.FoodItemID
Group By F.FoodItemID, F.Name, F.Description, F.Price
Order By TotalOrders ASC;

--15. Show the most popular category based on the number of orders.
Select Top 1 C.Name As 'Category Name',Count(DISTINCT O.OrderID) As 'OrderCount' From Category As C
Left Join FoodItem As F On C.CategoryID = F.CategoryID
Left Join orderDetails As Od On F.FoodItemID= Od.FoodItemID
Left Join Orders As O On Od.OrderID=O.OrderID
Group By C.Name Order By OrderCount DESC;

--16. Display the least popular category based on the number of orders.
Select Top 1 C.Name As 'Category Name',Count(DISTINCT O.OrderID) As 'OrderCount' From Category As C
Left Join FoodItem As F On C.CategoryID = F.CategoryID
Left Join orderDetails As Od On F.FoodItemID= Od.FoodItemID
Left Join Orders As O On Od.OrderID=O.OrderID
Group By C.Name Order By OrderCount ASC;

--17. Show the average price of baked goods in each category.
Select C.Name As 'Category Name',AVG(F.Price) As 'Avgerage Price' From Category As C
Join FoodItem F On C.CategoryID =F.CategoryID
Group By C.Name;

--18. Display the last 3 food items added by the admin to the list of food items
SELECT TOP 3 F.Name As 'Food Item Name', F.Price As 'Food Item Price', F.image_01 As 'Food Item Image'
FROM FoodItem As F ORDER BY FoodItemID DESC;



-- CUSTOMER AND ORDERS RELATED


--19. List all customers who have registered on the website.
Select Name As 'Customer Name', Email As 'Customer Email' From Users 
Where RoleID = 2;

--20. Display all the administrators of the bakery.
Select Name As 'Admin Name', Email As 'Admin Email' From Users 
Where RoleID = 1;

--21. Logging in With email 'Lama@gmail.com' and Password = '432109'
Select Name As 'Customer Name', Email As 'Customer Email' From Users 
Where RoleID = 2 AND Email = 'Lama@gmail.com' AND Password = '432109';

--22. Find the number of orders placed by each customer.
Select U.Name As 'Customer Name', U.Email As 'Customer Email', Count(O.OrderID) As 'Num Of Orders'
From Users As U
Left Join Orders As O On U.UserId = O.UserID
Where U.RoleID = 2
Group By U.Name, U.Email;

--23. Display all orders placed by the customers.
Select * From Orders As O, Users As U Where U.roleID = 2;

--24. Show the total revenue generated from completed orders.
Select Sum(TotalAmount) As 'Total Revenue Generated From Completed Orders' From Orders Where orderStatus = 'completed';

--25. Show the total revenue generated from pending orders.
Select Sum(TotalAmount) As 'Total Revenue Generated From Pending Orders' From Orders Where orderStatus='pending';

--26. Show the total revenue generated from placed orders.
Select Sum(TotalAmount) AS 'Total Revenue Generated From Placed Orders' From Orders;


--27. Display the top 3 most valuable customers with the highest number of orders.
Select Top 3 U.Name As 'Customer Name', Count(Distinct O.OrderID) As 'Number Of Orders', 
Sum(O.TotalAmount) As 'Total Amount Spent' From Users As U
Inner Join Orders As O ON U.UserID = O.UserID
Group By U.UserID, U.Name Order By Sum(O.TotalAmount) DESC, Count(Distinct O.OrderID) DESC;


--28. Mark all the orders placed before 2024-04-22 as completed
UPDATE Orders Set OrderStatus = 'completed' Where placed_on < '2024-04-22';

--29. Display all the orders that include more than 4 items.
Select O.FName, O.LName, O.TotalProducts, O.TotalAmount, O.OrderStatus
From Orders as O Where O.TotalProducts > 4;

--30. Calculate the number of orders that have food items belonging to the 'Croissant' Category.
Select Count(Distinct O.OrderID) As 'Number Of Orders' From Orders As O
Join orderDetails As Od On O.OrderID = Od.OrderID
Join FoodItem  As F On Od.FoodItemID = F.FoodItemID
Join Category As C On C.CategoryID = F.CategoryID
Where C.Name = 'Croissant';


--31. Display the total revenue generated by the bakery in the month of april
Select Sum(O.TotalAmount) As 'Total Revenue of April' From Orders As O
Where O.placed_on >= '2024-04-01' AND O.placed_on <= '2024-04-30';


--32. Show the top 3 best-selling baked goods.
-- based on the total quantity sold
Select Top 3 F.Name As 'Food Item Name', SUM(Od.Quantity) As 'Total Quantity Sold' From FoodItem As F
Join OrderDetails As Od On F.FoodItemID = Od.FoodItemID
Group By F.Name Order By 'Total Quantity Sold' DESC;


--33. Retrieve all orders that where placed by admins and not by customers.
Select O.FName, O.LName, O.TotalProducts, O.TotalAmount, O.placed_on, O.OrderStatus From Orders As O
Left Outer Join Users As U On O.UserID = U.UserID
Left Outer Join Role As R On U.RoleID = R.RoleID
WHERE R.RoleID = 1;


--34. A customer whose orderID is 5 wants to cancel their order
Delete From orderDetails Where OrderID = 5;
Delete From Orders Where OrderID = 5;


--35. Retrieve all orders made by the customer Farah.
Select O.FName, O.LName, O.TotalProducts, O.TotalAmount, O.placed_on, O.OrderStatus From Orders As O
Where UserID IN (Select U.UserID From Users As U Where Name LIKE 'Farah%' AND ROLEID = 2);


--36. Retrieve all orders placed on the 14th and 21st of april
Select O.FName, O.LName, O.TotalProducts, O.TotalAmount, O.placed_on, O.OrderStatus From Orders As O
Where placed_on IN ('2024-04-14' , '2024-04-21');


--37. Retrieve the total number of orders placed from the first day the bakery opened till today.
Select Count(*) AS 'Total Orders Placed' From Orders;


--38. List all orders that are pending and yet to be delivered from the oldest order to the most recent one.
Select * From Orders Where OrderStatus NOT IN (Select OrderStatus FROM Orders WHERE OrderStatus = 'completed')
ORDER BY placed_on ASC;


--39. List all orders completed and ready for delivery.
Select * From Orders Where orderStatus = 'completed';


--40. Display the number of orders placed and the total revenue generated from the order in each city.
Select City, Count(OrderID) As 'Total Orders', Sum(O.TotalAmount) As TotalRevenue From Orders As O
Group By O.City;


--41. List all customers who have placed orders from a specific city 'Beirut'.
Select Distinct U.UserID, U.Name From Users U
Left Outer Join Orders As O On U.UserID = O.UserID
Where O.City='Beirut' AND U.RoleID=2; 


--42. Display the total revenue generated from orders placed by a customer with UserId = 4.
Select Sum(O.TotalAmount) As 'Total Revenue Generated' From Orders As O
Where O.UserID = 4;

--43. Display the customer and total price of the most expensive order
Select U.Name As 'Customer Name', O.TotalProducts As 'Total Products', O.TotalAmount As 'Total Price' From Orders As O
JOIN Users As U On O.UserID = U.UserID
Where O.TotalAmount = (Select Max(TotalAmount) From Orders);

--44. Find all users who have placed orders containing 'chocolate chip cookies' and provide details of those orders.
Select U.UserID, O.FName, O.LName, O.TotalProducts, O.TotalAmount, O.placed_on, O.OrderStatus From Users As U
Join Orders As O On U.UserID = O.UserID
Join orderDetails As Od On O.OrderID = Od.OrderID
Where EXISTS (Select 1 From FoodItem AS F
Where F.FoodItemID = Od.FoodItemID AND F.Name = 'chocolate chip cookies');


--45. List all customers who have placed orders worth more than $20.
Select U.UserID, U.Name, Sum(O.TotalAmount) as 'Total Amount' From Users As U, Orders As O
Where U.UserID = O.UserID 
Group By U.UserID, U.Name Having Sum(O.TotalAmount) > 20;


--46. Show the number of orders and total revenue generated on '2024-04-21'
Select COUNT(*) As 'Number Of Orders', Sum(TotalAmount) As 'Total Revenue Generated'
From Orders As O Where O.placed_on = '2024-04-21';


--47. Retrieve the average order price.
Select AVG(TotalAmount) As 'Average Value' From Orders;


--48. Show the total quantity of food items over all the order ordered by each customer
Select U.Name As 'Customer Name', Sum(Od.Quantity) As 'Total Quantity Ordered' From Users As U
Join Orders As O On U.UserID =O.UserID
Join orderDetails As Od On O.OrderID= Od.OrderID
Join FoodItem As F On Od.FoodItemID = F.FoodItemID
GROUP BY U.Name;


--49. Show the number of customers who have registered but not placed any orders.
Select U.Name As 'Customer Name', U.Email As 'Customer Email' From Users As U
Where UserID NOT IN (Select Distinct UserID From Orders) AND U.RoleID = 2;


--50. List all customers who have placed orders above the average order price.
Select Distinct U.Name as 'Customer Name', U.Email As 'Customer Email' From Users As U
Join Orders As O On U.UserID =O.UserID
Where O.TotalAmount > (Select AVG(TotalAmount) From Orders);


--51. Retrieve all customers along with the total number of orders they've placed.
Select U.Name as 'Customer Name', Count(O.OrderID) As 'TotalOrders' From Users As U
Left Join Orders As O On U.UserID=O.UserID
Where U.RoleID=2 Group By U.UserID, U.Name Order By TotalOrders DESC;

--52. Retrieve all customers who have placed more than 2 orders.
Select U.Name as 'Customer Name', Count(O.OrderID) As 'TotalOrders' From Users As U
Left Join Orders O On U.UserID=O.UserID
Where U.RoleID=2 Group By U.UserID, U.Name HAVING Count(O.OrderID) > 2;

--53. Retrieve all customers along with their total spending.
Select U.Name as 'Customer Name',Sum(O.TotalAmount) As 'Total Spending' From Users As U
Join Orders As O On U.UserId=O.UserID
Where U.RoleID=2 Group By U.UserId,U.Name;

--54. Retrieve all customers who have spent more than $50.
Select  U.Name as 'Customer Name',Sum(O.TotalAmount) As 'Total Spending' From Users As U
Join Orders As O On U.UserId=O.UserID
Where U.RoleID=2 Group By U.UserId,U.Name Having Sum(O.TotalAmount)>50;

--55. Retrieve the top 10 customers by total spending.
Select Top 10 U.Name as 'Customer Name',Sum(O.TotalAmount) AS 'TotalSpending' From Users As U
Join Orders As O ON U.UserId=O.UserID
Where U.RoleID=2 Group By U.UserId,U.Name Order By TotalSpending DESC;

--56. List the names of customers, along with their total order price who have placed orders with a price greater than the average price of all food items.
Select U.Name As 'Customer Name', SUM(O.TotalAmount) AS 'Total Order Price' From Users As U
Join Orders As O On U.UserID = O.UserID
Where O.OrderID IN (Select Distinct OrderID From orderDetails
Where FoodItemID IN (Select FoodItemID From FoodItem
Where Price > (Select AVG(Price) From FoodItem)))
GROUP BY U.Name;


--57.List the names of customers along with their number of orders that have food items from more than one category
Select U.Name As 'Customer Name', Count(Distinct O.OrderID) AS 'Num of Orders' From Users As U
Join Orders As O On U.UserID = O.UserID
Where U.RoleID = 2 AND O.OrderID IN (Select O.OrderID From Orders O
Join orderDetails As Od On O.OrderID = Od.OrderID
Join FoodItem As F On Od.FoodItemID = F.FoodItemID
Group By O.OrderID Having Count(Distinct F.CategoryID) > 1)
Group By U.Name;


--58. Display the customers who have made at least 1 order with a total price above $20, and have submitted a rating of 5 stars and wrote a review
Select Distinct U.Name as 'Customer Name', U.Email As 'Customer Email' From Users As U
Where U.UserID IN (Select O.UserID From Orders As O
Where O.TotalAmount > 20 AND O.UserID IN (Select R.UserID From Reviews As R
Where R.Rating = 5 AND R.UserID IN (Select O.UserID From Orders As o)));


--59. Display all the customers who have not bought in the past month
Select Distinct U.Name as 'Customer Name', U.Email As 'Customer Email' From Users As U
Left Join Orders As O ON U.UserID =O.UserID
Where O.UserID IS NULL OR O.placed_on < DATEADD(month, -1, GETDATE());




-- CART AND WISHLIST RELATED


--60. List all customers who have added items to their cart.
Select U.Name As 'User Name', U.Email As 'User Email' From Users As U 
Full Outer Join Cart As C ON U.UserID =C.UserID
Where U.RoleID=2;


--61. Retrieve all customers who have not yet checked out their orders.
Select U.Name As 'User Name', U.Email As 'User Email' From Users As U
Where RoleID NOT LIKE 1 AND UserID IN (SELECT UserID FROM Cart) AND UserID NOT IN(SELECT UserID FROM Orders);


--62. List all customers who have items in their wishlist.
Select U.Name As 'User Name', U.Email As 'User Email' From Users As U 
Where UserID IN (Select Distinct UserID From Wishlist);


--63. Display all items with their quantities in the wishlist of a user with userid = 14
Select Wc.FoodItemID, F.Name As 'Food Item Name', Wc.Quantity As 'Quantity In Wishlist' From wishContains As Wc
Join FoodItem As F On Wc.FoodItemID = F.FoodItemID
Where Wc.wishListID = (Select wishListID From wishlist Where UserID = 14);


--64. Show all items with their quantities in the cart of a user with userid = 2
Select F.Name As 'Food Item Name', Ci.Quantity As 'Quantity In Cart' From Cart As C
Join CartIncludes As Ci On C.CartID = Ci.CartID
Join FoodItem As F ON Ci.FoodItemID = F.FoodItemID
Where C.UserID = 2;


--65. Show all users that have placed orders for food items that are also present in their wishlists
Select Distinct U.Name As 'Customer Name', U.email As 'Customer Email' From Users As U 
Where U.UserID IN (Select Distinct W.UserID from wishlist As W
Join wishContains As Wc ON W.wishListID = Wc.wishListID
Where Wc.FoodItemID IN (
Select Distinct Od.FoodItemID From Orders As o
Join orderDetails As Od On O.OrderID = Od.OrderID
Where O.UserID = W.UserID));


--66. Display the number of customers who have registered but not added any items to their wishlist.
Select Count(UserID) As 'Num Of Customers' From Users As U
Where U.UserID NOT IN (SELECT UserID FROM wishlist) AND U.RoleID = 2;


--67. Delete food item named 'double chocolate cookies' from cartid = 8
Delete From CartIncludes
Where CartID = 4 AND 
FoodItemID = (Select FoodItemID From FoodItem
Where Name = 'double chocolate cookies');


--68. Display the top 1 food item in the carts and in the wishlists of all customers
Select (Select Top 1 Name As 'Food Item Name' From FoodItem 
Where FoodItemID = (Select Top 1 FoodItemID From CartIncludes 
Group By FoodItemID Order By SUM(Quantity) DESC)) As 'Top Food Item In Cart',
(Select Top 1 Name As 'Food Item Name' From FoodItem 
Where FoodItemID = (Select Top 1 FoodItemID From wishContains 
Group By FoodItemID Order By SUM(Quantity) DESC)) AS 'Top Food Item In Wishlist';



-- MESSAGES AND REVIEWS RELATED


--69. Display the total number of messages sent by each customer.
Select UserID, Count(*) AS 'Total Messages Sent' From Messages
Where UserID IN (Select UserID From Users Where RoleID=2)
Group By UserID;


--70. Retrieve all customers who have sent messages to the admin, along with their sent messages.
Select U.Name As 'Customer Name', U.email As 'Customer Email',  M.message AS SentMessage From Users As U
Join Messages As M On U.UserID=M.UserID
Where U.RoleID=2;


--71. Retrieve all messages sent by customers to the admin.
Select * From Messages;

--72. Retrieve all reviews left by customers.
Select * From Reviews;

--73. Retrieve the average rating of all reviews.
Select AVG(Rating) As 'Average Rating' FROM Reviews;


--74. Show the details of customers who have given the highest rating.
Select U.Name As 'Customer Name', U.Email As 'Customer Email', R.Rating As 'Highest Rating' From Users As U
Join Reviews As R ON U.UserID = R.UserID
Where R.Rating = (Select MAX(Rating) From Reviews);


--75. List all customers who have given ratings below 3 stars.
Select U.Name As 'Customer Name', U.Email As 'Customer Email' 
From Users As U, Reviews
Where U.UserID = Reviews.UserID AND Rating < 3;


--76. List all customers who have registered but have not sent any messages to the admin.
Select Count(UserID) AS NbOfCustomers
From Users
WHERE Users.UserID NOT IN (SELECT UserID FROM Messages)
AND Users.RoleID = 2;


--77. Retrieve all customers who have not yet written a review.
Select * From Users As U
Where UserID NOT IN (Select Distinct UserID From Reviews);


--78. Retrieve the total number of messages sent to the admin.
Select COUNT(*) AS 'Number Of Messages' From Messages;