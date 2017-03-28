*********************************************************
*********** Do file final analysis **********************
*********************************************************

// Master Thesis: Philipp Rathjen
// Submitted March 29 2017

clear
use "/Users/philipp_rathjen/Documents/Education/04 Ludwig Maximilians Universitaet/04 Semester/Master Thesis/Github/masterthesis/02 Data/database.dta"

** Generate squared variables for analysis
gen wlc2 = wlc^2 
gen mlc2 = mlc^2 
gen wlc_sub2 = wlc_sub^2
gen mlc_sub2 = mlc_sub^2
gen elas2 = elas^2
gen elas_alt2 = elas_alt^2


** Conventions
// cluster -- allow error correlation within groups
	// discussion of robust cluster: http://www.stata.com/support/faqs/statistics/standard-errors-and-vce-cluster-option/
// No Constant
	// It would not make sense to evaluate the nbreg at zero. 
	// Including industry effects allows a more straightforwar interpretations


** Import instrument data
// http://www.stata.com/support/faqs/statistics/instrumental-variables-regression/
// Import other instrument data
merge 1:1 year nace using "/Users/philipp_rathjen/Documents/Education/04 Ludwig Maximilians Universitaet/04 Semester/Master Thesis/Github/masterthesis/02 Data/wagedev.dta"
drop _merge
merge 1:1 nace year using "/Users/philipp_rathjen/Documents/Education/04 Ludwig Maximilians Universitaet/04 Semester/Master Thesis/Github/masterthesis/02 Data/trade_by_nace.dta"
drop _merge
merge 1:1 year nace using "/Users/philipp_rathjen/Documents/Education/04 Ludwig Maximilians Universitaet/04 Semester/Master Thesis/Github/masterthesis/02 Data/import_wiot.dta"
drop _merge
xtset nace year
drop if year>2012


** Summarize
sum wpc mppc wlc mlc wlc_sub mlc_sub elas elas_alt interest 

** Overdispersion
gen nace2 = floor(nace/10)

preserve
bysort nace2: sum wpc
restore

** Cross Correlation
pwcorr wpc mppc wlc mlc wlc_sub mlc_sub elas elas_alt interest, sig

** Expore instrument characterstics
pwcorr wlc mlc interest entry imports tradevolume wagedev, sig
reg mlc interest int2 i1-i58 y1-y22, cluster(nace) nocons // sig #int_rate expectation: inv-U  

** Data Summary
sum wpc mppc wlc mlc wlc_sub mlc_sub elas elas_alt interest

** Reported Table 4

nbreg mppc wlc_sub wlc_sub2 L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant)
nbreg mppc mlc_sub mlc_sub2 L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant)
nbreg wpc mlc_sub mlc_sub2 L1.wpc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant)

**Remove Outliers
** Outliers
gen out_wlc = 0
sum wlc_sub, detail
replace out_wlc = 1 if wlc_sub>r(p5)
replace out_wlc = 0 if wlc_sub>r(p95)
scatter wpc wlc_sub if out_wlc == 1

gen out_mlc = 0
sum mlc_sub, detail
replace out_mlc = 1 if mlc_sub>r(p5)
replace out_mlc = 0 if mlc_sub>r(p95)
scatter wpc mlc_sub if out_mlc == 1

**
nbreg mppc wlc_sub wlc_sub2 L1.mppc i1-i58 y1-y22 if out_wlc ==1, cluster(nace) nocons dispersion(constant)
nbreg mppc mlc_sub mlc_sub2 L1.mppc i1-i58 y1-y22 if out_mlc ==1, cluster(nace) nocons dispersion(constant)

** Reported in Text Section 4
nbreg mppc mlc mlc2 L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant)  // external validity

** Reported in Table 5

nbreg wpc elas L1.wpc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant) 
nbreg wpc elas elas2 L1.wpc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant) 
nbreg mppc elas L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant) 
nbreg mppc elas elas2 L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant) 

** Instrument Choice
// Does it make sense to use the interest rate? 
// Yes. Look at Audretsch and Mahmood (1995) Firm Survival
qui reg mlc_sub interest int2 i1-i58 y1-y22, cluster(nace) nocons // sig
test interest int2
predict mlc_hat
label var mlc_hat "[Average Lerner] Fitted Values" 
predict res_mlc, res

qui reg wlc_sub interest int2 i1-i58 y1-y22, cluster(nace) nocons
test interest int2
predict wlc_hat
label var wlc_hat "[Weighted Lerner] Fitted Values" 
predict res_wlc, res

** Appendix: Alternative Instruments Table 9

reg wlc_sub interest int2 imports entry tradevolume wagedev i1-i58   y1-y22, cluster(nace) nocons
reg wlc_sub interest int2 imports i1-i58   y1-y22, cluster(nace) nocons
reg wlc_sub interest int2 entry i1-i58   y1-y22, cluster(nace) nocons
reg wlc_sub interest int2 tradevolume i1-i58   y1-y22, cluster(nace) nocons
reg wlc_sub interest int2 wagedev i1-i58   y1-y22, cluster(nace) nocons


** Instrumental Variable approach
gen mlc_hat2 = mlc_hat^2
gen wlc_hat2 = wlc_hat^2

** Table 4
nbreg mppc mlc_hat mlc_hat2  L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant)
nbreg mppc wlc_hat wlc_hat2  L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant)


** Appendix Table 10
nbreg mppc elas_alt L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant) 
nbreg mppc elas_alt elas_alt2 L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant) 
reg mppc wlc_hat wlc_hat2  L1.mppc i1-i58 y1-y22, cluster(nace) nocons

** Split the sample [Lerner]
qui gen ml1 = 0
qui replace ml1 = 1 if mlc>=0 & mlc<=0.5
qui gen ml2 = 0
qui replace ml2 = 1 if mlc>0.5 & mlc<=0.6
qui gen ml3 = 0
qui replace ml3 = 1 if mlc>0.6 & mlc<=0.7
qui gen ml4 = 0
qui replace ml4 = 1 if mlc>0.7 & mlc<=0.8
qui gen ml5 = 0
qui replace ml5 = 1 if mlc>0.8 & mlc<=0.9
qui gen ml6 = 0
qui replace ml6 = 1 if mlc>0.9 & mlc<=1

** Split sample indicator estimate
reg mppc ml2 ml3 ml4 ml5 ml6 L1.mppc i1-i58 y1-y22, cluster(nace) nocons
test ml2 ml3 ml4 ml5 ml6
nbreg wpc ml2 ml3 ml4 ml5 ml6 L1.wpc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant)
test ml2 ml3 ml4 ml5 ml6
nbreg mppc ml2 ml3 ml4 ml5 ml6 L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant)
test ml2 ml3 ml4 ml5 ml6

** Split the sample [PE]
qui sum elas, detail
qui gen pe1 = 0
qui replace pe1 = 1 if elas<=r(p5)
gen pe2 = 0
qui replace pe2 = 1 if elas>r(p5) & elas<=r(p10)
qui gen pe3 = 0
qui replace pe3 = 1 if elas>r(p10) & elas<=r(p25)
qui gen pe4 = 0
qui replace pe4 = 1 if elas>r(p25) & elas<=r(p50)
qui gen pe5 = 0
qui replace pe5 = 1 if elas>r(p50) & elas<=r(p75)
qui gen pe6 = 0
qui replace pe6 = 1 if elas>r(p75) & elas<=r(p90)
qui gen pe7 = 0
qui replace pe7 = 1 if elas>r(p90) 

** Split sample indicator [PE]
// Mentioned in Text
// first dropped to include industry fixed effects instead [Interpretation of Benchmark]
nbreg wpc pe2 pe3 pe4 pe5 pe6 pe7 L1.wpc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant)
test pe2 pe3 pe4 pe5 pe6 pe7
nbreg mppc pe2 pe3 pe4 pe5 pe6 pe7 L1.mppc i1-i58 y1-y22, cluster(nace) nocons dispersion(constant)
test pe2 pe3 pe4 pe5 pe6 pe7


** APPENDIX 
// OLS result, not significant - discussed in text.
reg mppc wlc_hat wlc_hat2  L1.mppc i1-i58 y1-y22, cluster(nace) nocons
nbreg mppc mlc_hat  L1.mppc i1-i58 y1-y22 if mppc<100, cluster(nace) dispersion(constant)

** Label
label var wlc "Weighted Lerner" 
label var mlc "Average Lerner" 
label var mppc "Citation-weighted patents [Pat. Lit]"
label var wpc "Citation-weighted patents" 

** Images 
qui scatter mppc wlc, name(panel1)
qui scatter mppc mlc, name(panel2)
qui scatter mppc wlc_hat, name(panel3)
qui scatter mppc mlc_hat, name(panel4)
graph combine panel1 panel2 panel3 panel4
