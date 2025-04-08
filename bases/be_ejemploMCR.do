********  EJEMPLO 8.3 de Gujarati & Porter (5ed) ***
*---------------------------------------------------

*2025

clear all
global data "C:\Users\LENOVO\Downloads"
import excel "$data/Table 8_8.xls", sheet("Table 8_8") cellrange(A5:D25) firstrow clear

drop YEAR
rename GDP y
rename Employment l
rename CAPITAL k

*Regresión no retringida -------------------
gen l_y=ln(y)
gen l_l=ln(l)
gen l_k=ln(k)

regress l_y l_l l_k
*R2(MNR)=0.9951


*Regresión retringida -----------------------
gen ry=y/l
gen rk=k/l

gen lry=ln(ry)
gen lrk=ln(rk)

regress lry lrk
*R2(MR)=0.9777


*Prueba de hipótesis ------------------------
*H0: b2+b3=1
*H1: b2+b3!=1

*F_calculado
display (0.01662887-.01360456)/((0.01360456)/(20-3))
* NOTA: dado que la v. dependiente no es la misma, no se puede usar F=f(R^2):
*display (0.9951-0.9777)/((1-0.9951)/(20-3)) //no es el mismo resultado

*F críticos (2 colas)
display invF(1,17,0.025)
*0.0010114
display invFtail(1,17,0.025)
*6.0420133