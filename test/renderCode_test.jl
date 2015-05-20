module TestRenderCode

using Base.Test
using JFinM_Charts

## test d3 loading code
##---------------------

testPath = "../d3"
expOut = "<script src=\"$testPath/d3.min.js\"></script>\n"
@test expOut == JFinM_Charts.dthreeCode(testPath)

d3Url = "http://d3js.org/d3.v3.min.js"
expOut = "<script src=\"$d3Url\"\ncharset=\"utf-8\"></script>\n"
@test expOut == JFinM_Charts.dthreeCode("")

## test reading javascript function code
##--------------------------------------

fname = "mlineChartShowNAs.js"
dirPath = joinpath(Pkg.dir("JFinM_Charts"), "d3_charts/lineCharts")
expOut = string("<script>", readall(joinpath(dirPath, fname)), "</script>")
@test expOut == JFinM_Charts.jsCode("lineCharts/mlineChartShowNAs.js")

## call template functions
##------------------------

JFinM_Charts.upperHTML_template()
JFinM_Charts.lowerHTML_template()

end
