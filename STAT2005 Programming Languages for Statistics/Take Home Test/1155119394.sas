* Question 3;
* (a);
data Q3;
length CITY $ 11;
input CITY $ & STATE $ COAST $ RATE;
datalines;
Denver  CO      West     9  ####
 Los Angeles     CA     West    23
San Diego  CA       West    10
   Atlanta      GA      South	  14
Dallas  TX 	South 18
  Washington     DC  South  11
Chicago     IL  North   14
   Cleveland    OH      North 16
Detroit    MI       North   16
 Madison        WI      North	   2
;
run;

* (b);
data Q3;
length CITY $ 11;
input CITY $ & STATE $ COAST $ RATE @@;
datalines;
Denver      CO      West     9 Los Angeles  CA		
  West  23  San Diego    CA     West    10
Atlanta  GA     South    14  Dallas	    TX   South	
18  Washington    DC         South 11
Chicago     IL		
   North    14  Cleveland   OH     North     16
Detroit     MI    North   16  Madison		
WI      North    2
;
run;

* (c);
data Q3;
length CITY $ 11;
input CITY $ & STATE $ COAST $ COAST $ RATE;
datalines;
Denver  CO    ##  West     9  ####
 Los Angeles     CA  #   West    23
San Diego  CA   ###    West    10
   Atlanta      GA   #   South	  14
Dallas  TX 	# South 18
  Washington     DC # South  11
Chicago     IL ## North   14
   Cleveland    OH  #    North 16
Detroit    MI  #     North   16
 Madison        WI   ###   North	   2
;
run;


* Question 4;
libname appoint "D:\";

* (a);
data appoint.Q4;
input TIME time5. LAST_NAME $ FULL_NAME $ 7 - 19 PLACE $ 22 - 35 SUBJECT $ 37 - 52 LENGTH_MEETING @69 CONFIRM $;
datalines;
11:00 Li Lan         Room 30        Personnel review 45 minutes     Yes
13:00 Leung Mei Fai  Leung's office Marketing        30 minutes     No
15:00 Mak David      Lab            Test results     20 minutes     Yes
;
run;

* (b);
data appoint.Q4;
length TIME 5 LAST_NAME FULL_NAME $ 13 PLACE $ 14;
input TIME time5. LAST_NAME $ @7 FULL_NAME $ & PLACE $ & SUBJECT $ 36 - 51 LENGTH_MEETING CONFIRM $3.;
datalines;
11:00 Li Lan      Room 30          Personnel review 45 Yes#
13:00 Leung Mei Fai  Leung's office  Marketing     30 No
15:00 Mak David     Lab            Test results      20 Yes
;
run;

* (c);
data appoint.Q4;
length TIME 6 LAST_NAME FULL_NAME $ 13 PLACE $ 14 SUBJECT $ 16;
input TIME time6. LAST_NAME $ @7 FULL_NAME $ & PLACE $ & SUBJECT $ & LENGTH_MEETING +4 CONFIRM $;
datalines;
11:00 Li Lan      Room 30       Personnel review  45 minsYes
 13:00Leung Mei Fai   Leung's office  Marketing     30 mins  No 
15:00 Mak David      Lab            Test results        20 mins  Yes
;
run;