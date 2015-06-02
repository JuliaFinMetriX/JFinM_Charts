module TestUtils

using Base.Test
using JFinM_Charts

#####################
## chart functions ##
#####################

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
kk4 = JFinM_Charts.chart(JFinM_Charts.VineTreeChart)

@test isequal(kk, kk2)
@test !isequal(kk, kk3)
@test !isequal(kk, kk4)

#######################
## Jupyter embedding ##
#######################

expHtmlCode = "<iframe src=\"testFile.html\"  width=\"600px\"></iframe>"
actHtmlCode = JFinM_Charts.iframe("testFile.html", width = "600px").s
@test actHtmlCode == expHtmlCode

####################
## rendering code ##
####################

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

############################
## resolve path functions ##
############################

## normpath
##---------

normpath("./tmp")

## assureDir
##----------

## check that directory exists
JFinM_Charts.assureDir(Pkg.dir())

testPath = joinpath(Pkg.dir("JFinM_Charts"), "testDirToBeDeleted")
JFinM_Charts.assureDir(testPath)
@test isdir(testPath)

## delete directory again
rm(testPath)
@test !isdir(testPath)

## data file extension
##--------------------

anchorPath = "/home/chris/tmp/"
d3Path = "/home/chris/d3"
expOut = "../d3"
actOut = JFinM_Charts.relpath(d3Path, anchorPath)

@test expOut == actOut

anchorPath = "/home/chris/tmp"
actOut = JFinM_Charts.relpath(d3Path, anchorPath)

@test expOut == actOut

anchorPath = "/home/chris/tmp/sldkfj.html"
expOut = "../../d3"
actOut = JFinM_Charts.relpath(d3Path, anchorPath)

@test expOut == actOut

end
