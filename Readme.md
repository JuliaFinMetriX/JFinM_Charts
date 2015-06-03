# JFinM_Charts

A Julia interface to using the jfinm_d3_charts library.

- [![Build Status](https://travis-ci.org/JuliaFinMetriX/JFinM_Charts.svg?branch=master)](https://travis-ci.org/JuliaFinMetriX/JFinM_Charts)
- [![Coverage Status](https://coveralls.io/repos/JuliaFinMetriX/JFinM_Charts/badge.svg)](https://coveralls.io/r/JuliaFinMetriX/JFinM_Charts)

# Documentation
- [General usage example](http://nbviewer.ipython.org/github/JuliaFinMetriX/JFinM_Charts/blob/master/notebooks/JFinM_Charts_usage.ipynb)
- [Overview of individual charts](http://nbviewer.ipython.org/github/JuliaFinMetriX/jfinm_charts_doc/tree/master/tutorials/)

# Description

There are two different graphics:

- graphics with embedded data: data is included directly into the
  javascript code, such that no external data file needs to be loaded.
  An html graphics hence consists of a single html output file, and
  viewing it does not require a local server.
- graphics loading data from an external file (.csv, .json, ...): for
  reasons of performance, large data sets should be loaded from
  external files. This, however, complicates things, as html files are
  not allowed to load data from disk, so that any such html graphics
  needs to be viewed through some kind of server. This could either be
  a local http server, the server provided by github pages, or an
  ipython notebook.


- renderHtml with localhost:
	- for `D3VizExt` instances the only way of directly viewing a chart
     outside of Jupyter / IJulia notebooks
	- both html output file and all data files need to reside in a
     subdirectory of the local server; hence, the global /tmp
     directory is usually not a good choice
	- any default plots also need to specify default data files
- vizHtml:
	- create html output file and open in browser

# Internal setup

The most robust and internally used way to create a graphics is with
the following steps:
- create data
- create customized chart instance
- create AbstractD3Viz instance:
	- requires data and chart
	- writes data to file / js code: requires data paths / names
- render AbstractD3Viz instance:
	- requires output path
	- requires link to d3 library
- view rendered output file (viz, embed):
	- use local http server to view charts with external data files
	- embed as iframe into notebook environments

In addition, however, there exist some shortcuts for frequently used
settings.

## Disposable charts

For quick visualizations all produced files do not need to be
retrievable again after viewing the chart. Hence, output file and data
are written to temporary directories. 

However, temporary directories differ with respect to `D3VizExt` and
`D3VizEmb` instances, as `D3VizExt` instances come with external data
and hence their data needs to be accessible from local servers only.
Writing data to /tmp would require to mount the complete file system
to localhost. Hence, the default output directory for `D3VizExt`
charts is ./tmp and may have to be created during function call.

For quick and dirty view, use function viz. This will open the
respective file in google chrome.
- viz(data::Any, chrt::AbstractD3Chart) for `D3VizEmb`
- vizHtml(data::Any, chrt::AbstractD3Chart, lh::LocalHost)

To only view a chart 

- render: create output files
- viz functions will also automatically open created html file

Possible problems:
- recycle data
- fine tune data names
- offline d3

# render

To permanently store html output on file. Hence, the output path is a
mandatory input (for disposable charts with default output path use
viz or embed).

- render(data::Any, chrt::AbstractD3Chart,
  outPath::String, dataNames::Array{ASCIIString, 1},
  d3Src::D3Lib)
- render(data::Any, chrt::AbstractD3Chart, outPath::String, d3lib::D3Lib)
- render(data::Any, chrt::AbstractD3Chart, outPath::String)

# viz

- viz(data::Any, chrt::AbstractD3Chart, d3lib::D3Lib, lh::LocalHost)
- viz(data::Any, chrt::AbstractD3Chart, lh::LocalHost)
- vizLh(data::Any, chrt::AbstractD3Chart, d3lib::D3Lib)
- viz(data::Any, chrt::AbstractD3Chart, d3lib::D3Lib)
- viz(data::Any, chrt::AbstractD3Chart)

# embed

- embed(data::Any, chrt::AbstractD3Chart, d3lib::D3Lib; args...)
- embed(data::Any, chrt::AbstractD3Chart; args...)

# TODOs
- handle javascript graphics (requires to write code directly to
  notebook via writemime and initCanvas function)
- add recycle functionality for data charts
- add export to gist functionality
- allow for multiple datasets

# Documentation repo
- keep original d3 version as gist bl.ock
- run all charts with given dummy data
- for each chart:
  - extract png
  - add png with link to gallery
  - describe chart details
  - show multiple customizations per chart
