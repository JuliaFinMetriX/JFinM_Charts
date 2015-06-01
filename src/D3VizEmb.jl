##########################
## D3Viz, embedded data ##
##########################

@doc doc"""
d3 visualization with embedded data.
"""->
type D3VizEmb <: AbstractD3Viz
    code::String
end

##################
## Constructors ##
##################

function D3VizEmb(data::Any, chrt::AbstractD3Chart,
                  dataNames::Array{ASCIIString, 1})
    dataCode = ""
    if !isempty(data)
        if !isempty(dataNames)
            dataCode = writeData(data, chrt, dataNames)
        else
            dataCode, dataNames = writeData(data, chrt)
        end
    end
    code = string(jsCode(chrt.jsCodePath),
                  customChart(chrt),
                  renderChart(chrt, dataNames...))
    return D3VizEmb(string(dataCode, code))
end

@doc doc"""
Use default name for javascript chart data.
"""->
function D3VizEmb(data::Any, chrt::AbstractD3Chart)
    dataNames = defaultDataNames(chrt)
    return D3VizEmb(data, chrt, dataNames)
end

#############
## display ##
#############

import Base.display
function display(dviz::D3VizEmb)
    println("D3VizEmb instance")
end

############
## render ##
############

@doc doc"""
Function render creates returns the full js code, with d3 library path
relative to the output file.
"""->
function renderCode(dviz::D3VizEmb, outPath::String, d3SrcDir::D3Lib)

    outAbsPath = abspath(outPath)
    
    ## d3 library code
    ##----------------

    ## get d3 library path relative to output
    if !(d3SrcDir.online)
        d3SrcDirAbs = abspath(d3SrcDir.path)
        d3SrcDir.path = relpath(d3SrcDirAbs, dirname(outAbsPath))
    end
    
    ## write code to load d3 library
    d3libCode = dthreeCode(d3SrcDir)

    ## return complete code
    return string(d3libCode, dviz.code)
end
    
