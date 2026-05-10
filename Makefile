# SPDX-License-Identifier: Apache-2.0

VERILATOR    ?= verilator
SIM_BUILD    ?= sim_build_verilator
SIM_TIMEOUT  ?= 180

# RTL-only source list used by all SV testbench targets
$(SIM_BUILD)/compile.f: Bender.yml
	mkdir -p $(SIM_BUILD)
	bender script verilator -t simulation > $@

# Common Verilator flags shared by all SV testbench targets
VLT_SIM_FLAGS = --binary --timing --assert -DVERILATOR
VLT_SIM_WARN  = --Wno-WIDTHTRUNC --Wno-WIDTHEXPAND --Wno-TIMESCALEMOD \
                --Wno-CASEINCOMPLETE --Wno-CONSTRAINTIGN --Wno-INITIALDLY -Wno-fatal

# Run all supported Verilator simulations (mirrors test/simulate.sh)
.PHONY: sim-verilator
sim-verilator: $(SIM_BUILD)/compile.f
	bash test/simulate_verilator.sh $(SIM_BUILD)

# Individual SV testbench targets: make sim-graycode_tb, sim-fifo_tb, etc.
# Usage: make sim-<tb_name> [VLT_PARAMS="-GNAME=value ..."]
.PHONY: sim-%
sim-%: $(SIM_BUILD)/compile.f
	mkdir -p $(SIM_BUILD)/$*
	$(VERILATOR) $(VLT_SIM_FLAGS) \
	    --top-module $* \
	    $(VLT_PARAMS) \
	    -f $(SIM_BUILD)/compile.f \
	    test/$*.sv \
	    -Mdir $(SIM_BUILD)/$* \
	    $(VLT_SIM_WARN)
	timeout $(SIM_TIMEOUT) $(SIM_BUILD)/$*/V$* || true

all: ecc_encode ecc_decode ecc_synth

distclean:
	rm -fr obj_dir $(SIM_BUILD)

ecc_%: test/ecc/ecc_%.cpp test/ecc/ecc.cpp src/ecc_pkg.sv src/ecc_%.sv
	$(VERILATOR) --cc $^ --top-module $@ --trace --exe
	cd obj_dir && make -f V$@.mk > /dev/zero
	cd obj_dir && ./V$@

ecc_synth: test/ecc_synth.cpp src/ecc_pkg.sv src/ecc_encode.sv src/ecc_decode.sv test/ecc_synth.sv 
	$(VERILATOR) --cc $^ --top-module $@ --trace --exe
	cd obj_dir && make -f V$@.mk > /dev/zero
	cd obj_dir && ./V$@
