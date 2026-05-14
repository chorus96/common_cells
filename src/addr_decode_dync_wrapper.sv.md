# addr_decode_dync_wrapper (`addr_decode_dync_wrapper.sv`)

## 개요

`addr_decode_dync_wrapper`는 AMD Custom IP Packaging용 패스스루(wrapper) 모듈로, 내부에서 원본 `addr_decode_dync` 모듈을 1:1로 인스턴스화합니다. Wrapper 자체의 기능 로직은 없고, 파라미터/포트를 외부에 노출하는 목적입니다.

## 블록 다이어그램

```mermaid
graph LR
    A["External IP Ports"] --> W["addr_decode_dync_wrapper\n(pass-through wrapper)"]
    W --> C["addr_decode_dync\n(core module)"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 설명 |
|--------|------|---------|------|
| `addr_i` | `input` | `logic [addr_t_WIDTH-1:0]` | 원본 모듈 `addr_decode_dync`로 전달되는 포트 |
| `addr_map_i` | `input` | `logic [rule_t_WIDTH-1:0] [NoRules-1:0]` | 원본 모듈 `addr_decode_dync`로 전달되는 포트 |
| `idx_o` | `output` | `logic [idx_t_WIDTH-1:0]` | 원본 모듈 `addr_decode_dync`로 전달되는 포트 |
| `dec_valid_o` | `output` | `logic` | 원본 모듈 `addr_decode_dync`로 전달되는 포트 |
| `dec_error_o` | `output` | `logic` | 원본 모듈 `addr_decode_dync`로 전달되는 포트 |
| `en_default_idx_i` | `input` | `logic` | 원본 모듈 `addr_decode_dync`로 전달되는 포트 |
| `default_idx_i` | `input` | `logic [idx_t_WIDTH-1:0]` | 원본 모듈 `addr_decode_dync`로 전달되는 포트 |
| `config_ongoing_i` | `input` | `logic` | 원본 모듈 `addr_decode_dync`로 전달되는 포트 |

## 파라미터

| 파라미터 | 선언 | 설명 |
|----------|------|------|
| `parameter int unsigned NoIndices = 32'd0` | `parameter int unsigned NoIndices = 32'd0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned NoRules   = 32'd0` | `parameter int unsigned NoRules   = 32'd0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned addr_t_WIDTH = 1` | `parameter int unsigned addr_t_WIDTH = 1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned rule_t_WIDTH = 1` | `parameter int unsigned rule_t_WIDTH = 1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter bit          Napot     = 0` | `parameter bit          Napot     = 0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned IdxWidth  = cf_math_pkg::idx_width(NoIndices)` | `parameter int unsigned IdxWidth  = cf_math_pkg::idx_width(NoIndices)` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned idx_t_WIDTH = 1` | `parameter int unsigned idx_t_WIDTH = 1` | Wrapper에서 동일 이름으로 core에 전달 |

## 연결 방식

- Wrapper 인스턴스는 core 모듈과 명시적 named port 매핑(`.port(port)`)을 사용합니다.
- Wrapper 내부 추가 연산/레지스터/조합 로직은 없습니다.
