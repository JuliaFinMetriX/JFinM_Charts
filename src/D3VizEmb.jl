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
