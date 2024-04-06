filename F1 "C:\Users\kathe\Downloads\Project1_Data-1-1.xlsx";

proc import DATAFILE = F1
OUT = Work.Initial_study_project1 (rename =(A=PID B=Age C = State D = Length_of_Stay E = Total_Charge F = Initial_Sugar))
DBMS = XLSX
Replace;
Getnames = NO;
Sheet = Intial_Study_Project1;
run;

proc print data = Work.Initial_study_project1; run;

proc import DATAFILE = F1
OUT = Work.Second_study_project (rename =(A = PID B = After_Sugar))
DBMS = XLSX
Replace;
Getnames = NO;
Sheet = Second_Study_Project1;
run;

proc print data = Work.Second_study_project;
run;

Data Drug_A;
merge Work.Initial_study_project1 Work.Second_study_project;
run;

proc print data = Drug_A;
run;

proc surveyselect data = Drug_A
method= SRS
sampsize=1000
out= Results;
run;

proc print data = Results;
run;

Proc Corr data = Results; 
Var Initial_Sugar After_Sugar;
With Age;
run;

Proc freq data = Results;
table Total_Charge*State;
run;

proc sgplot data = Results;
title 'Age v. After_Sugar';
yaxis label= 'After_Sugar';
xaxis label= 'Age';
reg x = Age y =After_Sugar /
lineattrs = (color=red thickness =2)
markerattrs=(Color = black);
run;

proc sgplot data = Results;
title 'Age v. Initial_Sugar';
yaxis label= 'Initial_Sugar';
xaxis label= 'Age';
reg x = Age y =Initial_Sugar /
lineattrs = (color=red thickness =2)
markerattrs=(Color = black);
run;

proc GLM data = Results;
Class State;
Model Initial_Sugar =State;
MEANS State Initial_Sugar;
title 'Initial_Sugar v. State';
Run;

proc GLM data = Results;
Class State Total_Charge;
Model After_Sugar = Total_Charge*State;
MEANS State Total_Charge After_Sugar;
title 'After_Sugar based on Total Charge by State';
Run;

Proc means data = Results;
VAR Initial_Sugar After_Sugar;
run;

proc chart data = Results;
PIE Initial_Sugar; 
Run;

proc chart data = Results;
PIE After_Sugar; 
Run;
