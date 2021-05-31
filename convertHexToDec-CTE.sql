;with inputSelect as (
	select '1AA5' as inputTxt
	union all
	select '1AB4'
	union all
	select '11ab3'
), calculateHexvalue as (
    select
        1 as charIdx,
		0 as calcValue,
        0 as decValue,
        '' as lastchar,
        upper(inputTxt) as inputTxt
    from inputSelect
	union all
	select
        charIdx+1,
        ascii(substring(inputtxt, charIdx, 1)) - 
            case when substring(inputtxt, charIdx, 1) between 'A' and 'G' then 55
                else 48
            end,
        decValue*16 + 
        ascii(substring(inputtxt, charIdx, 1)) - 
            case when substring(inputtxt, charIdx, 1) between 'A' and 'G' then 55
                else 48
            end,
        substring(inputtxt, charIdx, 1),
        inputTxt
	from calculateHexvalue
	where charIdx<=len(inputTxt)
), result as (
    select 
        max(decValue) as decValue,
        inputTxt
    from calculateHexvalue
    group by inputTxt
)
select *
from result

;with inputSet as (
	select 'ff' as inputTxt
	union all
	select '1a'
	union all
	select '20a'
), convertHexToDec as (
    select
        1 as charIdx,
        0 as decValue,
        upper(inputTxt) as inputTxt
    from inputSet
	union all
	select
        charIdx+1,
        decValue*16 + ascii(substring(inputtxt, charIdx, 1)) - case when substring(inputtxt, charIdx, 1) between 'A' and 'G' then 55 else 48 end,
        inputTxt
	from convertHexToDec
	where charIdx<=len(inputTxt)
), resultSet as (
    select 
        max(decValue) as decValue,
        inputTxt
    from convertHexToDec
    group by inputTxt
)
select *
from resultSet
