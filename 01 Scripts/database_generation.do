*********************************************************
*********** Do file to make dataset *********************
*ssc inst _gwtmean

use "/Users/philipp_rathjen/Documents/Education/04 Ludwig Maximilians Universitaet/04 Semester/Master Thesis/Github/masterthesis/02 Data/firm_data.dta", clear


** Generate two-digit industry variables from nace
qui tab ind_id, gen(i)
destring ind_id, replace
rename ind_id nace

** Gen year dummies
qui tab year, gen(y)

** Clean the data
replace ebit=. if ebit ==0
replace cogs=. if cogs ==0
replace revenues=. if revenues ==0

// Firm Level citation weighted_patents in database
** Generate Firm level Total WPC
destring WPC_NPL , replace
destring WPC_PL, replace
destring WPC, replace
replace WPC =WPC_PL + WPC_NPL
destring WPC, replace




** Develop Boone indicator
gen lebit = log(ebit)
gen lcogs = log(cogs)
gen lrev = log(revenues)
egen market = max(revenues), by(ind_id)
gen lmarket = log(market)
gen mcogs = cogs/revenues 
gen lmcogs = log(mcogs) 

replace sgaexp = 0 if sgaexp == .
replace cogs = 0 if cogs == . 
gen avc = sgaexp + cogs
replace avc = avc/revenues
gen lavc = log(avc)


gen elas_comp = .
gen elas_comp2 = .
encode company, gen(comp_id) 
qui tab company
local numcomp = r(r)
forvalues x = 1/`numcomp' {
	cap reg lebit lmcogs if comp_id==`x'
	cap replace elas_comp = _b[lmcogs] if comp_id ==`x' 
	// company specific beta as competition measure
	cap reg lebit lavc if comp_id==`x'
	cap replace elas_comp2 = _b[lavc] if comp_id ==`x' 
	di `x'
}
egen elas = mean(elas_comp), by (nace)
egen elas_alt = mean(elas_comp2), by (nace)
pwcorr elas elas_alt, sig // 0.94, sig

** Assessing indicator accuracy
// Benchmark: Herfindahl index (given for subsample) [0,2][highcomp, low comp]
// Expectaion: pos; sig // higher PCM/lower PE <> higher herfindahl
pwcorr herfindahl ebitda_rate, sig // pos; sig 
pwcorr herfindahl profrate, sig // neg; no sig
pwcorr herfindahl nincome_rate, sig // neg; no sig
*pwcorr herfindahl elas, sig // neg; sig


** Generate Profitability indicators
// Following Aghion et al. (2005)
** Indicators
// Sample Lerner by NACE code
local rate ebitda_rate
egen wlc = wtmean(`rate'), weight(revenue) by(nace year)
replace wlc = 1-wlc
egen mlc = mean(`rate'), by(nace year)
replace mlc = 1-mlc
pwcorr wlc mlc, sig // pos, sig

// Subsample (Where WPC>0) by NACE code [_sub]
egen wlc_sub =  wtmean(`rate') if WPC != ., weight(revenue) by(nace year)
replace wlc_sub = 1-wlc_sub
egen mlc_sub = mean(`rate') if WPC != ., by(nace year)
replace mlc_sub = 1 - mlc_sub
pwcorr wlc_sub mlc_sub, sig // pos, sig

// correlation competition indicators
pwcorr wlc mlc herfindahl, sig // pos, sig 


** Difficulty with this measure: beta should be negative but can be positive due to:
// Boone assumes largest firm is most efficient (not true in reality (DIW, 2010)
// Too few observations


** WPC and rd_exp
pwcorr WPC rd_exp, sig // pos, sig #FirmLevel
egen rd_nace = mean(rd_exp), by(nace year)
egen wpc = mean(WPC), by(nace year)
egen mppc = mean(WPC_PL), by(nace year)
egen mnpc = mean(WPC_NPL), by(nace year)
pwcorr wpc rd_nace, sig // pos, sig #SectorLevel
gen lwpc = log(wpc)
gen lrd = log(rd_exp)
drop lwpc lrd

** Control: extend subsample herfindahl to NACE sector level
egen herf_sec = mean(herfindahl), by(nace year)

* Source: ECB and Thomson Reuters

gen int2 = interest ^2

** Would the interest rate influence consumption*
// Effect on sales
pwcorr rev interest, sig // neg; no sig

// Effect on long term debt
pwcorr lt_debt_tot interest, sig // neg; sig

** Generate Table XXX
sum WPC WPC_NPL WPC_PL ebit ebitda herfindahl revenues sgaexp cogs
qui tab company 
di r(r) // 146
qui tab company if WPC != .
di r(r) // 157




** Exclude irrelevant industries from panel
keep if nace>10 & nace <70
drop if nace == 49 // Land transport and transport via pipelines
drop if nace == 50 // Water transport
drop if nace == 51 // Air transport
drop if nace == 52 // Warehousing and support activities for transportation
drop if nace == 53 // Postal and courier activities
drop if nace == 55 // Accommodation
drop if nace == 56 // Food and beverage service activities
drop if nace == 58 // Publishing activities
drop if nace == 59 // Motion picture, video and television programme production, sound recording 
drop if nace == 64 // Financial service activities, except insurance and pension funding
drop if nace == 65 // Insurance, reinsurance and pension funding, except compulsory social 
drop if nace == 66 // Activities auxiliary to financial services and insurance activities
drop if nace == 68 // Real estate activities
drop if nace == 69 // Legal and accounting activities


** Generate Table XXX
gen ind_id = substr(ind_id_trans,1,1)
sum WPC if ind_id == "1"
sum WPC if ind_id == "2"
sum WPC if ind_id == "3"
sum WPC if ind_id == "4"
sum WPC if ind_id == "5"
sum WPC if ind_id == "6"


** Correlation Revenues Interest
pwcorr revenues interest ,sig // -0.0244 (0.1720)


** Build the panel
keep wlc wlc_sub mlc mlc_sub elas herf_sec y* i* nace wpc mppc mnpc elas_alt
drop identifier interest_exp_tot y_founding ind_id_trans
drop if mlc_sub==.
duplicates drop
xtset nace year
drop if year>2012 // exclude to prevent patcit generation bias

** Generate Table XXX
sum wpc mppc wlc wlc_sub mlc mlc_sub elas elas_alt interest


** Sources:
* (DIW, 2010)
* https://de.statista.com/statistik/daten/studie/201419/umfrage/entwicklung-des-kapitalmarktzinssatzes-in-deutschland/

