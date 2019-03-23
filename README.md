# reg_comb
Stata program for computation all combinations regression of all variables

Program reg_comb run OLS regression for all combination variables

regr_comb  depvar [treatment variables] [o: obligatory variables for all combination] [if statements], [reg options]

result writes in new variables: varnam_b = coeficient, varnam_t - t-stat

Exmpales:

reg_comb y x1 x2 x3
reg_comb y x1 x2 x3 o: x4 x5 if year>2015, rob



To use program, put reg_comb.ado file into ../ado directoty (it stata don't see file, try to open it and run file)

