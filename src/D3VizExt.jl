################################
## D3Viz, external data files ##
################################

@doc doc"""
d3 visualization with external data file.
"""->
type D3VizExt <: AbstractD3Viz
    code::Function
    dataPaths::Array{String, 1}
end

@doc doc"""
Calling with existing data: D3Viz([], chrt, dataPath)
"""->
function D3Viz(data::Any, chrt::JFinM_Charts.AbstractD3Chart,
               dataPaths::Array{String, 1})

    if chrt.dataFileRequired
        ## transform relative data paths to absolute data paths
        dataPaths = String[relToAbs(p) for p in dataPaths]

        ## make sure data directory exists
        for p in dataPaths
            JFinM_Charts.assureDir(dirname(p))
        end

        ## if data is given, write data to disk or jscode
        if !isempty(data)
            ## write data to disk: this function needs to be
            ## adapted for each chart type
            writeData(dataPaths, data, chrt)
        end
    end

    ## create code function
    tmplFunc = makeTemplateFunc(chrt)
    return D3Viz(tmplFunc, dataPaths)
end


@doc doc"""
Write data to default file path.
"""->
function D3Viz(data::Any, chrt::JFinM_Charts.AbstractD3Chart)
    ## create default tmp file
    ## call D3Viz with data file path argument
end

@doc doc"""
dataPaths will be an Array, even if only a single data set is
required. 
"""->
function makeTemplateFunc(chrt::JFinM_Charts.AbstractD3Chart)
    if chrt.dataFileRequired
        function templateFunc(dataPaths)
            return string(JFinM_Charts.jsCode(chrt.jsCodePath),
                          JFinM_Charts.customChart(chrt),
                          JFinM_Charts.renderChart(chrt, dataPaths...))
        end
    else
        function templateFunc(dataPaths)
            return string(JFinM_Charts.jsCode(chrt.jsCodePath),
                          JFinM_Charts.dataJsCode(dkdk),
                          JFinM_Charts.customChart(chrt),
                          JFinM_Charts.renderChart(chrt, dataPaths...))
        end

    end
    return templateFunc
end
