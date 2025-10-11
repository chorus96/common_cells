# SPDX-License-Identifier: Apache-2.0

VERILATOR ?= verilator

all: ecc_encode ecc_decode ecc_synth

distclean:
	rm -fr obj_dir

ecc_%: test/ecc/ecc_%.cpp test/ecc/ecc.cpp src/ecc_pkg.sv src/ecc_%.sv
	$(VERILATOR) --cc $^ --top-module $@ --trace --exe
	cd obj_dir && make -f V$@.mk > /dev/zero
	cd obj_dir && ./V$@

ecc_synth: test/ecc_synth.cpp src/ecc_pkg.sv src/ecc_encode.sv src/ecc_decode.sv test/ecc_synth.sv 
	$(VERILATOR) --cc $^ --top-module $@ --trace --exe
	cd obj_dir && make -f V$@.mk > /dev/zero
	cd obj_dir && ./V$@
