# sync_wrapper (`sync_wrapper.sv`)

## 개요

`sync_wrapper`는 AMD Custom IP Packaging용 패스스루(wrapper) 모듈로, 내부에서 원본 `sync` 모듈을 1:1로 인스턴스화합니다. Wrapper 자체의 기능 로직은 없고, 파라미터/포트를 외부에 노출하는 목적입니다.

## 블록 다이어그램

```mermaid
graph LR
    A["External IP Ports"] --> W["sync_wrapper\n(pass-through wrapper)"]
    W --> C["sync\n(core module)"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 설명 |
|--------|------|---------|------|
| `clk_i` | `input` | `logic` | 원본 모듈 `sync`로 전달되는 포트 |
| `rst_ni` | `input` | `logic` | 원본 모듈 `sync`로 전달되는 포트 |
| `serial_i` | `input` | `logic` | 원본 모듈 `sync`로 전달되는 포트 |
| `serial_o` | `output` | `logic` | 원본 모듈 `sync`로 전달되는 포트 |

## 파라미터

| 파라미터 | 선언 | 설명 |
|----------|------|------|
| `parameter int unsigned STAGES = 2` | `parameter int unsigned STAGES = 2` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter bit ResetValue = 1'b0` | `parameter bit ResetValue = 1'b0` | Wrapper에서 동일 이름으로 core에 전달 |

## 연결 방식

- Wrapper 인스턴스는 core 모듈과 명시적 named port 매핑(`.port(port)`)을 사용합니다.
- Wrapper 내부 추가 연산/레지스터/조합 로직은 없습니다.
