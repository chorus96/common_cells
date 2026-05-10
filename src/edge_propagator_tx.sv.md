# edge_propagator_tx.sv

## 개요

`edge_propagator_tx`는 비동기 에지 전파 시스템에서 송신(TX) 측 기능을 담당하는 모듈입니다. TX 클록 도메인에서 유효 이벤트(`valid_i`)를 수신하면 이를 내부 레지스터에 래치하여 `valid_o`로 출력합니다. RX 도메인으로부터 ACK 신호(`ack_i`)가 돌아오면 레지스터를 클리어하여 다음 이벤트를 수용할 준비를 합니다.

`edge_propagator_rx`와 쌍을 이루어 사용되며, TX 도메인에서 RX 도메인으로의 안정적인 단방향 이벤트 전달을 위한 핸드셰이크 메커니즘을 구현합니다.

## 블록 다이어그램

```mermaid
graph LR
    subgraph TX 도메인 clk_i
        VI["valid_i<br/>(유효 이벤트 입력)"]
        NEXT["s_input_reg_next<br/>= valid_i | (r_input_reg & ~sync_a[0])"]
        IR["r_input_reg<br/>(이벤트 래치 레지스터)"]
        SA["sync_a[1:0]<br/>(ACK 2단 동기화 체인)"]
        VO["valid_o = r_input_reg<br/>(토글 신호 출력)"]
    end

    subgraph RX 도메인 (외부)
        AI["ack_i<br/>(RX로부터의 ACK 피드백)"]
    end

    VI --> NEXT
    IR --> NEXT
    SA --> NEXT
    NEXT --> IR
    IR --> VO
    AI -->|동기화 입력| SA
    SA -->|ACK 확인| NEXT
```

### 핸드셰이크 타이밍

```
clk_tx:      __|‾|_|‾|_|‾|_|‾|_|‾|_|‾|_|‾|_|‾|_
valid_i:     _____|‾|________________________
r_input_reg: ________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|___  (valid_o)
ack_i:       ________________________|‾‾‾‾‾‾‾  (RX 피드백)
sync_a[1]:   __________________________|‾‾‾‾‾
sync_a[0]:   ____________________________|‾‾‾  (ACK 확인)
r_input_reg: _____________________________|___  (클리어)
```

## 포트/파라미터

### 파라미터

이 모듈은 별도의 파라미터가 없습니다.

### 포트

| 포트 | 방향 | 타입 | 설명 |
|------|------|------|------|
| `clk_i` | input | `logic` | TX 도메인 클록 |
| `rstn_i` | input | `logic` | TX 도메인 비동기 리셋 (액티브 로우) |
| `valid_i` | input | `logic` | TX 도메인의 유효 이벤트 입력 |
| `ack_i` | input | `logic` | RX 도메인으로부터의 ACK 피드백 신호 |
| `valid_o` | output | `logic` | RX 도메인으로 전달할 이벤트 신호 (r_input_reg 값) |

## 동작 설명

### 1. 이벤트 래치 및 유지

`valid_i`가 1이 되면 `r_input_reg`가 세트됩니다. ACK(`sync_a[0]`)가 수신될 때까지 상태를 자기 유지(self-sustaining)합니다.

```systemverilog
assign s_input_reg_next = valid_i | (r_input_reg & ~sync_a[0]);
```

- `valid_i = 1`: 즉시 세트
- `r_input_reg & ~sync_a[0]`: ACK가 수신되지 않은 동안 유지
- ACK(`sync_a[0] = 1`) 수신 시 자동 클리어

### 2. ACK 2단 동기화

`ack_i`(RX 도메인에서 오는 비동기 신호)를 TX 클록에 2단 플립플롭 체인으로 동기화합니다. 이를 통해 메타스태빌리티를 방지합니다.

```systemverilog
always @(negedge rstn_i or posedge clk_i) begin
    if (~rstn_i) begin
        r_input_reg <= 1'b0;
        sync_a      <= 2'b00;
    end else begin
        r_input_reg <= s_input_reg_next;
        sync_a      <= {ack_i, sync_a[1]};  // ack_i를 2단으로 동기화
    end
end
```

`sync_a`는 `{ack_i, sync_a[1]}` 순서로 시프트되어, `sync_a[0]`이 2클록 후 동기화된 ACK 값이 됩니다.

### 3. 유효 신호 출력

```systemverilog
assign valid_o = r_input_reg;
```

`r_input_reg`가 세트되어 있는 동안 `valid_o`가 High를 유지합니다. `edge_propagator_rx`는 이 신호의 상승 에지를 감지하여 `valid_o` 펄스를 생성하고, 동기화된 값을 `ack_o`(= `edge_propagator_tx`의 `ack_i`)로 피드백합니다.

### 이벤트 연속 처리 제약

`r_input_reg`가 클리어되기 전에 새로운 `valid_i`가 발생해도 이벤트는 유지되지만, 이전 이벤트와 병합되어 하나의 이벤트로만 전달됩니다. 고속 연속 이벤트 처리에는 적합하지 않으며, ACK 완료 후 다음 이벤트를 전송해야 합니다.

## 의존성 및 관계

| 항목 | 설명 |
|------|------|
| `edge_propagator_rx` | 쌍을 이루는 RX 모듈. `valid_o`를 `valid_i`로, `ack_o`를 `edge_propagator_tx`의 `ack_i`로 연결하여 완전한 핸드셰이크 구성 |
| `edge_propagator_ack` | TX+RX 기능을 통합한 모듈. `edge_propagator_tx`의 래치 로직과 동일한 메커니즘을 내부적으로 구현 |

### edge_propagator_tx + edge_propagator_rx 연결 구성

```
[TX 도메인]                        [RX 도메인]
edge_propagator_tx                 edge_propagator_rx
  valid_i (이벤트 입력)
  valid_o ─────────────────────────► valid_i
  ack_i   ◄──────────────────────── ack_o
                                     valid_o (이벤트 펄스 출력)
```
