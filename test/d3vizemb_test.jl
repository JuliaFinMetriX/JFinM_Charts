module TestVizEmb

using Base.Test
using JFinM_Charts

##################
## Constructors ##
##################

chrt = JFinM_Charts.VineTreeChart()
vn = [0 2 3;
      1 0 1;
      1 1 0]

outputPath = "./tmp_charts/testFile.html"

## with data and charts
dviz = JFinM_Charts.D3VizEmb(vn, chrt)
JFinM_Charts.render_dviz(dviz, outputPath, JFinM_Charts.D3Lib())

## with already given data
dviz = JFinM_Charts.D3VizEmb([], chrt, ["myOwnArrayName"])
JFinM_Charts.render_dviz(dviz, outputPath, JFinM_Charts.D3Lib())

println("Test AbstractD3 display method:")
display(dviz)

## with data and data name
dviz = JFinM_Charts.D3VizEmb(vn, chrt, ["myOwnArrayName"])

end
