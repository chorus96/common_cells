[![Build Status](https://github.com/pulp-platform/common_cells/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/pulp-platform/common_cells/actions/workflows/ci.yml?query=branch%3Amaster)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/pulp-platform/common_cells?color=blue&label=current&sort=semver)](CHANGELOG.md)
[![SHL-0.51 license](https://img.shields.io/badge/license-SHL--0.51-green)](LICENSE)

# Common Cells 저장소

관리자: Philippe Sauter <phsauter@iis.ee.ethz.ch>

이 저장소는 다양한 프로젝트에서 공통으로 사용되는 셀(cell)과 헤더 파일을 포함합니다.

## 셀 목록

현재 이 저장소에는 아래와 같은 셀들이 카테고리별로 정리되어 있습니다.
*deprecated(더 이상 사용되지 않음)* 상태의 셀은 새 설계에 사용하지 않으며, 기존 코드와의 호환성 유지 목적으로만 존재합니다.

### 클록 및 리셋

| 이름                                                               | 설명                                                                              | 상태         | 대체 모듈                                |
|--------------------------------------------------------------------|-------------------------------------------------------------------------------------|--------------|--------------------------------------|
| [`clk_int_div`](src/clk_int_div.sv)                                | 설정 인터페이스와 50% 듀티 사이클 출력을 갖는 임의 정수 클록 분주기               | 활성         |                                      |
| [`clk_int_div_static`](src/clk_int_div_static.sv)                  | 정적 분주 비율을 갖는 `clk_int_div` 편의 래퍼                                     | 활성         |                                      |
| [`clk_div`](src/deprecated/clk_div.sv)                             | 정수 분주기를 사용하는 클록 분주기                                                 | *deprecated* | [`clk_int_div`](src/clk_int_div.sv)  |
| [`clock_divider`](src/deprecated/clock_divider.sv)                 | 설정 레지스터를 갖는 클록 분주기                                                   | *deprecated* | [`clk_int_div`](src/clk_int_div.sv)  |
| [`clock_divider_counter`](src/deprecated/clock_divider_counter.sv) | 카운터를 사용하는 클록 분주기                                                      | *deprecated* | [`clk_int_div`](src/clk_int_div.sv)  |
| [`rstgen`](src/rstgen.sv)                                          | 리셋 동기화기                                                                     | 활성         |                                      |
| [`rstgen_bypass`](src/rstgen_bypass.sv)                            | 전용 테스트 리셋 바이패스를 갖는 리셋 동기화기                                    | 활성         |                                      |

### 클록 도메인 및 비동기 크로싱

| 이름                                                                  | 설명                                                                                              | 상태         | 대체 모듈                           |
|-----------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|--------------|-----------------------------------|
| [`cdc_4phase`](src/cdc_4phase.sv)                                     | 4상(4-phase) 핸드셰이크를 사용하는 클록 도메인 크로싱 (ready/valid 인터페이스)                    | 활성         |                                   |
| [`cdc_2phase`](src/cdc_2phase.sv)                                     | 2상(2-phase) 핸드셰이크를 사용하는 클록 도메인 크로싱 (ready/valid 인터페이스)                    | 활성         |                                   |
| [`cdc_2phase_clearable`](src/cdc_2phase_clearable.sv)                 | `cdc_2phase`와 동일하며, 송신 또는 수신 측의 단방향 비동기/동기 리셋을 지원                       | 활성         |                                   |
| [`cdc_fifo_2phase`](src/cdc_fifo_2phase.sv)                           | 2상 핸드셰이크를 사용하는 CDC FIFO (ready/valid 인터페이스)                                       | 활성         |                                   |
| [`cdc_fifo_gray`](src/cdc_fifo_gray.sv)                               | 그레이 카운터를 사용하는 CDC FIFO (ready/valid 인터페이스)                                        | 활성         |                                   |
| [`cdc_fifo_gray_clearable`](src/cdc_fifo_gray_clearable.sv)           | `cdc_fifo_gray`와 동일하며, 단방향 비동기/동기 리셋을 지원                                        | 활성         |                                   |
| [`cdc_reset_ctrlr`](src/cdc_reset_ctrlr.sv)                           | 클록 도메인 간 동기적 리셋 시퀀서 (내부적으로 clearable CDC에서 사용)                             | 활성         |                                   |
| [`clk_mux_glitch_free`](src/clk_mux_glitch_free.sv)                   | 입력 수를 파라미터로 설정할 수 있는 글리치 없는 클록 멀티플렉서                                   | 활성         |                                   |
| [`edge_detect`](src/edge_detect.sv)                                   | 상승/하강 에지 감지기                                                                             | 활성         |                                   |
| [`edge_propagator`](src/edge_propagator.sv)                           | 비동기 클록 도메인 크로싱에서 단일 사이클 펄스를 전파                                             | 활성         |                                   |
| [`edge_propagator_ack`](src/edge_propagator_ack.sv)                   | 송신 측 동기 ACK 핀을 갖는 `edge_propagator` (수신된 펄스를 알림)                                 | 활성         |                                   |
| [`edge_propagator_rx`](src/edge_propagator_rx.sv)                     | 수신 클록만 필요로 하는 `edge_propagator`의 수신 슬라이스                                         | 활성         |                                   |
| [`edge_propagator_tx`](src/edge_propagator_tx.sv)                     | 송신 클록만 필요로 하는 `edge_propagator`의 송신 슬라이스                                         | 활성         |                                   |
| [`isochronous_spill_register`](src/isochronous_spill_register.sv)     | 등시성(isochronous) CDC 및 완전 핸드셰이크 (`spill_register`와 유사)                              | 활성         |                                   |
| [`isochronous_4phase_handshake`](src/isochronous_4phase_handshake.sv) | 등시성 4상 핸드셰이크                                                                             | 활성         |                                   |
| [`pulp_sync`](src/deprecated/pulp_sync.sv)                            | 직렬 라인 동기화기                                                                                | *deprecated* | [`sync`](src/sync.sv)             |
| [`pulp_sync_wedge`](src/deprecated/pulp_sync_wedge.sv)                | 에지 감지기를 갖는 직렬 라인 동기화기                                                             | *deprecated* | [`sync_wedge`](src/sync_wedge.sv) |
| [`serial_deglitch`](src/serial_deglitch.sv)                           | 직렬 라인 디글리처                                                                                | 활성         |                                   |
| [`sync`](src/sync.sv)                                                 | 직렬 라인 동기화기                                                                                | 활성         |                                   |
| [`sync_wedge`](src/sync_wedge.sv)                                     | 에지 감지기를 갖는 직렬 라인 동기화기                                                             | 활성         |                                   |

### 카운터 및 시프트 레지스터

| 이름                                                       | 설명                                                             | 상태         | 대체 모듈                            |
| ---------------------------------------------------------- | ---------------------------------------------------------------- | ------------ | ---------------------------------- |
| [`counter`](src/counter.sv)                                | 오버플로 감지를 갖는 범용 업/다운 카운터                         | 활성         |                                    |
| [`credit_counter`](src/credit_counter.sv)                  | 크레딧용 업/다운 카운터                                          | 활성         |                                    |
| [`delta_counter`](src/delta_counter.sv)                    | 가변 델타와 오버플로 감지를 갖는 업/다운 카운터                  | 활성         |                                    |
| [`generic_LFSR_8bit`](src/deprecated/generic_LFSR_8bit.sv) | 8비트 선형 피드백 시프트 레지스터(LFSR)                          | *deprecated* | [`lfsr_8bit`](src/lfsr_8bit.sv)    |
| [`lfsr_8bit`](src/lfsr_8bit.sv)                            | 8비트 선형 피드백 시프트 레지스터(LFSR)                          | 활성         |                                    |
| [`lfsr_16bit`](src/lfsr_16bit.sv)                          | 16비트 선형 피드백 시프트 레지스터(LFSR)                         | 활성         |                                    |
| [`lfsr`](src/lfsr.sv)                                      | 옵션 화이트닝 기능을 갖는 4~64비트 파라메트릭 갈루아 LFSR        | 활성         |                                    |
| [`max_counter`](src/max_counter.sv)                        | 최댓값을 추적하는 가변 델타 업/다운 카운터                       | 활성         |                                    |
| [`mv_filter`](src/mv_filter.sv)                            | **ZARUBAF 설명 추가 필요**                                       | 활성         |                                    |
| [`trip_counter`](src/trip_counter.sv)                      | 지정한 경계에 도달하면 자동으로 리셋되는 카운터                  | 활성         |                                    |

### 데이터 패스 요소

| 이름                                                           | 설명                                                                                                      | 상태         | 대체 모듈                             |
|----------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|--------------|-------------------------------------|
| [`addr_decode`](src/addr_decode.sv)                            | 주소 맵 디코더                                                                                             | 활성         |                                     |
| [`addr_decode_dync`](src/addr_decode_dync.sv)                  | 동적 온라인 설정을 지원하도록 확장된 주소 맵 디코더                                                        | 활성         |                                     |
| [`addr_decode_napot`](src/addr_decode_napot.sv)                | 자연 정렬 2의 제곱(NAPOT) 영역을 사용하는 주소 맵 디코더                                                   | 활성         |                                     |
| [`multiaddr_decode`](src/multiaddr_decode.sv)                  | NAPOT 영역을 사용하며 여러 주소 입력을 허용하는 주소 맵 디코더                                             | 활성         |                                     |
| [`ecc_decode`](src/ecc_decode.sv)                              | SECDED 디코더 (단일 오류 정정, 이중 오류 감지)                                                             | 활성         |                                     |
| [`ecc_encode`](src/ecc_encode.sv)                              | SECDED 인코더 (단일 오류 정정, 이중 오류 감지)                                                             | 활성         |                                     |
| [`binary_to_gray`](src/binary_to_gray.sv)                      | 이진수를 그레이 코드로 변환                                                                                 | 활성         |                                     |
| [`find_first_one`](src/deprecated/find_first_one.sv)           | 최상위 1 탐색기 / 선행 제로 카운터                                                                         | *deprecated* | [`lzc`](src/lzc.sv)                 |
| [`gray_to_binary`](src/gray_to_binary.sv)                      | 그레이 코드를 이진수로 변환                                                                                 | 활성         |                                     |
| [`lzc`](src/lzc.sv)                                            | 선행/후행 제로 카운터                                                                                      | 활성         |                                     |
| [`onehot_to_bin`](src/onehot_to_bin.sv)                        | 원-핫(one-hot)에서 이진수로 변환                                                                            | 활성         |                                     |
| [`shift_reg`](src/shift_reg.sv)                                | 임의 타입을 위한 시프트 레지스터                                                                            | 활성         |                                     |
| [`shift_reg_gated`](src/shift_reg_gated.sv)                    | 임의 타입을 위한 ICG 시프트 레지스터                                                                        | 활성         |                                     |
| [`rr_arb_tree`](src/rr_arb_tree.sv)                            | req/gnt 및 vld/rdy 인터페이스를 위한 선택적 우선순위 라운드 로빈 아비터                                    | 활성         |                                     |
| [`rrarbiter`](src/deprecated/rrarbiter.sv)                     | 예측(look-ahead) 기능을 갖는 req/ack 인터페이스용 라운드 로빈 아비터                                       | *deprecated* | [`rr_arb_tree`](src/rr_arb_tree.sv) |
| [`prioarbiter`](src/deprecated/prioarbiter.sv)                 | 예측 기능을 갖는 req/ack 인터페이스용 우선순위 아비터                                                      | *deprecated* | [`rr_arb_tree`](src/rr_arb_tree.sv) |
| [`fall_through_register`](src/fall_through_register.sv)        | ready/valid 인터페이스를 갖는 폴스루(fall-through) 레지스터                                                | 활성         |                                     |
| [`spill_register_flushable`](src/spill_register_flushable.sv)  | 모든 조합 경로를 차단하며 추가 플러시 신호를 갖는 ready/valid 인터페이스 레지스터                          | 활성         |                                     |
| [`spill_register`](src/spill_register.sv)                      | 모든 조합 경로를 차단하는 ready/valid 인터페이스 레지스터                                                  | 활성         |                                     |
| [`stream_arbiter`](src/stream_arbiter.sv)                      | ready/valid 스트림 인터페이스를 위한 라운드 로빈 아비터                                                    | 활성         |                                     |
| [`stream_arbiter_flushable`](src/stream_arbiter_flushable.sv)  | 플러시 기능을 갖는 ready/valid 스트림 인터페이스용 라운드 로빈 아비터                                      | 활성         |                                     |
| [`stream_demux`](src/stream_demux.sv)                          | ready/valid 인터페이스 디멀티플렉서                                                                        | 활성         |                                     |
| [`lossy_valid_to_stream`](src/lossy_valid_to_stream.sv)        | 진행 중인 트랜잭션을 갱신하여 Valid-only를 ready/valid로 변환                                             | 활성         |                                     |
| [`stream_join`](src/stream_join.sv)                            | 여러 ready/valid 핸드셰이크를 하나로 합산                                                                  | 활성         |                                     |
| [`stream_join_dynamic`](src/stream_join_dynamic.sv)            | 동적으로 설정 가능한 부분 집합 선택을 갖는 ready/valid 핸드셰이크 합산                                    | 활성         |                                     |
| [`stream_mux`](src/stream_mux.sv)                              | ready/valid 인터페이스 멀티플렉서                                                                          | 활성         |                                     |
| [`stream_register`](src/stream_register.sv)                    | ready/valid 인터페이스를 갖는 레지스터                                                                     | 활성         |                                     |
| [`stream_fork`](src/stream_fork.sv)                            | ready/valid 포크(fork)                                                                                     | 활성         |                                     |
| [`stream_fork_dynamic`](src/stream_fork_dynamic.sv)            | 부분 포킹을 위한 선택 마스크를 갖는 ready/valid 포크                                                       | 활성         |                                     |
| [`stream_filter`](src/stream_filter.sv)                        | ready/valid 필터                                                                                            | 활성         |                                     |
| [`stream_delay`](src/stream_delay.sv)                          | ready/valid 인터페이스를 무작위화하거나 지연                                                               | 활성         |                                     |
| [`stream_to_mem`](src/stream_to_mem.sv)                        | 스트림 출력 데이터에 플로우 제어 없는 메모리 사용                                                          | 활성         |                                     |
| [`stream_xbar`](src/stream_xbar.sv)                            | ready/valid 인터페이스를 갖는 완전 연결 크로스바                                                           | 활성         |                                     |
| [`stream_omega_net`](src/stream_omega_net.sv)                  | ready/valid 인터페이스를 갖는 단방향 스트림 오메가 네트워크 (버터플라이와 동형)                            | 활성         |                                     |
| [`stream_throttle`](src/stream_throttle.sv)                    | 스트림에서 진행 중인 전송 수를 제한                                                                        | 활성         |                                     |
| [`sub_per_hash`](src/sub_per_hash.sv)                          | 치환-순열(Substitution-Permutation) 해시 함수                                                              | 활성         |                                     |
| [`popcount`](src/popcount.sv)                                  | 조합 논리 팝카운트 (해밍 가중치)                                                                           | 활성         |                                     |
| [`mem_to_banks_detailed`](src/mem_to_banks_detailed.sv)        | 상세 응답 신호를 갖는 다중 병렬 뱅크에 걸친 메모리 액세스 분할                                            | 활성         |                                     |
| [`mem_to_banks`](src/mem_to_banks.sv)                          | 다중 병렬 뱅크에 걸친 메모리 액세스 분할                                                                  | 활성         |                                     |
| [`heaviside`](src/heaviside.sv)                                | 헤비사이드(Heaviside) 계단 함수를 적용하여 마스크 생성                                                     | 활성         |                                     |
| [`boxcar`](src/boxcar.sv)                                      | 박스카(boxcar) 함수를 적용하여 마스크 생성                                                                 | 활성         |                                     |

### 데이터 구조

| 이름                                                             | 설명                                                                        | 상태         | 대체 모듈                                                                                       |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------- | ------------ | ----------------------------------------------------------------------------------------------- |
| [`cb_filter`](src/cb_filter.sv)                                  | 조합 조회를 갖는 카운팅 블룸 필터(Counting Bloom Filter)                    | 활성         |                                                                                                 |
| [`fifo`](src/deprecated/fifo_v1.sv)                              | 상위 임계값을 갖는 FIFO 레지스터                                            | *deprecated* | [`fifo_v3`](src/fifo_v3.sv)                                                                     |
| [`fifo_v2`](src/deprecated/fifo_v2.sv)                           | 상위 및 하위 임계값을 갖는 FIFO 레지스터                                    | *deprecated* | [`fifo_v3`](src/fifo_v3.sv)                                                                     |
| [`fifo_v3`](src/fifo_v3.sv)                                      | 범용 채움 카운트를 갖는 FIFO 레지스터                                       | 활성         |                                                                                                 |
| [`passthrough_stream_fifo`](src/passthrough_stream_fifo.sv)      | 가득 찬 경우 동일 사이클 푸시/팝이 가능한 ready/valid 인터페이스 FIFO       | 활성         |                                                                                                 |
| [`ring_buffer`](src/ring_buffer.sv)                              | 순차 쓰기 및 임의 접근 읽기 인터페이스를 갖는 링 버퍼                      | 활성         |                                                                                                 |
| [`stream_fifo`](src/stream_fifo.sv)                              | ready/valid 인터페이스를 갖는 FIFO 레지스터                                 | 활성         |                                                                                                 |
| [`stream_fifo_optimal_wrap`](src/stream_fifo_optimal_wrap.sv)    | 스필 레지스터 또는 FIFO를 최적으로 선택하는 래퍼                            | 활성         |                                                                                                 |
| [`generic_fifo`](src/deprecated/generic_fifo.sv)                 | 임계값 없는 FIFO 레지스터                                                   | *deprecated* | [`fifo_v3`](src/fifo_v3.sv)                                                                     |
| [`generic_fifo_adv`](src/deprecated/generic_fifo_adv.sv)         | 임계값 없는 FIFO 레지스터                                                   | *deprecated* | [`fifo_v3`](src/fifo_v3.sv)                                                                     |
| [`sram`](src/deprecated/sram.sv)                                 | SRAM 동작 모델                                                              | *deprecated* | [`tc_sram`](https://github.com/pulp-platform/tech_cells_generic/blob/master/src/rtl/tc_sram.sv) |
| [`plru_tree`](src/plru_tree.sv)                                  | 유사 최근 미사용(PLRU) 트리                                                 | 활성         |                                                                                                 |
| [`unread`](src/unread.sv)                                        | 연결되지 않은 출력을 흡수하는 빈 모듈                                       | 활성         |                                                                                                 |
| [`read`](src/read.sv)                                            | 합성 중 신호 제거를 방지하는 더미 모듈                                      | 활성         |                                                                                                 |

## 헤더 파일 목록

현재 이 저장소에는 다음과 같은 헤더 파일이 포함되어 있습니다.

### RTL 레지스터 매크로

헤더 파일 [`registers.svh`](include/common_cells/registers.svh)는 레지스터 기술(description)로 확장되는 매크로를 포함합니다.
`always_ff` 블록의 오용을 방지하기 위해, 순차 동작 기술 시에는 아래 매크로만 사용해야 합니다.
소스 코드에서 명시적인 `always_ff` 사용을 감지하는 린터 규칙 사용을 권장합니다.

|    매크로     |                             인수                              |                                 설명                                  |
| ------------ | ------------------------------------------------------------- | --------------------------------------------------------------------- |
| <code>`FF</code>     | `q_sig`, `d_sig`, `rst_val`, (`clk_sig`, `arstn_sig`)         | 비동기 액티브-로우 리셋을 갖는 플립플롭                               |
| <code>`FFAR</code>   | `q_sig`, `d_sig`, `rst_val`, `clk_sig`, `arst_sig`            | 비동기 액티브-하이 리셋을 갖는 플립플롭                               |
| <code>`FFARN</code>  | `q_sig`, `d_sig`, `rst_val`, `clk_sig`, `arstn_sig`           | *deprecated* 비동기 액티브-로우 리셋을 갖는 플립플롭                  |
| <code>`FFSR</code>   | `q_sig`, `d_sig`, `rst_val`, `clk_sig`, `rst_sig`             | 동기 액티브-하이 리셋을 갖는 플립플롭                                 |
| <code>`FFSRN</code>  | `q_sig`, `d_sig`, `rst_val`, `clk_sig`, `rstn_sig`            | 동기 액티브-로우 리셋을 갖는 플립플롭                                 |
| <code>`FFNR</code>   | `q_sig`, `d_sig`, `clk_sig`                                   | 리셋 없는 플립플롭                                                    |
|              |                                                               |                                                                       |
| <code>`FFL</code>    | `q_sig`, `d_sig`, `load_ena`, `rst_val`, (`clk_sig`, `arstn_sig`) | 로드 인에이블과 비동기 액티브-로우 리셋을 갖는 플립플롭          |
| <code>`FFLAR</code>  | `q_sig`, `d_sig`, `load_ena`, `rst_val`, `clk_sig`, `arst_sig`    | 로드 인에이블과 비동기 액티브-하이 리셋을 갖는 플립플롭          |
| <code>`FFLARN</code> | `q_sig`, `d_sig`, `load_ena`, `rst_val`, `clk_sig`, `arstn_sig`   | *deprecated* 로드 인에이블과 비동기 액티브-로우 리셋을 갖는 플립플롭 |
| <code>`FFLSR</code>  | `q_sig`, `d_sig`, `load_ena`, `rst_val`, `clk_sig`, `rst_sig`     | 로드 인에이블과 동기 액티브-하이 리셋을 갖는 플립플롭            |
| <code>`FFLSRN</code> | `q_sig`, `d_sig`, `load_ena`, `rst_val`, `clk_sig`, `rstn_sig`    | 로드 인에이블과 동기 액티브-로우 리셋을 갖는 플립플롭            |
| <code>`FFLNR</code>  | `q_sig`, `d_sig`, `load_ena`, `clk_sig`                           | 리셋 없이 로드 인에이블을 갖는 플립플롭                          |
- *암묵적 변형에서 클록과 리셋 신호의 이름은 각각 `clk_i`와 `rst_ni`입니다.*
- *인수 접미사 `_sig`는 현재/다음 상태, 클록, 리셋을 위한 신호 이름을 나타냅니다.*
- *인수 `rst_val`은 리셋 시 할당될 값 리터럴을 지정합니다.*
- *인수 `load_ena`는 레지스터의 로드 인에이블을 구성하는 불리언 표현식을 지정합니다.*

### SystemVerilog 어서션 매크로

헤더 파일 [`assertions.svh`](include/common_cells/assertions.svh)는 어서션 블록으로 확장되는 매크로를 포함합니다.
이 매크로는 많은 어서션 작성 시의 노력을 줄이고 사용을 쉽게 하기 위해 제공됩니다.
[lowrisc](https://github.com/lowRISC/opentitan/blob/master/hw/ip/prim/rtl/prim_assert.sv)의 매크로와 유사하지만 호환되지는 않습니다.

#### 단순 어서션 및 커버 매크로
| 매크로              | 인수                                             | 설명                                                                       |
| ------------------ | ------------------------------------------------ | -------------------------------------------------------------------------- |
| <code>`ASSERT_I</code>     | `__name`, `__prop`, (`__desc`)                   | 즉시(Immediate) 어서션                                                     |
| <code>`ASSERT_INIT</code>  | `__name`, `__prop`, (`__desc`)                   | initial 블록 내 어서션 (파라미터 검사 등에 활용 가능)                      |
| <code>`ASSERT_FINAL</code> | `__name`, `__prop`, (`__desc`)                   | final 블록 내 어서션                                                       |
| <code>`ASSERT</code>       | `__name`, `__prop`, (`__clk`, `__rst`, `__desc`) | 동시(Concurrent) 속성을 직접 어서션                                        |
| <code>`ASSERT_NEVER</code> | `__name`, `__prop`, (`__clk`, `__rst`, `__desc`) | 동시 속성이 절대 발생하지 않음을 어서션                                    |
| <code>`ASSERT_KNOWN</code> | `__name`, `__sig`, (`__clk`, `__rst`, `__desc`)  | 사용자 정의 오류 메시지를 갖는 동기 클록 어서션                            |
| <code>`COVER</code>        | `__name`, `__prop`, (`__clk`, `__rst`)           | 동시 속성 커버리지 측정                                                    |
- *암묵적 변형에서 클록과 리셋 신호의 이름은 각각 `clk_i`와 `rst_ni`입니다.*
- *`__desc`는 어서션 위반 시 오류 보고서에 포함될 선택적 문자열 인수이며 기본값은 `""`입니다.*

#### 복합 어서션 매크로
| 매크로                 | 인수                                                                                | 설명                                                                                                       |
| --------------------- | ----------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| <code>`ASSERT_PULSE</code>    | `__name`, `__sig`, (`__clk`, `__rst`, `__desc`)                                     | 신호가 1 클록 사이클 길이의 액티브-하이 펄스임을 어서션                                                    |
| <code>`ASSERT_IF</code>       | `__name`, `__prop`, `__enable`, (`__clk`, `__rst`, `__desc`)                        | 인에이블 신호가 설정된 경우에만 속성이 참임을 어서션                                                       |
| <code>`ASSERT_KNOWN_IF</code> | `__name`, `__sig`, `__enable`, (`__clk`, `__rst`, `__desc`)                         | 인에이블이 설정된 경우 리셋 후 신호가 알려진 값(각 비트가 '0' 또는 '1')을 가짐을 어서션                   |
| <code>`ASSERT_STABLE</code>   | `__name`, `__valid`, `__ready`, `__data`, `__enable`, (`__clk`, `__rst`, `__desc`)  | ready-valid 인터페이스에서 valid 어서션 후 ready가 될 때까지 데이터가 안정적으로 유지됨을 어서션           |
- *암묵적 변형에서 클록과 리셋 신호의 이름은 각각 `clk_i`와 `rst_ni`입니다.*
- *`__desc`는 어서션 위반 시 오류 보고서에 포함될 선택적 문자열 인수이며 기본값은 `""`입니다.*

#### 가정(Assumption) 매크로

| 매크로          | 인수                                             | 설명                     |
| -------------- | ------------------------------------------------ | ------------------------ |
| <code>`ASSUME</code>   | `__name`, `__prop`, (`__clk`, `__rst`, `__desc`) | 동시 속성 가정           |
| <code>`ASSUME_I</code> | `__name`, `__prop`, (`__desc`)                   | 즉시 속성 가정           |
- *암묵적 변형에서 클록과 리셋 신호의 이름은 각각 `clk_i`와 `rst_ni`입니다.*
- *`__desc`는 어서션 위반 시 오류 보고서에 포함될 선택적 문자열 인수이며 기본값은 `""`입니다.*

#### 형식 검증(Formal Verification) 매크로

| 매크로              | 인수                                             | 설명                                                         |
| ------------------ | ------------------------------------------------ | ------------------------------------------------------------ |
| <code>`ASSUME_FPV</code>   | `__name`, `__prop`, (`__clk`, `__rst`, `__desc`) | 형식 검증 시에만 동시 속성 가정                              |
| <code>`ASSUME_I_FPV</code> | `__name`, `__prop`, (`__desc`)                   | 형식 검증 시에만 동시 속성 가정 (즉시 형식)                  |
| <code>`COVER_FPV</code>    | `__name`, `__prop`, (`__clk`, `__rst`)           | 형식 검증 중 동시 속성 커버리지 측정                         |
- *암묵적 변형에서 클록과 리셋 신호의 이름은 각각 `clk_i`와 `rst_ni`입니다.*
- *`__desc`는 어서션 위반 시 오류 보고서에 포함될 선택적 문자열 인수이며 기본값은 `""`입니다.*
