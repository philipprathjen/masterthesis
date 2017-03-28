create table filip.person_data
select  
	t1.APPLN_ID,
	t2.PERSON_ID, 
	t3.PERSON_NAME,
	t3.PERSON_ADDRESS,
	t3.PERSON_CTRY_CODE,
	t3.DOC_STD_NAME_ID,
	t3.DOC_STD_NAME
from filip.orbis_match t1
left join patstat_a16.tls207_pers_appln t2
	on t1.APPLN_ID = t2.APPLN_ID 
left join patstat_a16.tls206_person t3
	ON t2.PERSON_ID = t3.PERSON_ID
limit 10;

delete from filip.person_data;
insert into filip.person_data
select  
	t1.APPLN_ID,
	t2.PERSON_ID, 
	t3.PERSON_NAME,
	t3.PERSON_ADDRESS,
	t3.PERSON_CTRY_CODE,
	t3.DOC_STD_NAME_ID,
	t3.DOC_STD_NAME
from filip.orbis_match t1
left join patstat_a16.tls207_pers_appln t2
	on t1.APPLN_ID = t2.APPLN_ID 
left join patstat_a16.tls206_person t3
	ON t2.PERSON_ID = t3.PERSON_ID