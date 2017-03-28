create table filip.patents11_16
select distinct
	t1.pat_publn_id, t1.PUBLN_DATE, 
    t2.CITN_ORIGIN, t2.CITN_GENER_AUTH, 
    t3.APPLN_ID, t3.docdb_family_id, t3.docdb_family_size,
    t4.person_id, 
    t5.person_name, t5.DOC_STD_NAME, t5.DOC_STD_NAME_ID, t5.person_ctry_code,
    t6.nace2_code
from 
	patstat_s16.tls211_pat_publn t1
INNER JOIN patstat_s16.tls212_citation t2
	ON t1.pat_publn_id = t2.PAT_PUBLN_ID
INNER JOIN patstat_s16.tls201_appln t3
	ON t1.APPLN_ID = t3.appln_id
INNER JOIN patstat_s16.tls207_pers_appln t4
	ON t1.appln_ID = t4.APPLN_ID
INNER JOIN patstat_s16.tls206_person t5
	ON t4.person_id = t5.person_id
INNER JOIN patstat_s16.tls229_appln_nace2 t6
	ON t1.appln_id = t6.appln_id

WHERE (tls211.PUBLN_DATE BETWEEN '2010-12-31' AND '2016-01-01');