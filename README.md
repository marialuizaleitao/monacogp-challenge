# F1 Challenge
This project was based on a Medium [challenge](https://medium.com/@BetterEverythingsql-exercise-for-data-analysts-formula-1-data-f64a5b690a19).

## Monaco 2023 GP

Monaco is a unique and challenging F1 circuit that tests the drivers and teams to the limit. 
The narrow streets and tight corners make it difficult to overtake, which leads to close racing and exciting finishes. 
The race is also surrounded by glamour and excitement, making it one of the most popular events on the F1 calendar, and also one of my favorite weekends of the F1 season!

Being a huge F1 fan and a Data Analyst, I had to accept this Challenge!

## Getting Started

Firstly, we have to create and enter the database to get us started.

From the 2023 Monaco GP standings, we'll create a table to store the top 8 pilots.
Your table should be called `monaco_gp_2023` and have these attributes:

1. `car_number`: An integer that uses the pilot's number as an id.
2. `seconds`: A decimal that tells how many seconds it took for each car to complete the race.

The code for building the database and the table can be found [here](schema.sql).
After successfully creating your environment, you can copy the code from [data.sql](data.sql) to insert all the information from the top 8 pilots of this race, retrieved from [wikipedia](https://en.wikipedia.org/wiki/2023_Monaco_Grand_Prix).

## The Challenge

The challenge provided by Medium is to write a SQL query that outputs the race result with every car’s difference to the race winner and the car that finished in front of it.
Returning something like this:

| Car Number | Difference to the Winner | Difference to Previous Pilot | 
|------------|--------------------------|------------------------------| 
| 1          |          0.000           |            0.000             | 
| 14         |          27.921          |            27.921            | 
| 31         |          36.990          |            9.069             | 
| 44         |          39.062          |            2.072             | 
| 63         |          56.284          |            17.222            | 
| 16         |          61.890          |            5.606             | 
| 10         |          62.362          |            0.472             | 
| 55         |          63.391          |            1.029             | 

Let's solve this!

### Difference to the Winner

The difference between each car and the winner is the difference between the car’s time to complete the race and the minimum time which is the winner's race time, because the winner is the one who takes the least seconds to complete the race.

So to have that difference, we would have to take seconds (from the car in question) and subtract the minimum of seconds. To do this, we can use the aggragate function MIN. 

The query for that can be something like this:

SELECT car_number AS 'Car Number', seconds - (SELECT MIN(seconds) FROM monaco_gp_2023) AS 'Difference to the Winner'
FROM monaco_gp_2023;

Returning this:

| Car Number | Difference to the Winner | 
|------------|--------------------------| 
| 1          |          0.000           |  
| 14         |          27.921          |     
| 31         |          36.990          |      
| 44         |          39.062          |       
| 63         |          56.284          |    
| 16         |          61.890          |
| 10         |          62.362          |
| 55         |          63.391          |    

### Difference to the Previous Pilot

To get the difference between each car and the car that finished in front of it, they suggest we use the LAG function. The LAG function in SQL returns the value of a column from a previous row in the same table. It is used to compare values between rows. The LAG function can be used in combination with OVER clause, specifying that we want to order the results in seconds. By default the LAG function uses an offset of 1, which means it takes the value from the previous row.

We take the car’s number of seconds and have subtract the number of seconds of the car that finished in front of it. Using the LAG function, passing seconds as a parameter to specify we want to take a value from the seconds column.

SELECT car_number AS 'Car Number', seconds AS 'Time',
LAG(seconds) OVER(ORDER BY seconds) AS 'Difference to Previous Pilot'
FROM monaco_gp_2023;

To return this:

| Car Number |      Time     | Difference to Previous Pilot | 
|------------|---------------|------------------------------| 
| 1          |    6531.98    |            0.000             | 
| 14         |    6559.901   |            27.921            | 
| 31         |    6568.97    |            9.069             | 
| 44         |    6571.042   |            2.072             | 
| 63         |    6588.264   |            17.222            | 
| 16         |    6593.87    |            5.606             | 
| 10         |    6594.342   |            0.472             | 
| 55         |    6595.371   |            1.029             | 

If we set the offset of the LAG function to 1, we can also specify a default value to be used if there is no previous row in the partition. This is useful for the race winner, car 1, because there is no car in front of it.

I will use the default value of seconds so that when we subtract the result of the LAG function from seconds, the result will be 0 for car 1. This will allow us to compare the lap times of all of the cars relative to the race winner.

### Final Query

Putting these queries together, our final query will look like this:

SELECT car_number AS 'Car Number', 
seconds - (SELECT MIN(seconds) FROM monaco_gp_2023) AS 'Difference to the Winner',
seconds - LAG(seconds,1,seconds) OVER(ORDER BY seconds) AS 'Difference to Previous Pilot' 
FROM monaco_gp_2023;

| Car Number | Difference to the Winner | Difference to Previous Pilot | 
|------------|--------------------------|------------------------------| 
| 1          |          0.000           |            0.000             | 
| 14         |          27.921          |            27.921            | 
| 31         |          36.990          |            9.069             | 
| 44         |          39.062          |            2.072             | 
| 63         |          56.284          |            17.222            | 
| 16         |          61.890          |            5.606             | 
| 10         |          62.362          |            0.472             | 
| 55         |          63.391          |            1.029             |

You can see my final script clicking [here](script.sql).

It was very nice putting together my two interests in this project! Hope you had fun like me!
