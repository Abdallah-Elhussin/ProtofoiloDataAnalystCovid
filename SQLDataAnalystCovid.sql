select  dea.continent, dea.location , dea.date , dea.population , vea.new_vaccinations , sum(isnull(convert(int , vea.new_vaccinations),0)) 
        over(partition by dea.location order by  dea.location , dea.date)   as RollingPollVact
from ProtpfolioProject . .CovidDeaths dea
join ProtpfolioProject..CovidVaccinations vea
on dea.location = vea.location
and dea.date = vea.date
where dea.continent is not null
order by 2 , 3

--use CTE
with PopvsVec (Continent, Location , Date , Population , new_vaccinations , RollingPollVact)
as 
(select  dea.continent, dea.location , dea.date , dea.population , vea.new_vaccinations , sum(isnull(convert(int , vea.new_vaccinations),0)) 
        over(partition by dea.location order by  dea.location , dea.date)   as RollingPollVact
from ProtpfolioProject . .CovidDeaths dea
join ProtpfolioProject..CovidVaccinations vea
on dea.location = vea.location
and dea.date = vea.date
where dea.continent is not null
--order by 2 , 3
)
select * , round((RollingPollVact / Population) *100,2) as PercentagOfVaction
from PopvsVec

--Temp Table 
drop table if exists #PopulationOfVactionPepole
create table #PopulationOfVactionPepole
(
Continent nvarchar(250),
Location nvarchar(250),
Date datetime ,
Population numeric,
New_vaccinations numeric,
RollingPollVact numeric
)
insert into #PopulationOfVactionPepole
select  dea.continent, dea.location , dea.date , dea.population , vea.new_vaccinations , sum(isnull(convert(int , vea.new_vaccinations),0)) 
        over(partition by dea.location order by  dea.location , dea.date)   as RollingPollVact
from ProtpfolioProject . .CovidDeaths dea
join ProtpfolioProject..CovidVaccinations vea
on dea.location = vea.location
and dea.date = vea.date
where dea.continent is not null
select * from #PopulationOfVactionPepole

-- create a view 
create view PopulationOfVactionPepole
as
select  dea.continent, dea.location , dea.date , dea.population , vea.new_vaccinations , sum(isnull(convert(int , vea.new_vaccinations),0)) 
        over(partition by dea.location order by  dea.location , dea.date)   as RollingPollVact
from ProtpfolioProject . .CovidDeaths dea
join ProtpfolioProject..CovidVaccinations vea
on dea.location = vea.location
and dea.date = vea.date
where dea.continent is not null

select * from PopulationOfVactionPepole