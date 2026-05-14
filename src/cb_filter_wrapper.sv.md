# cb_filter_wrapper (`cb_filter_wrapper.sv`)

## 개요

`cb_filter_wrapper`는 AMD Custom IP Packaging용 패스스루(wrapper) 모듈로, 내부에서 원본 `cb_filter` 모듈을 1:1로 인스턴스화합니다. Wrapper 자체의 기능 로직은 없고, 파라미터/포트를 외부에 노출하는 목적입니다.

## 블록 다이어그램

```mermaid
graph LR
    A["External IP Ports"] --> W["cb_filter_wrapper\n(pass-through wrapper)"]
    W --> C["cb_filter\n(core module)"]
```

## 포트 목록

| 포트명 | 방향 | 타입/폭 | 설명 |
|--------|------|---------|------|
| `clk_i` | `input` | `logic` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `rst_ni` | `input` | `logic` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `look_data_i` | `input` | `logic [InpWidth-1:0]` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `look_valid_o` | `output` | `logic` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `incr_data_i` | `input` | `logic [InpWidth-1:0]` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `incr_valid_i` | `input` | `logic` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `decr_data_i` | `input` | `logic [InpWidth-1:0]` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `decr_valid_i` | `input` | `logic` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `filter_clear_i` | `input` | `logic` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `filter_usage_o` | `output` | `logic [HashWidth-1:0]` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `filter_full_o` | `output` | `logic` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `filter_empty_o` | `output` | `logic` | 원본 모듈 `cb_filter`로 전달되는 포트 |
| `filter_error_o` | `output` | `logic` | 원본 모듈 `cb_filter`로 전달되는 포트 |

## 파라미터

| 파라미터 | 선언 | 설명 |
|----------|------|------|
| `parameter int unsigned KHashes     =  32'd3` | `parameter int unsigned KHashes     =  32'd3` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned HashWidth   =  32'd4` | `parameter int unsigned HashWidth   =  32'd4` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned HashRounds  =  32'd1` | `parameter int unsigned HashRounds  =  32'd1` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned InpWidth    =  32'd32` | `parameter int unsigned InpWidth    =  32'd32` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter int unsigned BucketWidth =  32'd4` | `parameter int unsigned BucketWidth =  32'd4` | Wrapper에서 동일 이름으로 core에 전달 |
| `parameter cb_filter_pkg::cb_seed_t [KHashes-1:0] Seeds = cb_filter_pkg::EgSeeds` | `parameter cb_filter_pkg::cb_seed_t [KHashes-1:0] Seeds = cb_filter_pkg::EgSeeds` | Wrapper에서 동일 이름으로 core에 전달 |

## 연결 방식

- Wrapper 인스턴스는 core 모듈과 명시적 named port 매핑(`.port(port)`)을 사용합니다.
- Wrapper 내부 추가 연산/레지스터/조합 로직은 없습니다.
