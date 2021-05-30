libname project '/folders/myfolders/The Chinese University of Hong Kong/STAT2011 Workshop on Data Exploration and Technical Writing';

proc import datafile = '/folders/myfolders/The Chinese University of Hong Kong/STAT2011 Workshop on Data Exploration and Technical Writing/Data.xlsx'
	out = project.data dbms = xlsx replace;
	sheet = 'Sheet2';
run;

* tissue - toilet;
proc import datafile = '/folders/myfolders/The Chinese University of Hong Kong/STAT2011 Workshop on Data Exploration and Technical Writing/Data.xlsx'
	out = project.data2 dbms = xlsx replace;
	sheet = 'Sheet4';
run;

* kitchen - tissue;
proc import datafile = '/folders/myfolders/The Chinese University of Hong Kong/STAT2011 Workshop on Data Exploration and Technical Writing/Data.xlsx'
	out = project.data3 dbms = xlsx replace;
	sheet = 'Sheet3';
run;

proc sgplot data = project.data;
	title1 "Water Absorption Test Values by Treatment";
	vbox amount / category = type group = type;
	xaxis label = "Treatment";
	yaxis label = "Amount of Absorption";
	keylegend / title = "Type of Papaer";
run;

proc anova data = project.data;
	class type;
	model  amount = type;
	means type / hovtest welch;
run;

proc means data = project.data n mean stderr min max lclm uclm alpha = 0.05 vardef = df maxdec = 2;
	var amount;
	by type;
run;

proc univariate data = project.data normal;
var amount;
qqplot;
run;

* tissue - toilet;
proc ttest data = project.data2 h0 = 0 alpha = 0.05 side = 2;
	class type;
	var amount;
run;

* kitchen - tissue;
proc ttest data = project.data3 h0 = 0 alpha = 0.05 side = u;
	class type;
	var amount;
run;