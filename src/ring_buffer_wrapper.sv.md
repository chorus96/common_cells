# ring_buffer_wrapper (`ring_buffer_wrapper.sv`)

## 개요

`ring_buffer_wrapper`는 AMD Custom IP Packaging용 패스스루(wrapper) 모듈로, 내부에서 원본 `ring_buffer` 모듈을 1:1로 인스턴스화합니다. Wrapper 자체의 기능 로직은 없고, 파라미터/포트를 외부에 노출하는 목적입니다.

## 블록 다이어그램

```mermaid
graph LR
    A["External IP Ports"] --> W["ring_buffer_wrapper\n(pass-through wrapper)"]
    W --> C["ring_buffer\n(core module)"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 설명 |
|--------|------|---------|------|
| `clk_i` | `input` | `logic` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `rst_ni` | `input` | `logic` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `wvalid_i` | `input` | `logic` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `wready_o` | `output` | `logic` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `wdata_i` | `input` | `logic [data_t_WIDTH-1:0]` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `rvalid_i` | `input` | `logic` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `rready_o` | `output` | `logic` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `raddr_i` | `input` | `addr_t` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `rdata_o` | `output` | `logic [data_t_WIDTH-1:0]` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `advance_i` | `input` | `logic` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `step_i` | `input` | `step_t` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `wptr_o` | `output` | `addr_t` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `rptr_o` | `output` | `addr_t` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `full_o` | `output` | `logic` | 원본 모듈 `ring_buffer`로 전달되는 포트 |
| `empty_o` | `output` | `logic` | 원본 모듈 `ring_buffer`로 전달되는 포트 |

## 파라미터

| 파라미터 | 선언 | 설명 |
|----------|------|------|
| `parameter int unsigned Depth = 32` | `parameter int unsigned Depth = 32` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned data_t_WIDTH = 1` | `parameter int unsigned data_t_WIDTH = 1` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam int unsigned AddrWidth = cf_math_pkg::idx_width(Depth)` | `localparam int unsigned AddrWidth = cf_math_pkg::idx_width(Depth)` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam int unsigned StepWidth = cf_math_pkg::idx_width(Depth+1)` | `localparam int unsigned StepWidth = cf_math_pkg::idx_width(Depth+1)` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam type addr_t = logic [AddrWidth-1:0]` | `localparam type addr_t = logic [AddrWidth-1:0]` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam type step_t = logic [StepWidth-1:0]` | `localparam type step_t = logic [StepWidth-1:0]` | Wrapper에서 동일 이름으로 core에 전달 |

## 연결 방식

- Wrapper 인스턴스는 core 모듈과 명시적 named port 매핑(`.port(port)`)을 사용합니다.
- Wrapper 내부 추가 연산/레지스터/조합 로직은 없습니다.
