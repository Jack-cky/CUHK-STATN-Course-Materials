libname project '/folders/myfolders/The Chinese University of Hong Kong/STAT3011 Workshop on Data Analysis and Statistical Computing';

proc import datafile = '/folders/myfolders/The Chinese University of Hong Kong/STAT3011 Workshop on Data Analysis and Statistical Computing/OD.xlsx'
	out = project.md dbms = xlsx replace;
	sheet = 'apartment data';
run;

/* modify of the data file */
data project.md;
	set project.md;
	Year_Old = Year_Sold - Year_Built;
	N_Parking = N_Parking_G + N_Parking_B;
	School = N_Elementary + N_Middle + N_High + N_University;
	
	if TimeToSubway = '0~5min' then
		TimeToSubway = 1 * mean((5 - 0)/2);
		else if TimeToSubway = '5min~10min' then
			TimeToSubway = 2 * mean((10 - 5)/2);
		else TimeToSubway = 3 * mean((15 - 10)/2);
		
	if TimeToBusStop = '0-5min' then
		TimeToBusStop = 1 * mean((5 - 0)/2);
		else if TimeToBusStop = '5min~10min' then
			TimeToBusStop = 2 * mean((10 - 5)/2);
		else if TimeToBusStop = '10min~15min' then
			TimeToBusStop = 3 * mean((15 - 10)/2);
		else if TimeToBusStop = '15min~20min' then
			TimeToBusStop = 4 * mean((20 - 15)/2);
		else TimeToBusStop = .;
	
	AvgTime = mean(TimeToSubway, TimeToBusStop);
run;

proc corr data = project.md pearson;
	var Year_Old Size Floor N_Parking N_FacilitiesInApt N_APT -- N_Park School AvgTime;
	with Price;
run;

* model selection???????; 
proc reg data = project.md;
	model Price = Size Floor N_Parking N_FacilitiesInApt N_APT N_Dpartmentstore N_Mall N_Park / selection = rsquare adjrsq cp;
	model Price = Size Floor N_Parking N_FacilitiesInApt N_APT N_Dpartmentstore N_Mall N_Park / selection = stepwise sle = 0.05;
run;

proc reg data = project.md plots=none;
	model Price = Size Floor N_Parking N_FacilitiesInApt N_APT N_Dpartmentstore N_Mall N_Park / clb alpha = 0.05 vif;
	model Price = Size N_Parking N_FacilitiesInApt N_APT N_Dpartmentstore N_Mall N_Park / clb alpha = 0.05 vif;
	model Price = Size Floor N_FacilitiesInApt N_APT N_Dpartmentstore N_Mall N_Park / clb alpha = 0.05 vif;
	model Price = Size Floor N_Parking N_FacilitiesInApt N_APT N_Dpartmentstore N_Park / clb alpha = 0.05 vif;
	model Price = Size Floor N_FacilitiesInApt N_APT N_Dpartmentstore N_Park / clb alpha = 0.05 vif;
run;

proc reg data = project.md;
	model Price = Size Floor N_Parking N_FacilitiesInApt N_APT N_Dpartmentstore N_Mall N_Park / dw;
	plot residual.*obs.;
run;






proc sgplot data = project.md;
	vbar Price = mean(TimeToSubway) / group = TimeToSubway groupdisplay = cluster grouporder = data dataskin = crisp;
run;

proc sgplot data = project.md;
	vbar TimeToBusStop / group = TimeToBusStop groupdisplay = cluster grouporder = data dataskin = crisp;
run;





proc reg data = project.md;
	model Price = Year_Old Size Floor N_Parking N_FacilitiesInApt / selection = rsquare adjrsq cp;
	model Price = Year_Old Size Floor N_Parking N_FacilitiesInApt / selection = stepwise sle = 0.05;
run;


proc reg data = project.md;
	model Price = Year_Old Size Floor N_Parking N_FacilitiesInApt / clb alpha = 0.05 vif;
run;



proc sgscatter data = project.md;
	matrix Price Year_Old Size Floor N_Parking N_FacilitiesInApt / diagonal = (histogram kernel);
run;


proc reg data = project.md;
	model Price = Year_Old Size Floor N_Parking N_FacilitiesInApt / vif;
	model Price = Year_Old Size Floor N_Parking N_FacilitiesInApt / dw ;
run;



/* summary statistics */
proc means data = summary.md min p25 p50 p75 max maxdec = 2;
	var Price Year_Old Size Floor N_Parking_G N_Parking_B N_APT -- N_FacilitiesInApt;
run;

proc tabulate data = summary.md;
	class TimeToSubway TimeToBusStop / missing;
	table TimeToSubway TimeToBusStop, n pctn;
run;

/* correlation for inner factors */
proc corr data = project.md pearson;
	var Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt;
	with Price;
run;

/* correlation for outer factors */
proc corr data = project.md pearson;
	var N_APT -- N_University;
	with Price;
run;

/* regression selection for inner factor */
proc reg data = project.md;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / selection = rsquare adjrsq cp;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / selection = stepwise sle = 0.05;
run;

/* regression selection for outer factor */
proc reg data = project.md;
	model Price = N_APT -- N_University / selection = rsquare adjrsq cp;;
	model Price = N_APT -- N_University / selection = stepwise sle = 0.05;
run;

/* regression for inner factor */
proc reg data = project.md;
	model Price = Year_Old Size Floor N_Parking_G N_Parking_B N_FacilitiesInApt / clb alpha = 0.05;
run;

/* regression for outer factor */
proc glm data = project.md;
	class TimeToSubway TimeToBusStop;
	model Price = TimeToSubway TimeToBusStop N_APT -- N_University / solution alpha = 0.05;
run;

/* scatter plot for inner */
proc sgplot data = summary.md;
	scatter Y = Price X = Year_Old;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = Size;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = Floor;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_Parking_G;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_Parking_B;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_FacilitiesInApt;
run;

/* scatter plot for outer */
proc sgplot data = summary.md;
	scatter Y = Price X = TimeToSubway;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = TimeToBusStop;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_APT;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_PublicOffice;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_Hospital;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_Dpartmentstore;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_Mall;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_ETC;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_Park;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_Elementary;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_Middle;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_High;
run;

proc sgplot data = summary.md;
	scatter Y = Price X = N_University;
run;
