*===============================================================================
*==========================   BASIC ECONOMETRICS   =============================
*===============================================================================
*Luis Chávez
*Copyright © 2025
*---


* I. Regresión simple:
*-----------------------------------------------------------------
clear all
global file "C:\Users\LENOVO\Downloads"
import delimited "$file/be_ejemplo6.csv", clear

describe

*Ajustando variables
rename (p qd) (precio cantidad)
label variable precio "precio/kg"
label variable cantidad "cantidad demandada (kg)"
summarize

*Generando variables
gen nivel=.
label variable nivel "tipo de precio"
replace nivel=0 if precio<=9.2
replace nivel=1 if precio>9.2
tab nivel

*Etiquetas de valor
label define tipo 0 "barato" 1 "caro"
label values nivel tipo
label list tipo

tab nivel

*Gráficos básicos
graph pie, over(nivel) plabel(_all percent)
twoway (scatter precio cantidad) (lfit precio cantidad)
graph bar, over(nivel)
histogram precio
graph box precio, over(nivel)
twoway (dropline precio cantidad)

*Correlación
corr precio cantidad

*Regresión OLS
regress precio cantidad

*Post-estimación
predict p_hat, xb
predict e, resid

*ANOVA
regress precio cantidad
*SCT
*SCE
*SCR

*R-cuadrado=SCE/SCT
display 441.533282/458.998856

*Root MSE=sqrt[SCR/(n-k-1)]
display (17.4655744/(34-1))^(1/2)

* Escalares en salidas
regress precio cantidad
ereturn list

*Más detalles básico:
* https://www.youtube.com/watch?v=8slTP4myjdU&t=135s