# sub_per_hash_wrapper (`sub_per_hash_wrapper.sv`)

## 개요

`sub_per_hash_wrapper`는 AMD Custom IP Packaging용 패스스루(wrapper) 모듈로, 내부에서 원본 `sub_per_hash` 모듈을 1:1로 인스턴스화합니다. Wrapper 자체의 기능 로직은 없고, 파라미터/포트를 외부에 노출하는 목적입니다.

## 블록 다이어그램

```mermaid
graph LR
    A["External IP Ports"] --> W["sub_per_hash_wrapper\n(pass-through wrapper)"]
    W --> C["sub_per_hash\n(core module)"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 설명 |
|--------|------|---------|------|
| `data_i` | `input` | `logic [InpWidth-1:0]` | 원본 모듈 `sub_per_hash`로 전달되는 포트 |
| `hash_o` | `output` | `logic [HashWidth-1:0]` | 원본 모듈 `sub_per_hash`로 전달되는 포트 |
| `hash_onehot_o` | `output` | `logic [2**HashWidth-1:0]` | 원본 모듈 `sub_per_hash`로 전달되는 포트 |

## 파라미터

| 파라미터 | 선언 | 설명 |
|----------|------|------|
| `parameter int unsigned InpWidth   = 32'd11` | `parameter int unsigned InpWidth   = 32'd11` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned HashWidth  = 32'd5` | `parameter int unsigned HashWidth  = 32'd5` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned NoRounds   = 32'd1` | `parameter int unsigned NoRounds   = 32'd1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned PermuteKey = 32'd299034753` | `parameter int unsigned PermuteKey = 32'd299034753` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned XorKey     = 32'd4094834` | `parameter int unsigned XorKey     = 32'd4094834` | Wrapper에서 동일 이름으로 core에 전달 |

## 연결 방식

- Wrapper 인스턴스는 core 모듈과 명시적 named port 매핑(`.port(port)`)을 사용합니다.
- Wrapper 내부 추가 연산/레지스터/조합 로직은 없습니다.
