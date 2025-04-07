*====================  REGRESIÓN MULTIPLE ========================
*=================================================================
* Ejemplo 7
* Fuente: Stock & Watson (CollegeDistance)

*Luis Chávez

clear all
global base "C:\Users\LENOVO\Downloads"
use "$base/be_ejemplo07.dta", clear
describe

* 1. Preámbulo ---------------------------------------------------
*-----------------------------------------------------------------

rename ed educ
rename female mujer
rename black negro
rename hispanic hispano
rename bytest punt
rename dadcoll padre_uni
rename momcoll madre_uni
rename incomehi ingalt
rename ownhome propie
rename urban urbano
rename cue80 desemp
rename stwmfg80 salar
rename dist dist
rename tuition matric

label variable educ "Años de educación completados"
label variable mujer "Sexo: 1 = Mujer, 0 = Hombre"
label variable negro "Etnia: 1 = Negro, 0 = No negro"
label variable hispano "Etnia: 1 = Hispano, 0 = No hispano"
label variable punt "Puntaje base en prueba"
label variable padre_uni "1 = Padre con universidad, 0 = Sin universidad"
label variable madre_uni "1 = Madre con universidad, 0 = Sin universidad"
label variable ingalt "1 = Ingreso > $25,000, 0 = ≤ $25,000"
label variable propie "1 = Propietario, 0 = No propietario"
label variable urbano "1 = Escuela en área urbana, 0 = No urbana"
label variable desemp "Tasa de desempleo del condado en 1980"
label variable salar "Salario por hora en manufactura (1980)"
label variable dist "Distancia a universidad (decenas de millas)"
label variable matric "Matrícula promedio en universidad pública ($1000's)"


label define sexo 0 "Hombre" 1 "Mujer"
label define etnia_negro 0 "No negro" 1 "Negro"
label define etnia_hispano 0 "No hispano" 1 "Hispano"
label define universidad 0 "No universitario" 1 "Universitario"
label define ingreso 0 "≤ $25,000" 1 "> $25,000"
label define propiedad 0 "No propietario" 1 "Propietario"
label define ubicacion 0 "No urbano" 1 "Urbano"

* Etiquetas de valor
label values mujer sexo
label values negro etnia_negro
label values hispano etnia_hispano
label values padre_uni universidad
label values madre_uni universidad
label values ingalt ingreso
label values propie propiedad
label values urbano ubicacion


* 2. Missing -----------------------------------------------------
*-----------------------------------------------------------------
misstable summarize

list educ mujer negro hispano if missing(educ) | missing(mujer) | missing(negro) | missing(hispano)

egen falta = rowmiss(educ mujer negro hispano punt)
replace falta = falta > 0
label variable falta "1 = Falta algún valor, 0 = No falta ninguno"



* 3. Outliers -----------------------------------------------------
*------------------------------------------------------------------
*ssc install winsor2
winsor2 dist, replace cuts(1 99)


* 4. Gráficos -----------------------------------------------------
*------------------------------------------------------------------
foreach var in educ punt desemp salar dist matric {
graph box `var', title("Boxplot de `var'") name(box_`var', replace)
}

graph box educ punt desemp salar dist matric, title("Boxplot de Variables") legend(position(6) size(small) cols(2)) // no se recomienda si las UM son diferentes


foreach var in desemp salar dist matric {
	scatter `var' punt, ///
    title("Relación entre `var' y Educación") ///
    xlabel(, angle(45)) ///
    ylabel(, angle(0)) ///
    msize(small) legend(off)
}

graph matrix educ punt desemp salar dist matric, title("Matriz de dispersión")


* 5. Python -------------------------------------------------------
*------------------------------------------------------------------
python
import numpy as np 
a=34
b=12
c=a+b
c
vector1 = np.array([2, 3, 4])
vector2 = np.array([5, 1, 2])
vector3=vector1+vector2
vector3
print("Vector resultante:", vector3)
end


* 6. Descriptivas ----------------------------------------------------
*------------------------------------------------------------------
summ
sum educ punt, detail
tabstat educ punt, stat(mean sd var min max) col(stat)
tabstat educ punt desemp, stat(mean sd var min max) col(stat) by(urbano)
table urbano mujer, stat(mean punt)
table urbano mujer hispano, stat(mean punt)



* 6. Regresión ----------------------------------------------------
*------------------------------------------------------------------

* Modelo 1
regress educ dist mujer negro hispano punt padre_uni madre_uni ingalt propie urbano desemp salar matric
estimates store modelo1

* Modelo 2
regress educ dist mujer negro hispano punt padre_uni madre_uni ingalt propie desemp salar matric
estimates store modelo2

* Modelo 3
regress educ dist mujer negro hispano punt padre_uni madre_uni ingalt propie desemp salar
estimates store modelo3

*Modelo 4
gen urb_salar=urban*salar //interacción
regress educ dist mujer negro hispano punt padre_uni madre_uni ingalt propie desemp salar urb_salar
estimate store modelo4

estat ic
estimates dir

esttab modelo1 modelo2 modelo3 modelo4, b(%9.4f) se //con ee
esttab modelo1 modelo2 modelo3 modelo4, b(%9.4f) //con t_c
esttab modelo1 modelo2 modelo3 modelo4, b(%9.4f) nostar
esttab modelo1 modelo2 modelo3 modelo4, b(%9.4f) r2 aic(%8.2f) bic(%8.2f)

*Mejor modelo: modelo3
regress educ dist mujer negro hispano punt padre_uni madre_uni ingalt propie desemp salar



