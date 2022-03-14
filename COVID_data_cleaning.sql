# COVID Death data used for project

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM `glassy-compiler-321611.covid_data.covid_deaths` 
ORDER BY 1, 2




# Total Cases vs Total Deaths
# Shows number of COVID deaths vs number of positive COVID tests in every country

SELECT 
location, 
MAX(date) AS date, 
MAX(total_cases) AS total_cases, 
MAX(total_deaths) AS total_deaths, 
ROUND((MAX(total_deaths)/MAX(total_cases))*100,2) AS death_percentage

FROM `glassy-compiler-321611.covid_data.covid_deaths` 

WHERE continent is not null

GROUP BY location

ORDER BY 1, 2




# Total Cases vs Total Population
# Shows the percentage of positive COVID tests, organized by country

SELECT 
location, 
MAX(total_cases) AS infection_count, 
population, 
ROUND((MAX(total_cases)/population)*100,2) AS infections_per_capita

FROM `glassy-compiler-321611.covid_data.covid_deaths` 

WHERE continent IS NOT NULL

GROUP BY population, location

ORDER BY 4 DESC




# Continents by total COVID deaths and deaths vs population

SELECT 
location,
MAX(population) AS population, 
MAX(total_deaths) AS death_count,
ROUND(MAX(total_deaths) / MAX(population) * 100,2) AS percent_dead

FROM `glassy-compiler-321611.covid_data.covid_deaths` 

WHERE location IN (SELECT DISTINCT continent FROM `glassy-compiler-321611.covid_data.covid_deaths`)

GROUP BY location

ORDER BY death_count DESC





## Global new cases by day, and percentage deaths per new case

SELECT 
date, SUM(new_cases) AS new_cases, SUM(new_deaths) AS new_deaths, 
ROUND((SUM(new_deaths)/SUM(new_cases))*100,3) AS death_percentage

FROM `glassy-compiler-321611.covid_data.covid_deaths` 

WHERE continent IS NOT NULL

GROUP BY date

ORDER BY 1, 2




## Total Population vs Vaccinations

SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) 
    OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS cumulative_vaccinations,
FROM `glassy-compiler-321611.covid_data.covid_deaths` death
JOIN `glassy-compiler-321611.covid_data.covid_vaccinations` vac
    ON death.location = vac.location
    AND death.date = vac.date
WHERE death.continent IS NOT NULL
ORDER by 2, 3




## Using CTE

WITH VacPercent AS (SELECT death.continent, death.location, death.date, death.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) 
    OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS cumulative_vaccinations,
FROM `glassy-compiler-321611.covid_data.covid_deaths` death
JOIN `glassy-compiler-321611.covid_data.covid_vaccinations` vac
    ON death.location = vac.location
    AND death.date = vac.date
WHERE death.continent IS NOT NULL 
ORDER BY 2, 3)
SELECT *, ROUND(cumulative_vaccinations / population * 100,4) AS percent_vaccinated FROM VacPercent
