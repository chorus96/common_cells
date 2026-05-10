# unread.sv

## 개요

`unread`는 사용되지 않는(unread) 입력 신호에 대한 EDA 툴 경고(Open Pin Warning)를 억제하기 위한 더미(dummy) 모듈이다. 어떤 신호를 의도적으로 미사용 상태로 두고자 할 때 이 모듈에 연결하면 툴이 경고를 발생시키지 않는다.

Verilator의 `UNUSED` 경고를 lint_off/lint_on 지시어로 감싸고, Vivado 타겟에서는 블랙박스 처리를 방지하기 위해 조건부 로직을 포함한다.

## 블록 다이어그램

```mermaid
flowchart LR
    subgraph unread["unread"]
        direction LR
        subgraph vivado["ifdef TARGET_VIVADO"]
            X["내부 logic x\nd_i = x (Vivado 블랙박스 방지)"]
        end
        subgraph default["그 외 환경"]
            NOP["아무 동작 없음\n(입력 소비)"]
        end
    end

    signal["미사용 신호"] -->|"d_i"| unread
    Note["경고 억제"] -.-> unread
```

## 포트/파라미터

### 파라미터

없음.

### 포트

| 포트명 | 방향 | 폭 | 설명 |
|--------|------|----|------|
| `d_i` | input | 1 | 소비할 미사용 신호 입력 |

## 동작 설명

### 기본 동작

`d_i` 입력을 받지만 아무런 출력도 생성하지 않는다. Verilator는 `/* verilator lint_off UNUSED */` 지시어로 `UNUSED` 경고가 억제된다.

### Vivado 타겟 (`TARGET_VIVADO` 정의 시)

Vivado는 포트만 있고 내부 로직이 없는 모듈을 블랙박스로 처리할 수 있다. 이를 방지하기 위해 내부에 `logic x`를 선언하고 `d_i = x`로 연결한다 (실제로는 의미 없는 연결).

### 사용 예시

```systemverilog
// 사용하지 않는 신호를 unread에 연결하여 경고 억제
unread i_unread (.d_i(unused_signal));
```

## 의존성 및 관계

| 항목 | 설명 |
|------|------|
| 사용하는 모듈 | 없음 |
| 관련 도구 | Verilator (`UNUSED` 경고), Vivado (블랙박스 처리) |
| 주요 용도 | 의도적으로 미연결 상태로 두는 신호의 경고 억제 |
