Timeseries rolling theree day averages by county

github
https://tinyurl.com/ycwl47nq
https://github.com/rogerjdeangelis/utl-timeseries-rolling-three-day-averages-by-county

R has many timeseries packages, do your homework. I did not.

SAS Forum
https://tinyurl.com/y9ss545e
https://communities.sas.com/t5/SAS-Programming/Autofilling-a-list-of-dates-in-a-specific-range-from-partial/m-p/642759

Other timeseries repos (sas and R)
https://github.com/rogerjdeangelis?tab=repositories&q=moving&type=&language=
https://github.com/rogerjdeangelis?tab=repositories&q=rolling&type=&language=

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
   input county $ date :mmddyy10. value1 value2 total;
   format date mmddyy10.;
cards4;
CountyA 03/02/2020 2 0 1
CountyA 03/03/2020 1 1 0
CountyA 03/05/2020 2 2 2
CountyA 03/09/2020 1 1 2
CountyA 03/11/2020 1 2 3
CountyB 03/02/2020 1 0 1
CountyB 03/04/2020 4 1 5
CountyB 03/06/2020 2 1 3
CountyB 03/09/2020 1 1 2
CountyB 03/11/2020 1 2 3
CountyB 03/12/2020 1 0 1
;;;;
run;quit;

                                                      | RULES
 SD1.HAVE total obs=11                                | =====               Original  Three
                                                      |                        Zero   Day
 Obs    COUNTY        DATE       VALUE1 VALUE2 TOTAL  | COUNTY        DATE     Fill   Avg
                                                      |
   1    CountyA    03/02/2020       2      0     1    | CountyA    03/02/2020    1    0.00   0.00  not enough data
   2    CountyA    03/03/2020       1      1     0    | CountyA    03/03/2020    0    0.00   0.00  not enough data
                                                        CountyA    03/04/2020    0    0.33   0.33  (0+0+1)/3
   3    CountyA    03/05/2020       2      2     2    | CountyA    03/05/2020    2    0.67   0.67  (0+0+2)/3
                                                      | CountyA    03/06/2020    0    0.67   0.67  (0+2+0)/3
                                                      | CountyA    03/07/2020    0    0.67   0.67  (2+0+0)/3
                                                      | CountyA    03/08/2020    0    0.00   0.00  (0+0+0)/3
   4    CountyA    03/09/2020       1      1     2    | CountyA    03/09/2020    2    0.67   0.67  (0+0+2)/3
                                                      | CountyA    03/10/2020    0    0.67   0.67  (0+2+0)/3
   5    CountyA    03/11/2020       1      2     3    | CountyA    03/11/2020    3    1.67   1.67  (2+0+3)/3
                                                      | CountyA    03/12/2020    0    1.00   1.00  (0+3+0)/3 Note not in CountyA
                                                                                                             Makes each county cover the
                                                                                                             same dates

   6    CountyB    03/02/2020       1      0     1    |
   7    CountyB    03/04/2020       4      1     5    |
   8    CountyB    03/06/2020       2      1     3    |
   9    CountyB    03/09/2020       1      1     2    |
  10    CountyB    03/11/2020       1      2     3    |
  11    CountyB    03/12/2020       1      0     1    |

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

WANT total obs=22

Obs    COUNTY        DATE       VALUE1    VALUE2    TOTAL

  1    CountyA    03/02/2020     0.00      0.00     0.00
  2    CountyA    03/03/2020     0.00      0.00     0.00
  3    CountyA    03/04/2020     1.00      0.33     0.33
  4    CountyA    03/05/2020     1.00      1.00     0.67
  5    CountyA    03/06/2020     0.67      0.67     0.67
  6    CountyA    03/07/2020     0.67      0.67     0.67
  7    CountyA    03/08/2020     0.00      0.00     0.00
  8    CountyA    03/09/2020     0.33      0.33     0.67
  9    CountyA    03/10/2020     0.33      0.33     0.67
 10    CountyA    03/11/2020     0.67      1.00     1.67
 11    CountyA    03/12/2020     0.33      0.67     1.00
 12    CountyB    03/02/2020     0.00      0.00     0.00
 13    CountyB    03/03/2020     0.00      0.00     0.00
 14    CountyB    03/04/2020     1.67      0.33     2.00
 15    CountyB    03/05/2020     1.33      0.33     1.67
 16    CountyB    03/06/2020     2.00      0.67     2.67
 17    CountyB    03/07/2020     0.67      0.33     1.00
 18    CountyB    03/08/2020     0.67      0.33     1.00
 19    CountyB    03/09/2020     0.33      0.33     0.67
 20    CountyB    03/10/2020     0.33      0.33     0.67
 21    CountyB    03/11/2020     0.67      1.00     1.67
 22    CountyB    03/12/2020     0.67      0.67     1.33


*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;

%utl_submit_r64('
library(haven);
library(dplyr);
library(tidyr);
library(zoo);
library(SASxport);
library(lubridate);
have<-read_sas("d:/sd1/have.sas7bdat");
have;
filday <- have %>%
  complete(nesting(COUNTY), DATE = seq(min(DATE), max(DATE), by = "day"));
filday[is.na(filday)] <- 0;
myfun = function(x) rollmean(x, k = 3, fill = 0, align = "right");
filday %>%
   group_by(COUNTY) %>%
   mutate_each(funs(myfun), VALUE1, VALUE2, TOTAL)
   -> want;
str(want);
want<-as.data.frame(want);
want;
write.xport(want,file="d:/xpt/want.xpt");
');

libname xpt xport "d:/xpt/want.xpt";
data want ;
  retain county;
  format date mmddyy10. value1 value2 total 6.2;
  set xpt.want;
run;quit;
libname xpt clear;



