type MLineChart <: AbstractD3Chart
    chartType::String
    jsCodePath::String
    extData::Bool
    nData::Int
    width::Int
    height::Int
    yScale::String
    yLabel::String
end

## default values
MLineChart() = MLineChart("MLineChart",
                          "lineCharts/mlineChartShowNAs.js",
                          true,
                          1,
                          900, 400, "lin", "")

########################
## default data names ##
########################

@doc doc"""
Return default data names for MLineChart with given absolute output
path. 
"""->
function defaultDataNames(outAbsPath::String, chrt::MLineChart)
    ## get directory name of output
    fileStem = split(outAbsPath, ".")[1]
    return [string(fileStem, "_data.csv")]
end

## customize and render chart
##---------------------------

function customChart(chrt::MLineChart)
    jsChartName = "mlineChartShowNAs"

    d3_yScale = ""
    if chrt.yScale == "lin"
        d3_yScale = "d3.scale.linear()"
    elseif chrt.yScale == "log"
        d3_yScale = "d3.scale.log()"
    else
        error("Wrong y scale specification")
    end
    
    chartCmd = """

<script>
var customizedChart = $jsChartName()
.width($(chrt.width))
.height($(chrt.height))
.y($d3_yScale)
.yAxisLabel("$(chrt.yLabel)");
</script>

"""
    return chartCmd
end

function renderChart(chrt::MLineChart, dataPath::String)
    renderCode = """
<script>
d3.csv("$dataPath", function(data) {
d3.select("body")
.datum(data)
.call(customizedChart)
})
</script>
"""
    return renderCode
end

## ## handle data
## ##------------

## @doc doc"""
## Write data as .csv file. Hence, intended name needs not be modified.
## """->
## ## write data to disk
## function writeData(intendedFname::String, tm::AbstractTimenum,
##                    chrt::MLineChart)
##     writeTimedata(intendedFname, tm)
## end

## @doc doc"""
## Fix file extension of data file if the path to data was not given
## manually. 
## """->
## function fixExtension(intendedFname::String,
##                       chrt::MLineChart)
##     return string(splitext(intendedFname)[1], ".csv")
## end
