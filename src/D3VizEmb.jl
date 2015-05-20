##########################
## D3Viz, embedded data ##
##########################

@doc doc"""
d3 visualization with embedded data.
"""->
type D3VizEmb <: AbstractD3Viz
    code::String
end

##################
## Constructors ##
##################

function D3VizEmb(data::Any, chrt::AbstractD3Chart,
                  dataNames::Array{ASCIIString, 1})
    dataCode = ""
    if !isempty(data)
        if !isempty(dataNames)
            dataCode = writeData(data, chrt, dataNames)
        else
            dataCode, dataNames = writeData(data, chrt)
        end
    end
    code = string(jsCode(chrt.jsCodePath),
                  customChart(chrt),
                  renderChart(chrt, dataNames...))
    return D3VizEmb(string(dataCode, code))
end

@doc doc"""
Use default name for javascript chart data.
"""->
function D3VizEmb(data::Any, chrt::AbstractD3Chart)
    dataNames = defaultDataNames(chrt)
    return D3VizEmb(data, chrt, dataNames)
end


@doc doc"""
Function render creates returns the full js code, with d3 library path
relative to the output file.
"""->
function render(dviz::D3VizEmb, outPath::String, d3SrcDir::String)

    outAbsPath = abspath(outPath)
    
    ## d3 library code
    ##----------------

    ## get d3 library path relative to output
    if !isempty(d3SrcDir)
        d3SrcDirAbs = abspath(d3SrcDir)
        d3SrcDir = relpath(d3SrcDirAbs, outAbsPath)
    end
    
    ## write code to load d3 library
    d3libCode = dthreeCode(d3SrcDir)

    ## return complete code
    return string(d3libCode, dviz.code)
end
    

@doc doc"""
Write graphics to html file.
"""->
function renderHtml(dviz::AbstractD3Viz, outPath::String,
                    d3SrcDir::String)

    ## output file
    ##------------

    ## transform outpath to absolute file path
    outAbsPath = abspath(outPath)

    ## assure that output file exists
    if isfile(outAbsPath)
        run(`rm $outAbsPath`)
    end
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
    fullCode = render(dviz, outPath, d3SrcDir)
    write(fout, fullCode)

    ## final html code
    ##----------------

    ## write html final
    htmlLow = lowerHTML_template()
    write(fout, htmlLow)
    
    close(fout)

    return outAbsPath
end

@doc doc"""
Write graphics to html and open with localhost. Since there is no
external data, file could also be opened without local server.
"""->
function renderHtml(dviz::AbstractD3Viz, outPath::String,
                    d3SrcDir::String,
                    lh::LocalHost)
    outAbsPath = renderHtml(dviz, outPath, d3SrcDir)

    ## open file from localhost in browser
    println("localhost: $(lh.path)")
    println("html file: $outAbsPath")
    outputRelToLH = relpath(outAbsPath, lh.path)

    chartUrl = string("http://localhost:", lh.port, "/",
                      outputRelToLH)
    
    run(`google-chrome $chartUrl`)
    return outAbsPath
end

@doc doc"""
Write graphics to html and open with google-chrome.
"""->
function vizHtml(dviz::D3VizEmb, outPath::String, d3SrcDir::String)
    outAbsPath = renderHtml(dviz, outPath, d3SrcDir)
    run(`google-chrome $outAbsPath`)
    return outAbsPath
end 

@doc doc"""
Write to html in tmp directory and open in browser.
"""->
function vizHtml(data::Any, chrt::AbstractD3Chart)
    ## create random file
    randPart = tempname()
    outAbsPath = string(randPart, "_", chrt.chartType, ".html")
    ## write to file
    d3viz = D3VizEmb(data, chrt)
    renderHtml(d3viz, outAbsPath, "")
    ## open file
    run(`google-chrome $outAbsPath`)
    return outAbsPath
end
