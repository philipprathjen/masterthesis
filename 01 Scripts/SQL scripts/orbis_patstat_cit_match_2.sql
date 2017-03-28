-- delete from filip.orbis_match_citation;
-- insert into filip.orbis_match_citation
# Distinct option to avoid double counting APP and EXA citations (applicant exampiner -- p.51/269 EPO Guide)
select distinct
	t1.PAT_PUBLN_ID,
	count(t2.PAT_PUBLN_ID) as FwdCit
from filip.orbis_match_test t1
left JOIN patstat_a16.tls212_citation t2
	on t2.CITED_PAT_PUBLN_ID = t1.PAT_PUBLN_ID
GROUP BY PAT_PUBLN_ID

