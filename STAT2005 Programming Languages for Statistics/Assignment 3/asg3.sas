* Question 3;
/**
(a)	Incorrect. There is no such key word "CARDS3" in SAS; it should be either "CARDS" or "CARDS4"
(b)	Correct.
(c)	Incorrect. Identifier of filename does not accepts "." as part of the name (assume IN is the libref); it should be DATA IN.NEW_RECORD
(d)	Incorrect. The length of numeric variable cannot be 1; there is missing a "$" after the character variable list; there should not be short-cut forms of defined variables since variables should not have defined yet on before the LENGTH statement; it should be LENGTH A1 A2 A3 A C D B $ 12;
(e)	Correct.
(f)	Incorrect. There is no "." after "5 - 9" since it is reading data from column 5 to column 9 which is no "." in syntax; the order of comment block is reversed; (optional) there is a logical error in "C2 - C10 $2" which only C10 is defined as character variable; it should be INPUT _A C2 - C10 $2 L 5 - 9 /* L IS NUMERIC */;
(g)	Incorrect. There should be a pair of pair brackets or no brackets while apply format to multiple variables; it should be INPUT @5 (X2 - X5) (COMMA4) our INPUT @5 X2 - X5 COMMA4
(h)	Correct.
(i)	Incorrect. There should be a pair of quotion marks in indicating the file path; it should be INFILE "C:\DATA.TXT"; or INFILE 'C:\DATA.TXT';
(j)	Incorrect. The quotion mark should be consistent in pair; it should be LIBNAME A.B "C:\"; or LIBNAME A.B 'C:\';
**/

* Question 4;
* (i);
data PERSONNEL;
input ID $ 1 - 4 DEPT $ 1 @7 BIRTHDAY DATE9. YEAR 12 - 15 @19 SALARY COMMA8.2;
datalines;
A123   4Mar1989    8,60000
A037  23Jun1957   21,45000
M015  19Sep1977   17,50000
run;

* (ii);
data PERSONAL;
input ID $ +(-5) DEPT $1. +4 BIRTHDAY DATE9. +(-4) YEAR 4. SALARY COMMA8. /;
datalines;
A123  4Mar1989  8,6,00
***************
    A037 23Jun1957  21,450
**************
 M015 19Sep1977$17,500
***********
run;