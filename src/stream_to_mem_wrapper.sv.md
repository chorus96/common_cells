# stream_to_mem_wrapper (`stream_to_mem_wrapper.sv`)

## 개요

`stream_to_mem_wrapper`는 AMD Custom IP Packaging용 패스스루(wrapper) 모듈로, 내부에서 원본 `stream_to_mem` 모듈을 1:1로 인스턴스화합니다. Wrapper 자체의 기능 로직은 없고, 파라미터/포트를 외부에 노출하는 목적입니다.

## 블록 다이어그램

```mermaid
graph LR
    A["External IP Ports"] --> W["stream_to_mem_wrapper\n(pass-through wrapper)"]
    W --> C["stream_to_mem\n(core module)"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 설명 |
|--------|------|---------|------|
| `clk_i` | `input` | `logic` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `rst_ni` | `input` | `logic` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `req_i` | `input` | `logic [mem_req_t_WIDTH-1:0]` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `req_valid_i` | `input` | `logic` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `req_ready_o` | `output` | `logic` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `resp_o` | `output` | `logic [mem_resp_t_WIDTH-1:0]` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `resp_valid_o` | `output` | `logic` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `resp_ready_i` | `input` | `logic` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `mem_req_o` | `output` | `logic [mem_req_t_WIDTH-1:0]` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `mem_req_valid_o` | `output` | `logic` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `mem_req_ready_i` | `input` | `logic` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `mem_resp_i` | `input` | `logic [mem_resp_t_WIDTH-1:0]` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |
| `mem_resp_valid_i` | `input` | `logic` | 원본 모듈 `stream_to_mem`로 전달되는 포트 |

## 파라미터

| 파라미터 | 선언 | 설명 |
|----------|------|------|
| `parameter int unsigned mem_req_t_WIDTH = 1` | `parameter int unsigned mem_req_t_WIDTH = 1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned mem_resp_t_WIDTH = 1` | `parameter int unsigned mem_resp_t_WIDTH = 1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned BufDepth   = 32'd1` | `parameter int unsigned BufDepth   = 32'd1` | Wrapper에서 동일 이름으로 core에 전달 |

## 연결 방식

- Wrapper 인스턴스는 core 모듈과 명시적 named port 매핑(`.port(port)`)을 사용합니다.
- Wrapper 내부 추가 연산/레지스터/조합 로직은 없습니다.
