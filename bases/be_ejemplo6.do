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



* II. Estimación por intervalos:
*-----------------------------------------------------------------
h statistical_functions

/* Nota de la v.a t:
tden(df,t) 		-> devuelve P(t=t_0), t_0 es un valor.
t(df, t)		-> devuelve P(t<=t_0) de izquierda a derecha
ttail(df,t) 	-> devuelve P(t>t_0) de derecha a izquierda
invt(df,p)		-> devuelve el t_c para un alpha (acumulado de izq a der).
invttail(df,p) 	-> devuelve el t_c para un alpha (acumulado de der a izq)
*/


*LI -> beta1
display invt(33,0.025) // -2.0345153
display 28.42295-(0.6766084*2.0345153)

*LS -> beta1
display invt(33,0.975) // 2.0345153
display 28.42295+(0.6766084*2.0345153)

*LI -> beta2
*LS -> beta2



* III. Pruebas de hipótesis:
*-----------------------------------------------------------------



