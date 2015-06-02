module runtests

tests = ["utils_test.jl",
         "d3lib_test.jl",
         "d3vizemb_test.jl",
         "d3vizext_test.jl",
         "d3viz_test.jl",
         ## "jfinm_charts_test.jl",
         ## "JFinM_Charts_usage.jl",
         "localhost_test.jl",
         "mlineChart_test.jl",
         "vineTreeChart_test.jl"
         ]

println("Running JFinM_Charts tests:")

for t in tests
    println("")
    println("----------------------")
    println(" * $(t)")
    println("----------------------")
    println("")
    include(string(Pkg.dir("JFinM_Charts"), "/test/", t))
end

println("Removing testing directories:")

## clean up
dirToDel = string(Pkg.dir("JFinM_Charts"), "/test/tmp_charts")
rm(dirToDel, recursive=true)
println("$dirToDel deleted")

symlinkToDel = string(Pkg.dir("JFinM_Charts"), "/test/d3")
rm(symlinkToDel, recursive=true)
println("$symlinkToDel deleted")

end
