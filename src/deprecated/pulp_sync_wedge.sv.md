# pulp_sync_wedge.sv (Deprecated)

## 개요

`pulp_sync_wedge`는 비동기 입력 신호를 동기화하고 상승 엣지(rising edge)와 하강 엣지(falling edge)를 검출하는 모듈입니다. `pulp_sync`를 사용하여 동기화를 수행한 뒤, 클럭 게이팅과 1사이클 지연 플립플롭으로 엣지를 검출합니다. 비동기 인터페이스의 핸드셰이크 신호를 로컬 클럭 도메인에서 처리할 때 사용됩니다.

**Deprecated 이유:** PULP 플랫폼 전용 네이밍 규칙을 따르며, `pulp_clock_gating`에 의존합니다. common_cells의 표준 모듈로 대체되었습니다.

**대안 모듈:** `sync_wedge` (common_cells 표준 동기화+엣지 검출 모듈)

---

## 블록 다이어그램

```mermaid
graph TD
    serial_i["serial_i\n(비동기 입력)"]
    clk_i["clk_i"]
    rstn_i["rstn_i"]
    en_i["en_i\n(클럭 게이팅 활성화)"]

    subgraph pulp_sync_wedge ["pulp_sync_wedge"]
        sync["pulp_sync\n(STAGES단 동기화)\nserial → serial (동기화됨)"]
        clk_gate["pulp_clock_gating\n(en_i로 게이팅된 clk)"]
        delay_ff["지연 플립플롭\nserial_q (1사이클 지연)"]
        r_edge["상승 엣지 검출\nr_edge_o = serial & ~serial_q"]
        f_edge["하강 엣지 검출\nf_edge_o = ~serial & serial_q"]
    end

    serial_o["serial_o\n(동기화된 신호, 1사이클 지연)"]
    r_edge_o["r_edge_o\n(상승 엣지 펄스)"]
    f_edge_o["f_edge_o\n(하강 엣지 펄스)"]

    serial_i --> sync
    clk_i --> sync
    rstn_i --> sync
    sync -->|serial (동기화)| delay_ff
    sync -->|serial| r_edge
    sync -->|serial| f_edge
    clk_i --> clk_gate
    en_i --> clk_gate
    clk_gate -->|gated clk| delay_ff
    rstn_i --> delay_ff
    delay_ff -->|serial_q| serial_o
    delay_ff -->|serial_q| r_edge
    delay_ff -->|serial_q| f_edge
    r_edge --> r_edge_o
    f_edge --> f_edge_o
```

---

## 포트/파라미터

### 파라미터

| 파라미터명 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `STAGES` | `int unsigned` | `2` | `pulp_sync` 동기화 플립플롭 단수 |

### 포트

| 포트명 | 방향 | 너비 | 설명 |
|---|---|---|---|
| `clk_i` | input | 1 | 목적지 클럭 도메인 클럭 |
| `rstn_i` | input | 1 | 비동기 액티브 로우 리셋 |
| `en_i` | input | 1 | 클럭 게이팅 활성화 (지연 플립플롭 클럭 제어) |
| `serial_i` | input | 1 | 동기화할 비동기 입력 신호 |
| `r_edge_o` | output | 1 | 동기화된 신호의 상승 엣지 펄스 |
| `f_edge_o` | output | 1 | 동기화된 신호의 하강 엣지 펄스 |
| `serial_o` | output | 1 | 동기화된 신호 (1사이클 지연됨) |

---

## 동작 설명

### 신호 처리 파이프라인

```
serial_i (비동기)
   → pulp_sync (STAGES 사이클 지연) → serial (동기화됨)
   → pulp_clock_gating + FF           → serial_q (1사이클 추가 지연)

r_edge_o =  serial & ~serial_q   (상승 엣지: 현재 High, 이전 Low)
f_edge_o = ~serial &  serial_q   (하강 엣지: 현재 Low, 이전 High)
serial_o = serial_q              (동기화 + 1사이클 지연된 출력)
```

### 엣지 검출 타이밍

- `en_i`가 Low이면 지연 플립플롭의 클럭이 게이팅되어 `serial_q`가 갱신되지 않습니다.
- 따라서 `en_i`가 High인 사이클에서만 엣지 검출이 동작합니다.

### 사용 예시: 비동기 핸드셰이크

`clock_divider` 모듈에서 비동기 `clk_div_valid_i` 신호를 처리할 때 사용됩니다.

```sv
pulp_sync_wedge i_edge_prop (
    .clk_i(clk_i),
    .rstn_i(s_rstn_sync),
    .en_i(1'b1),
    .serial_i(clk_div_valid_i),
    .serial_o(clk_div_ack_o),   // ACK로 사용
    .r_edge_o(s_clk_div_valid_sync),  // 상승 엣지에서 데이터 샘플링
    .f_edge_o()
);
```

---

## 의존성 및 관계

| 하위 모듈 | 역할 |
|---|---|
| `pulp_sync` | 다단 플립플롭 동기화 |
| `pulp_clock_gating` | `en_i`로 제어되는 클럭 게이팅 셀 |

- **상위 모듈:** `clock_divider`
- **대안 모듈:** `sync_wedge` — common_cells 표준 동기화+엣지 검출 모듈
