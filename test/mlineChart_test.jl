module TestMLineChart

using Base.Test
using JFinM_Charts

## test mline constructor
##-----------------------

kk = JFinM_Charts.MLineChart()

## test generic chart constructor
##-------------------------------

kk = JFinM_Charts.chart(JFinM_Charts.MLineChart,
                        width=900, height=400,
                        yScale="log", yLabel="gdp")

kk2 = JFinM_Charts.chart(JFinM_Charts.MLineChart,
                        width=900, height=400,
                        yScale="log", yLabel="gdp")

@test isequal(kk, kk2)

kk = JFinM_Charts.chart(JFinM_Charts.MLineChart, yLabel = "gdp")
kk2 = JFinM_Charts.MLineChart()
kk2.yLabel = "gdp"

@test isequal(kk, kk2)

## using non-existent property
@test_throws Exception JFinM_Charts.chart(JFinM_Charts.MLineChart, dkslf = "gdp")

## test chart command
##-------------------

## default settings
kk = JFinM_Charts.MLineChart()
JFinM_Charts.customChart(kk)

## log scale
kk = JFinM_Charts.chart(JFinM_Charts.MLineChart, yScale = "log")
JFinM_Charts.customChart(kk)

## wrong specification for y scale
kk = JFinM_Charts.chart(JFinM_Charts.MLineChart, yScale = "logg")
@test_throws Exception JFinM_Charts.customChart(kk)

JFinM_Charts.renderChart(JFinM_Charts.MLineChart(), "/tmp/gdp_data.csv")

##################
## defaultNames ##
##################

kk = JFinM_Charts.MLineChart()

expOut = ["/tmp/gdp_data.csv"]
actOut = JFinM_Charts.defaultDataNames("/tmp/gdp.html", kk)
@test expOut == actOut

end
