type VineGraph <: AbstractD3Chart
    chartType::String
    jsCodePath::String
    extData::Bool
    nData::Int
    width::Int
    height::Int
    ## vSpace::Int
    ## nodeRadius::Int
end

## default values
VineGraph() = VineGraph("VineGraph",
                        "vines/vineGraph.js",
                        false,
                        1,
                        200, 500)

## relevant chart properties
##--------------------------

## get chart code
function jsCode(chrt::VineGraph)
    return jsCode("vines/vineGraph.js")
end

function needsDataFile(chrt::VineGraph)
    return false
end

## customize and render chart
##---------------------------

## TODO
function customChart(chrt::VineGraph)
    chartCmd = """
<script>
var customizedChart = vineChart()
.width($(chrt.width))
.height($(chrt.height));
</script>
"""
    return chartCmd
end

## TODO
function renderChart(chrt::VineGraph, dataPath::String)
    renderCode = """
<script>
d3.select("body")
.datum($dataPath)
.append("chart")
.attr("class", "vineGraph")
.call(customizedChart)
</script>
"""
    return renderCode
end

