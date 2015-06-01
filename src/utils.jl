#####################
## chart functions ##
#####################

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

#######################
## Jupyter embedding ##
#######################

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

####################
## rendering code ##
####################

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

###################
## resolve paths ##
###################

@doc doc"""
Assure that a given directory exists. If it does not exist yet, create
all required folders and subfolders and print a warning message.
"""->
function assureDir(absDirPath::String)
    ## check if directory exists
    dirExists = isdir(absDirPath)
    if !dirExists
        ## create it
        mkpath(absDirPath)
        warn("Some directories for $absDirPath were created")
    end
end

function relToAbs(path::String)
    return normpath(joinpath(pwd(), path))
end

## define functions from Julia 0.4
##################################

## these functions are part of Julia 0.4!
## they should be removed after transition to Julia 0.4.

function _findprev(testf::Function, A, start)
    for i = start:-1:1
        testf(A[i]) && return i
    end
    0
end
_findlast(testf::Function, A) = _findprev(testf, A, length(A))


@doc doc"""
relpath is only defined in Julia 0.4. Hence, here is a slightly less
robust copy of the code. Ideally, this should be removed as soon as I
switch over to Julia 0.4.
"""->
function relpath(path::String, startpath::String = ".")
    ## (!isdirpath(startpath)) && throw(ArgumentError("`path` must be a directory"))
    isempty(path) && throw(ArgumentError("`path` must be specified"))
    isempty(startpath) && throw(ArgumentError("`startpath` must be specified"))
    path_separator_re = "/"
    path_separator = "/"
    curdir = "."
    pardir = ".."
    path == startpath && return curdir
    path_arr  = split(abspath(path),      path_separator_re)
    start_arr = split(abspath(startpath), path_separator_re)
    i = 0
    while i < min(length(path_arr), length(start_arr))
        i += 1
        if path_arr[i] != start_arr[i]
            i -= 1
            break
        end
    end
    pathpart = join(path_arr[i+1:_findlast(x -> !isempty(x), path_arr)], path_separator)
    prefix_num = _findlast(x -> !isempty(x), start_arr) - i - 1
    if prefix_num >= 0
        prefix = pardir * path_separator
        relpath_ = isempty(pathpart)     ?
            (prefix^prefix_num) * pardir :
            (prefix^prefix_num) * pardir * path_separator * pathpart
    else
        relpath_ = pathpart
    end
    return isempty(relpath_) ? curdir :  relpath_
end
