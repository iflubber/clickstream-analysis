**Project1: **

**Big Data Analytics using Clickstream Data**

**Clickstream Data**

Clickstream data is an information trail a user leaves behind while
visiting a website. It is typically captured in semi-structured website
log files.

These website log files contain data elements such as a date and time
stamp, the visitor’s IP address, the destination URLs of the pages
visited, and a user ID that uniquely identifies the website visitor.

**Potential Uses of Clickstream Data**

One of the original uses of Hadoop at Yahoo was to store and process
their massive volume of clickstream data. Now enterprises of all types
can use Hadoop and the clouderato refine and analyzeclickstream data.

They can then answer business questions such as:

What is the most efficient path for a site visitor to research a
product, and then buy it? (Path Optimization)

What products do visitors tend to buy together, and what are they most
likely to buy in the future? (Association Analysis & Next product to
buy)

Where should I spend resources on fixing or enhancing the user
experience on my website? (Allocation of website resources)

we will focus on the “path optimization” use case. Specifically: how can
we improve our website to reduce bounce rates and improve conversion?

**Input Data**

Here’s a summary of the data we’re working with:

**Omniture logs**–website log files containing information such as URL,
timestamp, IP address, geocoded IP address, and user ID (SWID)

> The Omniture log dataset contains about 4 million rows of data, which
> represents five days of clickstream data. Often, organizations will
> process weeks, months, or even years of data.

**Users**–CRM user data(registered Users) listing SWIDs (Software User
IDs) along with date of birth and gender.

**Products**–CMS data that maps product categories to website URLs.

**Expected Output:**

In order to optimize your website and convert more visits into sales and
revenue.

Analyze the clickstream data by location

Filter the data by product category

Graph the website user data by age and gender

Pick a target customer segment

Identify a few web pages with the highest bounce rates

***Solution:***

***Download the data***

***Load the downloaded data onto HDFS**:*

-   Omniture.0.tsv

-   regusers.tsv

-   urlmap.tsv

\[cloudera@quickstart Project1\]\$ hadoop fs -mkdir
/user/cloudera/clickstream-data

\[cloudera@quickstart Project1\]\$ hdfs dfs -put
/home/cloudera/localdata/Project1/Omniture.0.tsv
/user/cloudera/clickstream-data/

\[cloudera@quickstart Project1\]\$ hdfs dfs -put
/home/cloudera/localdata/Project1/regusers.tsv
/user/cloudera/clickstream-data/

\[cloudera@quickstart Project1\]\$ hdfs dfs -put
/home/cloudera/localdata/Project1/urlmap.tsv
/user/cloudera/clickstream-data/

\[cloudera@quickstart Project1\]\$ hadoop fs -ls
/user/cloudera/clickstream-data

Found 3 items

-rw-r--r-- 1 cloudera cloudera 66685542 2018-06-05 05:40
/user/cloudera/clickstream-data/Omniture.0.tsv

-rw-r--r-- 1 cloudera cloudera 1870304 2018-06-05 05:40
/user/cloudera/clickstream-data/regusers.tsv

-rw-r--r-- 1 cloudera cloudera 1522 2018-06-05 05:41
/user/cloudera/clickstream-data/urlmap.tsv

![](./screenshots/media/image1.tiff){width="6.263888888888889in"
height="2.9217399387576553in"}

Let’s take a look at the data:

Omniture.0.tsv

![](./screenshots/media/image2.tiff){width="6.262328302712161in"
height="4.626087051618548in"}

regusers.tsv

![](./screenshots/media/image3.tiff){width="6.263141951006125in"
height="3.7826082677165354in"}

urlmap.tsv

![](./screenshots/media/image4.tiff){width="6.261484033245845in"
height="4.365217629046369in"}

***Create Hive Tables for the 3 data-sets:***

CREATE TABLE omnitureweblogs (

col\_1 STRING,

col\_2 STRING, -- timestamp

col\_3 STRING,

col\_4 STRING,

col\_5 STRING,

col\_6 STRING,

col\_7 STRING,

col\_8 STRING, -- ip address

col\_9 STRING,

col\_10 STRING,

col\_11 STRING,

col\_12 STRING,

col\_13 STRING, -- url

col\_14 STRING, -- swid

col\_15 STRING,

col\_16 STRING,

col\_17 STRING,

col\_18 STRING,

col\_19 STRING,

col\_20 STRING,

col\_21 STRING,

col\_22 STRING,

col\_23 STRING,

col\_24 STRING,

col\_25 STRING,

col\_26 STRING,

col\_27 STRING,

col\_28 STRING,

col\_29 STRING,

col\_30 STRING,

col\_31 STRING,

col\_32 STRING,

col\_33 STRING,

col\_34 STRING,

col\_35 STRING,

col\_36 STRING,

col\_37 STRING,

col\_38 STRING,

col\_39 STRING,

col\_40 STRING,

col\_41 STRING,

col\_42 STRING,

col\_43 STRING,

col\_44 STRING,

col\_45 STRING,

col\_46 STRING,

col\_47 STRING,

col\_48 STRING,

col\_49 STRING,

col\_50 STRING, -- city

col\_51 STRING, -- country

col\_52 STRING,

col\_53 STRING) -- state

ROW FORMAT DELIMITED

FIELDS TERMINATED by '\\t'

STORED AS TEXTFILE

TBLPROPERTIES ("skip.header.line.count"="1");

CREATE TABLE regusers (swid STRING, birth\_dt STRING, gender\_cd
CHAR(1))

ROW FORMAT DELIMITED

FIELDS TERMINATED BY '\\t'

STORED AS TEXTFILE

TBLPROPERTIES ("skip.header.line.count"="1");

CREATE TABLE urlmap (url STRING, category STRING)

ROW FORMAT DELIMITED

FIELDS TERMINATED BY '\\t'

STORED AS TEXTFILE

TBLPROPERTIES ("skip.header.line.count"="1");

***Load the data into the tables:***

LOAD DATA INPATH '/user/cloudera/clickstream-data/urlmap.tsv' OVERWRITE
INTO TABLE urlmap;

LOAD DATA INPATH '/user/cloudera/clickstream-data/regusers.tsv'
OVERWRITE INTO TABLE regusers;

LOAD DATA INPATH '/user/cloudera/clickstream-data/Omniture.0.tsv'
OVERWRITE INTO TABLE omnitureweblogs;

***Verify the data loaded:***

select \* from omnitureweblogs limit 5

![](./screenshots/media/image5.tiff){width="6.263888888888889in"
height="1.179861111111111in"}

select \* from regusers limit 5

![](./screenshots/media/image6.tiff){width="6.263888888888889in"
height="1.2777777777777777in"}

select \* from urlmap limit 5

![](./screenshots/media/image7.tiff){width="6.263888888888889in"
height="1.3777777777777778in"}

***Prepare the data for analysis:***

-- create a view to include only the required columns from
omnitureweblogs table

CREATE VIEW omniture AS

SELECT col\_2 ts, col\_8 ip, col\_13 url, col\_14 swid, col\_50 city,
col\_51 country, col\_53 state

FROM omnitureweblogs;

-- join the view data with the users and products data to create a new
table for analytics

CREATE TABLE clickstreamdata as

SELECT to\_date(o.ts) logdate, o.url, o.ip, o.city, upper(o.state)
state,

o.country, p.category,

CAST(datediff(from\_unixtime(unix\_timestamp()),
from\_unixtime(unix\_timestamp(u.birth\_dt, 'dd-MMM-yy'))) / 365 AS INT)
age,

u.gender\_cd

FROM omniture o

INNER JOIN urlmap p

ON o.url = p.url

LEFT OUTER JOIN regusers u

ON o.swid = concat('{', u.swid , '}');

***Analysis using Hive:***

-- count of ip address by country

SELECT country, count(ip) as hits FROM clickstreamdata GROUP BY country
ORDER BY hits DESC;

![](./screenshots/media/image8.tiff){width="6.263888888888889in"
height="7.98125in"}

As we can see, the maximum traffic is coming from USA. So, let’s dig
deeper into US and check the number of hits by state in usa.

SELECT state, count(ip) as hits FROM clickstreamdata WHERE country =
'usa'

GROUP BY state ORDER BY hits DESC;

![](./screenshots/media/image9.tiff){width="6.263888888888889in"
height="8.54861111111111in"}

We can dig further deep into the cities:

SELECT city, count(ip) as hits FROM clickstreamdata WHERE country =
'usa' and state = 'CA'

GROUP BY city ORDER BY hits DESC;

![](./screenshots/media/image10.tiff){width="6.263888888888889in"
height="6.43125in"}

This shows that the largest number of page hits is coming from Los
Angeles. Now, let’s find out what is being bought the most in Los
Angeles.

SELECT category, count(ip) as hits FROM clickstreamdata

WHERE country = 'usa' and state = 'CA' and city = 'los angeles'

GROUP BY category ORDER BY hits DESC;

![](./screenshots/media/image11.tiff){width="6.263888888888889in"
height="4.216666666666667in"}

We can see that the largest number of page hits in Los Angeles were for
clothing, followed by shoes.

Now let’s look at the clothing data in Los Angeles by age and gender.

SELECT gender\_cd, age, count(ip) as hits FROM clickstreamdata

WHERE country = 'usa' and state = 'CA' and city = 'los angeles' and
category = 'clothing'

GROUP BY gender\_cd, age ORDER BY hits DESC;

![](./screenshots/media/image12.tiff){width="6.263888888888889in"
height="5.669564741907261in"}

We can derive a few insights from the above data:

-   there is significant amount of page hits where the gender hasn’t
    been specified

-   majority of men shopping for clothing in Los Angeles are above 30
    and below 40

-   majority of women shopping for clothing in Los Angeles are above 25
    and below 40

Now let’s take a look at the bounce rate:

SELECT url, count(url) as hits FROM clickstreamdata GROUP BY url ORDER
BY hits

![](./screenshots/media/image13.tiff){width="6.2621052055993in"
height="1.6347823709536309in"}

The above pages are not getting many hits, so we might consider
optimizing them.

**Export hive table data to csv:**

insert overwrite directory
'/user/cloudera/output/clickstreamdata\_analysis.csv'

row format delimited

fields terminated by ','

select \* from clickstreamdata;

Now this final file can be used to do analysis using several tools.

***Analysis using Tableau (using Tableau Public):***

Use the exported final file and connect to it in Tableau Public. Now, we
can do various analysis:

-- count of IP hits country-wise

![](./screenshots/media/image14.tiff){width="6.263888888888889in"
height="3.821527777777778in"}

-- count of IP hits in USA state-wise

![](./screenshots/media/image15.tiff){width="6.263888888888889in"
height="3.8159722222222223in"}

-- count of IP hits in the state of California in USA, city-wise

![](./screenshots/media/image16.tiff){width="6.263888888888889in"
height="3.807638888888889in"}

-- category information in every state

![](./screenshots/media/image17.tiff){width="6.263888888888889in"
height="4.7in"}

-- category information by age

![](./screenshots/media/image18.tiff){width="6.263888888888889in"
height="4.550694444444445in"}

-- category analysis by Age and Gender

![](./screenshots/media/image19.tiff){width="6.263888888888889in"
height="3.490972222222222in"}

![](./screenshots/media/image20.tiff){width="6.263888888888889in"
height="3.475in"}

-- bounce rate analysis

![](./screenshots/media/image21.tiff){width="6.263888888888889in"
height="3.702777777777778in"}

***Analysis in RStudio:***

Refer to *clickstream-analytics.R* script:

-- pivot using R

![](./screenshots/media/image22.tiff){width="6.263888888888889in"
height="4.501388888888889in"}

-- clickstream data by country

![](./screenshots/media/image23.tiff){width="6.263888888888889in"
height="3.6875in"}

-- clickstream data by category

![](./screenshots/media/image24.tiff){width="6.263888888888889in"
height="3.4055555555555554in"}

-- clickstream data by city in USA

![](./screenshots/media/image25.tiff){width="6.263888888888889in"
height="3.415277777777778in"}

-- clickstream data by gender = male

![](./screenshots/media/image26.tiff){width="6.263888888888889in"
height="3.370138888888889in"}

-- clickstream data by gender = female

![](./screenshots/media/image27.tiff){width="6.263888888888889in"
height="3.4493055555555556in"}

-- clickstream data for male by age

![](./screenshots/media/image28.tiff){width="6.263888888888889in"
height="3.3756944444444446in"}

-- clickstream data for female by age

![](./screenshots/media/image29.tiff){width="6.263888888888889in"
height="3.3868055555555556in"}
