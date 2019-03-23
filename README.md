# reg_comb
Stata program for computation all combinations regression of all variables

Program reg_comb run OLS regression for all combination variables

regr_comb  depvar [treatment variables] [o: obligatory variables for all combination] [if statements], [reg options]

result writes in new variables: varnam_b = coeficient, varnam_t - t-stat

To use program, put reg_comb.ado file into ../ado directoty (it stata don't see file, try to open it and run file)

