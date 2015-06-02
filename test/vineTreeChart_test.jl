module TestMLineChart

using Base.Test
using JFinM_Charts

##################
## Constructors ##
##################

chrt = JFinM_Charts.VineTreeChart()

@test JFinM_Charts.defaultDataNames(chrt) == ["treeArrayData"]
@test typeof(JFinM_Charts.defaultDataNames(chrt)) == Array{ASCIIString, 1}


## customized chart
##-----------------

chrt = JFinM_Charts.chart(JFinM_Charts.VineTreeChart,
                          width=300,
                          height=500)

@test chrt.width == 300

#################
## customChart ##
#################

expCmd = """
<script>
var customizedChart = treeChart()
.width(300)
.height(500)
.vSpace(100)
.nodeRadius(12);
</script>
"""

@test expCmd == JFinM_Charts.customChart(chrt)

#################
## renderChart ##
#################

expCmd = """
<script>
 d3.select("body")
    .selectAll(".singleTree")
    .data(treeDataArray)
    .enter()
    .append("chart")
    .attr("class", "singleTree")
    .call(customizedChart)
</script>
"""

@test expCmd == JFinM_Charts.renderChart(chrt, "treeDataArray")

###############
## writeData ##
###############

chrt = JFinM_Charts.VineTreeChart()

vn = [0 2 3;
      1 0 1;
      1 1 0]

@test_throws Exception JFinM_Charts.writeData(vn, chrt, ["lsdkjf", "sldkfj"])

end
