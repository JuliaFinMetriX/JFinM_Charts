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

@doc doc"""
Get final js code without output paths. If data is [], the code will
not entail any part for data, but will use data defined somewhere
else. Probably does not make sense anymore, as I do not write charts
directly to notebook files, but embed them as html files with one html
file per chart. 
"""->
function D3VizEmb(data::Any, chrt::AbstractD3Chart,
                  dataNames::Array{ASCIIString, 1})
    dataCode = ""
    if !isa(data, Array{None, 1})
        dataCode = writeData(data, chrt, dataNames)
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
