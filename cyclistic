# Organizing data by month and double checking to ensure data values are within expected range. 
# Start month ranges from 4 (April) to 9 (September) as expected. Trips begin and end entirely within stated months. 
# All coordinates for each month are contained within the Chicago area.

SELECT 
    EXTRACT(MONTH FROM started_at) AS start_month,
    MIN(started_at) AS first_trip,
    MAX(started_at) AS last_trip,
    ROUND(MIN(start_lat),2) AS min_start_lat,
    ROUND(MAX(start_lat),2) AS max_start_lat,
    ROUND(MIN(end_lat),2) AS min_end_lat,
    ROUND(MAX(end_lat),2) AS max_end_lat,
    ROUND(MIN(start_lng),2) AS min_start_lng,
    ROUND(MAX(start_lng),2) AS max_start_lng,
    ROUND(MIN(end_lng),2) AS min_end_lng,
    ROUND(MAX(end_lng),2) AS max_end_lng
 FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
 GROUP BY start_month
 ORDER BY start_month




# COUNT(ride_id) and COUNT(DISTINCT ride_id) return the same value. There are no duplicates in the table, so every ride_id is unique.

SELECT 
    COUNT(ride_id),
    COUNT(DISTINCT ride_id)
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`




# Length of rides by minute. Original source mentioned that trips under 60 seconds were removed, but trips of 1 minute or less are still in the dataset. 
# A small number of the results are negative, which will not be included in the final analysis. 

SELECT 
    DISTINCT TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS duration_in_minutes,
    ROUND(COUNT(CASE WHEN member_casual = "casual" THEN 1 END) / COUNT(member_casual) * 100,2) AS percent_casual,
    COUNT(member_casual) AS total_number, 
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
GROUP BY duration_in_minutes
ORDER BY duration_in_minutes




# Length of rides by hour. The vast majority of rides are 6 hours or less. 
# Rides 25 hours or more are 100% casual riders, but a small group in comparison to the overall dataset. 
# They most likely do not represent typical casual riders. 
# There's a sudden large jump in trips that are 24 hours  (1995 total) vs. 23 hours (115 total) or 25 hours (34 total). 

SELECT 
    DISTINCT TIMESTAMP_DIFF(ended_at, started_at, HOUR) AS duration_in_hours,
    ROUND(COUNT(CASE WHEN member_casual = "casual" THEN 1 END) / COUNT(member_casual) * 100,2) AS percent_casual,
    COUNT(CASE WHEN member_casual = "casual" THEN 1 END) AS number_casual,
    COUNT(member_casual) AS total_number, 
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
GROUP BY duration_in_hours
ORDER BY duration_in_hours




# This is a closer look at the jump from 23 to 24 hours. The jump isn't for the hour, it's for exactly 1499 minutes. 
# Only 1 ride was 1500 minutes, and only 1 ride was 1498 minutes, but 1887 people ended their trips exactly 1499 minutes after starting them. 

SELECT 
    TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS minutes_difference,
    COUNT(started_at) AS number_of_rides,
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
WHERE TIMESTAMP_DIFF(ended_at, started_at, HOUR) IN (23, 24, 25) 
GROUP BY minutes_difference HAVING minutes_difference < 1502
ORDER BY minutes_difference DESC




# Rides under one minute (including the questionable cases which were negative in length) represent about 1.5% of total rides. 
# Rides more than six hours (including the questionable cases 1499 minutes in length) represent around 0.2% of total rides. 
# As these groups are outside of our ordinary customer base and contain some questionable values, they will not be included in the final analysis.

SELECT 
    COUNT(started_at) AS total_rides,
    COUNT(CASE WHEN TIMESTAMP_DIFF(ended_at, started_at, MINUTE) < 1 THEN 1 END) AS rides_below_one_minute,
    COUNT(CASE WHEN TIMESTAMP_DIFF(ended_at, started_at, HOUR) >= 6 THEN 1 END) AS rides_more_than_six_hours,
    ROUND(COUNT(CASE WHEN TIMESTAMP_DIFF(ended_at, started_at, MINUTE) < 1 THEN 1 END) / COUNT(started_at) * 100,4) AS percent_below_one_minute,
    ROUND(COUNT(CASE WHEN TIMESTAMP_DIFF(ended_at, started_at, HOUR) >= 6 THEN 1 END) / COUNT(started_at) * 100,4) AS percent_more_than_six_hours
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`




# Determining the exact location of each starting station. Ideally we would expect the minimum/average/maximum for each station to all be the same. 
# In reality they differ slightly. The longitude and latitude data are mostly consistent, varying by less than 0.01 degrees total for almost all stations. 
# Using average values is a reasonable approximation for each station's actual location.

SELECT 
    start_station_name,
    COUNT(start_station_name) AS number_of_trips, 
    ROUND(MAX(start_lat) - MIN(start_lat) + MAX(start_lng) - MIN(start_lng),4) AS total_variance,
    ROUND(MIN(start_lat),4) AS min_start_lat,
    ROUND(MIN(start_lng),4) AS min_start_lng,
    ROUND(AVG(start_lat),4) AS avg_start_lat,
    ROUND(AVG(start_lng),4) AS avg_start_lng,
    ROUND(MAX(start_lat),4) AS max_start_lat,
    ROUND(MAX(start_lng),4) AS max_start_lng
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
WHERE start_station_name IS NOT null
GROUP BY start_station_name
ORDER BY total_variance DESC




# Verifying the integrity of the coordinates by looking at the average coordinates for start_stations, and comparing with the end_station coordinates for the same stations. 
# The total variance is insignificant. With the exception of a single test station, 
# start coordinates and end coordinates vary by less than 0.002 degrees for every station in the dataset.

SELECT 
    start_station_name,
    COUNT(start_station_name) AS number_of_trips, 
    ROUND(ABS(AVG(start_lat) - AVG(end_stations.avg_end_lat)) + ABS(AVG(start_lng) - AVG(end_stations.avg_end_lng)),6) AS total_variance,
    ROUND(AVG(start_lat),4) AS avg_start_lat,
    ROUND(AVG(start_lng),4) AS avg_start_lng,
    ROUND(AVG(end_stations.avg_end_lat),4) AS avg_end_lat,
    ROUND(AVG(end_stations.avg_end_lng),4) AS avg_end_lng
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata` AS start_trips
FULL OUTER JOIN (
    SELECT 
        end_station_name,
        ROUND(AVG(end_lat)) AS avg_end_lat,
        ROUND(AVG(end_lng)) AS avg_end_lng,
    FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata` 
    WHERE end_station_name IS NOT null
    GROUP BY end_station_name) end_stations
ON start_trips.start_station_name = end_stations.end_station_name
WHERE start_station_name IS NOT null
GROUP BY start_station_name
ORDER BY total_variance DESC




# Double-checking start stations which are all upper case. It seems like these may or may not be test stations. 
# As the overall number is very small, it shouldn't have a large impact on the results either way; they won't be included in the final analysis. 

SELECT 
    start_station_name,
    COUNT(ride_id) AS total_riders,
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata` AS start_trips
WHERE start_station_name = UPPER(start_station_name)
GROUP BY start_station_name



## To summarize so far: 
## -Data values are mostly within expected ranges
## -Start/End station names are about 11% null values, coordinates are about 0.1% null values
## -There are no duplicate ride_id's
## -Trips under 1 minute and over 6 hours will be removed
## -Average coordinates for starting and ending stations are in very close agreement
## -Upper case stations may be test stations and won't be included in the final analysis
##
## Now, we can dive into questions related to the analysis.
##
## Which areas of Chicago do casual riders prefer?
## Which stations have the highest and lowest proportion of members vs. casual riders?
## Which stations are most popular (with both members and casual riders)?
## How long are the trips of casual members?
## How has the number of members vs. casual riders varied over the previous six months?
## How does the number of members vs. casual riders vary by time of day, and weekday?




# Ceasual riders by day of week. Weekends are more popular with casual riders than weekdays.

SELECT 
    FORMAT_DATE("%A", started_at) AS day_of_week,
    ROUND(COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) / COUNT(member_casual) * 100,2) AS percent_casual,
    COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) casual_riders,
    COUNT(member_casual) AS total_riders
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1 AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 6 AND start_station_name <> UPPER(start_station_name)
GROUP BY day_of_week
ORDER BY (
    CASE WHEN day_of_week='Monday' THEN 1
        WHEN day_of_week='Tuesday' THEN 2
        WHEN day_of_week='Wednesday' THEN 3
        WHEN day_of_week='Thursday' THEN 4
        ELSE 5
    END)




# Casual riders by month. The number of total rides has risen since April, while the proportion of casual riders peaked in July and is now declining again. 

SELECT 
    EXTRACT(MONTH FROM started_at) AS start_month,
    ROUND(COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) / COUNT(member_casual) * 100,2) AS percent_casual,
    COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) casual_riders,
    COUNT(member_casual) AS total_riders
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1 AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 6 AND start_station_name <> UPPER(start_station_name)
GROUP BY start_month
ORDER BY start_month




# Casual riders by length of their trip, in minutes. 

SELECT 
    TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS length_in_minutes,
    ROUND(COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) / COUNT(member_casual) * 100,2) AS percent_casual,
    COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) casual_riders,
    COUNT(member_casual) AS total_riders
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1 AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 6 AND start_station_name <> UPPER(start_station_name)
GROUP BY length_in_minutes
ORDER BY length_in_minutes




# 100% of docked_bikes were used by casual riders. There might be a reason for this, perhaps docked_bikes can only be riden by casual riders. 

SELECT 
    rideable_type,
    ROUND(COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) / COUNT(member_casual) * 100,2) AS percent_casual,
    COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) casual_riders,
    COUNT(member_casual) AS total_riders
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1 AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 6 AND start_station_name <> UPPER(start_station_name)
GROUP BY rideable_type
ORDER BY percent_casual




# Relevant data extracted so it can be visualized easily using R. Specifically the date, month, day of month, hour, and how long the ride was in seconds. 
# Rides shorter than 1 minute and 6 hours or longer have been removed.

SELECT 
    EXTRACT(DATE FROM started_at) AS date,
    EXTRACT(MONTH FROM started_at) AS month,
    EXTRACT(DAY FROM started_at) AS day,
    EXTRACT(HOUR FROM started_at) AS hour,
    TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS ride_length_in_seconds,
    member_casual
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1 AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 6 AND start_station_name <> UPPER(start_station_name)
ORDER BY started_at




# Station Information which can be used for visualization in R. Includes the location of each station, and the percenage of casual riders, 
# filtering out trips shorter than 1 minute and longer than 6 hours, and stations in upper case.

SELECT 
    start_station_name,
    COUNT(start_station_name) AS number_of_trips, 
    ROUND(AVG(start_lat),4) AS avg_start_lat,
    ROUND(AVG(start_lng),4) AS avg_start_lng,
    ROUND(COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) / COUNT(member_casual) * 100,2) AS percent_casual, 
    COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) AS casual_riders,
    COUNT(member_casual) AS total_riders
FROM `glassy-compiler-321611.cyclistic_capstone.2021FY-2nd-half_tripdata`
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) >= 1 AND TIMESTAMP_DIFF(ended_at, started_at, HOUR) < 6 AND start_station_name IS NOT null AND start_station_name <> UPPER(start_station_name)
GROUP BY start_station_name
ORDER BY number_of_trips DESC
