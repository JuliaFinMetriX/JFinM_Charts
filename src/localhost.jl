@doc doc"""
Instance stores absolute path and port of local http server.
"""->
type LocalHost
    path::String
    port::Int
    
    function LocalHost(path::String, port::Int)
        if !isabspath(path)
            path = abspath(path)
        end
        return new(path, port)
    end
end

@doc doc"""
Initialize localhost with current directory and port 4000.
"""->
function LocalHost()
    return LocalHost(pwd(), 4000)
end

@doc doc"""
Initialize with directory only.
"""->
function LocalHost(path::String)
    return LocalHost(path, 4000)
end

@doc doc"""
Initialize with port only.
"""->
function LocalHost(port::Int)
    return LocalHost(pwd(), port)
end

## ## get path relative to local server
## ##----------------------------------

## @doc doc"""
## For an absolute file path, get the part that points to the file
## relative from the localhost. If the file is not in a subdirectory of
## localhost, throws an error.
## """->
## function relPathToLH(filePath::String, lh::String)
##     if !contains(filePath, lh)
##         error("Output file must be in a subdirectory of localhost.")
##     end

##     prePath, relPath = split(filePath, lh)
##     if !isempty(prePath)
##         error("Output file and localhost path must share the same
##     root.")
##     end
##     ## ## eliminate common path parts
##     ## commonCounter = 0
##     ## currInd = 1
##     ## maxInd = min(length(filePath), length(anchor))
##     ## commonPossible = true
##     ## while commonPossible & (currInd <= maxInd)
##     ##     if filePath[currInd] == anchor[currInd]
##     ##         commonCounter += 1
##     ##         currInd += 1
##     ##     else
##     ##         commonPossible = false
##     ##     end
##     ## end
##     if relPath[1] == '/'
##         relPath = relPath[2:end]
##     end
##     return relPath 
## end
