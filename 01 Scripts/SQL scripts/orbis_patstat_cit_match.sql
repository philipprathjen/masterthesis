create table filip.orbis_match_citation
# Distint option to avoid double counting APP and EXA citations (applicant exampiner -- p.51/269 EPO Guide)
select distinct
	filip.orbis_match.PAT_PUBLN_ID,
	count(patstat_a16.tls212_citation.PAT_PUBLN_ID) as FwdCit
from filip.orbis_match
LEFT JOIN patstat_a16.tls212_citation
	on patstat_a16.tls212_citation.CITED_PAT_PUBLN_ID = filip.orbis_match.PAT_PUBLN_ID
GROUP BY PAT_PUBLN_ID
limit 10;

delete from filip.orbis_match_citation;

insert into filip.orbis_match_citation
select distinct
	t1.PAT_PUBLN_ID,
	count(t2.PAT_PUBLN_ID) as FwdCit
from filip.orbis_match t1
left JOIN patstat_a16.tls212_citation t2
	on t2.CITED_PAT_PUBLN_ID = t1.PAT_PUBLN_ID
GROUP BY PAT_PUBLN_ID