module TestLocalHost

using Base.Test
using JFinM_Charts

## testing localhost constructors
##-------------------------------

## default settings
lh = JFinM_Charts.LocalHost()
@test lh.path == pwd()
@test lh.port == 4000

## speficying path
expOut = joinpath(pwd(), "tmp")
@test JFinM_Charts.LocalHost("./tmp").path == expOut
@test JFinM_Charts.LocalHost("tmp").path == expOut

expOut = "/home/chris/julia"
@test JFinM_Charts.LocalHost(expOut).path == expOut

## specifying port
expOut = 4323
@test JFinM_Charts.LocalHost(4323).port == expOut

lh = JFinM_Charts.LocalHost("/home/chris/julia", 4000)
@test lh.path == "/home/chris/julia"
@test lh.port == 4000

## testing localhost functions
##----------------------------

absOutputPath = "/home/user/test_JFinM_Charts/tmp/juliaO35gRx_MLineChart.html"
lhPath = "/home/user/test_JFinM_Charts/"

expOut = "tmp/juliaO35gRx_MLineChart.html"
@test expOut == JFinM_Charts.relpath(absOutputPath, lhPath)
@test expOut == JFinM_Charts.relpath(absOutputPath, lhPath[1:end-1])

## absOutputPath = "/home/user"
## lhPath = "/home/otheruser"
## @test_throws Exception JFinM_Charts.relpath(absOutputPath, lhPath)

## absOutputPath = "/home/user/julia"
## lhPath = "/user"
## @test_throws Exception JFinM_Charts.relpath(absOutputPath, lhPath)

end
