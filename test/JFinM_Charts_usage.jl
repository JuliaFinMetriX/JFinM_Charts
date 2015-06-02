
# coding: utf-8

# In general, we need to define paths to the following components:
# - output file
# - d3 library
# - data
# - d3 chart code
# - localhost
# 
# Thereby only two components are defined **relative to the current directory**:
# - output file
# - localhost
# 
# All other components are **relative to the output file**:
# - d3 library
# - data,
# 
# except the d3 chart code, which always resides in the package directory and gets completely included into the output file.

# ## Define chart type

# The best way to create a chart instance is through the general function `chart`, which simultaneously allows further customizations through keyword arguments:

# In[1]:

using TimeData
using Dates


# In[2]:

cd("../")
projectDir = pwd()


# In[3]:

try
    using JFinM_Charts
catch e
    println("JFinM_Charts package not yet added to julia package directory")
    cd(string(homedir(), "/.julia/v0.3"))
    try 
        symlink(string(homedir(), "/research/julia/JFinM_Charts/"), "JFinM_Charts")
    catch
    end
    using JFinM_Charts
end    
cd(projectDir)


# - link to d3 library, if not yet present

# In[4]:

try
    d3SymLink()
catch
end


# #### Tree chart without data file

# - create data

# In[5]:

treeData = [0  2  2  2  2  2;
            1  0  3  3  3  3;
            2  2  0  4  4  4;
            3  3  3  0  5  5;
            4  4  4  4  0  6;
            5  5  5  5  5  0]


# - create customized chart

# In[6]:

trChrt = chart(JFinM_Charts.VineTreeChart, vSpace = 50, width = 80)


# - render chart

# In[7]:

outData, outChart = renderHTML(treeData, trChrt, outputPath = "tmp/juliaGJpEKl_VineTreeChart.html")


# - include chart as iframe

# In[8]:

relOut = basename(outChart)


# In[9]:

iframeCode = iframe("../tmp/$relOut", width=600, height="350")


# In[10]:

NB_Raw_HTML(iframeCode)


# #### Multi-line chart with underlying data file

# - create customized chart

# In[11]:

chrt = JFinM_Charts.chart(MLineChart)


# - create data

# In[12]:

dats = [Date(2001,1,1):Date(2001,1,30)]
data = Timematr(rand(30), dats)
data[1:3, :]


# - render chart with default output:

# In[13]:

outData, outChart = renderHTML(data, chrt)


# - as can be seen, this will
#   - use a random string and the chart type to denote the file itself
#   - render the chart in subdirectory ./tmp of the current working directory  

# In[14]:

pwd()


# Potential warning messages have the following meaning:
# - if directories needed to be created in order to create the output directory or the data directory

# #### Embed as iframe

# - the output can be embedded as iframe:

# In[15]:

relOut = basename(outChart)


# In[16]:

iframeCode = """<iframe width="900" height="600" src="../tmp/$relOut"></iframe>"""


# In[18]:

NB_Raw_HTML(iframeCode)

