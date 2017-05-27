*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*This file uses the following analytic dataset to address several research
questions regarding happiness in countries around the world.

Dataset Name: H2015_Health_Suicide created in external file
STAT6250-02_s17-team-0_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets Happiness_yoy 
and H2015_Health_Suicide;
%include '.\STAT6250-02_s17-team-4_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
'Research Question: What are the top 20 happiest countries in 2016?'
;

title2
'Rationale: This answers some basics questions about the results of the research.'
;

footnote1
''
;

*
Note: This will use the Country and Happiness_Score from H2016_sorted_by_hscore.
 
Methodology: Use PROC PRINT on sorted 2016 data to get the top 20 countries
and their scores. Then use PROC SGPLOT to visuallize the happiness scores for
all countries. 

Limitations: These results are from one study which surveyed 157-158 countries
(out of 206 according the the UN).

Followup Steps: Look for other data sources.
;
proc print data=H2016_sorted_by_hscore(obs=20);
    var country happiness_score;
	label happiness_score="Happiness Score";
run;

title
'Happiness Scores by Country'
;
proc sgplot data=H2016_sorted_by_hscore;
    hbar country / response=happiness_score
        categoryorder=respdesc;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
'Research Question: Which variable contributes most in predicting the happiness score?'
;

title2
'Rationale: This will help identify what factor affects happiness the most.'
;

footnote1
''
;

*
Note: This will use the column Happiness_Score as the dependent variable and 
the rest of the variables from WorldHappiness2015 and WorldHappiness2016 as the
independent variables in a multiple linear regression.
 
Methodology: Use PROC REG to do a multiple linear regression. Use the p-values
to determine which variables are significant to the model.

Limitations: The regression model only looks at independent variables from the
happiness report.

Followup Steps: Re-run the regression with additional independent variables.
;
proc reg data=Happiness_yoy;
    model happiness_score = GDP family life_exp freedom trust;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
'Research Question: Is happiness inversely correlated to suicide rates?'
;

title2
'Rationale: One would expected a happier country to have a lower suicide rate. Is this true?'
;

footnote1
''
;

*
Note: This will use the column Y2015 from SuicideRates and column 
Happiness_Score from WorldHappiness2015.
 
Methodology: Use PROC CORR to calaculate the correlation between the two 
variables.

Limitations: The happiness score is an average by country. This may mask any
correlation between happiness and suicide rates.

Followup Steps: Look for and analyze data collected on individuals.
;
proc corr data=H2015_health_suicide plots=matrix(histogram);
    var happiness_score suicide_rate;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
'Research Question: How does Total Alcohol Consumption Per Capita correlate to happiness?'
;

title2
'Rationale: Some people drink to drown their sorrows. On the otherhand, happy people drink at celebrations. This could give insight how happiness affects drinking.'
;

footnote1
''
;

*
Note: This will use the column Alcohol_Consumption from HealthStats and 
Happiness_Score from WorldHappiness2015. 
 
Methodology: Use PROC CORR to calculate the correlation between the two 
variables.

Limitations: The correlation between happiness and alcohol maybe be weak.

Followup Steps: Try binning the alcohol consumpution into categories (high,
medium, low)
;
proc corr data=H2015_health_suicide plots=matrix(histogram);
    var happiness_score alcohol_consumption;
run;

title;
footnote;
