module TestAbstractFuncs

using Base.Test
using JFinM_Charts

## test display
##-------------

println("Test display method:")
kk = JFinM_Charts.chart(JFinM_Charts.MLineChart, width=1200)
JFinM_Charts.display(kk)

## test isequal
##-------------

kk = JFinM_Charts.chart(JFinM_Charts.MLineChart, width=1200)
kk2 = JFinM_Charts.chart(JFinM_Charts.MLineChart, width=1200)
kk3 = JFinM_Charts.chart(JFinM_Charts.MLineChart, width=230)

@test isequal(kk, kk2)
@test !isequal(kk, kk3)

## test unequal for different chart type
## kk4 = JFinM_Charts.chart(VineTreeChart)
## @test !isequal(kk, kk4)

end
