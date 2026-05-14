# sub_per_hash_wrapper (`sub_per_hash_wrapper.sv`)

## 개요

`sub_per_hash_wrapper`는 AMD Vivado Custom IP Packager 통합을 위한 패스스루(wrapper)입니다. 내부에 `sub_per_hash`를 1:1로 인스턴스화하며, wrapper 자체는 기능 로직을 추가하지 않습니다.

## 블록 다이어그램
```mermaid
graph LR
    EXT["Vivado IP Integrator / External Ports"] --> WR["sub_per_hash_wrapper\nWrapper"]
    WR --> CORE["sub_per_hash\nCore Module"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 신호 설명 |
|---|---|---|---|
| `data_i` | `input` | `logic [InpWidth-1:0]` | 입력 데이터/제어 신호 |
| `hash_o` | `output` | `logic [HashWidth-1:0]` | 출력 데이터/상태 신호 |
| `hash_onehot_o` | `output` | `logic [2**HashWidth-1:0]` | 출력 데이터/상태 신호 |

## 파라미터

| 파라미터 | 기본값 | 선언 | 설명 |
|---|---|---|---|
| `InpWidth` | `32'd11` | `parameter int unsigned InpWidth = 32'd11` | core 모듈로 동일 전달 |
| `HashWidth` | `32'd5` | `parameter int unsigned HashWidth = 32'd5` | core 모듈로 동일 전달 |
| `NoRounds` | `32'd1` | `parameter int unsigned NoRounds = 32'd1` | core 모듈로 동일 전달 |
| `PermuteKey` | `32'd299034753` | `parameter int unsigned PermuteKey = 32'd299034753` | core 모듈로 동일 전달 |
| `XorKey` | `32'd4094834` | `parameter int unsigned XorKey = 32'd4094834` | core 모듈로 동일 전달 |

## 연결 방식

- Wrapper는 core 인스턴스와 명시적 named-port 매핑(`.port(port)`)을 사용합니다.
- 추가 조합/순차 로직 없이 포트 및 파라미터를 전달(pass-through)합니다.

## AMD IP Packager 체크리스트

- [ ] 모든 외부 포트가 Vivado IP Packager의 Port and Interfaces에 노출되는지 확인
- [ ] 데이터 폭 파라미터(`*_WIDTH`) 기본값/범위가 설계 의도와 일치하는지 확인
- [ ] 클록/리셋 포트(`clk_i`, `rst_ni` 등) polarity 및 reset type 설정 확인
- [ ] 필요 시 X_INTERFACE_* 속성 및 clock association 메타데이터 추가
- [ ] OOC 합성 시 경고(폭 불일치/미연결 포트)가 없는지 확인

## 사용 시 주의사항

- Wrapper 문서는 인터페이스 설명용이며, 실제 기능 동작은 core 모듈 문서를 우선 참조하세요.
- 타입 파라미터가 폭 파라미터로 평탄화(flatten)되어 있으므로, packed struct 사용 시 비트 매핑 일관성을 검증하세요.
