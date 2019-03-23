/*
Program reg_comb run OLS regression for all combination variables

regr_comb  depvar [treatment variables] [o: obligatory variables for all combination] [if statements], [reg options]

result write in new variables: varnam_b = coeficient, varnam_t - t  
*/

	capture program drop reg_comb
	program define reg_comb

	//dvar = dependent variable
	local dvar="`1'" 
	display "dependent variable: `dvar'"
	//varl = variables list for treatment variables
	  while "`2'" != "o:" && "`2'" != "" && "`2'" != "," && "`2'" != "if" {
			local varl = "`varl' `2'"
			local varln = `varln'+1
			mac shift
			}
	display "treatment variables: `varl'"		
			
	//ovar - obligatory variables, include for all combinations
	local ovarn =0
	if "`2'" == "o:"  {
			mac shift
			while "`2'" != "" && "`2'" != "," && "`2'" != "if" {
				local ovar = "`ovar' `2'"
				local ovarn = `ovarn'+1
				mac shift
							}
				}
				
	display "obligatory variables: `ovar'"				
	
	if "`2'" == "if"  {
			while "`2'" != "" && "`2'" != "," {
				local ifvar = "`ifvar' `2'"
				mac shift
							}
				}
	display "if statments: `ifvar'"
	
	mac shift
	while "`2'" != "" {
			local options = "`options' `2'"
			mac shift
			}
    display "options: `options'"				
			

	
	
			
			



	tuples `varl',   max(1)

	//create variables

	 forval i = 1/`ntuples'{
					capture confirm variable `tuple`i''_b
					if !_rc {							
							 qui replace `tuple`i''_b=.
							 qui replace `tuple`i''_t=.
							}						
						else {
							 qui gen `tuple`i''_b=.
							 qui gen `tuple`i''_t=.
							}
	   }
	   

	 if `ovarn'!=0 {
			tuples `ovar',   max(1)
		
			//create variables
			 forval i = 1/`ntuples'{
						 capture confirm variable `tuple`i''_b
							if !_rc {							
									 qui replace `tuple`i''_b=.
									 qui replace `tuple`i''_t=.
									}						
								else {
									 qui gen `tuple`i''_b=.
									 qui gen `tuple`i''_t=.
									}
						 
						 
								}
			}

	 capture confirm variable r2a
			if !_rc {						
					qui replace r2a=.
					}						
				else {
					qui gen r2a=.
					}
		



	tuples `varl' ,   max(`varln')	

	forval k = 1/`ntuples'{


	//qui reg `dvar' `tuple`k'' `ovar' `advar' , rob
	qui reg `dvar' `tuple`k'' `ovar' `advar' `ifvar', `options'
	matrix b = e(b)
	svmat b
	matrix v = e(V)
	svmat v
	matrix r = e(r2_a)
	svmat r

	local r2 = r1 in 1
	qui replace r2a = `r2' in `k'




	tuples `tuple`k'', max(1)  nosort

	local vn = `ntuples'+1
	 forval j = 1/`ntuples'{
					local jj = `vn'- `j'
					local q = b`jj' in 1
					qui replace `tuple`j''_b = `q' in `k'
					local se = v`jj' in `jj'
					qui	replace `tuple`j''_t = `q'/`se'^0.5 in `k'
					
	}
	if `ovarn'!=0 {
			tuples `ovar', max(1) 

			local vno = `ntuples'+1
			 forval j = 1/`ntuples'{
							local jj = `vno'- `j' + `vn'-1
							
							local q = b`jj' in 1
							qui replace `tuple`j''_b = `q' in `k'
							

							local se = v`jj' in `jj'
							qui replace `tuple`j''_t = `q'/`se'^0.5 in `k'
							
			}

	}
	local vn = `vn' + `ovarn'
	 forval j = 1/`vn' {
					drop b`j'
					drop v`j'
	}
	drop r1

	tuples `varl' ,   max(`varln')

	}


	end

		
