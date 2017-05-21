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
*
Question: Which variable contributes most in predicting the happiness score? 

Rationale: This will help identify what factor affects happiness the most. 

Note: This will use the column Happiness_Score as the dependent variable and 
the rest of the variables from WorldHappiness2015 and WorldHappiness2016 as the
independent variables in a multiple linear regression.
 
Methodology: Use PROC REG to do a multiple linear regression. Use the p-values
to determine which variables are significant to the model.

Limitations: The linear regression model assumes the relationships between
variable to be linear.

Followup Steps:
;
proc reg data=Happiness_yoy;
	model happiness_score = GDP family life_exp freedom trust generosity;
run;
delete generosity;
print;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Is happiness inversely correlated to suicide rates? 

Rationale: One would expected a happier country to have a lower suicide rate. 
Is this true?

Note: This will use the column Y2015 from SuicideRates and column 
Happiness_Score from WorldHappiness2015.
 
Methodology: Use PROC CORR to calaculate the correlation between the two 
variables.

Limitations: Finding a correlation does not mean that one factor causes another.

Followup Steps:
;
proc corr data=H2015_health_suicide plots=matrix(histogram);
	var happiness_score suicide_rate;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: How does Total Alcohol Consumption Per Capita correlate to happiness? 

Rationale: Some people drink to drown their sorrows. On the otherhand, happy 
people drink at celebrations. This could give insight how happiness affects 
drinking.

Note: This will use the column Alcohol_Consumption from HealthStats and 
Happiness_Score from WorldHappiness2015. 
 
Methodology: Use PROC CORR to calaculate the correlation between the two 
variables.

Limitations: Finding a correlation does not mean that one factor causes another.

Followup Steps:
;
proc corr data=H2015_health_suicide plots=matrix(histogram);
	var happiness_score alcohol_consumption;
run;
