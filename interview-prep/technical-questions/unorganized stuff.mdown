### C3 Energy 
1. Write algo for find mean/median/mode for a continuous 1M stream of numbers. Do this in 20 mins and with minimal complexity. 

2. Re-derive linear regression optimization formulation in closed form for a spline function (flat then gradient) rather than y=Ax + B. Use matrix notation and assume tall-skinny problem. Talk about the complexity issues with closed form approach. Then extend to include regularization.
Write an algo to merge multiedge polygons together given the edges and shared edges.

### Baysensors
1. Develop a solution for fusing sensors that are sensing the same goal. Sensors are time unsynchronized and conflict at times. You have some truth data too.

3. Write a sorting algo.

### Facebook
1. How would you bring a metric to product X? Products at Facebook could be as large as News Feed or Ads, and as small as Pokes or Socrates (see below).

    Example 1: How would you assess the health of Facebook’s News Feed? (Define health ?)

    Example 2: Facebook’s Socrates is a box displayed under the Profile Picture of a user that prompts the user to answer questions about themselves, such as favorite movies, books, etc. Given the data about how users have answered questions in the past, design the best algorithm to present the next question that they will answer.

2. Compute the means, median, mode from a table using SQL
    Example: Using the data from this table, calculate the average length (in time) of a conversation on a particular post.

3. Use SQL to do an outer join & a self join.

4. Three ants are on different vertices of an equilateral triangle and can walk along the edges to any other vertex. What's the probability that any 2 of them will collide?

5.  Given a fleet of 50 trucks, each with a full fuel tank and   a range of 100 miles, how far can you deliver a payload? You can transfer the payload from truck to truck, and you can transfer fuel from truck to truck. Extend your answer for n trucks.

2. What experience do you have with Hadoop or other map-reduce frameworks?



1. Resume: Describe clearly what you did in past projects and what are future potential use cases

2. Questions about modeling, SQL and regression

3. Can you figure out SQL tricks and write SQL correctly?

4. Do you understand user engagement from user data?

5. How do you increase user engagement?

6. How do you establish a linear regression? What are outcome variables and independent variables? Can you translate the raw data into dummy variables? Think of ways to handle categorical variables.

7. What is cross validation?

8. Think of creative ways to combine features between source users and target users

9. Can you pick a model to start with among several options with good reasoning?

10. People recommendation question

11. Collaborative filtering method

12. Identify the potential problem of cold-start and hot-getting-hotter problem, and propose good solutions

13. Identify a correct way to establish features we can use in a ML model.

14. Figure out a way to deal with categorical features, or ways to increase the complexity of the model without new data points

15. Questions on Neural Networks and data sampling

16. Define user engagement in various ways (for example classification method)

17. Discuss about model selection, categorical variables encoding

18. Identifying under-fitting problems

19. SVM
 

### Walmart (Data Analyst)
1. Develop a recommendation engine for a product. Probability of men (Pm) liking a specific product is generally higher than probability of women liking it (Pf). What is the probability of a match between a man and a woman vs. a woman and a woman. What are the boundaries - that is, if Pm is greater than Pf, what are the likelihoods?

2. You have a clickthrough rate/impressions on two products, the first has a 1/100 CTR and the second has 100/10000 - how do you reconcile these rates and evaluate the performance of these two products?

3. If you were to run two coupon campaigns - one where users are sent popular coupons and the other are sent personalized (recommendation system) coupons, how do you design an experiment to measure the performance?


### Capital One (Data Scientist)

2. What are the odds of getting at least one roll of 6 on six rolls of a fair die?

3. What are the odds of getting at least TWO rolls of 6 on twelve rolls?

4. What are the odds of getting at least one hundred 6s on six hundred rolls?

5. Whats MapReduce and how does it work?

6. You have a 300GB dat file, and you want to run a computation on the third column. How do you do that? - This is to check whether you know how to use unix commands that work off disk rather than in memory.

7. I give you a dollar and a list of coin denominations. How many different ways can you get change? - generator functions

1. Case study - what features would you use to determine credit risk given transaction history from the past two years.

2. Explain a simple map reduce problem

3. Read in a very large file of tab delimitted numbers using python and count frequency of each number (don’t overthink this. Use python done in a few lines)

4. Whats more likely: Getting at least one six in 6 rolls, at least two sixes in 12 rolls or at least 100 sixes in 600 rolls?

5. Find all the combinations of change you can for a given amount



### Yelp


2. AB Testing on web site ad performance - ie, what are the locations on a web page that you can account and measure changes in user behavior

3. If you had a magic wand and you can choose to send 100000 users to any number of businesses to improve Yelp’s functionality, what would you do?


### DeNA

1. 1000 players played level 1 in a mobile game. only 200 moved to level 2, what are the kinds of questions you would ask to explain this difference?

2. Take this sample SQL database and run queries and make some charts. There’s a discrepancy on X date, what kind of factors would play into this?

3. Player matchmaking features

4. How do you incentivize users for higher engagement?

5. How would you use data science at our company?


### Accenture

1. What are the ACID properties of a database?

3. How do computer network architectures work?


7. Write a function to calculate the acceleration of a car moving north for 5 minutes.

8. Write a function that returns True if a number (n) is prime, if the number is prime, the function should also return all prime numbers smaller than n

9. What statistical method would you use to predict X?

10. How would you detect anomalies/fraudulent activity in a stream of a business data?

11. Where do you see yourself in 5 years?

12. Accenture’s Behavioral Interview - ie explain a situation with a coworker with which you had difficulty, greatest accomplishment, etc


### Hired.com

1. Stack Interview problem
    http://www.ardendertat.com/2011/11/08/programming-interview-questions-14-check-balanced-parentheses/


### NTT

1. How would you build a distributed, cloud-based machine learning system (like BigML)?

### Kabbage

2. How would you use map reduce to join two data sets on a common key? How would you do this is that key is not unique. 

3. List several ML techniques. Explain logistic regression and it's loss function. 


### Brightroll
The sim utilizes parking meter data available from the SFMTA(https://data.sfgov.org/Transportation/Parking-meters/7egw-qt89). The data dictionary can be found here. You can use absolutely any tools you want to answer the sim questions. Some questions may be easier to answer using a shell; others may be easier to answer using Excel.
Finally, we’re here as resources. You also have full access to the web.

1. How many total meters are included in this data set? 

1. How many smart meters? 

1. How many smart meters are on Geary Blvd? 

1. On how many distinct streets are there parking meters (of any kind)?

1. What are the top 5 streets (street names) with the most meters?

1. Produce a CSV of
    Street Name, Count of Meters

    Make sure the CSV has headers enumerating the fields. If this question takes more than 5 minutes, bug us for hints.

1. Based on the CSV produced in question 6, derive the following summary statistics:
    Mean, Median, Max, Range

1. If you worked for the SFMTA, what are some of the most interesting data here, and why? What data helps address interesting business questions? Are there data missing that would be required to answer pressing questions re: revenue, cost, etc.? Just dive in, have fun, and we’ll dig into your findings.


### LinkedIn
1. You have a table of every LinkedIn connection. Also, we define what a shared connection is below. Answer the below line of questions.

    ```
    Table Columns
    m_id = member id
    c_m_id = connection_member_id
    
    Table example
    m_id, c_m_id
    (user 1), (user 2)
    (user 3, (user 2)
    (user 1), (user 50)
    ...
    (user 50), (user 30)
    (user 51), (user 21)
    ```
    
    Shared Connection Definition
    The first two rows above are an example of 1 shared connection. So you could say "user 1 and user 3 have at least 1 shared connection", as shown here:
    
    ```
    User 1 -- User 2 -- User 3
    ```
    
    Questionsc
    1. Write a SQL query that finds the number of shared connections between user 1 and user 3
    2. Write a query that does the same thing in your favorite language
    3. Write a SQL query that finds the two users with the highest number of shared connections
    4. OK, now that won't work at scale because there are XX Billion connections. Write an approach that enables you to do this at scale in your favorite language. What algorithm might you consider using?

### Kwh
1. Find the difference in degrees between the hour and minute hand


### Questions Not Assigned to a Particular Company

1. **Most Frequent Words**

    Given a file that contains the text of a document and an integer n, return a list of the top n most frequent words.


1. **Pig Latin Translator**

    Write a pig latin translator. Given a phrase in english, return the pig latin.

    ```
    If the word starts with a consonant, move consonant to the end and add ay.
    cat->atcay
    If the word starts with a vowel, add hay.
    orange->orangehay
    If the word starts with more than one consonant, move all of them to the end and add ay.
    string->ingstray
    Start by assuming the phrase is all lowercase with no punctuation.
    ```


1. **Phone Numberpad**

    Given a dictionary that shows the mapping of digits to numbers on a phone numberpad (e.g. ‘2’: [‘a’, ‘b’, ‘c’], ‘3’: [‘d’, ‘e’, ‘f’], etc.) and a string of digits, return all the possible letter combinations that correspond to the string of digits.

    Start by assuming that there are two digits in the string.
    
    example: `‘32’ => da, db, dc, ea, eb, ec, fa, fb, fc`
    
    Extension: Have your function also take a corpus of words and only return strings which are in your corpus.


1. **Matrix Diagonals**

    Given a matrix, print out the diagonals. 

    ```
    example input:
    [[1, 2, 8],
     [-4, 5, 2],
     [0, -4, -6],
     [-3, 3, 9]]
    example output:
    8
    2 2
    1 5 -6
    -4 -4 9
    0 3
    -3
    ```


1. **Change machine**

    Write a function that computes what coins needed to give an amount of change. Given a value and a list containing the coin values, return the numbers of each coin required (use the minimum number of coins possible).

    ```
    example input: 85, [5, 10, 25]
    example output: [0, 1, 3]  => corresponds to 0 nickels, 1 dime, 3 quarters
    ```


1. **Rotate an Image**

    Given a square image encoded as a matrix, rotate the image clockwise with using only constant extra space.
    
    ```
    input:
    [[2, 3],
     [1, 4]]
    output:
    [[1, 2],
     [4, 3]]
    ```


1. **Foreign Alphabet**

    *Very challenging*

    There’s another language with our same letters but a different ordering of the letters. You are giving a list of words in alphabetical order and you must determine the order of the alphabet. You can assume that the input is not contradictory and if there are multiple possible alphabet orderings, you may return any of them.
    
    ```
    example input: 
    dbga
    dgg
    aa
    bbgd
    example output: d, a, b, g
    ```


1. **Even Odd Split**

    Given a list of integers, move all the odd numbers to the left and the even numbers to the right.

    Extension: Do it in-place, i.e., only use constant extra space.


1. **Dutch National Flag**

    Given a list of integers, sort them based on modulo 3. So first it's all the values that are 0 mod 3, then 1 mod 3, then 2 mod 3. You don't have to preserve order within each class.

    ```
    [4, 6, 1, 3, 9, 2, 8, 10, 12] -> [6, 3, 9, 12, 4, 1, 10, 2, 8]
    ```

    Extension: Do it in-place.

1. You are given the two tables. The first two rows of each toble are shown.

    registrations
    
    | userid | date       |
    | ------ | ---------- |
    |      2 | 2014-03-07 |
    |      5 | 2013-12-21 |

    logins
    
    | userid | date       |
    | ------ | ---------- |
    |      2 | 2014-03-10 |
    |      2 | 2014-03-11 |

    Each user has one entry in the registrations table and any number of entries in the logins table.

    Write a query that gives the number of times each user logged in in their first week (i.e. within 7 days after registration)

    First write a query which doesn't include the users which have never logged in. Once you have that, add them with value 0.


2. Facebook prompts users with questions to answer to fill in their profile. You have the following table showing which questions the users have answered.

    | userid | questionid |
    | ------ | ---------- |
    |     10 |          4 |

    Each user will have an entry in the table for each question they've answered.

    Write a query which gives, for each individual user, a question to suggest for them to answer.


3. You are running an A/B test to test out a new feature. You have the following tables:

    test_groups
    
    | userid | group   |
    | ------ | ------- |
    |      3 | CONTROL |
    |     10 |       A |

    opt_out
    
    | userid |
    | ------ |
    |     14 |

    following
    
    | follower | followee |
    | -------- | -------- |
    |       10 |       14 |
    
    (This means user 10 is following user 14)

    The opt_out table contains the users which have opted out of receiving email. The friend table contains

    We would like to send an email to all the users who are in the test group A, who have not opted out are following fewer than 30 users.


4. Write a query that gets all the users which have not received at least one message every day over the past 30 days.

    messages
    
    | sender | recipient | date       |
    | ------ | --------- | ---------- |
    |     12 |         3 | 2013-08-19 |

5. Given the below table _Content_, find the distribution for the number of comments on an _originating post_ on '2015-09-07'.
   An _originating post_ is the first post when person posts to her newsfeed.  Basically--the number of posts on '2015-09-07' that recieved 0 comments, 1 comment, 2 comments, .... max comments.

    | Column | Type | Example |
    | --- | --- | --- |
    | ContentID | INT | 1 |
    | UserID | INT | 2 |
    | Date | Date | '2015-09-15' |
    | Type | VARCHAR(50) | One of ['like', 'url', 'comment', 'photo', 'share', etc] |
    | ReferenceID | INT | The ContentID for the original post; NULL if this is an original post  |
