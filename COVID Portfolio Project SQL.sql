Select * 
From [Portfolio Project ]..CovidDeaths$
where continent is not null
order by 3,4

--Select * 
--From [Portfolio Project ]..CovidVaccinations$ 
--order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project ]..CovidDeaths$
where continent is not null
order by 1,2


-- Looking at Total Cases Vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project ]..CovidDeaths$
where location like '%states%'
and continent is not null
order by 1,2


-- Looking at Total cases Vs Population
-- Shows what percentage of population got covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project ]..CovidDeaths$
--where location like '%states%'
order by 1,2

-- Looking at countries with Highest infection rate compared to Population
Select location,  population, MAX(total_cases) as HighestInfectionCount,MAX( (total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project ]..CovidDeaths$
--where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project ]..CovidDeaths$
--where location like '%states%'
where continent is not null
Group by location
order by TotalDeathCount desc


-- Let's Break things down by continent



-- Showing Continents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project ]..CovidDeaths$
--where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc





-- GLOBAL NUMBERS

Select   SUM(NEW_CASES) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(NEW_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [Portfolio Project ]..CovidDeaths$
-- Where location like '%states%'
where continent is not null
--Group by date
order by 1,2





-- Looking at  Total Population Vs Vaccinations

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, SUM(CONVERT (int,vac.new_vaccinations)) OVER(Partition by dea.location oRDER BY DEA.LOCATION,DEA.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..CovidDeaths$ dea
Join [Portfolio Project ]..CovidVaccinations$ vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3






 -- Use CTE

 With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
 as
 (
 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, SUM(CONVERT (int,vac.new_vaccinations)) OVER(Partition by dea.location oRDER BY DEA.LOCATION,DEA.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..CovidDeaths$ dea
Join [Portfolio Project ]..CovidVaccinations$ vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )
 Select*, (RollingPeopleVaccinated/Population)*100
 From PopvsVac





 -- TEMP TABLE

 DROP Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, SUM(CONVERT (int,vac.new_vaccinations)) OVER(Partition by dea.location oRDER BY DEA.LOCATION,DEA.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..CovidDeaths$ dea
Join [Portfolio Project ]..CovidVaccinations$ vac
 On dea.location = vac.location
 and dea.date = vac.date
 --where dea.continent is not null
 --order by 2,3

 Select*, (RollingPeopleVaccinated/Population)*100
 From #PercentPopulationVaccinated




 -- Creating view to store data  for later visualisations
 Create view PercentPopulationVaccinated as 
  Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, SUM(CONVERT (int,vac.new_vaccinations)) OVER(Partition by dea.location oRDER BY DEA.LOCATION,DEA.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..CovidDeaths$ dea
Join [Portfolio Project ]..CovidVaccinations$ vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3



 Select *
 From PercentPopulationVaccinated