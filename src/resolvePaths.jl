## @doc doc"""
## Create random file name with default settings: relative path with
## directory ./tmp, ending of file indicating chart type (e.g.
## sldk_MLineChart.html). 
## """->
## function createHtmlPath(chartType::String)
##     randPart = tempname()
##     outputPath = string(".", randPart, "_", chartType, ".html")
##     return outputPath
## end

## @doc doc"""
## If no data path is specified, data will be in same directory as output
## with same file stem.
## """->
## function createRelPathEquStem(outputFile::String)
##     fname = basename(outputFile)
##     fstem = splitext(fname)[1]
##     dataFname = string(fstem, ".csv")
##     return dataFname
## end

## @doc doc"""
## If specified, the data file path is given relative to the html output
## file. Hence, in order to be able to write to the file, the relative
## path needs to be turned into an absolute path.
## """->
## function resolveRelDataPath(relDataPath::String, anchorPath::String)
##     absDataPath = ""
##     if isempty(relDataPath)
##         error("Data file path should already be set at this step.")
##         ## absDataPath = absDataPathSameStem(anchorPath)
##     else
##         absDataPath = absDataPathGivenName(relDataPath, anchorPath)
##     end
##     return absDataPath
## end

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


## @doc doc"""
## Return data file name with name stem equal to output file.
## """->
## function absDataPathGivenName(relDataPath::String,
##                      anchorPath::String)
##     ## get absolute path to relative anchor path
##     outputAbsPath = abspath(anchorPath)

##     outputDir = dirname(outputAbsPath)

##     return normpath(joinpath(outputDir, relDataPath))
## end

#####################################
## define functions from Julia 0.4 ##
#####################################

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
