function vineGraph() {
    
    var width = 960;
    var height = 500;
    
    function vineGraphInner(selection) {
        
        selection.each(function(data){
            
            var color = d3.scale.category20();
            
            var force = d3.layout.force()
                .charge(-600)
                .alpha(0.9999)
                .friction(0.9)
                .gravity(0.1)
                .linkDistance(function(d) {
                    if (+d.value == 1){
                        return 10;
                    } else {
                        return 30;
                    }
                })
            // .linkDistance(200)
                .size([width, height]);
            
            var svg = d3.select(this).append("svg")
                .attr("width", width)
                .attr("height", height);
            
            var graph = data;

            // eliminate links with value smaller than ... how to do that?!
            var allLinks = graph.links;
            
            force.nodes(graph.nodes)
                .links(graph.links)
                .start();
            
            force.linkStrength(function(d) {
                if (d.value == 1) {
                    return 1;
                } else {
                    return 0;
                }
            });
            
            var link = svg.selectAll(".link")
                .data(graph.links)
                .enter().append("line")
                .attr("class", "link")
                .style("stroke-width", function(d) { return Math.sqrt(d.value*5); })
            // .style("stroke", 'red');
                .style("stroke", function(d) { return color(d.value); });
            
            var node = svg.selectAll(".node")
                .data(graph.nodes)
                .enter().append("circle")
                .attr("class", "node")
                .attr("r", 5)
                .style("fill", function(d) { return color(d.group); })
                .call(force.drag);
            
            node.append("title")
                .text(function(d) { return d.name; });
            
            force.on("tick", function() {
                link.attr("x1", function(d) { return d.source.x; })
                    .attr("y1", function(d) { return d.source.y; })
                    .attr("x2", function(d) { return d.target.x; })
                    .attr("y2", function(d) { return d.target.y; });
                
                node.attr("cx", function(d) { return d.x; })
                    .attr("cy", function(d) { return d.y; });
            });
            
        })
            
            }
    
    vineGraphInner.width = function(value) {
        if (!arguments.length) return width;
        width = value;
        return vineGraphInner;
    };
    
    vineGraphInner.height = function(value) {
        if (!arguments.length) return height;
        height = value;
        return vineGraphInner;
    };
    
    return vineGraphInner;
}
// ideas:
// - links up to which level are included?
// - vertical alignment?
// - how is distance measured?
// - node color reflecting?!
// - different link colors
// - collapsable trees
// - multiple focus points (group factors, group lagged variables)
// - differing node sizes?
// implicit way to do position encoding

// required data format:
// http://bl.ocks.org/mbostock/4062045
//
// {
//     "nodes":[
//         {"name":"Myriel","group":1},
//         {"name":"Napoleon","group":1},
//         {"name":"Mme.Hucheloup","group":8}
//     ],
//     "links":[
//         {"source":1,"target":0,"value":1},
//         {"source":76,"target":58,"value":1}
//     ]
// }

// link distance can depend on some value: first layer links tighter
// than second layer links (force.linkDistance)
// also: link stroke width depending on some value

// nodes are factors / lagged factors / variables
// links: copulas of first (and possibly more) layers
// link value:
// - layer number?
// - layer number plus other measures of proximity
// - dependency


