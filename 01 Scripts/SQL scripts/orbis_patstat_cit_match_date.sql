create table filip.pat_citat_year
select distinct
	t1.PAT_PUBLN_ID as cited_publn_id, -- cited
	t1.earliest_publn_year, -- cited
	t2.PAT_PUBLN_ID as citing_publn_id, -- citing
	-- t3.APPLN_ID as citing_appln_id, -- citing
	t4.appln_filing_year as citing_appln_filing_year-- citing
from filip.orbis_match_test t1
left JOIN patstat_a16.tls212_citation t2
	on t2.CITED_PAT_PUBLN_ID = t1.PAT_PUBLN_ID
left join patstat_a16.tls211_pat_publn t3
	ON t2.PAT_PUBLN_ID = t3.PAT_PUBLN_ID
left join patstat_a16.tls201_appln t4
	ON t4.APPLN_ID = t3.APPLN_ID
Where 
	t4.appln_filing_year <= t1.earliest_publn_year + 5
limit 10;

delete from filip.pat_citat_year;

insert into filip.pat_citat_year
select distinct
	t1.PAT_PUBLN_ID as cited_publn_id, -- cited
	t1.earliest_publn_year, -- cited
	t2.PAT_PUBLN_ID as citing_publn_id, -- citing
	-- t3.APPLN_ID as citing_appln_id, -- citing
	t4.appln_filing_year as citing_appln_filing_year-- citing
from filip.orbis_match_test t1
left JOIN patstat_a16.tls212_citation t2
	on t2.CITED_PAT_PUBLN_ID = t1.PAT_PUBLN_ID
left join patstat_a16.tls211_pat_publn t3
	ON t2.PAT_PUBLN_ID = t3.PAT_PUBLN_ID
left join patstat_a16.tls201_appln t4
	ON t4.APPLN_ID = t3.APPLN_ID
Where 
	t4.appln_filing_year <= t1.earliest_publn_year + 5