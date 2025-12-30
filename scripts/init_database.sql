
/*

In this PostgreSQL script:

    1. Database|- db_dwh -|is created,
    2. Schemas|- bronze, silver, and gold -|are created
    

Note:
    The script also drops databases in the beginning, so please make sure that you don't already have the database implemented and are, for some reason, re-running the script. As it could delete all your data.

*/


DROP DATABASE if EXISTS db_dwh;


select 1 where EXISTS(select from pg_database where datname='db_dwh');

select * from pg_database where datname='db_dwh';

-- $$ DATABASE CREATION $$

create DATABASE db_dwh;

use db_dwh;


-- $$ SCHEMA CREATION $$

create SCHEMA bronze;

create SCHEMA silver;

create SCHEMA gold;
