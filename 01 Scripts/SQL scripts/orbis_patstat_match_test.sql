create table filip.orbis_match_test
select distinct 
	t1.appln_nr,
	t1.pat_pubnr,
	t2.APPLN_ID,
	t3.PAT_PUBLN_ID,
	t2.earliest_filing_date,
	t2.earliest_publn_year,
	t2.docdb_family_size,
	t2.nb_citing_docdb_fam
	
from filip.orbispat_upload_test t1
inner join patstat_s16.tls201_appln t2
	ON t1.appln_nr = t2.appln_nr_epodoc
inner join patstat_s16.tls211_pat_publn t3
	ON t2.APPLN_ID = t3.APPLN_ID
limit 10;