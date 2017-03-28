create table filip.pat_fwdcit5y
select
	t1.cited_publn_id,
	count(t1.citing_publn_id) as FwdCit5y
from filip.pat_citat_year t1
GROUP BY cited_publn_id
limit 10;

delete from filip.pat_fwdcit5y;

insert into filip.pat_fwdcit5y
select
	t1.cited_publn_id,
	count(t1.citing_publn_id) as FwdCit5y
from filip.pat_citat_year t1
GROUP BY cited_publn_id