type VineTreeChart <: AbstractD3Chart
    chartType::String
    jsCodePath::String
    extData::Bool
    nData::Int
    width::Int
    height::Int
    vSpace::Int
    nodeRadius::Int
end

## default values
VineTreeChart() = VineTreeChart("VineTreeChart",
                                "vines/vineTreeChart.js",
                                false,
                                1,
                                200, 500, 100, 12)

function defaultDataNames(chrt::VineTreeChart)
    return ["treeArrayData"]
end

## customize and render chart
##---------------------------

function customChart(chrt::VineTreeChart)
    chartCmd = """
<script>
var customizedChart = treeChart()
.width($(chrt.width))
.height($(chrt.height))
.vSpace($(chrt.vSpace))
.nodeRadius($(chrt.nodeRadius));
</script>
"""
    return chartCmd
end

function renderChart(chrt::VineTreeChart, dataPath::String)
    renderCode = """
<script>
 d3.select("body")
    .selectAll(".singleTree")
    .data($dataPath)
    .enter()
    .append("chart")
    .attr("class", "singleTree")
    .call(customizedChart)
</script>
"""
    return renderCode
end

## handle data
##------------

## call data with default js variable name
function writeData(data::Array{Int, 2}, chrt::VineTreeChart)
    ## create JavaScript data with default name
    return writeData(data, chrt, ["treeArrayData"])
end

## call data with given js variable name
function writeData(data::Array{Int, 2},
                   chrt::VineTreeChart,
                   dataName::Array{ASCIIString, 1})
    if length(dataName) > 1
        error("one single data name is allowed")
    end

    dataName = dataName[1]
    
    ## transform matrix to flat data Javascript variable
    nVars = size(data, 1)
    dataStr = Array(String, nVars*nVars + 2*nVars + 2)
    
    ind = 1
    dataStr[ind] = "["
    ind += 1
    for rt=1:nVars
        dataStr[ind] = "["
        ind += 1
        for nd=1:nVars
            p = data[nd, rt]
            dataStr[ind] = """{"name": "$nd", "parent": "$p"},"""
            ind += 1
        end
        dataStr[ind] = "],"
        ind += 1
    end
    dataStr[ind] = "]"
    
    dataScript = """
<script>
var $dataName = $(dataStr...)
</script>
"""
    return dataScript
end

