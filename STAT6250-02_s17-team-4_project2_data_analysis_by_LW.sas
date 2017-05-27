*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file is used to address several research questions regarding the dataset
2015-2016 world happiness report

Dataset Name: happiness_yoy_report in external file
STAT6250-02_s17-team-4_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that generates analytic datasets happiness_yoy_report;
%include '.\STAT6250-02_s17-team-4_project2_data_preparation.sas';



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question : What are the top 20 countries with the fastest GDP increase ? Which region contributes the largest number of countries among the top 20 ?'
;

title2
'Rationale : This gives us an insight into the economic growth of countries and regions that are developing rapidly in recent two years.'
;

footnote1
'Malawi has the largest rate at a 443% GDP increase from 2015-2016, followed by Burundi at a 346% increase. Tajikistan ranks at 20th, with a 25% increase in GDP.'
;

footnote2
'The frequency table indicates that 16 out of top 20 countries with the fastest GDP_increase are located in the Sub-Saharan Africa region.'
;

footnote3
'The reason why Sub-Saharan Africa countries have fastest GDP_increase is that their 2015 GDP is at a very low level. Therefore, the potential for those countries to expand their economy in the subsequent year is huge.'
;

*
Methodology : Use "proc sort" to arrange the variable "GDP_increase" in 
descending order, and then use the "obs=" option in "proc print" to only 
display the top 20 countries with fastest GDP increase. Use "proc freq" 
to calculate the frequency that each region accounts. 

Limitations : Some countries like Congo(Kinsha) and Zimbabwe have 0 GDP value
in these two years. As a result, the combined dataset contains missing value
for the new calculated variable GDP_increase when "merge" statement is used.

Followup Steps : Handle with missing values.
;

proc print data=GDP_sorted (obs=20);
	var country region GDP_increase;
run;

proc freq data=top20_GDP_increase;
	table region;
run;
title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question : Is the mean happiness score significantly different across the 4 major continents in the world ?'
;

title2
'Rationale : This studies the difference in happiness_score index by continents, which reflects a worldwide unequal development in the standard of living.'
;

footnote1
'Side-by-side boxplots indicate the average happiness_scores in America and Europe are higher that in Asia Pacific and Africa.'
;

footnote2
'The multiple comparison procedure (LSD) shows that the difference between the happiness_score in America and Europe is not significant. They both have a higher happiness_score than that in the Asia and Pacific region. The happiness_score in Africa is lower than any of the other major continents.'
;

footnote3
'The levene test indicates the homogeneity of variance assumption is valid by having a p-value at 0.2637. However, several outliers are spotted in the boxplot, and the shapiro test for residuals normality has a p-value at 0.0007. A further step of removing outliers should be considered in order to validate the model.'
;

*
Methodology : Use "proc format" to categorize the variable "region" 
into 4 groups including "Europe","Asia and Pacific","America","Africa",
and then use "proc glm" to perform one-way ANOVA on the response 
variable "happiness_score" to check if the mean happiness scores 
between these 4 major continents are significantly different.

Limitations : This dataset only contains information from 157-158 countries
or regions. We do not have information from other places, which might have
a great influence on the conclusion once their data is added. Hence this 
can only be used to roughly predict people's feeling of happiness on a 
global scale.

Followup Steps : Check model assumptions, and if it failed, alternative
models should be considered.
;

proc glm data=happiness_yoy_continents;
	class region;
	model happiness_score=region;
	means region/lsd;
	means region/hovtest=levene;
	output out=resids r=res;
run;

proc univariate normal plot;
	var res;
run;
title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question : Which variables can be used to predict the average life expectancy of each country ?'
;

title2
'Rationale : This helps us build up a model by which we are able to calculate the life expectancy once adequate information is obtained.'
;

footnote1
'In the output, GDP, Sanitation, Suicide_rate are the significant predictors for the response variable Age_Expectancy. Adjusted R-square is 0.8104, meaning that 81% of variation in the response variable can be explained from this regression model.'
;

footnote2
'In the diagnostic pltos, the residual points against all the predictors are randomly dispersed around the horizontal axis, and the model could be a good fit for the regressional analysis of Age_Expectancy.'
;

footnote3
'The model discussed above is just the additive model for regression. Thus, the interaction model should be further assessed. A model comparison could be used to determine the best fit of this regressional analysis.'
;

*
Methodology : Use "proc reg" to perform a multiple regression model
to see which independent variables including "Economy__GDP_per_Capita_",
"Alcohol_Consumption","Health","Sanitation","Suicide_Rate" are significant.

Limitations : Missing values are present in some of these variables
for particular countries.

Followup Steps : Handle with missing values.
;

proc reg data=H2015_health_suicide;
	model 
		Age_Expectancy=GDP Alcohol_Consumption Health 
	Sanitation Suicide_Rate
	;
run;
title;
footnote;



