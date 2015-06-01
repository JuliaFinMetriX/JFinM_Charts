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


################
## d3 symlink ##
################

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
