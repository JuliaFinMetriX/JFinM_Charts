function mlineChartShowNAs() {
    
    var outerWidth = 960;
    var outerHeight = 500;
    var y = d3.scale.log();
    var yAxisLabel = "";
    
    function mlineChartInner(selection) {
        
        selection.each(function(data){
            
            // define margins
            var margin = {top: 20, right: 80, bottom: 30, left: 150};
            
            // graphics size without axis
            var width = outerWidth - margin.left - margin.right;
            var height = outerHeight - margin.top - margin.bottom;
            
            var svg = d3.select(this).append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .attr("font", "sans-serif")
                .attr("font-size", "16px")
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
            
            var x = d3.time.scale()
                .range([0, width]);
            
            y = y.range([height, 0]);
            
            var color = d3.scale.category10();
            
            var xAxis = d3.svg.axis()
                .scale(x)
                .orient("bottom");
            
            var yAxis = d3.svg.axis()
                .scale(y)
                .orient("left")
                .ticks(5);
            
            var parseDate = d3.time.format("%Y-%m-%d").parse;
            
            var line = d3.svg.line()
                .defined(function(d) { return !isNaN(d.gdp); })
                .interpolate("basis")
                .x(function(d) { return x(d.idx); })
                .y(function(d) { return y(d.gdp); });
            
            
            color.domain(d3.keys(data[0]).filter(function(key) { return key !== "idx"; }));
            
            data.forEach(function(d) {
                d.idx = parseDate(d.idx);
            });
            
            var tseries = color.domain().map(function(name) {
                
                countryData = data.map(function(d) {
                    return {idx: d.idx, gdp: +d[name]};
                })
                return {name: name,
                        values: countryData
                       };
            });
            
            x.domain(d3.extent(data, function(d) { return d.idx; }));
            
            y.domain([
                d3.min(tseries, function(c) { return d3.min(c.values, function(v) { return v.gdp; }); }),
                d3.max(tseries, function(c) { return d3.max(c.values, function(v) { return v.gdp; }); })
            ]);
            
            var xAxisNodes = svg.append("g")
                .attr("class", "xaxis")
                .style({"fill": "none", "stroke": "#000"})
                .attr("transform", "translate(0," + height + ")")
                .call(xAxis);

            xAxisNodes.selectAll("text")
                .style({"stroke-width": "0.1px", "fill": "black"});
            
            var yAxisNodes = svg.append("g")
                .attr("class", "y axis")
                .style({"fill": "none", "stroke": "#000"})
                .call(yAxis);

            var yAxisText = yAxisNodes.append("text")
                .attr("transform", "rotate(-90)")
                .attr("y", 6)
                .attr("dy", ".71em")
                .style("text-anchor", "end")
                .text(yAxisLabel);

            yAxisNodes.selectAll("text")
                .style({"stroke-width": "0.1px", "fill": "black"});
            
            
            var gdp = svg.selectAll(".gdp")
                .data(tseries)
                .enter().append("g")
                .attr("class", "gdp");
            
            gdp.append("path")
                .attr("class", "line")
                .attr("d", function(d) { return line(d.values); })
                .attr("stroke-width", "1.5px")
                .attr("fill", "none")
                .style("stroke", function(d) { return color(d.name); });
        })
            
            
            
            }
    
    mlineChartInner.width = function(value) {
        if (!arguments.length) return outerWidth;
        outerWidth = value;
        return mlineChartInner;
    };
    
    mlineChartInner.height = function(value) {
        if (!arguments.length) return outerHeight;
        outerHeight = value;
        return mlineChartInner;
    };
    
    mlineChartInner.y = function(value) {
        if (!arguments.length) return y;
        y = value;
        return mlineChartInner;
    };

    mlineChartInner.yAxisLabel = function(value) {
        if (!arguments.length) return yAxisLabel;
        yAxisLabel = value;
        return mlineChartInner;
    };

    return mlineChartInner;
}
