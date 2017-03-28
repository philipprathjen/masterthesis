create table filip.pat_final select t1.appln_nr,
    t1.pat_pubnr,
    t1.APPLN_ID,
    t1.PAT_PUBLN_ID,
    t1.earliest_filing_date,
    t1.earliest_publn_year,
    t1.docdb_family_size,
    t1.nb_citing_docdb_fam,
    t2.FwdCit,
    t3.FwdCit5y 
from
    filip.orbis_match_test t1
left join
    filip.orbis_match_citation t2 ON t1.PAT_PUBLN_ID = t2.PAT_PUBLN_ID
left Join
    filip.pat_fwdcit5y t3 ON t1.PAT_PUBLN_ID = t3.cited_publn_id
limit 10;

delete from filip.pat_final;
insert into filip.pat_final
select 
	t1.appln_nr,
	t1.pat_pubnr,
	t1.APPLN_ID,
	t1.PAT_PUBLN_ID,
	t1.earliest_filing_date,
	t1.earliest_publn_year,
	t1.docdb_family_size,
	t1.nb_citing_docdb_fam,
	t2.FwdCit,
	t3.FwdCit5y
from filip.orbis_match_test t1
left join filip.orbis_match_citation t2
	on t1.PAT_PUBLN_ID = t2.PAT_PUBLN_ID
left Join filip.pat_fwdcit5y t3
	on t1.PAT_PUBLN_ID = t3.cited_publn_id
