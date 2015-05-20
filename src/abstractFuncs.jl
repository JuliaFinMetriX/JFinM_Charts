## display
##--------

import Base.Multimedia.display
function display(chrt::AbstractD3Chart)
    props = names(chrt)
    propNamLengths = Int[length(string(x)) for x in props]
    maxNameLength = max(propNamLengths...)
    
    for prop in props
        propExt = lpad(prop, maxNameLength + 2, " ")
        val = eval(:($chrt.$prop))
        println("$propExt: $val")
    end
end

## equality
##---------

import Base.isequal
function isequal(chrt1::AbstractD3Chart, chrt2::AbstractD3Chart)
    if !isequal(typeof(chrt1), typeof(chrt2))
        return false
    end
    ## cycle through each property
    props = names(chrt1)
    for prop in props
        equProp = eval(:(isequal($chrt1.$prop, $chrt2.$prop)))
        if !equProp
            return false
        end
    end
    return true
end
