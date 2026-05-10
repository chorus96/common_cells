# 변경 이력 (Changelog)
이 프로젝트의 주요 변경 사항은 모두 이 파일에 기록됩니다.

형식은 [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)를 따르며,
이 프로젝트는 [시맨틱 버저닝(Semantic Versioning)](http://semver.org/spec/v2.0.0.html)을 준수합니다.

## 1.39.0 - 2025-11-20
### 추가
- `boxcar`: 비트 마스크를 구성하는 박스카(boxcar) 함수 추가
- `heaviside`: 비트 마스크를 구성하는 헤비사이드(Heaviside) 함수 추가
- `ring_buffer`: 순차 쓰기 및 임의 읽기를 갖는 링 버퍼 추가
- `trip_counter`: 임계값에 도달하면 'trip' 출력이 발생하는 카운터 추가

### 변경
- `cb_filter`, `id_queue`, `lzc`, `rr_arb_tree`: Verilator 시뮬레이션 속도 개선
- `cdc_fifo_gray*`, `isochronous_spill_register`: 리셋 없는 플립플롭을 리셋 있는 플립플롭으로 변경
- `isochronous_spill_register`: 불필요한 데이터 안정성 어서션 제거
- `addr_decode*`: 가정된 정수 인덱스를 임의 타입으로 변경 (기본값은 정수 유지)

### 수정
- `id_queue`: 구조체 접근 방식 수정
- `cdc_fifo_gray*`: Spyglass 린팅 엣지 케이스 수정
- `lzc`: 퇴화 케이스 `WIDTH == 0`에 대한 어서션 수정
- 가드 구문 추가로 Verilator 컴파일 오류 수정

## 1.38.0 - 2025-02-28
### 변경
- Verilator에서 어서션이 더 이상 비활성화되지 않음. 비활성화하려면 `ASSERTS_OFF`를 정의하세요.
- 어서션을 끄는 다른 정의를 재정의하려면 `ASSERTS_OVERRIDE_ON`을 정의하세요.
- `id_queue`: 비교 포트 수를 파라미터로 설정 가능.
- `assertions.svh`: 어서션 매크로에 선택적 인수를 추가하여 사용자 정의 오류 메시지 표시 가능.
- `stream_to_mem`: 리셋 중 어서션 비활성화.
- `addr_decode_dync`, `cdc_fifo_gray_clearable`, `multiaddr_decode`, `spill_register_flushable`: `$warning`을 `$error`로 격상.
- `rr_arb_tree`, `stream_omega_net`, `stream_xbar`: 기본 어서션 비활성화 제거.

### 수정
- `delta_counter`: 반전된 리셋 수정.
- `stream_join_dynamic`: 선택된 스트림만 핸드셰이크 처리.
- 다양한 도구 호환성 개선.

## 1.37.0 - 2024-07-18
### 추가
- `credit_counter`: 크레딧용 업/다운 카운터 추가.

### 수정
- `mem_to_banks_detailed`: 전체 데드 라이트 후 불필요한 응답이 발생하지 않도록 수정.

## 1.36.0 - 2024-07-08
### 수정
- `registers`: FFARNC 매크로의 else 구문 수정.
- `stream_arbiter_flushable`: 우선순위 아비터가 잠기지 않도록 수정.

## 1.35.0 - 2024-04-22
### 변경
- `id_queue`: 크리티컬 패스를 차단하는 파라미터 추가.

## 1.34.0 - 2024-04-09
### 변경
- `stream_xbar`: 페이로드 어서션 안정성 마스크 추가.

## 1.33.1 - 2024-03-16
### 수정
- `stream_omega_net`: 어서션 수정.
- gitlab-ci 트리거 조건을 `pull_request`로 되돌림.

## 1.33.0 - 2024-03-07
### 추가
- `passthrough_stream_fifo` 추가: 타이밍 경로를 차단하지 않는 스트림 FIFO. 가득 찬 경우 동시 푸시/팝이 가능.
- Registers: FFARNC 매크로 추가: 비동기 액티브-로우 리셋 및 동기 클리어를 갖는 플립플롭.

### 변경
- Verilator에서 어서션 활성화.
- IEEE 1364.1-2005 spec 6.3.2에 따라 `pragma translate_off` 구문을 `` `ifndef SYNTHESIS ``으로 변경.
- `plru_tree`: 출력이 one-hot임을 확인하는 어서션 추가.
- CI 트리거 조건 업데이트.

### 수정
- `onehot_to_bin`: 할당에서 비트 폭 불일치 수정.
- `plru_tree`: 도구 호환성 개선.
- `stream_xbar`: 마스킹된 어서션 수정.

## 1.32.0 - 2023-09-26
### 추가
- `stream_join_dynamic` 추가: 동적으로 설정 가능한 부분 집합 선택을 갖는 `stream_join`.
- `multiaddr_decode` 추가: NAPOT 영역을 사용하며 여러 주소 입력을 허용하는 주소 맵 디코더.
- `addr_decode_dync` 추가: 동적 온라인 설정을 지원하는 `addr_decode`.

### 변경
- `mem_to_banks`: `NumBanks`의 기본값을 `0`에서 `1`로 변경 (0으로 나누기 방지).

## 1.31.1 - 2023-08-09
### 수정
- `mem_to_banks`: localparam 기본값 유지

## 1.31.0 - 2023-08-08
### 추가
- `mem_to_banks_detailed` 추가: 상세 응답 신호를 갖는 `mem_to_banks`

### 수정
- `unread`: Vivado 타겟 시 블랙박스 추론을 방지하는 더미 신호 할당 추가

## 1.30.0 - 2023-06-09
### 추가
- `lossy_valid_to_stream` 추가: valid-only 프로토콜과 ready-valid 간 변환기. 최신 트랜잭션이 가장 최근에 큐에 있던 것을 덮어씀.
- `clk_int_div_static` 추가: 정적 클록 분주를 위한 `clk_int_div` 래퍼.

### 변경
- `popcount`: 리팩토링 및 모든 입력 폭 지원.
- `clk_int_div`: 리셋 중 클록 출력 지원.
- `stream_delay`: 더 큰 카운트 지원.

### 수정
- `clk_int_div`: 가능한 교착 상태 수정 및 홀드 이슈 방지.

## 1.29.0 - 2023-04-14
### 추가
- `shift_reg_gated` 추가: 임의 타입을 위한 ICG 시프트 레지스터.

### 변경
- CI: 내부 gitlab 미러에서 `test/` 테스트벤치 실행.
- `fifo_tb`: 2의 제곱이 아닌 DEPTH에 대한 테스트 추가.

### 수정
- `clk_int_div`: 클록이 비활성화된 동안 설정 허용.
- `mem_to_banks`: HideStrb 기능의 가능한 타이밍 루프 차단.
- 도구 호환성 개선 (Verilator, Questasim, Synopsys).

## 1.28.0 - 2022-12-15
### 추가
- `clk_mux_glitch_free` 추가: 글리치 없는 클록 멀티플렉서.

## 1.27.1 - 2022-12-06
### 수정
- `fall_through_register`: 도구 호환성을 위해 불필요한 `$size()` 호출 제거

## 1.27.0 - 2022-12-01
### 추가
- `mem_to_banks` 추가: 여러 병렬 뱅크에 걸친 메모리 액세스 분할.
  [`axi_to_mem`](https://github.com/pulp-platform/axi/blob/2f395b176bee1c769c80f060a4345fda965bb04b/src/axi_to_mem.sv#L563) 모듈에서 이전.
- `read` 추가: 합성 중 신호 제거를 방지하는 더미 모듈

### 변경
- `stream_fifo_optimal_wrap`: 어서션 제거
- `fall_through_register`: FIFO를 `fifo_v3`으로 업데이트

### 수정
- FuseSoC: `assertions.svh` 추가

## 1.26.0 - 2022-08-26
### 추가
- `stream_throttle` 추가: 스트림에서 진행 중인 전송 수를 제한.

### 변경
- `addr_decode` 모듈의 addr_map에서 주소 공간 끝에 대해 범위 초과(즉, `'0`) 상위 주소를 허용.
- CI 업데이트.

## 1.25.0 - 2022-08-10
### 추가
- `addr_decode_napot` 추가: 시작/끝 주소 대신 기본 주소와 마스크를 사용하는 `addr_decode` 변형.
- `stream_fifo_optimal_wrap` 추가: `depth == 2`인 경우 더 최적의 `spill_register`를 인스턴스화.

### 변경
- 내부 FIFO를 FF로 교체하여 `stream_register`를 진정한 스트림으로 개선.
- `id_queue` 파라미터에서 `$bits()` 호출 사용 회피.
- 호환성 문제로 Vivado IP 패키저 프로젝트 소스에서 `cb_filter` 및 `cb_filter_pkg` 제거.
- 조합 글리치 방지를 위해 `rstgen_bypass`에서 글리치 없는 먹스로 `tc_clk_mux` 사용.
- 시뮬레이터 호환성을 위해 테스트벤치에서 프로그램 블록 사용 회피.

### 수정
- `src_files.yml` 및 `common_cells.core` 업데이트

## 1.24.1 - 2022-04-13
### 수정
- `Bender.yml` 및 `src_files.yml`의 오타 수정

## 1.24.0 - 2022-03-31
### 추가
- `edge_propagator_ack` 추가: 송신 측 동기 수신 확인(ACK) 출력을 갖는 에지/펄스 전파기. `edge_propagator`는 이제 `edge_propagator_ack`를 인스턴스화하여 구현.
- `4phase_cdc` 추가: 글리치 없는 리셋을 허용하는 4상 핸드셰이킹 CDC (내부적으로 새로운 clearable CDC IP에 사용).
- 2상 CDC의 단방향 clearable 및/또는 비동기 리셋 가능한 변형 추가 (`cdc_2phase_clearable`) 및 그레이 카운팅 FIFO CDC (`cdc_fifo_gray_clearable`).
- CDC에서 클록 도메인 간 리셋/동기 클리어 시퀀싱을 지원하는 리셋 CDC 컨트롤러 `cdc_reset_ctrl` 추가 (내부적으로 clearable CDC IP에 사용).
- 런타임에 분주 비율을 설정할 수 있고 글리치 없는 50% 듀티 사이클 출력 클록을 갖는 `clk_int_div` 임의 정수 클록 분주기 추가.
- `lzc`에 파라미터 검증 어서션 추가.

### 수정
- `isochronous_4phase_handshake` 및 `isochronous_spill_register` 어서션의 리셋 극성 수정
- Verilator와의 `sub_per_hash` 구문 호환성 수정

### 변경
- `sync` 셀의 FF에 `dont_touch` 및 `async_reg` 속성 추가.
- 기존 CDC IP의 리셋 동작 문서(모듈 헤더) 개선.
- 결함 있는 `clk_div` 모듈을 deprecated 처리하고 기존 설계에 표시될 elaboration 경고 메시지 추가 (선택적 인스턴스화 파라미터로 비활성화 가능).
- `stream_delay` 모듈에 선택적 `Seed` 파라미터 추가
- `tech_cells_generic`를 `0.2.9`로 업데이트

## 1.23.0 - 2021-09-05
### 추가
- `cc_onehot` 추가
- `isochronous_4phase_handshake`: 4상 핸드셰이크를 사용하여 모든 경로를 차단하는 등시성 CDC.
- `isochronous_spill_register_tb`를 `isochronous_crossing_tb`로 변경하여 `isochronous_4phase_handshake` 모듈도 커버.
- `sync` 모듈의 리셋 값을 파라미터로 설정 가능하도록 변경.

### 변경
- `id_queue`: `FULL_BW` 모드에서 동시 입출력 요청 허용

## 1.22.1 - 2021-06-14
### 수정
- `spill_register`의 호환성을 깨는 변경 사항 롤백

## 1.22.0 - 2021-06-09
### 추가
- `spill_register_flushable` 추가

### 변경
- `registers.svh`: 명시적 및 암묵적 레지스터 변형을 `` `FF `` 및 `` `FFL `` 매크로로 통합
- `rr_arb_tree`: 잠긴 결정 플러싱 허용
- `verific` 호환성 개선

## 1.21.0 - 2021-01-28
### 변경
- `timeprecision/timeunit` 인수 제거
- `common_verification`을 `0.2.0`으로 업데이트
- `tech_cells_generic`을 `0.2.3`으로 업데이트

## 1.20.1 - 2021-01-21
### 변경
- `id_queue`: `'x`가 할당된 신호의 기본 또는 리셋 값을 `'0`으로 교체.
- `id_queue`: localparam 계산에 `cf_math_pkg::idx_width()` 사용.

### 수정
- `xsim`과 호환되지 않는 구문에 대한 `XSIM` define 가드 추가.

## 1.20.0 - 2020-11-04
### 추가
- assertions: 매크로를 포함한 어서션 헤더 추가 (lowrisc에서 가져옴)

### 변경
- `sram.sv`: `tech_cells_generic`으로 이전되어 deprecated 처리

### 수정
- `stream_register`: 인스턴스화된 FIFO의 `DATA_WIDTH` 수정.
- `stream_xbar`: 어서션 오류 문자열의 누락된 인수 추가.
- 린트 스타일 수정
- `stream_omega`: verible을 사용한 파싱 문제 수정.
- `src_files.yml`: 컴파일 순서 및 누락된 모듈 수정.

## 1.19.0 - 2020-05-25
### 추가
- stream_to_mem: 요청에는 플로우 제어(req/gnt)를 사용하지만 출력 데이터에는 플로우 제어 없이 메모리를 스트림에서 사용 가능.
- isochronous_spill_register: 모든 경로를 차단하는 등시성 CDC.
- `rr_arb_tree_tb`: 공정한 처리량을 검사하는 `rr_arb_tree` SystemVerilog 테스트벤치.
- `cf_math_pkg::idx_width`: 인덱스 신호의 이진 표현 폭을 정의하는 상수 함수.

### 변경
- `addr_decode`: 인덱스 폭 계산에 `cf_math_pkg::idx_width` 사용, 인라인 문서화.
- `lzc`: 인덱스 폭 계산에 `cf_math_pkg::idx_width` 사용, 인라인 문서화.
- `Bender`: `cf_math_pkg::idx_width()`에 영향받는 모듈의 레벨 변경.
- `stream_xbar`: 가변 입출력 수를 갖는 완전 연결 스트림 기반 인터커넥트.
- `stream_omega_net`: 오메가 토폴로지를 구현하는 스트림 기반 네트워크. 가변 입력 수, 출력 수, 기수(radix). 버터플라이 네트워크와 동형.

### 수정
- 도구 호환성 개선.
- `rr_arb_tree`: `rr_i` 및 `idx_o` 신호의 퇴화 케이스 올바르게 처리.
- `rr_arb_tree`: 모든 입력에 요청이 없을 때 입력 요청의 처리량을 균등하게 분배하는 `FairArb` 파라미터 추가.
- `stream_demux`: `inp_sel_i` 신호의 퇴화 케이스 올바르게 처리.

## 1.18.0 - 2020-04-15
### 추가
- stream_fork_dynamic: 부분 포킹을 위한 `stream_fork` 래퍼.
- stream_join: 여러 Ready/Valid 핸드셰이크를 하나의 공통 핸드셰이크로 합산.
- SECDED (단일 오류 정정, 이중 오류 감지) 인코더 및 디코더
- SECDED Verilator 기반 테스트벤치
- SECDED 모듈을 위한 Travis 빌드

## 1.17.0 - 2020-04-09
### 추가
- stream_fifo: `fifo_v3`을 감싸는 Ready/Valid 핸드셰이크 래퍼

## 1.16.4 - 2020-03-02
### 수정
- id_queue: `head_tail_q` 레지스터 생성 수정

## 1.16.3 - 2020-02-11
### 수정
- `NoIndices == 1`인 퇴화된 `addr_decode` 처리, 기본 파라미터를 `32'd0`으로 변경

## 1.16.2 - 2020-02-04
### 수정
- `Bender.yml`의 작성자 섹션 수정

## 1.16.1 - 2020-02-03
### 수정
- `rr_arb_tree`: Verilator를 위한 SVA 구문 가드 추가
- `Bender.yml` 및 `src_files.yml`의 누락된 소스 추가

## 1.16.0 - 2020-01-13
### 수정
- `ONEHOT_WIDTH == 1`인 퇴화된 `onehot_to_bin` 처리
- `CAPACITY == 1` 또는 `HT_CAPACITY == 1`인 퇴화된 `id_queue` 처리
- 안전한 CDC가 되도록 `cdc_fifo_gray` 수정

## 1.15.0 - 2019-12-09
### 추가
- 주소 맵 디코더 모듈 추가

### 수정
- `WIDTH == 1`인 퇴화된 `lzc` 처리

## 1.14.0 - 2019-10-08

### 추가
- 치환-순열 해시 함수 모듈 추가
- 카운팅 블룸 필터 모듈 추가
- `spill_register`: Bypass 파라미터 추가
- `counter`: 스티키(sticky) 오버플로 추가
- 가변 델타 카운터 추가
- 최댓값을 추적하는 카운터 추가

### 변경
- `fifo` 및 `fall_through_register`에 대한 형식 테스트벤치 추가

## 1.13.1 - 2019-06-01

### 변경

- `stream_arbiter` 및 `stream_arbiter_flushable`에 대한 `src_files.yml`의 경로 수정

## 1.13.0 - 2019-05-29

### 추가

- 지수 백오프 윈도우 모듈 추가
- 옵션 화이트닝 기능을 갖는 파라메트릭 갈루아 LFSR 모듈 추가
- `cf_math_pkg` 추가: HDL elaboration을 위한 수학 함수의 상수 함수 구현체

### 변경
- `rr_arb_tree`의 파라메트릭 페이로드 데이터 타입

### Deprecated
- 다음 아비터 구현은 deprecated 처리되어 `rr_arb_tree`로 대체됩니다:
- 우선순위 아비터 `prioarbiter`
- 라운드 로빈 아비터 `rrarbiter`

### 수정

## 1.12.0 - 2019-04-09

### 추가
- 우선순위 아비터 추가
- 유사 최근 미사용(PLRU) 트리 추가
- 라운드 로빈 아비터 먹스 트리 추가

### 변경
- `stream_arbiter` 및 `stream_arbiter_flushable`에 선택 가능한 아비터 구현 추가. 우선순위(`prio`)와 라운드 로빈(`rr`) 중 선택 가능.
- one-hot to bin에 `$onehot0` 어서션 추가
- `rrarbiter` 유닛 재작성 (내부적으로 `rr_arb_tree` 구현 사용)

## 1.11.0 - 2019-03-20

### 추가
- 스트림 포크 추가
- 폴스루 레지스터 추가
- 스트림 필터 추가
- ID 큐 추가

### 변경
- `sync_wedge`에서 기존 동기화기 사용. 이를 통해 기술 특화 동기화기를 정의할 단일 위치가 결정됨.

### 수정
- `stream_register`의 FIFO 푸시 및 팝 신호가 인터페이스 전제 조건을 준수하도록 수정.
- `fifo_v3`에서 빈 폴스루 FIFO에 푸시할 때 데이터 출력 수정. 이전에는 입력 데이터가 있고(`push_i=1`) 빈 폴스루 FIFO의 데이터 출력이 `pop_i`에 의존했음: `pop_i=0`인 경우, `empty_o=0`임에도 불구하고 유효하지 않은 오래된 데이터가 출력에 보였음. `pop_i=1`인 경우에만 입력 데이터가 폴스루됨. 이 버그의 결과 중 하나로 `valid_o=1`인 동안 `fall_through_register`의 `data_o`가 변경될 수 있었으며, 이는 기본 스트림 사양을 위반하는 것이었음.

## 1.10.0 - 2018-12-18

### 추가
- 범용 채움 카운트를 갖는 `fifo_v3` 추가
- 16비트 LFSR 추가
- 스트림 지연기 추가
- 스트림 아비터 추가
- RTL 레지스터 매크로 추가
- 시프트 레지스터 추가

### 변경
- `rstgen_bypass`의 레지스터 수를 파라미터로 설정.

### 수정
- 하위 호환성을 위해 `generic_fifo`의 `valid_i` 및 `grant_i` 보장 수정.
- LZC: 삼항 연산자에서 스트리밍 연산자의 합성
- `Bender.yml`에 `popcount`에 대한 누락된 항목 추가.
- Synopsys DC 및 Vivado와의 호환성 향상을 위해 파라미터에 기본값 추가.

## 1.9.0 - 2018-11-02

### 추가
- 팝카운트 회로 `popcount` 추가

## 1.8.0 - 2018-10-15

### 추가
- rrarbiter에 잠금 기능 추가. 여러 사이클 동안 미처리된 요청이 남아 있는 경우 아비터의 결정이 변경되지 않도록 방지.
- 디글리칭 회로 추가
- 범용 클록 분주기 추가
- `sync_wedge`에 대한 별칭으로 에지 감지기 추가 (이름이 더 명확함)
- 범용 카운터 추가
- 이동 디글리처 추가

## 1.7.6 - 2018-09-27

### 추가
- 테스트 모드에서 명시적 리셋 바이패스를 갖는 리셋 동기화기 추가

## 1.7.5 - 2018-09-06
### 수정
- Verilator와의 비호환성 수정
- 오픈 소스 저장소 의존성 수정

## 1.7.4 - 2018-09-06
- `fifo_v2`의 어서션 수정 (가득 찼을 때 쓰기 / 비었을 때 읽기가 올바르게 트리거되지 않음)

## 1.7.3 - 2018-08-27
### 수정
- `generic_fifo` 모듈에서 올바른 `fifo_v2` 사용.

## 1.7.2 - 2018-08-27
### 추가
- `fifo_v2`로서 FIFO에 거의 가득 참/거의 비어 있음 플래그 추가.

### 변경
- FIFO가 `fifo_v1`로 이동되어 `fifo_v2`를 인스턴스화.

## 1.7.1 - 2018-08-27
### 수정
- `fifo`의 호환성을 깨는 변경 사항 롤백.

## 1.7.0 - 2018-08-24
### 추가
- 스트림 레지스터(`stream_register`) 추가.
- 스트림 멀티플렉서 및 디멀티플렉서 추가 (`stream_mux`, `stream_demux`).
- 라운드 로빈 아비터(`rrarbiter`) 추가.
- 선행 제로 카운터(`lzc`) 추가.

### 변경
- `lzc` 도입으로 `find_first_one` deprecated 처리.

## 1.6.0 - 2018-04-03
### 추가
- 이진수를 그레이 코드로 변환하는 모듈 추가.
- 그레이 코드를 이진수로 변환하는 모듈 추가.
- 그레이 코드 테스트벤치 추가.
- 그레이 카운터 기반의 CDC FIFO 추가. 도메인 클록이 멈춘 경우에도 동작하는 2상 FIFO의 더 빠른 대안.

### 변경
- `cdc_fifo`를 `cdc_fifo_2phase`로 이름 변경.
- 두 구현 모두를 커버하도록 CDC FIFO 테스트벤치 조정.

## 1.5.4 - 2018-03-31
### 변경
- `fifo`에서 명시적 클록 게이트를 암묵적인 것으로 교체.

## 1.5.3 - 2018-03-16
### 변경
- 중복된 deprecated 모듈 제거.

## 1.5.2 - 2018-03-16
### 변경
- deprecated `rstgen` 제거 및 인터페이스 수정.

## 1.5.1 - 2018-03-16
### 변경
- deprecated `onehot_to_bin` 제거.

## 1.5.0 - 2018-03-14
### 추가
- 동작 수준 SRAM 모델 추가

## 1.4.0 - 2018-03-14
### 추가
- 클록 도메인 크로싱 FIFO 추가

### 변경
- 네임스페이스 충돌 해결을 위해 새 sync 모듈 이름 변경

## 1.3.0 - 2018-03-12
### 추가
- 2상 클록 도메인 크로싱 추가
- 이전 common cells를 deprecated 레거시 모듈로 추가

## 1.2.3 - 2018-03-09
### 추가
- `generic_LFSR_8bit`를 위한 하위 호환성 래퍼 추가

## 1.2.2 - 2018-03-09
### 추가
- `generic_fifo`를 위한 하위 호환성 래퍼 추가

## 1.2.1 - 2018-03-09
### 수정
- 트랜잭션이 손실되는 스필 레지스터 문제 수정

## 1.2.0 - 2018-03-09
### 추가
- 스필 레지스터 추가

## 1.1.0 - 2018-03-06
### 추가
- 첫 번째 제로 탐색 추가

## 1.0.0 - 2018-03-02
### 추가
- 모든 사용 사례를 지원하는 범용 FIFO 재구현
- FIFO 테스트벤치 추가

### 변경
- 재형식화 및 코드 정리

## 0.1.0 - 2018-02-23
### 추가
- PULP common cells 저장소 포크
