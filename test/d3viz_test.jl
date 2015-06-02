module TestD3Viz

using Base.Test
using JFinM_Charts

chrt = JFinM_Charts.VineTreeChart()
vn = [0 2 3;
      1 0 1;
      1 1 0]

dviz = JFinM_Charts.D3VizEmb(vn, chrt, ["/tmp/JFinM_Charts_test.html"])


## renderCode
##-----------

## online d3 code
d3lib = JFinM_Charts.D3Lib()
JFinM_Charts.renderCode(dviz, "/tmp/JFinM_Charts_test.html", d3lib)

## local d3 code
d3lib = JFinM_Charts.D3Lib("/tmp/d3")
JFinM_Charts.renderCode(dviz, "/tmp/JFinM_Charts_test.html", d3lib)

## render_dviz
##------------

## online d3 code
d3lib = JFinM_Charts.D3Lib()
JFinM_Charts.render_dviz(dviz, "/tmp/JFinM_Charts_test.html", d3lib)

## local d3 code
d3lib = JFinM_Charts.D3Lib("/tmp/d3")
JFinM_Charts.render_dviz(dviz, "/tmp/JFinM_Charts_test.html", d3lib)

############
## render ##
############

chrt = JFinM_Charts.VineTreeChart()
vn = [0 2 3;
      1 0 1;
      1 1 0]
outPath = "/tmp/JFinM_Charts_test.html"
d3lib = JFinM_Charts.D3Lib("/tmp/d3")

## with all input arguments
JFinM_Charts.render(vn, chrt, outPath, ["vineTreeDataArray"], d3lib)

## without data
JFinM_Charts.render([], chrt, outPath, ["vineTreeDataArray"], d3lib)

## default data names
JFinM_Charts.render(vn, chrt, outPath, d3lib)

## neither data nor data names
@test_throws Exception JFinM_Charts.render([], chrt, outPath, d3lib)

## default data names and d3 lib
JFinM_Charts.render(vn, chrt, outPath, d3lib)

end
