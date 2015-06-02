module TestVizExt

using Base.Test
using JFinM_Charts

## I do not yet have a chart implemented with external data that does
## not require some types that are defined in other packages only.
using TimeData
using Dates

##################
## Constructors ##
##################

chrt = JFinM_Charts.chart(JFinM_Charts.MLineChart)

dats = [Date(2014, 03, ii) for ii=1:30]
data = Timematr(rand(30, 1), dats)

dviz = JFinM_Charts.D3VizExt(data, chrt,
                             ["/tmp/JFinM_Charts_test.csv"])

## display
##--------

println("Test D3VizExt display method:")
display(dviz)

end
