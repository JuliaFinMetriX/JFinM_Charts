################################
## D3Viz, external data files ##
################################

@doc doc"""
d3 visualization with external data file.
"""->
type D3VizExt <: AbstractD3Viz
    code::Function
    dataPaths::Array{ASCIIString, 1}
end

@doc doc"""
Calling with existing data: D3Viz([], chrt, dataPath)
"""->
function D3VizExt(data::Any, chrt::JFinM_Charts.AbstractD3Chart,
               dataPaths::Array{ASCIIString, 1})

    ## transform relative data paths to absolute data paths
    dataPaths = ASCIIString[relToAbs(p) for p in dataPaths]

    ## make sure data directory exists
    for p in dataPaths
        JFinM_Charts.assureDir(dirname(p))
    end

    ## if data is given, write data to disk or jscode
    if !(isa(data, Array{None, 1}))
        ## write data to disk: this function needs to be
        ## adapted for each chart type
        writeData(data, chrt, dataPaths)
    end

    ## create code function
    tmplFunc = makeTemplateFunc(chrt)
    return D3VizExt(tmplFunc, dataPaths)
end

@doc doc"""
dataPaths will be an Array, even if only a single data set is
required. 
"""->
function makeTemplateFunc(chrt::JFinM_Charts.AbstractD3Chart)
    function templateFunc(dataPaths)
        return string(JFinM_Charts.jsCode(chrt.jsCodePath),
                      JFinM_Charts.customChart(chrt),
                      JFinM_Charts.renderChart(chrt, dataPaths...))
    end
    return templateFunc
end

#############
## display ##
#############

import Base.display
function display(dviz::D3VizExt)
    println("D3VizExt instance")
    println("data paths:")
    display(dviz.dataPaths)
end

