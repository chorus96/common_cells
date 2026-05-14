# lzc_wrapper (`lzc_wrapper.sv`)

## 개요

`lzc_wrapper`는 AMD Custom IP Packaging용 패스스루(wrapper) 모듈로, 내부에서 원본 `lzc` 모듈을 1:1로 인스턴스화합니다. Wrapper 자체의 기능 로직은 없고, 파라미터/포트를 외부에 노출하는 목적입니다.

## 블록 다이어그램

```mermaid
graph LR
    A["External IP Ports"] --> W["lzc_wrapper\n(pass-through wrapper)"]
    W --> C["lzc\n(core module)"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 설명 |
|--------|------|---------|------|
| `in_i` | `input` | `logic [WIDTH-1:0]` | 원본 모듈 `lzc`로 전달되는 포트 |
| `cnt_o` | `output` | `logic [CNT_WIDTH-1:0]` | 원본 모듈 `lzc`로 전달되는 포트 |
| `empty_o` | `output` | `logic` | 원본 모듈 `lzc`로 전달되는 포트 |

## 파라미터

| 파라미터 | 선언 | 설명 |
|----------|------|------|
| `parameter int unsigned WIDTH = 2` | `parameter int unsigned WIDTH = 2` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter bit          MODE  = 1'b0` | `parameter bit          MODE  = 1'b0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned CNT_WIDTH = cf_math_pkg::idx_width(WIDTH)` | `parameter int unsigned CNT_WIDTH = cf_math_pkg::idx_width(WIDTH)` | Wrapper에서 동일 이름으로 core에 전달 |

## 연결 방식

- Wrapper 인스턴스는 core 모듈과 명시적 named port 매핑(`.port(port)`)을 사용합니다.
- Wrapper 내부 추가 연산/레지스터/조합 로직은 없습니다.
