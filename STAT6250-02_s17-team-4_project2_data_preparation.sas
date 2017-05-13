*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] Happiness2015
[Dataset Description] The 2015 World Happiness Report is a survey of the state 
of global happiness.The happiness scores and rankings use data from the Gallup 
World Poll.
[Experimental Unit Description] Select countries in 2015
[Number of Observations] 158                    
[Number of Features] 12
[Data Source] https://www.kaggle.com/unsdsn/world-happiness/downloads/2015.csv
[Data Dictionary] https://www.kaggle.com/unsdsn/world-happiness
[Unique ID Schema] The column "country"ù is a primary key, which is equivalent 
to the unique ID column "country"ù in dataset Happiness2016, and also 
equivalent to the unique ID column "country"ù in dataset SuicideRates
--
[Dataset 2 Name] Happiness2016
[Dataset Description] The 2016 World Happiness Report is a survey of the state 
of global happiness.The happiness scores and rankings use data from the Gallup 
World Poll.
[Experimental Unit Description] Select countries in 2016
[Number of Observations] 157                    
[Number of Features] 13
[Data Source] https://www.kaggle.com/unsdsn/world-happiness/downloads/2016.csv
[Data Dictionary] https://www.kaggle.com/unsdsn/world-happiness
[Unique ID Schema] The column "country"ù is a primary key, which is equivalent
to the unique ID column "country"ù in dataset Happiness2015
--
[Dataset 3 Name] HealthStats
[Dataset Description] World Health Statistics 2016 Report, Annex B: Tables of 
health statistics by country, WHO region and globally
[Experimental Unit Description] Countries
[Number of Observations] 193  
[Number of Features] 20
[Data Source] The original dataset 
http://www.who.int/entity/gho/publications/world_health_statistics/2016/whs2016_AnnexB.xls?ua=1 
was downloaded and editted. Variables from years that did not include 2015 were
deleted and variable names were created from the column headers.
[Data Dictionary] https://github.com/stat6250/team-4_project2/blob/master/whs2016_AnnexB-edit_Data_Dictionary.rtf
[Unique ID Schema] The column "country"ù is a primary key, which is equivalent 
to the unique ID column "country"ù in dataset Happiness2015
--
[Dataset 4 Name] SuicideRates
[Dataset Description] Age-standardized suicide rates (per 100,000 population) 
from the World Health Organization (WHO) for 2000, 2005, 2010, and 2015
[Experimental Unit Description] Countries
[Number of Observations] 183                 
[Number of Features] 5
[Data Source] The file 
http://apps.who.int/gho/athena/data/GHO/MH_12?format=csv"
was downloaded and editted to remove rows for men and women, leaving just the 
rows for "both sexes".
[Data Dictionary] http://apps.who.int/gho/indicatorregistry/App_Main/view_indicator.aspx?iid=78
[Unique ID Schema] The column "country"ù ù is a primary key, which is 
equivalent to the unique ID column "country"ù ù in dataset Happiness2015
;

* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat6250/team-4_project2/blob/master/data/2015.csv?raw=true
;
%let inputDataset1Type = CSV;
%let inputDataset1DSN = Happiness2015_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-4_project2/blob/master/data/2016.csv?raw=true
;
%let inputDataset2Type = CSV;
%let inputDataset2DSN = Happiness2016_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-4_project2/blob/master/data/whs2016_AnnexB-edit.xls?raw=true
;
%let inputDataset3Type = XLS;
%let inputDataset3DSN = HealthStats_raw;

%let inputDataset4URL =
https://github.com/stat6250/team-4_project2/blob/master/data/MH_12-edit.xls?raw=true
;
%let inputDataset4Type = XLS;
%let inputDataset4DSN = SuicideRates_raw;


* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset3DSN.,
    &inputDataset3URL.,
    &inputDataset3Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset4DSN.,
    &inputDataset4URL.,
    &inputDataset4Type.
)


* sort and check raw datasets for duplicates with respect to their unique ids,
  removing blank rows, if needed;
proc sort
        nodupkey
        data=Happiness2015_raw
        dupout=Happiness2015_raw_dups
        out=Happiness2015_raw_sorted
    ;
    by
        Country
    ;
run;
proc sort
        nodupkey
        data=Happiness2016_raw
        dupout=Happiness2016_raw_dups
        out=Happiness2016_raw_sorted
    ;
    by
        Country
    ;
run;
proc sort
        nodupkey
        data=HealthStats_raw
        dupout=HealthStats_raw_dups
        out=HealthStats_raw_sorted
    ;
    by
        Country
    ;
run;
proc sort
        nodupkey
        data=SuicideRates_raw
        dupout=SuicideRates_raw_dups
        out=SuicideRates_raw_sorted
    ;
    by
        Country
    ;
run;

