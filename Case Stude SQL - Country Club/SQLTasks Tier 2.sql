<<<<<<< HEAD
/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the CASE study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the CASE study. This will make the CASE study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational DatabASes in Python chapter in the previous resource.

Otherwise, the questions in the CASE study are exactly the same AS with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pASting the following URL into your browser, and
using the following Username and PASsword:

URL: https://sql.springboard.com/
Username: student
PASsword: learn_sql@springboard

The data you need is in the "country_club" databASe. This databASe
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this CASE study, you'll be ASked a series of questions. You can solve them using the platform, but for the final deliverable, pASte the code for each solution into this script, and upload it to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT * 
FROM `Facilities` 
WHERE membercost >0;


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*) 
FROM `Facilities` 
WHERE membercost > 0;


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's MONTHly maintenance cost.
Return the facid, facility name, member cost, and MONTHly maintenance of the
facilities in question. */

SELECT facid, facility name, member cost, MONTHly_maintenance 
FROM `Facilities` 
WHERE membercost > 0 
AND (membercost < MONTHlymaintenance * .20);


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT * 
FROM `Facilities` 
WHERE facid IN (1,5);


/* Q5: Produce a list of facilities, with each labelled AS
'cheap' or 'expensive', depending on if their MONTHly maintenance cost is
more than $100. Return the name and MONTHly maintenance of the facilities
in question. */

SELECT name, 
	CASE WHEN MONTHlymaintenance > 100 THEN 'expensive'
    	ELSE 'cheap' 
        END AS 'MONTHly maintenance'	
FROM `Facilities` ;

/* Q6: You'd like to get the first and lASt name of the lASt member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT firstname, surname 
FROM `Members` 
ORDER BY joindate DESC

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted AS a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT CONCAT(firstname, " ", surname) AS member_name, f.name AS facility_name
FROM `Members` AS m
INNER JOIN `Bookings` AS b ON m.memid = b.memid 
INNER JOIN `Facilities` AS f ON f.facid = b.facid
WHERE b.facid = 0 or b.facid = 1
ORDER BY member_name;

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user's ID is always 0. Include in your output the name of the facility, the name of the member formatted AS a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT DISTINCT CONCAT(firstname, " ", surname) AS member_name, f.name AS facility_name,
	CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
	ELSE f.membercost * b.slots
    END AS cost
FROM `Members` AS m
INNER JOIN `Bookings` AS b ON m.memid = b.memid 
INNER JOIN `Facilities` AS f ON f.facid = b.facid
WHERE DATE(b.starttime) = "2012-09-14" AND cost >30
ORDER BY cost DESC;

/* Q9: This time, produce the same result AS in Q8, but using a subquery. */
SELECT DISTINCT CONCAT(firstname, " ", surname) AS member_name, 
name AS facility_name, cost
FROM (SELECT m.firstname, m.surname, b.starttime, f.name, CASE WHEN b.memid = 0 THEN f.guestcost * b.slots ELSE f.membercost * b.slots END AS cost FROM `Members` AS m INNER JOIN `Bookings` AS b ON m.memid = b.memid INNER JOIN `Facilities` AS f ON f.facid = b.facid) AS inner_table
WHERE DATE(starttime) = "2012-09-14" AND cost >30
ORDER BY cost DESC;

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
query = '''SELECT name, revenue FROM (SELECT name, SUM(CASE WHEN memid = 0 THEN guestcost * slots ELSE membercost * slots END) AS revenue
FROM bookings INNER JOIN facilities ON bookings.facid = facilities.facid GROUP BY name) AS inner_table WHERE revenue < 1000 ORDER BY revenue'''
df = pd.read_sql_query(query, connection)
print(df)

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */
query = '''SELECT m1.firstname || ' ' || m1.surname AS member, recommended.firstname || ' ' || recommended.surname AS 'recommended by' FROM Members AS m1 INNER JOIN Members recommended On recommended.recommendedby = m1.memid WHERE m1.surname <> "GUEST" AND m1.recommendedby IS NOT NULL ORDER BY m1.surname, m1.firstname'''

/* Q12: Find the facilities with their usage by member, but not guests */
query = '''SELECT DISTINCT f.name, m.firstname || ' ' || m.surname AS member FROM Facilities AS f 
INNER JOIN Bookings b ON b.memid = m.memid
INNER JOIN Members m ON f.facid = b.facid
WHERE b.memid <> 0 ORDER BY f.name'''
df = pd.read_sql_query(query, connection)
print(df)

/* Q13: Find the facilities usage by MONTH, but not guests */
SELECT f.name,CONCAT(m.firstname,' ',m.surname) AS Member,
COUNT(f.name) AS bookings,
	SUM(CASE WHEN MONTH(starttime) = 1 THEN 1 ELSE 0 end) AS Jan,
SUM(CASE WHEN MONTH(starttime) = 2 THEN 1 ELSE 0 end) AS Feb,
SUM(CASE WHEN MONTH(starttime) = 3 THEN 1 ELSE 0 end) AS Mar,
SUM(CASE WHEN MONTH(starttime) = 4 THEN 1 ELSE 0 end) AS Apr,
SUM(CASE WHEN MONTH(starttime) = 5 THEN 1 ELSE 0 end) AS May,
SUM(CASE WHEN MONTH(starttime) = 6 THEN 1 ELSE 0 end) AS Jun,
SUM(CASE WHEN MONTH(starttime) = 7 THEN 1 ELSE 0 end) AS Jul,
SUM(CASE WHEN MONTH(starttime) = 8 THEN 1 ELSE 0 end) AS Aug,
SUM(CASE WHEN MONTH(starttime) = 9 THEN 1 ELSE 0 end) AS Sep,
SUM(CASE WHEN MONTH(starttime) = 10 THEN 1 ELSE 0 end) AS Oct,
SUM(CASE WHEN MONTH(starttime) = 11 THEN 1 ELSE 0 end) AS Nov,
SUM(CASE WHEN MONTH(starttime) = 12 THEN 1 ELSE 0 end) AS Decm

FROM `Members` m
INNER JOIN `Bookings` AS b ON b.memid = m.memid
INNER JOIN `Facilities` AS f ON f.facid = b.facid
WHERE m.memid>0
AND year(starttime) = 2012

GROUP BY f.name,concat(m.firstname,' ',m.surname)
=======
/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the CASE study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the CASE study. This will make the CASE study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational DatabASes in Python chapter in the previous resource.

Otherwise, the questions in the CASE study are exactly the same AS with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pASting the following URL into your browser, and
using the following Username and PASsword:

URL: https://sql.springboard.com/
Username: student
PASsword: learn_sql@springboard

The data you need is in the "country_club" databASe. This databASe
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this CASE study, you'll be ASked a series of questions. You can solve them using the platform, but for the final deliverable, pASte the code for each solution into this script, and upload it to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT * 
FROM `Facilities` 
WHERE membercost >0;


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*) 
FROM `Facilities` 
WHERE membercost > 0;


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's MONTHly maintenance cost.
Return the facid, facility name, member cost, and MONTHly maintenance of the
facilities in question. */

SELECT facid, facility name, member cost, MONTHly_maintenance 
FROM `Facilities` 
WHERE membercost > 0 
AND (membercost < MONTHlymaintenance * .20);


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT * 
FROM `Facilities` 
WHERE facid IN (1,5);


/* Q5: Produce a list of facilities, with each labelled AS
'cheap' or 'expensive', depending on if their MONTHly maintenance cost is
more than $100. Return the name and MONTHly maintenance of the facilities
in question. */

SELECT name, 
	CASE WHEN MONTHlymaintenance > 100 THEN 'expensive'
    	ELSE 'cheap' 
        END AS 'MONTHly maintenance'	
FROM `Facilities` ;

/* Q6: You'd like to get the first and lASt name of the lASt member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT firstname, surname 
FROM `Members` 
ORDER BY joindate DESC

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted AS a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT CONCAT(firstname, " ", surname) AS member_name, f.name AS facility_name
FROM `Members` AS m
INNER JOIN `Bookings` AS b ON m.memid = b.memid 
INNER JOIN `Facilities` AS f ON f.facid = b.facid
WHERE b.facid = 0 or b.facid = 1
ORDER BY member_name;

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user's ID is always 0. Include in your output the name of the facility, the name of the member formatted AS a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT DISTINCT CONCAT(firstname, " ", surname) AS member_name, f.name AS facility_name,
	CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
	ELSE f.membercost * b.slots
    END AS cost
FROM `Members` AS m
INNER JOIN `Bookings` AS b ON m.memid = b.memid 
INNER JOIN `Facilities` AS f ON f.facid = b.facid
WHERE DATE(b.starttime) = "2012-09-14" AND cost >30
ORDER BY cost DESC;

/* Q9: This time, produce the same result AS in Q8, but using a subquery. */
SELECT DISTINCT CONCAT(firstname, " ", surname) AS member_name, 
name AS facility_name, cost
FROM (SELECT m.firstname, m.surname, b.starttime, f.name, CASE WHEN b.memid = 0 THEN f.guestcost * b.slots ELSE f.membercost * b.slots END AS cost FROM `Members` AS m INNER JOIN `Bookings` AS b ON m.memid = b.memid INNER JOIN `Facilities` AS f ON f.facid = b.facid) AS inner_table
WHERE DATE(starttime) = "2012-09-14" AND cost >30
ORDER BY cost DESC;

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
query = '''SELECT name, revenue FROM (SELECT name, SUM(CASE WHEN memid = 0 THEN guestcost * slots ELSE membercost * slots END) AS revenue
FROM bookings INNER JOIN facilities ON bookings.facid = facilities.facid GROUP BY name) AS inner_table WHERE revenue < 1000 ORDER BY revenue'''
df = pd.read_sql_query(query, connection)
print(df)

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */
query = '''SELECT m1.firstname || ' ' || m1.surname AS member, recommended.firstname || ' ' || recommended.surname AS 'recommended by' FROM Members AS m1 INNER JOIN Members recommended On recommended.recommendedby = m1.memid WHERE m1.surname <> "GUEST" AND m1.recommendedby IS NOT NULL ORDER BY m1.surname, m1.firstname'''

/* Q12: Find the facilities with their usage by member, but not guests */
query = '''SELECT DISTINCT f.name, m.firstname || ' ' || m.surname AS member FROM Facilities AS f 
INNER JOIN Bookings b ON b.memid = m.memid
INNER JOIN Members m ON f.facid = b.facid
WHERE b.memid <> 0 ORDER BY f.name'''
df = pd.read_sql_query(query, connection)
print(df)

/* Q13: Find the facilities usage by MONTH, but not guests */
SELECT f.name,CONCAT(m.firstname,' ',m.surname) AS Member,
COUNT(f.name) AS bookings,
	SUM(CASE WHEN MONTH(starttime) = 1 THEN 1 ELSE 0 end) AS Jan,
SUM(CASE WHEN MONTH(starttime) = 2 THEN 1 ELSE 0 end) AS Feb,
SUM(CASE WHEN MONTH(starttime) = 3 THEN 1 ELSE 0 end) AS Mar,
SUM(CASE WHEN MONTH(starttime) = 4 THEN 1 ELSE 0 end) AS Apr,
SUM(CASE WHEN MONTH(starttime) = 5 THEN 1 ELSE 0 end) AS May,
SUM(CASE WHEN MONTH(starttime) = 6 THEN 1 ELSE 0 end) AS Jun,
SUM(CASE WHEN MONTH(starttime) = 7 THEN 1 ELSE 0 end) AS Jul,
SUM(CASE WHEN MONTH(starttime) = 8 THEN 1 ELSE 0 end) AS Aug,
SUM(CASE WHEN MONTH(starttime) = 9 THEN 1 ELSE 0 end) AS Sep,
SUM(CASE WHEN MONTH(starttime) = 10 THEN 1 ELSE 0 end) AS Oct,
SUM(CASE WHEN MONTH(starttime) = 11 THEN 1 ELSE 0 end) AS Nov,
SUM(CASE WHEN MONTH(starttime) = 12 THEN 1 ELSE 0 end) AS Decm

FROM `Members` m
INNER JOIN `Bookings` AS b ON b.memid = m.memid
INNER JOIN `Facilities` AS f ON f.facid = b.facid
WHERE m.memid>0
AND year(starttime) = 2012

GROUP BY f.name,concat(m.firstname,' ',m.surname)
>>>>>>> 5118fb68388bc629a20d8077b2fae9c997ec8a76
ORDER BY f.name, Member;
