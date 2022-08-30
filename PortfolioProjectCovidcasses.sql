--select * 

from PortfolioProject1..CovidDeaths
order by 3,4


select * 
from PortfolioProject1..CovidVaccinations
order by 3,4



--select data that we are going to be using 

select location, date, total_cases, new_cases, total_deaths,population
from PortfolioProject1..CovidDeaths
order by 1,2



--Looking at Total Cases vs Total Deaths 
--shows what percentage of population got Covid

-select location, date, population, total_cases,(total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject1..CovidDeaths
where location like '%states%'
order by 1,2




--Looking at Countries with Highest Infection Rate compared to population

select location, population, Max(total_cases) as HighestinfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected

From PortfolioProject1..CovidDeaths

Group by location, population
order by PercentPopulationInfected desc




--Showing Countries with Highest Death Count per Population 

select location, Max(cast(total_deaths as int)) as TotalDeathCount

From PortfolioProject1..CovidDeaths

--where location like '%states%'
--order by 1,2
where continent is not null
Group by location
order by TotalDeathCount desc





--Let's Break things down by Continent 

select location, Max(cast(total_deaths as int)) as TotalDeathCount

From PortfolioProject1..CovidDeaths

--where location like '%states%'
--order by 1,2
where continent is null
Group by location
order by TotalDeathCount desc




--Showing continents with the highest death count per population

select location, Max(cast(total_deaths as int)) as TotalDeathCount

From PortfolioProject1..CovidDeaths 
--where location like '%states%'
--order by 1,2
where continent is not null
Group by location
order by TotalDeathCount desc




--Global Numbers

select SUM(new_cases) as total_cases , SUM(cast(new_deaths as int)) as total_deaths , SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths 
--where location like '%states%'

where continent is not null
--Group by date
order by 1,2




--LOOKING FOR THE TOTAL POPOULATION VS VACCINATION

select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location,dea.date) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100

From PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
      ON dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null
order by 2,3




--Use CTE

With PopvsVac (Continen, location, date, population, new_vaccinations, rollingpeoplevaccinated) as 
(
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, 
dea.Date) as RollingPeopleVacinated
--, (RollingPeopleVacinated/population)*100
From PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
	 On dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)


select *,(rollingpeoplevaccinated/population)*100
from popvsvac 





--Temp table


DROP tABLE IF exists #percentpopulationvaccinated
Create Table #PercentagepopulationVaccinated
(
Continent nvarchar(255)
Location nvarchar(255),
Date datetime, 
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)


Insert into

--Creating view to store data for later visualizations 

Create View PercentPopulationVaccinated as 
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
,Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, 
dea.Date) as RollingPeopleVacinated
--, (RollingPeopleVacinated/population)*100
From PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
	 On dea.location = vac.location
	  and dea.date = vac.date
where dea.continent is not null
--order by 2,3

--Creating view to store data for later visualizations 


Select 
From PercentagepopulationVaccinated






