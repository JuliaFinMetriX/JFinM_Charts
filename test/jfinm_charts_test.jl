module TestJFinM_Charts

using Base.Test
using JFinM_Charts

using TimeData
using Dates

## create sample data
dats = [Date(2001,1,1):Date(2001,1,30)]
data = Timematr(rand(30), dats)

## create custom chart
chrt = JFinM_Charts.chart(JFinM_Charts.MLineChart)

lh = JFinM_Charts.LocalHost()
JFinM_Charts.viz(data, chrt, lh)

tmpDir = joinpath(Pkg.dir("JFinM_Charts"), "test/tmp")
run(`rm -r -f $tmpDir`)

end
