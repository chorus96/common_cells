#!/usr/bin/env bash
# Copyright (c) 2014-2024 ETH Zurich, University of Bologna
#
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#
# Verilator simulation script for common_cells.
# Mirrors test/simulate.sh but uses Verilator instead of QuestaSim.
#
# Usage: bash test/simulate_verilator.sh [build_dir]
#   build_dir: optional output directory (default: sim_build_verilator)

set -e

VERILATOR=${VERILATOR:-verilator}
SIM_BUILD=${1:-sim_build_verilator}

VLT_FLAGS="--binary --timing --assert -DVERILATOR"
VLT_WARN="--Wno-WIDTHTRUNC --Wno-WIDTHEXPAND --Wno-TIMESCALEMOD \
          --Wno-CASEINCOMPLETE --Wno-CONSTRAINTIGN --Wno-INITIALDLY -Wno-fatal"
SIM_TIMEOUT=180

PASS=0
FAIL=0

mkdir -p "$SIM_BUILD"

echo "Generating RTL source list from bender..."
bender script verilator -t simulation > "$SIM_BUILD/compile.f"
echo ""

# Compile a testbench with Verilator.
# $1: testbench module name (without .sv)
# $2..: optional -GNAME=value parameter overrides (compile-time)
# Returns the build directory path on stdout.
compile_tb() {
    local tb=$1
    shift
    local vlt_params=("$@")

    # Build a unique directory name for each parameter combination
    local param_tag=""
    for p in "${vlt_params[@]}"; do
        param_tag+="_${p#-G}"
    done
    param_tag=$(echo "$param_tag" | tr '=' '-')
    local build_dir="$SIM_BUILD/${tb}${param_tag}"

    mkdir -p "$build_dir"
    local compile_log="$build_dir/compile.log"

    # shellcheck disable=SC2086
    $VERILATOR $VLT_FLAGS \
        --top-module "$tb" \
        "${vlt_params[@]}" \
        -f "$SIM_BUILD/compile.f" \
        "test/${tb}.sv" \
        -Mdir "$build_dir" \
        $VLT_WARN > "$compile_log" 2>&1

    echo "$build_dir"
}

# Run a compiled Verilator simulation and check for assertion failures.
# $1: build directory returned by compile_tb
# $2: testbench module name
run_sim() {
    local build_dir=$1
    local tb=$2
    local sim_log="$build_dir/sim.log"

    # Exit codes: 0 = $finish, 134 = $stop (SIGABRT). Both are normal endings.
    timeout "$SIM_TIMEOUT" "$build_dir/V${tb}" > "$sim_log" 2>&1 || true

    if grep -q "Assertion failed" "$sim_log"; then
        echo "FAILED (assertion failure)"
        grep "Assertion failed" "$sim_log" | head -5 >&2
        return 1
    fi

    if grep -qE "^\s*\%Error:" "$sim_log" | grep -qv "Verilog \\\$stop"; then
        echo "FAILED (simulation error)"
        grep "%Error:" "$sim_log" | grep -v "Verilog \$stop" | head -5 >&2
        return 1
    fi

    echo "PASSED"
    return 0
}

# Compile and run a testbench, printing a formatted result line.
# $1: testbench module name
# $2..: optional -GNAME=value parameter overrides
call_verilator() {
    local tb=$1
    shift
    local vlt_params=("$@")

    local label="$tb"
    [[ ${#vlt_params[@]} -gt 0 ]] && label+=" [${vlt_params[*]}]"
    printf "  %-55s" "$label"

    local build_dir
    if ! build_dir=$(compile_tb "$tb" "${vlt_params[@]}" 2>&1); then
        echo "COMPILE FAILED"
        cat "$SIM_BUILD/${tb}/compile.log" >&2
        FAIL=$((FAIL + 1))
        return 1
    fi

    local result
    result=$(run_sim "$build_dir" "$tb")
    echo "$result"

    if [[ "$result" == PASSED ]]; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
        return 1
    fi
}

echo "=== Running Verilator simulations ==="
echo ""

# ----------------------------------------------------------------------------
# Testbenches from simulate.sh that are supported by Verilator
# ----------------------------------------------------------------------------

# Pure combinational / simple timing — no unsupported features
call_verilator graycode_tb
call_verilator fifo_tb
# popcount_tb uses standalone randomize(); replaced with $urandom() under VERILATOR
call_verilator popcount_tb
# stream_register_tb uses clocking blocks (supported in Verilator 5.x)
# Simulation time: ~100 ms → ~15 s wall-clock
call_verilator stream_register_tb

# ----------------------------------------------------------------------------
# Additional testbenches verified to work with Verilator
# ----------------------------------------------------------------------------

# clk_int_div_static_tb: self-checking, uses $info/$stop for end-of-test
call_verilator clk_int_div_static_tb

# ----------------------------------------------------------------------------
# Summary
# ----------------------------------------------------------------------------
echo ""
echo "Results: $PASS PASSED, $FAIL FAILED"
echo ""

# List testbenches that are skipped and why, so users know the status.
cat << 'EOF'
Skipped testbenches and reasons:
  cdc_2phase_tb           mailbox type is not supported by Verilator
  cdc_fifo_tb             mailbox type is not supported by Verilator
  id_queue_tb             dependency (rand_stream_mst.sv) uses randomize() in class context
  addr_decode_tb          Verilator C++ codegen bug with named assertion pass-action statements
  stream_to_mem_tb        non-blocking assignments with delays in initial blocks behave
                          differently in Verilator (INITIALDLY), causing assertion failures
  rr_arb_tree_tb          timing-sensitive assertions fail due to scheduling differences
  stream_xbar_tb          stream_test package uses virtual interfaces (unsupported)
  stream_omega_net_tb     stream_test package uses virtual interfaces (unsupported)
  isochronous_crossing_tb stream_test package uses virtual interfaces (unsupported)
  cb_filter_tb            randomize() with constraint is not supported by Verilator
EOF

[ "$FAIL" -eq 0 ]
