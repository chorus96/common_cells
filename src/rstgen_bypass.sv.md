# rstgen_bypass (`rstgen_bypass.sv`)

## 개요

테스트 모드 리셋 바이패스 기능이 포함된 리셋 동기화기입니다. 비동기 리셋 신호를 `NumRegs`개의 플립플롭 체인을 통해 클록 도메인에 동기화하며, 테스트 모드에서는 전용 리셋 신호(`rst_test_mode_ni`)로 동기화기를 우회할 수 있습니다. 권장 플립플롭 수는 최소 4개입니다.

## 블록 다이어그램

```mermaid
graph TD
    rst_ni --> MUX1["tc_clk_mux2\n(rst_n 선택)"]
    rst_test_mode_ni --> MUX1
    test_mode_i --> MUX1
    MUX1 -->|rst_n| FF_CHAIN["플립플롭 체인\nsynch_regs_q[NumRegs-1:0]"]
    clk_i --> FF_CHAIN
    FF_CHAIN -->|synch_regs_q[NumRegs-1]| MUX2["tc_clk_mux2\n(rst_no 선택)"]
    rst_test_mode_ni --> MUX2
    test_mode_i --> MUX2
    MUX2 --> rst_no

    FF_CHAIN -->|synch_regs_q[NumRegs-1]| MUX3["tc_clk_mux2\n(init_no 선택)"]
    MUX3 --> init_no
    test_mode_i --> MUX3
```

## 포트 목록

| 포트명 | 방향 | 비트폭 | 설명 |
|--------|------|--------|------|
| `clk_i` | input | 1 | 클록 입력 |
| `rst_ni` | input | 1 | 비동기 리셋 (active-low) |
| `rst_test_mode_ni` | input | 1 | 테스트 모드 전용 리셋 (active-low) |
| `test_mode_i` | input | 1 | 테스트 모드 선택 신호 |
| `rst_no` | output | 1 | 동기화된 리셋 출력 (active-low) |
| `init_no` | output | 1 | 초기화 완료 신호 (active-low) |

## 파라미터

| 파라미터명 | 기본값 | 설명 |
|-----------|--------|------|
| `NumRegs` | `4` | 동기화 플립플롭 체인의 길이 (최소 1, 권장 4 이상) |

## 동작 설명

**리셋 동기화 체인:**

```
rst_n → [FF0] → [FF1] → ... → [FF(NumRegs-1)] → synch_regs_q[NumRegs-1]
```

- 리셋 어서션 시: `rst_n`이 Low가 되면 모든 플립플롭이 비동기적으로 0으로 클리어됩니다.
- 리셋 디어서션 시: `rst_n`이 High가 되면 각 클록 사이클마다 1이 체인 끝으로 시프트됩니다. `NumRegs` 사이클 후 `synch_regs_q[NumRegs-1]`이 1이 되어 `rst_no`가 High로 전환됩니다.

**테스트 모드:**
- `test_mode_i = 1`이면 `rst_no` = `rst_test_mode_ni` (동기화 우회)
- `init_no`는 테스트 모드에서 항상 1 (초기화 완료 상태)

**타이밍 다이어그램 (NumRegs=4):**
```
clk_i:       __|‾|_|‾|_|‾|_|‾|_|‾|_|‾|_|‾|_
rst_ni:       ‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
rst_n(내부):  ‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
rst_no:       ‾‾‾‾‾‾‾‾‾‾‾‾|___|‾‾‾‾‾‾‾‾‾‾‾‾‾‾
              (4 클록 지연 후 디어서션)
```

## 내부 구조

- `synch_regs_q[NumRegs-1:0]`: 리셋 동기화 시프트 레지스터 체인
- 3개의 `tc_clk_mux2` 인스턴스로 테스트 모드 바이패스 구현
- 어서션 검사: `NumRegs < 1`이면 elaboration 오류

## 의존성

- `tc_clk_mux2` (tech_cells_generic)

## 사용 예시

```systemverilog
rstgen_bypass #(
    .NumRegs ( 4 )
) i_rstgen_bypass (
    .clk_i            ( clk              ),
    .rst_ni           ( async_rst_n      ),
    .rst_test_mode_ni ( test_rst_n       ),
    .test_mode_i      ( test_mode        ),
    .rst_no           ( synced_rst_n     ),
    .init_no          ( init_done_n      )
);
```
