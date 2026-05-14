# mem_to_banks_detailed_wrapper (`mem_to_banks_detailed_wrapper.sv`)

## 개요

`mem_to_banks_detailed_wrapper`는 AMD Custom IP Packaging용 패스스루(wrapper) 모듈로, 내부에서 원본 `mem_to_banks_detailed` 모듈을 1:1로 인스턴스화합니다. Wrapper 자체의 기능 로직은 없고, 파라미터/포트를 외부에 노출하는 목적입니다.

## 블록 다이어그램

```mermaid
graph LR
    A["External IP Ports"] --> W["mem_to_banks_detailed_wrapper\n(pass-through wrapper)"]
    W --> C["mem_to_banks_detailed\n(core module)"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 설명 |
|--------|------|---------|------|
| `clk_i` | `input` | `logic` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `rst_ni` | `input` | `logic` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `req_i` | `input` | `logic` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `gnt_o` | `output` | `logic` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `addr_i` | `input` | `addr_t` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `wdata_i` | `input` | `inp_data_t` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `strb_i` | `input` | `inp_strb_t` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `wuser_i` | `input` | `logic [wuser_t_WIDTH-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `we_i` | `input` | `logic` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `rvalid_o` | `output` | `logic` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `rdata_o` | `output` | `inp_data_t` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `ruser_o` | `output` | `inp_ruser_t` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `bank_req_o` | `output` | `logic [NumBanks-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `bank_gnt_i` | `input` | `logic [NumBanks-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `bank_addr_o` | `output` | `addr_t [NumBanks-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `bank_wdata_o` | `output` | `oup_data_t [NumBanks-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `bank_strb_o` | `output` | `oup_strb_t [NumBanks-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `bank_wuser_o` | `output` | `logic [wuser_t_WIDTH-1:0] [NumBanks-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `bank_we_o` | `output` | `logic [NumBanks-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `bank_rvalid_i` | `input` | `logic [NumBanks-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `bank_rdata_i` | `input` | `oup_data_t [NumBanks-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |
| `bank_ruser_i` | `input` | `oup_ruser_t [NumBanks-1:0]` | 원본 모듈 `mem_to_banks_detailed`로 전달되는 포트 |

## 파라미터

| 파라미터 | 선언 | 설명 |
|----------|------|------|
| `parameter int unsigned AddrWidth = 32'd0` | `parameter int unsigned AddrWidth = 32'd0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned DataWidth = 32'd0` | `parameter int unsigned DataWidth = 32'd0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned WUserWidth = 32'd0` | `parameter int unsigned WUserWidth = 32'd0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned RUserWidth = 32'd0` | `parameter int unsigned RUserWidth = 32'd0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned NumBanks  = 32'd1` | `parameter int unsigned NumBanks  = 32'd1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter bit          HideStrb  = 1'b0` | `parameter bit          HideStrb  = 1'b0` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned MaxTrans  = 32'd1` | `parameter int unsigned MaxTrans  = 32'd1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned FifoDepth = 32'd1` | `parameter int unsigned FifoDepth = 32'd1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned wuser_t_WIDTH = 1` | `parameter int unsigned wuser_t_WIDTH = 1` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam type addr_t      = logic [AddrWidth-1:0]` | `localparam type addr_t      = logic [AddrWidth-1:0]` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam type inp_data_t  = logic [DataWidth-1:0]` | `localparam type inp_data_t  = logic [DataWidth-1:0]` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam type inp_strb_t  = logic [DataWidth/8-1:0]` | `localparam type inp_strb_t  = logic [DataWidth/8-1:0]` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam type inp_ruser_t = logic [NumBanks-1:0][RUserWidth-1:0]` | `localparam type inp_ruser_t = logic [NumBanks-1:0][RUserWidth-1:0]` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam type oup_data_t  = logic [DataWidth/NumBanks-1:0]` | `localparam type oup_data_t  = logic [DataWidth/NumBanks-1:0]` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam type oup_strb_t  = logic [DataWidth/NumBanks/8-1:0]` | `localparam type oup_strb_t  = logic [DataWidth/NumBanks/8-1:0]` | Wrapper에서 동일 이름으로 core에 전달 |
| `localparam type oup_ruser_t = logic [RUserWidth-1:0]` | `localparam type oup_ruser_t = logic [RUserWidth-1:0]` | Wrapper에서 동일 이름으로 core에 전달 |

## 연결 방식

- Wrapper 인스턴스는 core 모듈과 명시적 named port 매핑(`.port(port)`)을 사용합니다.
- Wrapper 내부 추가 연산/레지스터/조합 로직은 없습니다.
