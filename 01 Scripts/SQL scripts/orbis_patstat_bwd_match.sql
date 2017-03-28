select distinct
	t1.PAT_PUBLN_ID,
	count(t2.CITED_PAT_PUBLN_ID) as BwdCit
from filip.orbis_match_test t1
left JOIN patstat_s16.tls212_citation t2
	on t2.PAT_PUBLN_ID = t1.PAT_PUBLN_ID
GROUP BY PAT_PUBLN_ID