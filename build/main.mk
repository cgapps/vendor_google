# build paths
TOPDIR := .
BUILD_SYSTEM := $(TOPDIR)/build
BUILD_GAPPS := $(BUILD_SYSTEM)/gapps.sh
OUTDIR := $(TOPDIR)/out
LOG_BUILD := /tmp/gapps_log

distclean :
	@rm -fr $(OUTDIR)
	@echo "$(tput setaf 2)Output removed! Ready for a clean build$(tput sgr 0)"

gapps :
	@echo "Compiling GApps..."
	@bash $(BUILD_GAPPS) 2>&1 | tee $(LOG_BUILD)
