## ## get chart type name
## ##--------------------

## function chartType(chrt::AbstractD3Chart)
##     return chrt.chartType
## end

## symlink to d3
##--------------

@doc doc"""
Create symbolic link to d3 library in present working directory.
"""->
function d3SymLink()
    d3Path = joinpath(Pkg.dir("JFinM_Charts"), "d3")
    try
        symlink(d3Path, "d3")
    catch e
        print(e)
    end
    return D3Lib("./d3")
end

@doc doc"""
Create symbolic link to the d3 library within a directory given by an
absolute path.
"""->
function d3SymLink(path::String)
    d3Path = joinpath(Pkg.dir("JFinM_Charts"), "d3")
    targetPath = joinpath(path, "d3")
    try
        symlink(d3Path, targetPath)
    catch e
        print(e)
    end
end

## allow easy embedding of iframes
##--------------------------------

type NB_Raw_HTML
    s::String
end

import Base.writemime
function writemime(io::IO, ::MIME"text/html", x::NB_Raw_HTML)
    print(io, x.s)
end

function iframe(src::String; args...)
    attrs = " "
    for (key, val) in args
        attrs = string(attrs, "$key=\"$val\"")
    end
    iframeCode = """
<iframe src="$src" $attrs></iframe>"""
    return NB_Raw_HTML(iframeCode)
end
