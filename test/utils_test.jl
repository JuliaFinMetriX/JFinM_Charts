module TestUtils

using Base.Test
using JFinM_Charts

## symlink creation
##-----------------

oldDir = pwd()
cd(Pkg.dir("JFinM_Charts"))
JFinM_Charts.d3SymLink()
JFinM_Charts.d3SymLink()
cd(oldDir)

end
