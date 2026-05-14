# mem_to_banks_detailed_wrapper (`mem_to_banks_detailed_wrapper.sv`)

## 개요

`mem_to_banks_detailed_wrapper`는 AMD Vivado Custom IP Packager 통합을 위한 패스스루(wrapper)입니다. 내부에 `mem_to_banks_detailed`를 1:1로 인스턴스화하며, wrapper 자체는 기능 로직을 추가하지 않습니다.

## 블록 다이어그램
```mermaid
graph LR
    EXT["Vivado IP Integrator / External Ports"] --> WR["mem_to_banks_detailed_wrapper\nWrapper"]
    WR --> CORE["mem_to_banks_detailed\nCore Module"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 신호 설명 |
|---|---|---|---|
| `clk_i` | `input` | `logic` | 클록 입력 |
| `rst_ni` | `input` | `logic` | 리셋 신호 |
| `req_i` | `input` | `logic` | 입력 데이터/제어 신호 |
| `gnt_o` | `output` | `logic` | 출력 데이터/상태 신호 |
| `addr_i` | `input` | `addr_t` | 입력 데이터/제어 신호 |
| `wdata_i` | `input` | `inp_data_t` | 입력 데이터/제어 신호 |
| `strb_i` | `input` | `inp_strb_t` | 입력 데이터/제어 신호 |
| `wuser_i` | `input` | `logic [wuser_t_WIDTH-1:0]` | 입력 데이터/제어 신호 |
| `we_i` | `input` | `logic` | 입력 데이터/제어 신호 |
| `rvalid_o` | `output` | `logic` | 핸드셰이크 valid 신호 |
| `rdata_o` | `output` | `inp_data_t` | 출력 데이터/상태 신호 |
| `ruser_o` | `output` | `inp_ruser_t` | 출력 데이터/상태 신호 |
| `bank_req_o` | `output` | `logic [NumBanks-1:0]` | 출력 데이터/상태 신호 |
| `bank_gnt_i` | `input` | `logic [NumBanks-1:0]` | 입력 데이터/제어 신호 |
| `bank_addr_o` | `output` | `addr_t [NumBanks-1:0]` | 출력 데이터/상태 신호 |
| `bank_wdata_o` | `output` | `oup_data_t [NumBanks-1:0]` | 출력 데이터/상태 신호 |
| `bank_strb_o` | `output` | `oup_strb_t [NumBanks-1:0]` | 출력 데이터/상태 신호 |
| `bank_wuser_o` | `output` | `logic [wuser_t_WIDTH-1:0] [NumBanks-1:0]` | 출력 데이터/상태 신호 |
| `bank_we_o` | `output` | `logic [NumBanks-1:0]` | 출력 데이터/상태 신호 |
| `bank_rvalid_i` | `input` | `logic [NumBanks-1:0]` | 핸드셰이크 valid 신호 |
| `bank_rdata_i` | `input` | `oup_data_t [NumBanks-1:0]` | 입력 데이터/제어 신호 |
| `bank_ruser_i` | `input` | `oup_ruser_t [NumBanks-1:0]` | 입력 데이터/제어 신호 |

## 파라미터

| 파라미터 | 기본값 | 선언 | 설명 |
|---|---|---|---|
| `AddrWidth` | `32'd0` | `parameter int unsigned AddrWidth = 32'd0` | core 모듈로 동일 전달 |
| `DataWidth` | `32'd0` | `parameter int unsigned DataWidth = 32'd0` | core 모듈로 동일 전달 |
| `WUserWidth` | `32'd0` | `parameter int unsigned WUserWidth = 32'd0` | core 모듈로 동일 전달 |
| `RUserWidth` | `32'd0` | `parameter int unsigned RUserWidth = 32'd0` | core 모듈로 동일 전달 |
| `NumBanks` | `32'd1` | `parameter int unsigned NumBanks = 32'd1` | core 모듈로 동일 전달 |
| `HideStrb` | `1'b0` | `parameter bit HideStrb = 1'b0` | core 모듈로 동일 전달 |
| `MaxTrans` | `32'd1` | `parameter int unsigned MaxTrans = 32'd1` | core 모듈로 동일 전달 |
| `FifoDepth` | `32'd1` | `parameter int unsigned FifoDepth = 32'd1` | core 모듈로 동일 전달 |
| `wuser_t_WIDTH` | `1` | `parameter int unsigned wuser_t_WIDTH = 1` | flat 데이터 폭 설정 파라미터 |
| `addr_t` | `logic [AddrWidth-1:0]` | `localparam type addr_t = logic [AddrWidth-1:0]` | core 모듈로 동일 전달 |
| `inp_data_t` | `logic [DataWidth-1:0]` | `localparam type inp_data_t = logic [DataWidth-1:0]` | core 모듈로 동일 전달 |
| `inp_strb_t` | `logic [DataWidth/8-1:0]` | `localparam type inp_strb_t = logic [DataWidth/8-1:0]` | core 모듈로 동일 전달 |
| `inp_ruser_t` | `logic [NumBanks-1:0][RUserWidth-1:0]` | `localparam type inp_ruser_t = logic [NumBanks-1:0][RUserWidth-1:0]` | core 모듈로 동일 전달 |
| `oup_data_t` | `logic [DataWidth/NumBanks-1:0]` | `localparam type oup_data_t = logic [DataWidth/NumBanks-1:0]` | core 모듈로 동일 전달 |
| `oup_strb_t` | `logic [DataWidth/NumBanks/8-1:0]` | `localparam type oup_strb_t = logic [DataWidth/NumBanks/8-1:0]` | core 모듈로 동일 전달 |
| `oup_ruser_t` | `logic [RUserWidth-1:0]` | `localparam type oup_ruser_t = logic [RUserWidth-1:0]` | core 모듈로 동일 전달 |

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
