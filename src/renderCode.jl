@doc doc"""
Create script element that loads d3. If input is an empty string, the
d3 library will be loaded online. Otherwise the path needs to be a
relative path that is relative to the final html output.
"""->
function dthreeCode(d3src::String)
    ## path to d3 lib
    ## note: and improved version might introduce a try/catch
    ## statement in Javascript
    d3libCode = ""
    if isempty(d3src)
        d3libCode = """
<script src="http://d3js.org/d3.v3.min.js"
charset="utf-8"></script>
"""
    else
        subPath = "d3.min.js"
        fullPath = joinpath(d3src, subPath)
        d3libCode = """
<script src="$fullPath"></script>
"""
    end
    return d3libCode
end


## get js code of d3 chart
##------------------------

@doc doc"""
The function returns the Javascript code of a given file in the d3
chart library. The file path only requires the path and filename
relative to the d3 chart directory. 
"""->
function jsCode(subPath::String)
    libPath = joinpath(Pkg.dir("JFinM_Charts"), "d3_charts")

    filePath = joinpath(libPath, subPath)

    return string("<script>", readall(filePath), "</script>")
end


## htlm templates
##---------------

function upperHTML_template()
    htmlCode = """
<!DOCTYPE html>
<meta charset="utf-8">
<body>

"""
    return htmlCode
end

function lowerHTML_template()
    htmlCode = """
  
</body>
</html>

"""
    return htmlCode
end
