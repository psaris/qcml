ifndef QHOME
$(error QHOME is not set)
endif

OS := $(shell uname)
QARCH ?= $(if $(filter Darwin,$(OS)),m32,l32)
Q ?= $(QHOME)/$(QARCH)/q

test:
	for f in  ex{1,2,3,4,5,6,7,8}.q;\
		do $(Q) $$f -s 4 >/dev/null </dev/null;\
  done
