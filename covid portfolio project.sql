SELECT *
FROM  portfolioproject1..[COVID DEATHS]
where continent is not null
order by 3,4

--SELECT *
--FROM  portfolioproject1..[COVID VACCINATION]
--order by 3,4

SELECT location, date,total_cases, new_cases, total_deaths, population
FROM  portfolioproject1..[COVID DEATHS]
where continent is not null
order by 1,2

--looking at toal cases vs total deaths
--shows the likelihood of dying if you have covid in your country
SELECT location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM  portfolioproject1..[COVID DEATHS]
where location like'%India'
order by 1,2


--looking at the total cases vs the population
--shows what percentage of population got covid

SELECT location, date,population,total_cases,(total_cases/population)*100 as PercentpopulationInfected
FROM  portfolioproject1..[COVID DEATHS]
--where location like'%India'
order by 1,2


--looking at country with highest infection rate compared to population

SELECT location, population,max(total_cases)  as Highestinfectioncount,max(total_cases/population)*100 as PercentpopulationInfected
FROM  portfolioproject1..[COVID DEATHS]
--where location like'%India'
group by location,population
order by PercentpopulationInfected desc 

--showing the countries with highest death count per population 

SELECT location, max(cast(total_deaths as int)) as TotalDeathCount
FROM  portfolioproject1..[COVID DEATHS]
--where location like'%India'
where continent is not null
group by location
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT

--showing continent with the highest death count per population

SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM  portfolioproject1..[COVID DEATHS]
--where location like'%India'
where continent is not null
group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS

SELECT sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from portfolioproject1..[COVID DEATHS]
--where location like '%state%'
where continent is not null
--group by date 
order by 1,2


--LOOKING AT TOTAL POPULATION VS VACCINATION

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolioproject1..[COVID DEATHS] dea
join portfolioproject1..[COVID VACCINATION] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3



--Use CTE

WITH popvsvac (continent, location, date, population, new_vaccination, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolioproject1..[COVID DEATHS] dea
join portfolioproject1..[COVID VACCINATION] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100
from popvsvac


--TEMP TABLE
drop table if exists  #percentpopulationvvaccinated
create table #percentpopulationvvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT into #percentpopulationvvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolioproject1..[COVID DEATHS] dea
join portfolioproject1..[COVID VACCINATION] vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null


select *, (RollingPeopleVaccinated/population)*100
from #percentpopulationvvaccinated


--Creating view to store Data for  later Visualizations

create view percentpopulationvvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolioproject1..[COVID DEATHS] dea
join portfolioproject1..[COVID VACCINATION] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null


select *
from percentpopulationvvaccinated







