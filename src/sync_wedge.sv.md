# sync_wedge.sv

## 개요

`sync_wedge`는 비동기 입력 신호를 동기화하면서 동시에 라이징 엣지(rising edge)와 폴링 엣지(falling edge)를 감지하는 모듈이다. 내부에 `sync` 모듈을 사용하여 메타스테이빌리티를 해결하고, 클록 게이팅(`pulp_clock_gating`)으로 이전 동기화 값을 샘플링하여 엣지를 감지한다.

## 블록 다이어그램

```mermaid
flowchart LR
    subgraph sync_wedge["sync_wedge"]
        direction TB

        subgraph sync_inst["sync (STAGES개 FF)"]
            SYNC["serial_i → serial\n(메타스테이빌리티 해소)"]
        end

        subgraph clk_gate["pulp_clock_gating"]
            CG["clk_i + en_i → clk\n(게이팅된 클록)"]
        end

        subgraph sample_ff["샘플 FF (게이팅 클록 사용)"]
            FF["serial → serial_q\n(이전 사이클 동기화 값)"]
        end

        subgraph edge_detect["엣지 감지 조합 논리"]
            RE["r_edge_o = serial & ~serial_q\n(라이징 엣지)"]
            FE["f_edge_o = ~serial & serial_q\n(폴링 엣지)"]
        end

        sync_inst --> sample_ff
        sync_inst --> edge_detect
        sample_ff --> edge_detect
        clk_gate --> sample_ff
    end

    serial_i["serial_i\n(비동기)"] --> sync_inst
    clk_i --> clk_gate
    en_i["en_i\n(클록 게이트 활성화)"] --> clk_gate
    en_i --> sample_ff
    rst_ni --> sync_inst
    rst_ni --> sample_ff

    sync_inst --> serial_o["serial_o\n(동기화 출력)"]
    edge_detect --> r_edge_o["r_edge_o"]
    edge_detect --> f_edge_o["f_edge_o"]
```

```mermaid
sequenceDiagram
    participant IN as serial_i
    participant SY as sync (FF체인)
    participant SA as 샘플 FF (serial_q)
    participant ED as 엣지 감지

    IN->>SY: 0→1 천이
    Note over SY: STAGES 사이클 후 serial=1
    SY->>SA: serial=1 샘플링 (en_i=1)
    Note over SA: serial_q=0 (이전값)
    SY->>ED: serial=1
    SA->>ED: serial_q=0
    ED-->>ED: r_edge_o = 1 & ~0 = 1 (라이징 엣지 감지)

    Note over SA: 다음 사이클: serial_q=1
    ED-->>ED: r_edge_o = 1 & ~1 = 0 (엣지 해제)
```

## 포트/파라미터

### 파라미터

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `STAGES` | `int unsigned` | `2` | 동기화 플립플롭 체인 단계 수 |

### 포트

| 포트명 | 방향 | 폭 | 설명 |
|--------|------|----|------|
| `clk_i` | input | 1 | 목적지 클록 도메인 클록 |
| `rst_ni` | input | 1 | 비동기 리셋 (active low) |
| `en_i` | input | 1 | 클록 게이트 활성화 및 샘플링 인에이블 |
| `serial_i` | input | 1 | 동기화할 비동기 입력 신호 |
| `r_edge_o` | output | 1 | 라이징 엣지 감지 (1 사이클 펄스) |
| `f_edge_o` | output | 1 | 폴링 엣지 감지 (1 사이클 펄스) |
| `serial_o` | output | 1 | 동기화된 출력 신호 (= serial_q, 이전 사이클 샘플) |

## 동작 설명

### 신호 흐름

| 신호 | 설명 |
|------|------|
| `serial` | `sync` 모듈 출력, 현재 사이클의 동기화된 값 |
| `serial_q` | 게이팅 클록(`clk`)으로 샘플링된 이전 사이클의 `serial` 값 |
| `serial_o` | `serial_q`와 동일 (`serial_o = serial_q`) |

### 엣지 감지 로직

```
r_edge_o =  serial & (~serial_q)   // 이전=0, 현재=1: 라이징 엣지
f_edge_o = (~serial) & serial_q    // 이전=1, 현재=0: 폴링 엣지
```

엣지 출력은 1 사이클 동안만 assert되는 펄스 신호이다.

### 클록 게이팅

`pulp_clock_gating`으로 `en_i`에 의해 제어되는 게이팅 클록 `clk`을 생성한다. 샘플링 FF는 이 게이팅 클록에 동작하므로, `en_i = 0`이면 `serial_q`가 갱신되지 않아 엣지 감지가 억제된다.

### 리셋 동작

`rst_ni` = 0이면:
- `sync` 내부 레지스터 → 0으로 초기화
- `serial_q` → 0으로 초기화

## 의존성 및 관계

| 항목 | 설명 |
|------|------|
| 사용하는 모듈 | `sync` (멀티 FF 동기화기), `pulp_clock_gating` (클록 게이팅 셀) |
| 관련 모듈 | `sync` (엣지 감지 없는 기본 동기화기) |
| 주요 용도 | 비동기 입력 신호의 동기화 및 엣지 이벤트 감지, CDC 인터페이스 |
