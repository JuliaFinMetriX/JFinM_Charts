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
