INSERT INTO orders (order#, customer#, orderdate)
VALUES ('1021', '1009', '20-Jul-2009');

UPDATE orders
SET shipzip = '33222'
WHERE order# = '1017';

COMMIT;

INSERT INTO orders (order#, customer#, orderdate)
VALUES ('1022', '2000', '06-AUG-2009');
Error was generated because referential integrity was violated.  A customer# entry needs to be added to the customers table before the entry can be added to the orders table.

INSERT INTO orders (order#, customer#)
VALUES ('1023', '1009');
An error was generated because the ‘orderdate’ column does not accept NULL values.

UPDATE books
SET cost = '&cost'
WHERE isbn = '&isbn';

1059831198	BODYBUILD IN 10 MINUTES A DAY	21-JAN-05	4	20	30.95		FITNESS

ROLLBACK;

SAVEPOINT ONE;

DELETE FROM orderitems
WHERE order# = '1005'

ROLLBACK ONE;

CREATE SEQUENCE customers_customer#_seq
	INCREMENT BY 1
	START WITH 1021
	NOCACHE
	NOCYCLE;

INSERT INTO customers (customer#,lastname, firstname, zip)
	VALUES (
	customers_customer#_seq.NEXTVAL, 'Shoulders', 'Frank', 23567);

CREATE SEQUENCE MY_FIRST_SEQ
	INCREMENT BY -3
	START WITH 5
	MAXVALUE 5
	MINVALUE 0
	NOCYCLE;

SELECT MY_FIRST_SEQ.NEXTVAL
FROM DUAL;

ALTER SEQUENCE MY_FIRST_SEQ
	MINVALUE -1000;

CREATE TABLE email_log (
	emailid		NUMBER (4) GENERATED AS IDENTITY PRIMARY KEY,
	emaildate	DATE,
	customer#	NUMBER (4)
);

INSERT INTO email_log (emaildate, customer#)
VALUES (SYSDATE, '1007');

1	03-MAR-18	1007

INSERT INTO email_log (emailid, emaildate, customer#)
VALUES (default, SYSDATE, '1008');

2	03-MAR-18	1008

INSERT INTO email_log (emailid, emaildate, customer#)
VALUES (25, SYSDATE, '1009');

"cannot insert into a generated always identity column"

orrected by using this statement:

INSERT INTO email_log (emailid, emaildate, customer#)
VALUES (default, SYSDATE, '1009');

CREATE SYNONYM NUMGEN
FOR MY_FIRST_SEQ;

SELECT NUMGEN.CURRVAL
FROM DUAL;
DROP SYNONYM NUMGEN;
DROP SEQUENCE MY_FIRST_SEQ;

CREATE BITMAP INDEX customers_state_idx
	ON customers (state);

SELECT table_name, index_name, index_type
FROM user_indexes
WHERE table_name = 'CUSTOMERS';

DROP INDEX customers_state_idx;

CREATE INDEX customers_lastname_idx
ON customers (LastName);

SELECT table_name, index_name, index_type
FROM user_indexes
WHERE table_name = 'CUSTOMERS';

CREATE INDEX ship_days_idx
ON orders (shipdate - orderdate);

ALTER SESSION set "_ORACLE_SCRIPT"=true;
CREATE USER agrimm
IDENTIFIED BY Pa$sword

GRANT create session, create table, alter any table
TO c##agrimm;

CREATE ROLE c##customerrep;
GRANT INSERT, DELETE
ON system.orders
TO c##customerrep;
GRANT INSERT, DELETE
ON system.orderitems
TO c##customerrep;

GRANT c##customerrep
TO c##agrimm;

SELECT *
FROM user_sys_privs;
SELECT *
FROM user_role_privs;

REVOKE DELETE
ON system.orders
FROM c##customerrep;
REVOKE DELETE
ON system.orderitems
FROM c##customerrep;

REVOKE c##customerrep
FROM c##agrimm;

DROP ROLE c##customerrep;

DROP USER c##agrimm;

SELECT Lastname, Firstname, state
FROM Customers
WHERE State = 'NJ';

SELECT Order#, ShipDate
FROM Orders
WHERE ShipDate > '01-APR-2009';

SELECT Title, Category
FROM Books
WHERE Category != 'Fitness';

SELECT Customer#, LastName, State
FROM Customers
WHERE State IN ('GA','NJ')
ORDER BY LastName;
SELECT Customer#, LastName, State
FROM Customers
WHERE State  = 'GA' OR State = 'NJ'
ORDER BY LastName;

SELECT Order#, OrderDate
FROM Orders
WHERE OrderDate <= '01-APR-2009';
SELECT Order#, OrderDate
FROM Orders
WHERE OrderDate <= '01-APR-2009'
ORDER BY Order#;

SELECT Lname, Fname
FROM Author
WHERE Lname LIKE '%IN%'
ORDER BY Lname, Fname;

SELECT Lastname, Referred
FROM Customers
WHERE Referred IS NOT NULL
ORDER BY Lastname;

SELECT Title, Category
FROM Books
WHERE Category LIKE 'C%I%';
SELECT Title, Category
FROM Books
WHERE Category = 'CHILDREN' OR Category = 'COOKING';
SELECT Title, Category
FROM Books
WHERE Category IN ('CHILDREN','COOKING')
ORDER BY Category;

SELECT ISBN, Title
FROM Books
WHERE Title LIKE '_A_N%'
ORDER BY Title DESC;

SELECT Title, PubDate
FROM Books
WHERE Category = 'COMPUTER' AND PubDate LIKE '%05';
SELECT Title, PubDate
FROM Books
WHERE Category = 'COMPUTER' AND PubDate BETWEEN '01-JAN-05' AND '31-DEC-05';
SELECT Title, PubDate
FROM Books
WHERE Category = 'COMPUTER'
AND PubDate >= '01-JAN-05' AND PubDate <= '31-DEC-05'
ORDER BY PubDate;

SELECT title, name, phone
FROM Books b, Publisher p
WHERE b.pubid = p.pubid;
SELECT title, name, Publisher
FROM Books b JOIN Publisher p
ON b.pubid = p.pubid;

SELECT Lastname, FirstName, Order#
FROM Customers c, Orders o
WHERE c.Customer# = o.Customer# AND o.ShipDate = NULL
ORDER BY OrderDate;
SELECT LastName, FirstName, Order#
FROM Customers c JOIN Orders o
ON c.Customer# = o.Customer#
AND o.ShipDate = NULL
ORDER BY o.ShipDate;

SELECT Customer#, LastName, FirstName
FROM Customers c, orders o, books b, OrderItems oi
Where c.Customer# = o.Customer#
AND o.Order# = oi.Order#
AND oi.ISBN = b.ISBN
AND c.State = 'FL' AND b.Category = 'COMPUTER';
SELECT Customer#, FirstName, LastName
FROM Customers c JOIN Orders o USING (Customer#)
JOIN OrderItems oi USING (Order#)
JOIN Books b USING (ISBN)
WHERE c.State = 'FL' AND b.Category = 'COMPUTER';

SELECT DISTINCT title, LastName, FirstName
FROM Books b, Customers c, Orders o, OrderItems oi
WHERE c.LastName = 'LUCAS' AND c.FirstName = 'JAKE'
AND c.Customer# = o.Customer#
AND o.Order# = oi.Order#
AND oi.ISBN = b.ISBN;
SELECT DISTINCT Title, LastName, FirstName
FROM Customers c JOIN Orders o USING (Customer#)
JOIN OrderItems oi USING (Order#)
JOIN Books b USING (ISBN)
WHERE c.LastName = 'LUCAS' AND c.FirstName = 'JAKE';

SELECT b.Title, o.OrderDate, (oi.PaidEach - b.Cost) PROFIT
FROM Books b, Customers c, Orders o, OrderItems oi
WHERE c.LastName = 'LUCAS' AND c.FirstName = 'JAKE'
AND c.Customer# = o.Customer#
AND o.Order# = oi.Order#
AND oi.ISBN = b.ISBN
ORDER BY OrderDate, PROFIT DESC;
SELECT b.Title, o.OrderDate (oi.PaidEach - b.Cost) PROFIT
FROM Customers c JOIN Orders o USING (Customer#)
JOIN OrderItems oi USING (Order#)
JOIN Books b USING (ISBN)
WHERE c.LastName = 'LUCAS' AND c.FirstName = 'JAKE'
ORDER BY OrderDate, PROFIT DESC;

SELECT b.Title
FROM Books b, BookAuthor ba, Authors a
WHERE b.ISBN = ba.ISBN
AND ba.AuthorID = a.AuthorID
AND a.LastName = 'ADAMS';
SELECT b.Title
FROM Books b JOIN BookAuthor ba USING (ISBN)
JOIN Author a USING (AuthorID)
WHERE a.LastName = 'ADAMS';

SELECT p.Gift
FROM Promotions p, Books b
WHERE b.Retail BETWEEN p.Minretail and p.Maxretail
AND b.Title = 'SHORTEST POEMS';
SELECT p.Gift
FROM Books b JOIN Promotions p
ON b.Retail BETWEEN p.Minretail and p.Maxretail
WHERE b.Title = 'SHORTEST POEMS';

SELECT a.LastName, a.FirstName
FROM Author a, BookAuthor ba, Customers c, Orders o, OrderItems oi
WHERE c.Customer# = o.Customer#
AND o.Order# = oi.Order#
AND oi.ISBN = ba.ISBN
AND ba.AuthorID = a.AuthorID
WHERE c.LastName = 'NELSON' AND c.FirstName = 'BECCA';
SELECT a.LastName, a.FirstName
FROM Customers c JOIN Orders o USING (Customer#)
JOIN OrderItems oi USING (Order#)
JOIN BookAuthor ba USING (ISBN)
JOIN Author a USING (AuthorID)
WHERE c.LastName = 'NELSON' AND c.FirstName = 'BECCA';

SELECT b.Title, o.Order#, c.State
FROM Books b, Customers c, Orders o, OrderItems oi
WHERE c.Customer#(+) = o.Customer#
AND o.Order#(+) = oi.Order#
AND oi.ISBN(+) = b.ISBN;
SELECT. Title, o.Order#, c.State
FROM Customers c LEFT OUTER JOIN Orders o USING (Customer#)
LEFT OUTER JOIN OrderItems oi USING (Order#)
LEFT OUTER JOIN Books b USING (ISBN);

SELECT e.FName || ' ' || e.LName "Employee Name", e.Job,
       m.FName || ' ' || m.LName "Manager Name"
FROM Employees e, Employees m
WHERE m.MGR = e.empno(+);

***********
Chapter 10
1.
SELECT INITCAP(FirstName) "First Name", INITCAP(LastName) "Last Name"
FROM Customers;

2.
SELECT Customer#, NVL2(Referred, 'Referred', 'Not Referred') "Referred Status"
FROM Customers;

3.
SELECT b.Title, TO_CHAR (SUM ((oi.PaidEach*oi.Quantity)-(oi.Quantity*b.Cost)), '$999.99') "Profit"
FROM Books b JOIN OrderItems oi USING (ISBN)
JOIN Orders o USING (Order#)
WHERE Order# = 1002
GROUP BY b.Title;

4.
SELECT Title, ROUND((Retail-Cost)/Cost*100, 0)||'%' "Markup"
FROM Books;

5.
SELECT TO_CHAR(Current_Date, 'Day, HH:MI:SS')
FROM dual;

6.
SELECT Title, Cost LPAD(Cost, 12, '*')
FROM Books;

7.
SELECT DISTINCT LENGTH(ISBN)
FROM Books;

8.
SELECT Title, PubDate, SYSDATE, TRUNC(MONTHS_BETWEEN(SYSDATE,PubDate), 0) "AGE"
From Books;

9.
SELECT NEXT_DAY(SYSDATE, 'Wednesday')
FROM dual;

10.
SELECT Customer#, SUBSTR(Zip, 3, 2), INSTR(Customer#, 3)
From Customers;

***********
Chapter 12

1.
SELECT title, retail
FROM books
WHERE retail <ALL (SELECT AVG (retail)
					FROM books);

2.
SELECT a.title, b.category, a.cost
FROM books a, (SELECT category, AVG(cost) avcost
			  FROM books
			  GROUP BY category) b
WHERE a.category = b.category
	AND a.cost < b.avcost;

3.
SELECT Order#
FROM Orders
WHERE ShipState = (SELECT shipstate
				   FROM orders
				   WHERE order# = 1014);

4.
SELECT order#, SUM(quantity * paideach) "SUM"
FROM orderitems
GROUP BY order#
HAVING SUM(quantity * paideach) >(SELECT SUM(quantity * paideach)
                                  FROM orderitems
                                  WHERE order# = 1008);

5.
SELECT Fname || ' ' || Lname "Name"
FROM author JOIN bookauthor USING (authorid)
WHERE isbn IN(SELECT isbn
	          FROM orderitems
	          GROUP BY isbn
	          HAVING SUM(quantity) =(SELECT MAX(COUNT(*))
	          						 FROM orderitems
	          						 GROUP BY isbn));

6.
Select title
From Books
Where category IN (Select Distinct Category 
				   From Books Join orderitems using (isbn)
				   JOIN Orders Using (order#)
				   Where customer# = 1007)
				   AND isbn NOT IN (Select isbn 
				   				    From orders Join Orderitems Using (order#)
				   				    Where customer# = 1007);

7.
SELECT order#, shipcity || ', ' || shipstate
FROM orders
WHERE shipdate - orderdate = (SELECT MAX (shipdate-orderdate)
                                      FROM orders);

8.
SELECT c.firstname || ' ' || c.lastname "Name", b.title
FROM customers c JOIN orders o USING (customer#)
JOIN orderitems oi USING (order#)
JOIN books b USING (isbn)
WHERE retail = (SELECT MIN(retail)
                FROM books);

9.
SELECT COUNT(DISTINCT customer#)
FROM customers JOIN orders USING (customer#)
JOIN orderitems USING (order#)
WHERE isbn IN (SELECT isbn
               FROM books JOIN bookauthor USING (isbn)
               JOIN author USING (authorid)
               WHERE lname = 'AUSTIN'
               AND fname = 'JAMES');

10.
SELECT title
FROM books
WHERE pubid = (SELECT pubid
               FROM books
               WHERE title = 'THE WOK WAY TO COOK');

***********
Chapter 13
***********

1.
CREATE VIEW contact
AS SELECT contact, phone
	FROM Publisher
WITH READ ONLY;

2.
CREATE OR REPLACE VIEW contact
AS SELECT contact, phone
	FROM Publisher;

3.
CREATE FORCE VIEW homework13
AS SELECT col1, col2
	FROM firstattempt
WITH READ ONLY:

4.
SELECT *
FROM homework13;

5.
CREATE VIEW reorderinfo
AS SELECT isbn, title, contact, phone
	FROM books JOIN publisher USING (pubid)
WITH READ ONLY;

6.
UPDATE reorderinfo
SET contact = 'Adrian Grimm'
WHERE contact = 'DAVID DAVIDSON';
Error:
Error at Command Line : 2 Column : 5
Error report -
SQL Error: ORA-01779: cannot modify a column which maps to a non key-preserved table
01779. 00000 -  "cannot modify a column which maps to a non key-preserved table"
*Cause:    An attempt was made to insert or update columns of a join view which
           map to a non-key-preserved table.
*Action:   Modify the underlying base tables directly.

7.
UPDATE reorderinfo
SET isbn = '2147428390'
WHERE isbn = '2147428890';
Error:
Error at Command Line : 2 Column : 5
Error report -
SQL Error: ORA-42399: cannot perform a DML operation on a read-only view
42399.0000 - "cannot perform a DML operation on a read-only view"

8.
DELETE FROM reorderinfo
WHERE contact = 'DAVID DAVIDSON';
Error at Command Line : 1 Column : 13
Error report -
SQL Error: ORA-42399: cannot perform a DML operation on a read-only view
42399.0000 - "cannot perform a DML operation on a read-only view"

9.
ROLLBACK;

10.
DROP VIEW reorderinfo;
