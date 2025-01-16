/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SELECT name
FROM Facilities
WHERE membercost > 0;

A: Facilities that charge a fee to members include: Tennis Court 1, Tennis Court 2, Massage Room 1, Massage Room 2, and Squash Court. 

/* Q2: How many facilities do not charge a fee to members? */
SELECT name
FROM Facilities
WHERE membercost = 0;

A: Badminton Court, Table Tennis, Snooker Table, Pool Table

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost > 0
AND membercost < (0.2 * monthlymaintenance);

A:
facid	name	membercost	monthlymaintenance	
0	Tennis Court 1	5.0	200	
1	Tennis Court 2	5.0	200	
4	Massage Room 1	9.9	3000	
5	Massage Room 2	9.9	3000	
6	Squash Court	3.5	80	


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT name
FROM Facilities
WHERE facid IN (1, 5);
 A: Tennis Court and Massage Room

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT name, 
       monthlymaintenance,
       CASE 
           WHEN monthlymaintenance > 100 THEN 'expensive'
           ELSE 'cheap'
       END AS expense_label
FROM Facilities;

A:
name	monthlymaintenance	expense_label	
Tennis Court 1	200	expensive	
Tennis Court 2	200	expensive	
Badminton Court	50	cheap	
Table Tennis	10	cheap	
Massage Room 1	3000	expensive	
Massage Room 2	3000	expensive	
Squash Court	80	cheap	
Snooker Table	15	cheap	
Pool Table	15	cheap	

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT firstname, 
       surname
FROM Members
ORDER BY joindate DESC;

A: Darren Smith

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


SELECT DISTINCT CONCAT(Members.firstname, ' ', Members.surname, ' - ', Facilities.name) AS member_court
FROM Members
JOIN Bookings ON Members.memid = Bookings.memid
JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE Facilities.name LIKE 'Tennis Court%'
ORDER BY Members.firstname, Members.surname;

A: 
member_court	
Anne Baker - Tennis Court 2	
Anne Baker - Tennis Court 1	
Burton Tracy - Tennis Court 2	
Burton Tracy - Tennis Court 1	
Charles Owen - Tennis Court 1	
Charles Owen - Tennis Court 2	
Darren Smith - Tennis Court 2	
David Farrell - Tennis Court 2	
David Farrell - Tennis Court 1	
David Jones - Tennis Court 1	
David Jones - Tennis Court 2	
David Pinker - Tennis Court 1	
Douglas Jones - Tennis Court 1	
Erica Crumpet - Tennis Court 1	
Florence Bader - Tennis Court 2	
Florence Bader - Tennis Court 1	
Gerald Butters - Tennis Court 2	
Gerald Butters - Tennis Court 1	
GUEST GUEST - Tennis Court 2	
GUEST GUEST - Tennis Court 1	
Henrietta Rumney - Tennis Court 2	
Jack Smith - Tennis Court 2	
Jack Smith - Tennis Court 1	
Janice Joplette - Tennis Court 1	
Janice Joplette - Tennis Court 2	
Jemima Farrell - Tennis Court 2	
Jemima Farrell - Tennis Court 1	
Joan Coplin - Tennis Court 1	
John Hunt - Tennis Court 2	
John Hunt - Tennis Court 1	
Matthew Genting - Tennis Court 1	
Millicent Purview - Tennis Court 2	
Nancy Dare - Tennis Court 2	
Nancy Dare - Tennis Court 1	
Ponder Stibbons - Tennis Court 2	
Ponder Stibbons - Tennis Court 1	
Ramnaresh Sarwin - Tennis Court 2	
Ramnaresh Sarwin - Tennis Court 1	
Tim Boothe - Tennis Court 1	
Tim Boothe - Tennis Court 2	
Tim Rownam - Tennis Court 2	
Tim Rownam - Tennis Court 1	
Timothy Baker - Tennis Court 2	
Timothy Baker - Tennis Court 1	
Tracy Smith - Tennis Court 1	
Tracy Smith - Tennis Court 2	


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT 
    Facilities.name AS facility_name,
    CONCAT(Members.firstname, ' ', Members.surname) AS member_name,
    CASE 
        WHEN Bookings.memid = 0 THEN Bookings.slots * Facilities.guestcost
        ELSE Bookings.slots * Facilities.membercost
    END AS cost
FROM 
    Bookings
JOIN 
    Facilities ON Bookings.facid = Facilities.facid
JOIN 
    Members ON Bookings.memid = Members.memid
WHERE 
    DATE(Bookings.starttime) = '2012-09-14'
    AND (
        (Bookings.memid = 0 AND Bookings.slots * Facilities.guestcost > 30)
        OR (Bookings.memid != 0 AND Bookings.slots * Facilities.membercost > 30)
    )
ORDER BY 
    cost DESC;



/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT Facilities.name AS facility_name,
       CONCAT(Members.firstname, ' ', Members.surname) AS member_name,
       CASE
           WHEN Bookings.memid = 0 THEN Bookings.slots * Facilities.guestcost
           ELSE Bookings.slots * Facilities.membercost
       END AS cost
FROM Bookings
JOIN Facilities ON Bookings.facid = Facilities.facid
LEFT JOIN Members ON Bookings.memid = Members.memid
WHERE DATE(Bookings.starttime) = '2012-09-14'
AND (CASE 
	WHEN Bookings.memid = 0 THEN Bookings.slots * Facilities.guestcost
     ELSE Bookings.slots * Facilities.membercost 
     END) > 30
ORDER BY cost DESC;

A: 
facility_name	member_name	cost   	
Massage Room 2	GUEST GUEST	320.0	
Massage Room 1	GUEST GUEST	160.0	
Massage Room 1	GUEST GUEST	160.0	
Massage Room 1	GUEST GUEST	160.0	
Tennis Court 2	GUEST GUEST	150.0	
Tennis Court 1	GUEST GUEST	75.0	
Tennis Court 2	GUEST GUEST	75.0	
Tennis Court 1	GUEST GUEST	75.0	
Squash Court	GUEST GUEST	70.0	
Massage Room 1	Jemima Farrell	39.6	
Squash Court	GUEST GUEST	35.0	
Squash Court	GUEST GUEST	35.0	

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT 
    Facilities.name AS facility_name, 
    SUM(
        CASE 
            WHEN Bookings.memid = 0 THEN Facilities.guestcost * Bookings.slots
            ELSE Facilities.membercost * Bookings.slots
        END
    ) AS total_revenue
FROM 
    Facilities
JOIN 
    Bookings ON Facilities.facid = Bookings.facid
GROUP BY 
    Facilities.name
HAVING 
    SUM(
        CASE 
            WHEN Bookings.memid = 0 THEN Facilities.guestcost * Bookings.slots
            ELSE Facilities.membercost * Bookings.slots
        END
    ) < 1000
ORDER BY 
    total_revenue;


facility_name	total_revenue   	
Table Tennis	180.0	
Snooker Table	240.0	
Pool Table	270.0	


/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT 
    m1.surname AS member_surname,
    m1.firstname AS member_firstname,
    m2.surname AS recommender_surname,
    m2.firstname AS recommender_firstname
FROM 
    Members m1
LEFT JOIN 
    Members m2 ON m1.recommendedby = m2.memid
ORDER BY 
    m1.surname, m1.firstname;


member_surname	member_firstname	recommender_surname	recommender_firstname	
Bader	Florence	Stibbons	Ponder	
Baker	Anne	Stibbons	Ponder	
Baker	Timothy	Farrell	Jemima	
Boothe	Tim	Rownam	Tim	
Butters	Gerald	Smith	Darren	
Coplin	Joan	Baker	Timothy	
Crumpet	Erica	Smith	Tracy	
Dare	Nancy	Joplette	Janice	
Farrell	David	GUEST	GUEST	
Farrell	Jemima	GUEST	GUEST	
Genting	Matthew	Butters	Gerald	
GUEST	GUEST	GUEST	GUEST	
Hunt	John	Purview	Millicent	
Jones	David	Joplette	Janice	
Jones	Douglas	Jones	David	
Joplette	Janice	Smith	Darren	
Mackenzie	Anna	Smith	Darren	
Owen	Charles	Smith	Darren	
Pinker	David	Farrell	Jemima	
Purview	Millicent	Smith	Tracy	
Rownam	Tim	GUEST	GUEST	
Rumney	Henrietta	Genting	Matthew	
Sarwin	Ramnaresh	Bader	Florence	
Smith	Darren	GUEST	GUEST	
Smith	Darren	GUEST	GUEST	
Smith	Jack	Smith	Darren	
Smith	Tracy	GUEST	GUEST	
Stibbons	Ponder	Tracy	Burton	
Tracy	Burton	GUEST	GUEST	
Tupperware	Hyacinth	GUEST	GUEST	
Worthington-Smyth	Henry	Smith	Tracy	


/* Q12: Find the facilities with their usage by member, but not guests */


SELECT 
    Facilities.name AS facility_name,
    COUNT(Bookings.bookid) AS member_usage
FROM 
    Facilities
JOIN 
    Bookings ON Facilities.facid = Bookings.facid
WHERE 
    Bookings.memid != 0
GROUP BY 
    Facilities.name
ORDER BY 
    member_usage DESC;


facility_name	member_usage   	
Pool Table	783	
Massage Room 1	421	
Snooker Table	421	
Table Tennis	385	
Badminton Court	344	
Tennis Court 1	308	
Tennis Court 2	276	
Squash Court	195	
Massage Room 2	27	


/* Q13: Find the facilities usage by month, but not guests */

SELECT 
    Facilities.name AS facility_name,
    DATE_FORMAT(Bookings.starttime, '%Y-%m') AS month,
    COUNT(Bookings.bookid) AS member_usage
FROM 
    Facilities
JOIN 
    Bookings ON Facilities.facid = Bookings.facid
WHERE 
    Bookings.memid != 0
GROUP BY 
    Facilities.name, month
ORDER BY 
    month, facility_name
LIMIT 0, 100;


facility_name   month   member_usage	
Badminton Court	2012-07	51	
Massage Room 1	2012-07	77	
Massage Room 2	2012-07	4	
Pool Table	2012-07	103	
Snooker Table	2012-07	68	
Squash Court	2012-07	23	
Table Tennis	2012-07	48	
Tennis Court 1	2012-07	65	
Tennis Court 2	2012-07	41	
Badminton Court	2012-08	132	
Massage Room 1	2012-08	153	
Massage Room 2	2012-08	9	
Pool Table	2012-08	272	
Snooker Table	2012-08	154	
Squash Court	2012-08	85	
Table Tennis	2012-08	143	
Tennis Court 1	2012-08	111	
Tennis Court 2	2012-08	109	
Badminton Court	2012-09	161	
Massage Room 1	2012-09	191	
Massage Room 2	2012-09	14	
Pool Table	2012-09	408	
Snooker Table	2012-09	199	
Squash Court	2012-09	87	
Table Tennis	2012-09	194	
Tennis Court 1	2012-09	132	
Tennis Court 2	2012-09	126	

