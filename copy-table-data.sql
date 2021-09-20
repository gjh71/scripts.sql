set identity_insert [DetectionValue].[LastBehavior_nVarchar] on
go

;with notInsertedYet as (
	select top 1000 org.*
	from [DetectionValue].[LastBehavior] org
	left outer join [DetectionValue].[LastBehavior_nVarchar] cpy on cpy.id = org.id
	where cpy.id is null
	order by org.id
)
insert into [DetectionValue].[LastBehavior_nVarchar] 
(
	[Id],
	[CowId],
	[LastTimeStamp],
	[NotActiveTimeSeries],
	[RuminatingTimeSeries],
	[EatingTimeSeries],
	[HighActiveTimeSeries],
	[Sub8AvgDiffAverageTimeSeries],
	[Series],
	[FormatVersion]
)
select 
	[Id],
	[CowId],
	[LastTimeStamp],
	[NotActiveTimeSeries],
	[RuminatingTimeSeries],
	[EatingTimeSeries],
	[HighActiveTimeSeries],
	[Sub8AvgDiffAverageTimeSeries],
	[Series],
	[FormatVersion]
from notInsertedYet niy

go 1000


set identity_insert [DetectionValue].[LastBehavior_nVarchar] off
go


select count(1) from [DetectionValue].[LastBehavior_nVarchar]
select count(1) from [DetectionValue].[LastBehavior]