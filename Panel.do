*import long form panel data
import excel "C:\Users\Pooja Reddy\Desktop\THESIS\Panel_final_data.xlsx", sheet("Sheet1") firstrow
* Convert country as a categorical variable type
encode Country, gen (COUNTRY1)
* convert time as numeric variable type
destring Time, replace
* generate new time variable and convert it to monthly format 
gen timevar1 = mofd(Time)
format timevar1 %tm
* check the format of the newly generated time variable
list Time timevar1 in 1/10
* reset panel structure
xtset COUNTRY1 timevar1
* summary statistics for all variables
xtsum RiskTransfer MonthlyDeltarisk Precipitation AverageMeanSurfaceAirTempera Population GHGEmissionsCO2equivalents MonthlyPrimaryenergyconsumpti MonthlyElectricitygeneration
*find the skewness and kurtosis for all variables 
summarize RiskTransfer MonthlyDeltarisk Precipitation AverageMeanSurfaceAirTempera Population GHGEmissionsCO2equivalents MonthlyPrimaryenergyconsumpti MonthlyElectricitygeneration, detail
*check histograms
histogram RiskTransfer, bin(30) normal
* transform variables
gen log_risktransfer = log(RiskTransfer)
*check histograms of transformed variables
histogram log_risktransfer, bin(30) normal
*check skewness and kurtosis of transformed variables
summarize log_risktransfer, detail
* Swamy slope homogenity test to be done manually 
* Alternative: Pesaran & Yamagata (2008) Delta Test for slope homogenity 
 ssc install xthst
 xthst RiskTransfer Precipitation AverageMeanSurfaceAirTempera Population GHGEmissionsCO2equivalents MonthlyPrimaryenergyconsumpti MonthlyElectricitygeneration
 rename AverageMeanSurfaceAirTempera AirTemp
* cross sectional dependence tests among explanatory variables
 xtcd Precipitation AirTemp log_GHG log_energy log_population log_electricity
 drop if missing( timevar1 )
  xtcd2 Precipitation log_pop log_ghg log_energy_cons log_elec air_temp
* checking for correlation between risk transfer and independent variables 
corr RiskTransfer Precipitation AverageMeanSurfaceAirTempera Population GHGEmissionsCO2equivalents MonthlyPrimaryenergyconsumpti MonthlyElectricitygeneration
*checking for correlation between monthly delta risk and independent variables
corr MonthlyDeltarisk Precipitation AverageMeanSurfaceAirTempera Population GHGEmissionsCO2equivalents MonthlyPrimaryenergyconsumpti MonthlyElectricitygeneration
* testing for multicollinearity 
** running a pooled ols for Risk transfer
reg RiskTransfer Precipitation AverageMeanSurfaceAirTempera Population GHGEmissionsCO2equivalents MonthlyPrimaryenergyconsumpti MonthlyElectricitygeneration
** calculating multicollinearity for risk transfer 
vif
** running a pooled ols for monthly delta risk 
reg MonthlyDeltarisk Precipitation AverageMeanSurfaceAirTempera Population GHGEmissionsCO2equivalents MonthlyPrimaryenergyconsumpti MonthlyElectricitygeneration
** claculating multicollinearity for delta risk 
vif
* Cadf & Cips test for stationarity 

*====================================================
* Principal Component Analysis (PCA)
*====================================================

* Log transform variables used in PCA
gen log_POP = log(Population)
gen log_GHG = log(GHGEmissionsCO2equivalents)
gen log_energycons = log(MonthlyPrimaryenergyconsumpti)
gen log_elecprodn = log(MonthlyElectricitygeneration)

* Run PCA
pca log_POP log_GHG log_energycons log_elecprodn

* Generate first principal component
predict PC0, score

* Check variance explained
estat loadings
screeplot

* Test stationarity of PC0
pescadf PC0, lags(3)

* First difference if non-stationary
gen D_PC0 = D.PC0

* Rescale for interpretation
gen D_PC0_scaled = D_PC0*100

* Check stationarity after differencing
pescadf D_PC0_scaled, lags(3)
 ssc install pescadf
pescadf log_risk_transfer, lags(3)
pescadf log_GHG, lags(3)
pescadf log_population, lags(3)
pescadf Precipitation, lags(3)
pescadf AirTemp, lags(3)
pescadf log_monthly_delta_risk, lags(3)
pescadf log_energy, lags(3)
pescadf log_electricity , lags(3)

xtcips log_risk_transfer, maxlags(3) bglags(1)
xtcips log_GHG , maxlags(3) bglags(1)
xtcips log_population, maxlags(3) bglags(1)
xtcips Precipitation, maxlags(3) bglags(1)
xtcips AirTemp, maxlags(3) bglags(1)
xtcips log_monthly_delta_risk, maxlags(3) bglags(1) 
xtcips log_electricity, maxlags(3) bglags(1)
xtcips log_energy, maxlags(3) bglags(1)

*Taking First Difference for not stationary variables
gen D_log_GHG = D.log_GHG
gen D_log_population = D.log_population
 gen D_log_energy = D.log_energy
 * cadf tests for non stationary variables 
 pescadf D_log_GHG, lags(3)
 pescadf D_log_population, lags(3)
 pescadf D_log_energy, lags(3)
 * second generation - Westerlund (2007) Cointegration Test
 ssc install xtwest
 xtwest log_Riskcontrb Temp precpn log_POP log_GHG log_energycons log_elecprodn , lags(3)
 * Gt (Group-mean t-statistic), null rejected so some countries have a cointegrating relationship 
 * Ga (Group- mean ADF statistic), null rejected so some individual series are cointegrated
 * pt (panel test statistic), tests for entire panel jointly, null rejected, so long run relationship across all countries
 * pa (Panel adf statistic), has an adf style approach similar to pt, null rejected, so long run relationship across all countries
 
 * Dumitrescu-Hurlin panel Granger causality test
 xtgcause log_risk_transfer log_electricity, lags(3)
 xtgcause log_risk_transfer AirTemp, lags(3)
 xtgcause log_risk_transfer Precipitation, lags(3)
 xtgcause log_risk_transfer log_GHG, lags(3)
 xtgcause log_risk_transfer log_population, lags(3)
 xtgcause log_risk_transfer log_energy, lags(3)
 
 * FGLS for log_risk_transfer
 xtgls log_risk_transfer D_log_GHG D_log_population D_log_energy log_electricity AirTemp Precipitation, panels(heteroskedastic)
 
 * ARDL for log_risk_transfer
 ssc install xtpmg
 xtpmg d(log_risk_transfer) d(D_log_GHG D_log_population D_log_energy), lr(l.log_risk_transfer Precipitation AirTemp log_electricity) ec(ec) pmg replace
  * second generation - Westerlund (2007) Cointegration Test for monthly delta risk

  xtwest log_monthly_delta_risk D_log_GHG D_log_population D_log_energy log_electricity AirTemp Precipitation, lags(3)

 
 * FGLS for log_monthly_delta_risk
 xtgls log_monthly_delta_risk D_log_GHG D_log_population D_log_energy log_electricity Precipitation AirTemp, panels(heteroskedastic)
 
 * ARDL for log_monthly_delta_risk
 
 * fmols
 xtcointreg log_Riskcontrb log_GHG log_POP log_energycons log_elecprodn precpn Temp, est(fmols)
 *dols
 xtcointreg log_Riskcontrb log_GHG log_POP log_energycons log_elecprodn precpn Temp, est(dols)
 *ccr
 xtcointreg log_Riskcontrb log_GHG log_POP log_energycons log_elecprodn precpn Temp, est(ccr)
 
 * amg
 xtmg log_Riskcontrb log_GHG log_POP log_energycons log_elecprodn precpn Temp, aug
 
 *DK method
  xtscc log_Deltariskcontrbn D_PC1_scaled precpn Temp, lag(3)


 
 

