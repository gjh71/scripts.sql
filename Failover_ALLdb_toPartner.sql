-- Execute this script on the 'principal'. Then all relevant databases (i.e. mirrored and hosted on this machine)
-- will be shifted to the mirroring partner.
-- nb. a script will be generated. It's handy to save this for when the databases need to be shifted back. 
-- (the script needs then to be run on the PARTNER!)

use master

select 
	@@SERVERNAME as [DB-Server], 
	db.name as [DB-Name], 
	db.state_desc,
	sdm.mirroring_role_desc,
	sdm.mirroring_state_desc,
	sdm.mirroring_safety_level_desc,
	sdm.mirroring_partner_name,
	sdm.mirroring_partner_instance,
	sdm.mirroring_failover_lsn
from sys.database_mirroring sdm
inner join sys.databases db on db.database_id = sdm.database_id
where db.state_desc = 'online'
and sdm.mirroring_role_desc = 'PRINCIPAL'


-- Generate the script NOTE: switch to text results (CTRL-T) (back: CTRL-D = griD)
use master
set nocount on

select 
	'alter database [' + db.name + '] set partner failover
	'  as failoverSqlStatements
from sys.database_mirroring sdm
inner join sys.databases db on db.database_id = sdm.database_id
where db.state_desc = 'online'
and sdm.mirroring_role_desc = 'PRINCIPAL'
order by db.name

-- note that, if you want to be in control, it's advised to failover 1-by-1. 
-- if all systems are healthy, there's no problem to execute all at once
