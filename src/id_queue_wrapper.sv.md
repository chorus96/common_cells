# id_queue_wrapper (`id_queue_wrapper.sv`)

## 개요

`id_queue_wrapper`는 AMD Custom IP Packaging용 패스스루(wrapper) 모듈로, 내부에서 원본 `id_queue` 모듈을 1:1로 인스턴스화합니다. Wrapper 자체의 기능 로직은 없고, 파라미터/포트를 외부에 노출하는 목적입니다.

## 블록 다이어그램

```mermaid
graph LR
    A["External IP Ports"] --> W["id_queue_wrapper\n(pass-through wrapper)"]
    W --> C["id_queue\n(core module)"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 설명 |
|--------|------|---------|------|
| `clk_i` | `input` | `logic` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `rst_ni` | `input` | `logic` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `inp_id_i` | `input` | `id_t` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `inp_data_i` | `input` | `logic [data_t_WIDTH-1:0]` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `inp_req_i` | `input` | `logic` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `inp_gnt_o` | `output` | `logic` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `exists_data_i` | `input` | `logic [data_t_WIDTH-1:0] [NUM_CMP_PORTS-1:0]` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `exists_mask_i` | `input` | `logic [data_t_WIDTH-1:0] [NUM_CMP_PORTS-1:0]` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `exists_req_i` | `input` | `logic [NUM_CMP_PORTS-1:0]` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `exists_o` | `output` | `logic [NUM_CMP_PORTS-1:0]` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `exists_gnt_o` | `output` | `logic [NUM_CMP_PORTS-1:0]` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `oup_id_i` | `input` | `id_t` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `oup_pop_i` | `input` | `logic` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `oup_req_i` | `input` | `logic` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `oup_data_o` | `output` | `logic [data_t_WIDTH-1:0]` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `oup_data_valid_o` | `output` | `logic` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `oup_gnt_o` | `output` | `logic` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `full_o` | `output` | `logic` | 원본 모듈 `id_queue`로 전달되는 포트 |
| `empty_o` | `output` | `logic` | 원본 모듈 `id_queue`로 전달되는 포트 |

## 파라미터

| 파라미터 | 선언 | 설명 |
|----------|------|------|
| `parameter int ID_WIDTH  = 0` | `parameter int ID_WIDTH  = 0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int CAPACITY  = 0` | `parameter int CAPACITY  = 0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter bit FULL_BW   = 0` | `parameter bit FULL_BW   = 0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter bit CUT_OUP_POP_INP_GNT = 0` | `parameter bit CUT_OUP_POP_INP_GNT = 0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int NUM_CMP_PORTS = 1` | `parameter int NUM_CMP_PORTS = 1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned data_t_WIDTH = 1` | `parameter int unsigned data_t_WIDTH = 1` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam type id_t    = logic[ID_WIDTH-1:0]` | `localparam type id_t    = logic[ID_WIDTH-1:0]` | Wrapper에서 동일 이름으로 core에 전달 |

## 연결 방식

- Wrapper 인스턴스는 core 모듈과 명시적 named port 매핑(`.port(port)`)을 사용합니다.
- Wrapper 내부 추가 연산/레지스터/조합 로직은 없습니다.
