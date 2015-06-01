# JFinM_Charts

A Julia interface to using the jfinm_d3_charts library.

- [![Build Status](https://travis-ci.org/JuliaFinMetriX/JFinM_Charts.svg?branch=master)](https://travis-ci.org/JuliaFinMetriX/JFinM_Charts.jl)
- [![Coverage Status](https://coveralls.io/repos/JuliaFinMetriX/JFinM_Charts/badge.svg)](https://coveralls.io/r/JuliaFinMetriX/JFinM_Charts)

# Documentation
- [General usage example](http://nbviewer.ipython.org/github/JuliaFinMetriX/JFinM_Charts/blob/master/notebooks/JFinM_Charts_usage.ipynb)
- [Overview of individual charts](http://nbviewer.ipython.org/github/JuliaFinMetriX/jfinm_charts_doc/tree/master/tutorials/)

# Description

There are two different graphics:
- graphics with embedded data: here data is included directly into the
  javascript code, such that no external data file needs to be loaded.
  An html graphics hence consists of a single html output file, and
  viewing it does not require a local server.
- graphics loading data from an external file (.csv, .json, ...): for
  reasons of performance, large data sets should be loaded from
  external files. This, however, complicates things, as html files are
  not allowed to load data from disk, so that any such html graphics
  need to be viewed through some kind of server. This could either be
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
