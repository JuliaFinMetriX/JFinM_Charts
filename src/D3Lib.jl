type D3Lib
    path::String
    online::Bool
end

function D3Lib()
    return D3Lib("http://d3js.org/d3.v3.min.js", true)
end

function D3Lib(path::String)
    return D3Lib(path, false)
end

@doc doc"""
Create script element that loads d3. If input is an empty string, the
d3 library will be loaded online. Otherwise the path needs to be a
relative path that is relative to the final html output.
"""->
function dthreeCode(d3src::D3Lib)
    ## path to d3 lib
    ## note: and improved version might introduce a try/catch
    ## statement in Javascript
    d3libCode = ""
    if d3src.online
        d3libCode = """
<script src="http://d3js.org/d3.v3.min.js"
charset="utf-8"></script>
"""
    else
        subPath = "d3.min.js"
        fullPath = joinpath(d3src.path, subPath)
        d3libCode = """
<script src="$fullPath"></script>
"""
    end
    return d3libCode
end


