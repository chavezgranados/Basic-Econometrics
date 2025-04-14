*================    Estabilidad paramétrica    ============================
*===========================================================================
* Fuente: Guarati & Porter, 5th.

*Luis Chávez
*2025

clear all
global data "C:\Users\LENOVO\Downloads"
import excel "$data/Table 8_9.xls", sheet("Table 8_9") cellrange(A5:C31) firstrow clear

*Seteo de series de tiempo
tsset YEAR, yearly

describe


*Regresión 1: 1970-1981
regress SAVINGS INCOME if YEAR<=1981
estimates store reg1

*Regresión 2: 1982-1995
regress SAVINGS INCOME if YEAR>=1982
estimates store reg2

*Regresión 3: 1970-1995
regress SAVINGS INCOME
estimates store reg3

twoway (scatter SAVINGS INCOME) (lfit SAVINGS INCOME) if YEAR<=1981, title("1970-1981")  name(g1, replace)
twoway (scatter SAVINGS INCOME) (lfit SAVINGS INCOME) if YEAR>=1982, title("1982-1995") name(g2, replace)
graph combine g1 g2, cols(2)

twoway (scatter SAVINGS INCOME if YEAR<=1981) ///
       (lfit SAVINGS INCOME if YEAR<=1981) ///
       || (scatter SAVINGS INCOME if YEAR>=1982, title("1970-1995")) ///
       (lfit SAVINGS INCOME if YEAR>=1982), ///
       xtitle(INCOME) ytitle(SAVINGS) ///
       legend(order(1 "1970-1981" 2 "Fit" 3 "1982-1995" 4 "Fit"))


esttab reg1 reg2 reg3, scalars(r2 N F mss) title("Comparación") collabels("1970-1981" "1982-1995" "1970-1995")

	  
*Test de Chow ------------------------------------------------------

*Paso 1: regress modelo 3
regress SAVINGS INCOME
*SCR_R= 23248.2982 (n-k)gl=26-2=24gl

*Paso 2: regress modelo 1
regress SAVINGS INCOME if YEAR<=1981
*SCR_1=  1785.0321 (n1-k)=12-2=10gl

*Paso 3: regress modelo 2
regress SAVINGS INCOME if YEAR>=1982
*SCR_1=10005.2207 (n2-k)=14-2=12gl

*Paso 4:
display 1785.0321+10005.2207
*SCR_NR=11790.253 (22gl)

*Paso 5: estadístico F de prueba (F_c)
display ((23248.2982-11790.253)/2)/(11790.253/22)

*Paso 6: valore críticos al 5%
display invFtail(2,22, 0.025)
*4.3827684
display invFtail(2,22, 0.975)
*0.02534697

*p-value
display Ftail(2,22,10.690059)

*Paso 7: decisión
*HO: estabilidad paramétrica (betas iguales en el modelos restringido).