module TestD3Lib

using Base.Test
using JFinM_Charts

##################
## constructors ##
##################

d3lib = JFinM_Charts.D3Lib()
@test d3lib.online == true

d3lib = JFinM_Charts.D3Lib("./d3")
@test d3lib.online == false

################
## dthreeCode ##
################

## online javascript code
d3lib = JFinM_Charts.D3Lib()
JFinM_Charts.dthreeCode(d3lib)

## local javascript code
d3lib = JFinM_Charts.D3Lib("./d3")
JFinM_Charts.dthreeCode(d3lib)

################
## d3 symlink ##
################

## create symbolic link in current directory
d3lib = JFinM_Charts.d3SymLink()
@test d3lib.path == "./d3"

## create symbolic link in different directory
d3lib = JFinM_Charts.d3SymLink("/tmp")
@test d3lib.path == "/tmp/d3"

## create symbolic link a second time
d3lib = JFinM_Charts.d3SymLink("/tmp")

end
