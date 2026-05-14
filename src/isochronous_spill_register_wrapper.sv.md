# isochronous_spill_register_wrapper (`isochronous_spill_register_wrapper.sv`)

## 개요

`isochronous_spill_register_wrapper`는 AMD Custom IP Packaging용 패스스루(wrapper) 모듈로, 내부에서 원본 `isochronous_spill_register` 모듈을 1:1로 인스턴스화합니다. Wrapper 자체의 기능 로직은 없고, 파라미터/포트를 외부에 노출하는 목적입니다.

## 블록 다이어그램

```mermaid
graph LR
    A["External IP Ports"] --> W["isochronous_spill_register_wrapper\n(pass-through wrapper)"]
    W --> C["isochronous_spill_register\n(core module)"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 설명 |
|--------|------|---------|------|
| `src_clk_i` | `input` | `logic` | 원본 모듈 `isochronous_spill_register`로 전달되는 포트 |
| `src_rst_ni` | `input` | `logic` | 원본 모듈 `isochronous_spill_register`로 전달되는 포트 |
| `src_valid_i` | `input` | `logic` | 원본 모듈 `isochronous_spill_register`로 전달되는 포트 |
| `src_ready_o` | `output` | `logic` | 원본 모듈 `isochronous_spill_register`로 전달되는 포트 |
| `src_data_i` | `input` | `logic [T_WIDTH-1:0]` | 원본 모듈 `isochronous_spill_register`로 전달되는 포트 |
| `dst_clk_i` | `input` | `logic` | 원본 모듈 `isochronous_spill_register`로 전달되는 포트 |
| `dst_rst_ni` | `input` | `logic` | 원본 모듈 `isochronous_spill_register`로 전달되는 포트 |
| `dst_valid_o` | `output` | `logic` | 원본 모듈 `isochronous_spill_register`로 전달되는 포트 |
| `dst_ready_i` | `input` | `logic` | 원본 모듈 `isochronous_spill_register`로 전달되는 포트 |
| `dst_data_o` | `output` | `logic [T_WIDTH-1:0]` | 원본 모듈 `isochronous_spill_register`로 전달되는 포트 |

## 파라미터

| 파라미터 | 선언 | 설명 |
|----------|------|------|
| `parameter int unsigned T_WIDTH = 1` | `parameter int unsigned T_WIDTH = 1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter bit  Bypass = 1'b0` | `parameter bit  Bypass = 1'b0` | Wrapper에서 동일 이름으로 core에 전달 |

## 연결 방식

- Wrapper 인스턴스는 core 모듈과 명시적 named port 매핑(`.port(port)`)을 사용합니다.
- Wrapper 내부 추가 연산/레지스터/조합 로직은 없습니다.
