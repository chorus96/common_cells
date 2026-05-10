# clk_mux_glitch_free_tb.sv

## 개요

`clk_mux_glitch_free_tb`는 글리치 없는 클록 멀티플렉서 모듈 `clk_mux_glitch_free`를 검증하는 테스트벤치입니다. 랜덤 주기와 랜덤 위상 오프셋을 가진 복수의 입력 클록 중 하나를 선택할 때 출력 클록에 글리치(짧은 펄스)가 발생하지 않는지 검증합니다. 검증 규칙은 high 펄스 폭과 low 펄스 폭이 선택된 클록의 반주기와 일치해야 한다는 원칙에 기반합니다.

## 테스트 구조 다이어그램

```mermaid
flowchart TD
    subgraph TB["clk_mux_glitch_free_tb"]
        subgraph CLK_GEN["입력 클록 생성 (genvar i=0..NUM_INPUTS-1)"]
            C0["s_clocks[0]\n랜덤 주기 + 랜덤 위상"]
            C1["s_clocks[1]\n랜덤 주기 + 랜덤 위상"]
            Ci["s_clocks[i]\n랜덤 주기 + 랜덤 위상"]
            CN["s_clocks[NUM_INPUTS-1]\n랜덤 주기 + 랜덤 위상"]
        end

        subgraph SEL["sel 자극 생성 (stimulate_sel_input)"]
            S1[s_rstn=0 어서트\n랜덤 1000 MAX_PERIOD 이내]
            S2[s_rstn=1 해제]
            S3[TEST_LENGTH회 반복]
            S4[10~30 MAX_PERIOD 대기]
            S5[s_sel 랜덤 변경\n0 ~ NUM_INPUTS-1]
            S1 --> S2 --> S3 --> S4 --> S5 --> S3
        end

        subgraph DUT["clk_mux_glitch_free\n(NUM_INPUTS=10)"]
            MUX["입력 클록 중\ns_sel 번째 선택\n→ s_clock_output"]
        end

        CLK_GEN -- s_clocks --> DUT
        SEL -- s_sel, s_rstn --> DUT
        DUT --> s_clock_output

        subgraph CHECK["출력 클록 검사 (check_clock)"]
            E1[posedge s_clock_output]
            E2[low 펄스 폭 측정]
            E3{이전 high 폭과 동일?}
            E4[target_periods[s_sel]/2 이상 확인]
            E5[negedge s_clock_output]
            E6[high 펄스 폭 측정]
            E7{이전 low 폭과 동일?}
            E8[target_periods[s_sel]/2와 일치 확인]
            E1 --> E2 --> E3
            E3 -- No --> E4 --> E5
            E3 -- Yes --> E5
            E5 --> E6 --> E7
            E7 -- No --> E8 --> E1
            E7 -- Yes --> E1
        end
    end
```

## 테스트 시나리오

### 1. 랜덤 입력 클록 생성
- `NUM_INPUTS = 10`개의 입력 클록을 각각 독립적인 `initial` 블록으로 생성합니다.
- 각 클록 주기는 `MIN_PERIOD(1ns) ~ MAX_PERIOD(3ns)` 범위에서 `TIME_RESOLUTION(0.1ns)` 단위로 랜덤하게 결정됩니다.
- 각 클록의 위상(시작 시간)도 `0 ~ MAX_PERIOD` 범위에서 랜덤하게 설정됩니다.
- 선택된 주기 값은 `target_periods[i]` 배열에 저장되어 검증 시 참조됩니다.

### 2. 하드 리셋 시나리오
- `s_rstn = 0`으로 리셋을 어서트하고 0~1000 MAX_PERIOD 범위의 랜덤 시간 동안 유지합니다.
- 리셋 중 `s_sel`을 랜덤값으로 설정하여 리셋 상태에서의 클록 선택을 검증합니다.
- 리셋 해제 후 정상 동작을 검증합니다.

### 3. 랜덤 클록 전환 스트레스 테스트 (`TEST_LENGTH = 1000`)
- 리셋 해제 후 `TEST_LENGTH`회 반복합니다.
- 매 반복마다 `10 ~ 30 MAX_PERIOD` 범위의 랜덤 시간을 대기합니다.
- `s_sel`을 `0 ~ NUM_INPUTS-1` 범위에서 랜덤하게 변경합니다.
- 서로 다른 주기와 위상을 가진 클록 사이를 비동기적으로 전환합니다.

### 4. 글리치 검출 검증 (`check_clock`)

검증 규칙:
- **low 펄스**: 이전 high 펄스 폭과 다를 경우(클록 전환 직후), `target_periods[s_sel]/2` 이상인지 확인합니다.
- **high 펄스**: 이전 low 펄스 폭과 다를 경우(클록 전환 직후), `target_periods[s_sel]/2`와 `TIME_RESOLUTION` 내 오차로 일치하는지 확인합니다.
- 위반 시 `$error`를 출력하고 `num_errors`를 증가시킵니다.

이중 조건 확인 방식:
- 연속된 동일 주기 펄스는 전환 중이 아닌 것으로 판단하여 엄격한 검사를 건너뜁니다.
- 이를 통해 클록 전환 과도 구간의 허용 여유를 제공합니다.

### 5. 테스트 종료
- `TEST_LENGTH` 반복 완료 후 출력 클록 상승 에지 10개를 추가 대기합니다.
- `$info`로 총 오류 수를 출력하고 `$stop()`으로 시뮬레이션을 종료합니다.

## 포트/파라미터

| 파라미터 | 타입 | 기본값 | 설명 |
|---------|------|--------|------|
| `NUM_INPUTS` | `int unsigned` | `10` | 입력 클록 수 |
| `MIN_PERIOD` | `realtime` | `1ns` | 입력 클록 최소 주기 |
| `MAX_PERIOD` | `realtime` | `3ns` | 입력 클록 최대 주기 |
| `TIME_RESOLUTION` | `realtime` | `0.1ns` | 시간 해상도 (시뮬레이션 최소 단위) |
| `TEST_LENGTH` | `int` | `1000` | 클록 전환 반복 횟수 |
| `SEL_WIDTH` (localparam) | `int unsigned` | `$clog2(NUM_INPUTS)` | 선택 신호 비트 폭 |

| 신호 | 방향 | 설명 |
|------|------|------|
| `s_clocks [NUM_INPUTS-1:0]` | input to DUT | 입력 클록 배열 |
| `s_sel [SEL_WIDTH-1:0]` | input to DUT | 클록 선택 신호 |
| `s_rstn` | input to DUT | 비동기 액티브-로우 리셋 |
| `s_clock_output` | output from DUT | 선택된 글리치 없는 출력 클록 |
| `target_periods [NUM_INPUTS-1:0]` | 내부 | 각 입력 클록의 실제 주기 기록 |
| `num_errors` | 내부 | 검출된 글리치/오류 카운터 |

## 의존성

| 모듈 | 설명 |
|------|------|
| `clk_mux_glitch_free` | 글리치 없는 클록 멀티플렉서 (DUT) |
