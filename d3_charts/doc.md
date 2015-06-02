# vineTreeChart

The d3 tree layout needs data in hierarchical format, but here data is
read in as flat data (see the [bl.ocks.org
example](http://bl.ocks.org/cgroll/52d435bf489294750fe1)). 

For each tree, data is read in as Array with elements similar to
```
{name: "3", parent: "2"}
```

At a first step, the data is transformed to a sorted object consisting
of individual objects similar to
```
{name: "3", parent: "2"}
```
Here, one can easily query the parent for each node.

Then, data is transformed to hierarchical data:
```
{copulaLink: Array[3],
name: "3",
parent: "2"}
```

`copulaLink` keeps track of all children.
