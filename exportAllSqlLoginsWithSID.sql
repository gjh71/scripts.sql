-- do export logins with their SID and password (hashed)
; with logins AS
(
    SELECT 
        name, 
        master.dbo.fn_varbintohexstr(CONVERT(varbinary(256), LOGINPROPERTY(name, 'PasswordHash'))) as PasswordHash, 
        master.dbo.fn_varbintohexstr(sid) as sid
    FROM master.sys.server_principals
    WHERE
        type = 'S' AND 
        name NOT IN ('sa', 'guest') AND 
        create_date >= '12/31/2005'
)
select 
	'if exists (select name from master.sys.server_principals where name = [' + name + ']) begin drop login [' + name + '] end ' as dropSql,
    'create login [' + name + ']'
    + ' with password = ' + passwordhash + ' hashed'
    + ', sid = ' + sid
    + ' , CHECK_POLICY = OFF' 
    + ' , DEFAULT_DATABASE = master'
    + ' , CHECK_EXPIRATION = OFF' 
    --+ ' , CHECK_POLICY = OFF' -- not allowed on sql 2017
     as createSql,
	'if exists (select name from master.sys.server_principals where name = [' + name + ']) begin drop login [' + name + '] end
create login [' + name + ']'
    + ' with password = ' + passwordhash + ' hashed'
    + ', sid = ' + sid
    + ' , CHECK_POLICY = OFF' 
    + ' , DEFAULT_DATABASE = master'
    + ' , CHECK_EXPIRATION = OFF
' as recreateSql
from logins
order by name
