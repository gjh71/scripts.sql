-- define allowed characters
declare @safeChars nvarchar(50) = '%[^A-z0-9 ]%'

;with rawInput as (
    select 
        'Hoi Piepeloi' as inputTxt
    union all 
    select 
        '€ 128,- v¢¢r wat anders'
), initialRow as (
    --in fact a dummy cte, but makes sure types are identical
    select
        0 as safeCharIdx,
        stuff(inputTxt, PATINDEX(@safeChars, inputTxt), 0, '') as filteredTxt,
        inputTxt
    from rawInput
), filteredInput as (
    --recurse until unallowed characters are no longer found
    select
        safeCharIdx,
        filteredTxt,
        inputTxt
    from initialRow
    union all
    select
        PATINDEX(@safeChars, filteredTxt) as idx,
        stuff(filteredTxt, PATINDEX(@safeChars, filteredTxt), 1, ''),
        inputTxt
    from filteredInput
    where PATINDEX(@safeChars, filteredTxt) >= 0
), cleanInput as (
    -- select the 'shortest' (=min) result, but when 'null' no illegal characters were found, then use the original
    select 
        (ltrim(rtrim(coalesce(min(filteredTxt), inputTxt)))) as CleanInputTxt,
        inputTxt as OriginalInputTxt
    from filteredInput
    group by
        inputTxt
)
-- select * from initialRow
-- select * from filteredInput
select * from cleanInput cn

