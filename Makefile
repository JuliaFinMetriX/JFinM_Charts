## tell make where to look for targets and dependencies
vpath %.jl test
vpath %.ipynb notebooks

## list of targets
JL_FILES := JFinM_Charts_usage.jl

all: tests

tests: $(JL_FILES)

run: $(JL_FILES)
	julia -e 'include("test/runtests.jl")'

%.jl: %.ipynb
	ipython nbconvert --to python $<; \
	mv $(*F).py test/$(*F).jl

clean:
	cd test; rm $(JL_FILES)
