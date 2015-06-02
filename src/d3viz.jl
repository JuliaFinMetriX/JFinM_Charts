################
## renderCode ##
################

@doc doc"""
Function render creates and returns the full js code when final output
components like d3 library path and data paths already have been
determined. Paths will be made relative to the output file.

Output path must be a complete path to a file, not only to the
containing directory!
"""->
function renderCode(dviz::AbstractD3Viz,
                    outPath::String, d3SrcDir::D3Lib)

    outAbsPath = abspath(outPath)
    
    ## d3 library code
    ##----------------

    ## get d3 library path relative to output
    if !(d3SrcDir.online)
        d3SrcDirAbs = abspath(d3SrcDir.path)
        d3SrcDir.path = relpath(d3SrcDirAbs, dirname(outAbsPath))
    end
    
    ## write code to load d3 library
    d3libCode = dthreeCode(d3SrcDir)

    ## relative data file paths
    ##-------------------------

    fullChartCode = ASCIIString[]
    
    if isa(dviz, D3VizExt)
        relDataPaths = ASCIIString[relpath(p) for p in dviz.dataPaths]
        fullChartCode = dviz.code(relDataPaths)
    else
        fullChartCode = dviz.code
    end

    ## return complete code
    return string(d3libCode, fullChartCode)
end

#################
## render_dviz ##
#################

@doc doc"""
Write AbstractD3Viz graphics to html file.
"""->
function render_dviz(dviz::AbstractD3Viz, outPath::String,
                     d3SrcDir::D3Lib)

    ## output file
    ##------------

    ## transform outpath to absolute file path
    outAbsPath = abspath(outPath)

    ## assure that output file exists
    if isfile(outAbsPath)
        run(`rm $outAbsPath`)
    end
    assureDir(dirname(outAbsPath))
    touch(outAbsPath)

    ## upper html code
    ##----------------

    ## get upper html code
    htmlUp = upperHTML_template()

    ## write html header to file
    fout = open(outAbsPath, true, true, false, false, true)
    write(fout, htmlUp)

    ## chart code
    ##-----------
    fullCode = renderCode(dviz, outPath, d3SrcDir)
    write(fout, fullCode)

    ## final html code
    ##----------------

    ## write html final
    htmlLow = lowerHTML_template()
    write(fout, htmlLow)
    
    close(fout)

    return outAbsPath
end

## render functions: user interface to create html graphics
##---------------------------------------------------------

@doc doc"""
Most general function to allow setting of all components. If data is
empty, data files will be recycled.
"""->
function render(data::Any, chrt::AbstractD3Chart,
                outPath::String,
                dataNames::Array{ASCIIString, 1},
                d3Src::D3Lib)
    dviz = []
    if chrt.extData
        dviz = D3VizExt(data, chrt, dataNames)
    else
        dviz = D3VizEmb(data, chrt, dataNames)
    end

    return render_dviz(dviz, outPath, d3Src)
end

## using default settings
##-----------------------

function d3RndFile(data::Any, chrt::AbstractD3Chart)
    
    ## create ./tmp
    absTmpPath = abspath("./tmp/")
    assureDir(dirname(absTmpPath))
    
    ## create file in ./tmp
    randPart = tempname()
    outRelPath = string(".", randPart, "_", chrt.chartType, ".html")
    outAbsPath = abspath(outRelPath)

    return outAbsPath
end

## default data names, online d3 library
function render(data::Any, chrt::AbstractD3Chart,
                outPath::String, d3lib::D3Lib)
    if isa(data, Array{None, 1})
        error("data must not be empty if no data file paths are specified.")
    end

    ## get default data paths
    if chrt.extData
        absDataPaths = defaultDataNames(outPath, chrt)
        dataPaths = ASCIIString[relpath(outPath, dirname(p)) for p in absDataPaths]
    else
        dataPaths = defaultDataNames(chrt)
    end
    
    return render(data, chrt, outPath, dataPaths, d3lib)
end

## with default d3 path
function render(data::Any, chrt::AbstractD3Chart,
                outPath::String)

    ## create d3 path
    d3lib = D3Lib()
    
    return render(data, chrt, outPath, d3lib)
end

#########
## viz ##
#########

## notes: with localhost, output file resides in pwd()/tmp
##
## without localhost, D3VizEmb resides in /tmp

@doc doc"""
To visualize a graphics with external data files, the graphics needs
to be rendered with a local server. Hence, we need to make sure that
both data files and output file reside in subdirectories of localhost.
"""->
function viz(data::Any, chrt::AbstractD3Chart,
             d3lib::D3Lib,
             lh::LocalHost)

    ## create html file
    outAbsPath = d3RndFile(data, chrt)
    render(data, chrt, outAbsPath, d3lib)

    ## open file
    if chrt.extData
        ## open file from localhost in browser
        println("localhost: $(lh.path)")
        println("html file: $outAbsPath")
        outputRelToLH = relpath(outAbsPath, lh.path)

        chartUrl = string("http://localhost:", lh.port, "/",
                          outputRelToLH)
    
        run(`google-chrome $chartUrl`)
    else
        run(`google-chrome $outAbsPath`)
    end
    return outAbsPath
end

## without localhost: only D3VizEmb
##---------------------------------

function viz(data::Any, chrt::AbstractD3Chart, d3lib::D3Lib)
    if chrt.extData
        error("D3VizExt charts need to be called with localhost instance.")
    end
    ## create dummy localhost
    lh = LocalHost()
    viz(data, chrt, d3lib, lh)
end

## online d3 library, only D3VizEmb without localhost
function viz(data::Any, chrt::AbstractD3Chart)
    d3lib = D3Lib()
    viz(data, chrt, d3lib)
end

## with localhost
##---------------

## online d3 library, only D3VizEmb without localhost
function viz(data::Any, chrt::AbstractD3Chart, lh::LocalHost)
    d3lib = D3Lib()
    viz(data, chrt, d3lib, lh)
end

#############
## vizHtml ##
#############

@doc doc"""
viz will create a disposable chart. It is mainly written for usage
from the console, as charts would need to be saved to disk and
embedded in jupyter. Still, the default output path differs for
D3VizExt and D3VizEmb.

D3VizEmb consists of a single file only, and can be viewed without any
server. Hence, it will be written to /tmp by default.

D3VizExt, however, will create files that need to be accessible by a
local server. As /tmp usually is not a subdirectory of the local
server, the default path will be ./tmp.
"""->
function viz(data::Any, chrt::AbstractD3Chart, d3lib::D3Lib)
    if chrt.extData
        error("D3VizExt charts need to be called with localhost instance.")
    end
    ## create output path
    randPart = tempname()
    outAbsPath = string(".", randPart, "_", chrt.chartType, ".html")
    ## get data paths
    dataPaths = defaultDataNames(chrt)
    dviz = D3VizEmb(data, chrt, dataPaths)
    render_dviz(dviz, outAbsPath, d3lib)
    run(`google-chrome $outAbsPath`)
    return outAbsPath
end
