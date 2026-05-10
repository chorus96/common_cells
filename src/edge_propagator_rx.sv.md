# edge_propagator_rx.sv

## 개요

`edge_propagator_rx`는 비동기 에지 전파 시스템에서 수신(RX) 측 기능을 담당하는 모듈입니다. TX 도메인에서 토글(toggle)된 신호(`valid_i`)를 RX 클록 도메인으로 동기화하고, 상승 에지를 감지하여 `valid_o` 펄스를 생성합니다. 동시에 동기화된 신호를 `ack_o`로 출력하여 TX 측에 피드백을 제공합니다.

`edge_propagator_tx`와 쌍을 이루어 사용되며, TX에서 토글 방식으로 전달된 신호를 RX에서 펄스 이벤트로 변환하는 역할을 합니다.

## 블록 다이어그램

```mermaid
graph LR
    subgraph TX 도메인 (외부)
        VI["valid_i<br/>(TX에서 토글된 신호)"]
    end

    subgraph edge_propagator_rx RX 도메인 clk_i
        PSW["pulp_sync_wedge<br/>i_sync_clkb<br/>(2단 동기화 + 에지 감지)"]
        VO["valid_o (r_edge_o)<br/>상승 에지 감지 시 1클록 펄스"]
        AO["ack_o (serial_o)<br/>동기화된 valid_i 값"]
    end

    VI -->|serial_i| PSW
    PSW -->|r_edge_o| VO
    PSW -->|serial_o| AO
```

### TX-RX 연동 시 타이밍

```
clk_tx:   __|‾|_|‾|_|‾|_|‾|_|‾|_
valid_i:  ________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾  ← TX에서 토글
clk_rx:   _|‾|_|‾|_|‾|_|‾|_|‾|_|‾
ack_o:    ______________|‾‾‾‾‾‾‾‾‾  ← 동기화된 valid_i
valid_o:  ________________|‾|______  ← 에지 감지 펄스
```

## 포트/파라미터

### 파라미터

이 모듈은 별도의 파라미터가 없습니다.

### 포트

| 포트 | 방향 | 타입 | 설명 |
|------|------|------|------|
| `clk_i` | input | `logic` | RX 도메인 클록 |
| `rstn_i` | input | `logic` | RX 도메인 비동기 리셋 (액티브 로우) |
| `valid_i` | input | `logic` | TX 도메인에서 전달된 토글 신호 입력 |
| `ack_o` | output | `logic` | TX 측으로의 ACK 피드백 (RX 동기화된 valid_i 값) |
| `valid_o` | output | `logic` | RX 도메인에서 유효 이벤트 감지 시 1클록 폭 펄스 출력 |

## 동작 설명

`edge_propagator_rx`는 `pulp_sync_wedge`를 활용하여 다음 두 가지 기능을 동시에 수행합니다.

```systemverilog
pulp_sync_wedge i_sync_clkb (
    .clk_i    ( clk_i   ),
    .rstn_i   ( rstn_i  ),
    .en_i     ( 1'b1    ),
    .serial_i ( valid_i ),
    .r_edge_o ( valid_o ),   // 상승 에지 감지 → RX 유효 이벤트
    .f_edge_o (         ),   // 하강 에지 미사용
    .serial_o ( ack_o   )    // 동기화된 값 → TX ACK 피드백
);
```

### 1. 동기화 (2단 플립플롭)

`valid_i`(TX 도메인)를 `pulp_sync_wedge` 내부의 2단 플립플롭 체인으로 RX 클록(`clk_i`)에 동기화합니다. 이를 통해 메타스태빌리티(metastability) 위험을 제거합니다.

### 2. 에지 감지

동기화된 신호의 이전 값과 현재 값을 비교하여 상승 에지를 감지합니다. 상승 에지가 감지된 클록 사이클에 `valid_o`가 1클록 폭의 펄스로 출력됩니다.

### 3. ACK 피드백

`serial_o`(동기화된 `valid_i` 값)를 `ack_o`로 출력합니다. TX 측(`edge_propagator_tx`)은 이 값을 수신하여 RX에서 이벤트가 정상적으로 처리되었음을 확인하고 내부 토글 레지스터를 클리어합니다.

## 의존성 및 관계

| 항목 | 설명 |
|------|------|
| `pulp_sync_wedge` | 2단 동기화 + 에지 감지 기능을 제공하는 핵심 서브모듈 |
| `edge_propagator_tx` | 쌍을 이루는 TX 모듈. `valid_o`를 토글하여 `edge_propagator_rx`의 `valid_i`로 전달, `ack_o`를 `ack_i`로 수신 |
| `edge_propagator_ack` | TX+RX 기능을 통합한 모듈. 내부적으로 `pulp_sync_wedge`를 사용하여 유사한 RX 동기화 수행 |

`edge_propagator_tx`와 `edge_propagator_rx`를 조합하여 `edge_propagator_ack`와 동일한 기능을 구현할 수 있으며, 모듈 경계를 명시적으로 분리해야 할 때 유용합니다.
