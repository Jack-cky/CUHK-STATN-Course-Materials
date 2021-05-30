libname project '/home/a0006/The Chinese University of Hong Kong/STAT2011 Workshop on Data Exploration and Technical Writing';

proc import datafile = '/home/a0006/The Chinese University of Hong Kong/STAT2011 Workshop on Data Exploration and Technical Writing/Data.xlsx'
	out = project.md dbms = xlsx replace;
	sheet = 'apartment data';
run;

/* modify of the data file */
data project.md;
	set project.md;
	
	Year_Old = Year_Sold - Year_Built;
	
	log_YearOld = log(Year_Old + 1);
	
	N_Parking = N_Parking_G + N_Parking_B;
	
run;


/* plot graphs for checking the correlateion of variables */

proc sgplot data = project.md;
	scatter Y = Price X = log_YearOld;
run;

* there is no linaer relation between price and Year_Old? ;


proc sgplot data = project.md;
	scatter Y = Price X = size;
run;


/* multiple regression for inner factors */
proc reg data = project.md;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / vif;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / dw r;
run;

proc reg data = project.md;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / selection = rsquare adjrsq cp;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / selection = backward sle = 0.1;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / selection = forward sle = 0.1;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / selection = stepwise sle = 0.1;
run;

proc reg data = project.md;
	model Price=TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University / selection = rsquare adjrsq cp;
	model Price=TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University / selection = stepwise sle = 0.05;
run;


proc reg data = project.md;
model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / dw;
plot residual.*obs.;
run;


proc glm data = project.md;
	class TimeToSubway TimeToBusStop;
	model Price = TimeToSubway TimeToBusStop N_APT -- N_University / solution alpha = 0.05;
run;


PROC REG DATA=test.data;
	MODEL Price=Year_Built	Year_Sold	Month_Sold	Size	Floor	N_Parking_G	N_Parking_B	TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University	N_FacilitiesInApt / SELECTION=BACKWARD SLE=0.1;
	MODEL Price=Year_Built	Year_Sold	Month_Sold	Size	Floor	N_Parking_G	N_Parking_B	TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University	N_FacilitiesInApt / SELECTION=FORWARD SLE=0.1;
	MODEL Price=Year_Built	Year_Sold	Month_Sold	Size	Floor	N_Parking_G	N_Parking_B	TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University	N_FacilitiesInApt / SELECTION=STEPWISE SLE=0.1;
	MODEL Price=Year_Built	Year_Sold	Month_Sold	Size	Floor	N_Parking_G	N_Parking_B	TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University	N_FacilitiesInApt / SELECTION=RSQUARE ADJRSQ CP;
RUN;

/* normal assumption on variables */

proc univariate data = project.md;
	var Year_Old;
	
run;

















/* data modifiy */
/* modify the categorical variables
data summary.md;
	set summary.md;
	
	if TimeToSubway = '0~5min' then
		TimeToSubway = 1;
		else if TimeToSubway = '5min~10min' then
			TimeToSubway = 2;
		else TimeToSubway = 3;
		
	if TimeToBusStop = '0-5min' then
		TimeToBusStop = 1;
		else if TimeToBusStop = '5min~10min' then
			TimeToBusStop = 2;
		else if TimeToBusStop = '10min~15min' then
			TimeToBusStop = 3;
		else if TimeToBusStop = '15min~20min' then
			TimeToBusStop = 4;
		else TimeToBusStop = .;
		
run;
*/



data summary.md;
	set summary.md;
	
	Year_Old = Year_Sold - Year_Built;
	
	log_Old = log(Year_Old);
	
	/*
	if TimeToBusStop = 'no_bus_stop_nearby' then
		Trans = 'Subway';
	else Trans = 'both';
	*/

run;

/* house size
proc means data = summary.md;
var size;
run;

Class A - saleable area less than 40 m2
Class B - saleable area of 40 m2 to 69.9 m2
Class C - saleable area of 70 m2 to 99.9 m2
Class D - saleable area of 100 m2to 159.9 m2
Class E - saleable area of 160 m2 or above
*/



/* summary statistics */
proc means data = summary.md min p25 p50 p75 max maxdec = 2;
	var Price Year_Old Size Floor N_Parking_G N_Parking_B N_APT -- N_FacilitiesInApt;
run;

proc tabulate data = summary.md;
	class TimeToSubway TimeToBusStop / missing;
	table TimeToSubway TimeToBusStop, n pctn;
run;


/* correlation */
* 1;
proc corr data = project.md pearson;
	var Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt;
	with Price;
run;

* 2;
proc corr data = project.md pearson;
	var N_APT -- N_University;
	with Price;
run;


/* t-test */
proc ttest data = summary.md h0 = 0 alpha = 0.05 sides = u;
	class Trans;
	var Price;
run;


/* graph */



proc sgplot data = project.md;
	vbar Month_Sold;
run;

proc sgplot data = summary.md;
	scatter Y = log_Old X = Year_Old;
run;



/* regression */

proc reg data = summary.md;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / clb alpha = 0.05;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / selection = stepwise sle = 0.1;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / selection = rsquare adjrsq cp;
run;


proc reg data = summary.md;
	model Price = log_Old;
run;

proc reg data = summary.md;
	model Price = log_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / clb alpha = 0.05;
run;


proc glm data = summary.md;
	class TimeToSubway TimeToBusStop;
	model Price = TimeToSubway TimeToBusStop N_APT -- N_University / solution alpha = 0.05;
run;






PROC GLM DATA=Assign2.Telco;
	CLASS Sex PlanName;
	MODEL ClubPurchase=Sex PlanName HasLandLine UseAutopay/SOLUTION ALPHA=0.05;

	/* Calculate the predicted values of ClubPurchase */
	OUTPUT OUT=Assign2.Telco_Predict P=ClubPurchase_Pred;
RUN;

LIBNAME test "/home/a0006/The Chinese University of Hong Kong/STAT3011 Workshop on Data Analysis and Statistical Computing";

PROC IMPORT DATAFILE="/home/a0006/The Chinese University of Hong Kong/STAT3011 Workshop on Data Analysis and Statistical Computing/apartment price data.xlsx" 
		OUT=test.data DBMS=XLSX REPLACE;
	SHEET="apartment data";
RUN;

PROC REG DATA=project.md;
	MODEL Price=Year_Built	Year_Sold	Month_Sold	Size	Floor	N_Parking_G	N_Parking_B	TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University	N_FacilitiesInApt / VIF dw;
	MODEL Price=Year_Built	Year_Sold	Month_Sold	Size	Floor	N_Parking_G	N_Parking_B	TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University	N_FacilitiesInApt / SELECTION=BACKWARD SLE=0.1;
	MODEL Price=Year_Built	Year_Sold	Month_Sold	Size	Floor	N_Parking_G	N_Parking_B	TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University	N_FacilitiesInApt / SELECTION=FORWARD SLE=0.1;
	MODEL Price=Year_Built	Year_Sold	Month_Sold	Size	Floor	N_Parking_G	N_Parking_B	TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University	N_FacilitiesInApt / SELECTION=STEPWISE SLE=0.1;
	MODEL Price=Year_Built	Year_Sold	Month_Sold	Size	Floor	N_Parking_G	N_Parking_B	TimeToSubway_1	TimeToBusStop_1	N_APT	N_PublicOffice	N_Hospital	N_Dpartmentstore	N_Mall	N_ETC	N_Park	N_Elementary	N_Middle	N_High	N_University	N_FacilitiesInApt / SELECTION=RSQUARE ADJRSQ CP;
RUN;


PROC REG DATA=test.data;
MODEL Price=N_FacilitiesInApt /CLB ALPHA=0.1;
RUN;

proc gplot data=test.data;
plot Price*Year_Built;
run;
