*------------------- INEI - ENDES ----------------------
**------------------------------------------------------
* Módulo 1638 - peso y talla
* Cuestionario REC44


keep HW1 HW2 HW3 HW53

rename HW1 edad
label variable edad "edad en meses"

rename HW2 pes
label variable pes kg

rename HW3 tall
label variable tall cm

rename HW53 hemo
label variable hemo "hemoglobina g/dl"
drop if hemo==999

summ tall
drop if tall==9999
histogram tall
gen talla=tall/10

summ pes
drop if pes==999
histogram pes
gen peso=pes/10

graph matrix peso talla hemo edad
twoway (scatter peso talla)
twoway (scatter hemo peso)
twoway (scatter talla edad)
twoway (scatter peso talla) (lfit peso talla) (qfit peso talla)
twoway (scatter talla edad) (qfit talla edad)

*Continuación con peso y talla:
regress peso talla
gen talla2=talla^2
regress peso talla talla2
predict peso_hat, xb
twoway (scatter peso_hat talla)

twoway (scatter edad peso)
