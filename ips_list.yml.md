# ips_list.yml

## 개요

`ips_list.yml`은 `common_cells` 라이브러리가 의존하는 외부 IP(Intellectual Property) 패키지 목록을 정의하는 YAML 파일입니다. 주로 PULP Platform의 빌드 인프라에서 사용되며, 각 의존 IP의 소스 버전(Git 커밋 해시 또는 태그)을 명시하여 재현 가능한 빌드를 보장합니다.

이 파일은 `common_cells` 자체가 다른 검증(verification) 라이브러리에 의존함을 선언하며, 구체적으로는 `common_verification` 패키지의 특정 버전을 고정합니다.

## 블록 다이어그램

```mermaid
graph LR
    A[common_cells 라이브러리] -->|의존| B[ips_list.yml]
    B -->|IP 목록 정의| C[common_verification]
    C -->|버전 고정| D[commit: v0.2.0]

    style A fill:#4a90d9,color:#fff
    style B fill:#f5a623,color:#fff
    style C fill:#7ed321,color:#fff
    style D fill:#9b9b9b,color:#fff
```

## 상세 내용

### 파일 구조

```yaml
common_verification:
    commit: v0.2.0
```

파일은 단일 YAML 맵(map) 구조로 이루어져 있으며, 최상위 키가 IP 이름, 하위 항목이 해당 IP의 버전 정보를 나타냅니다.

### 항목별 설명

#### `common_verification`

| 항목 | 값 | 설명 |
|------|-----|------|
| IP 이름 | `common_verification` | PULP Platform의 공통 검증(verification) 유틸리티 패키지 |
| `commit` | `v0.2.0` | 사용할 Git 태그 또는 커밋 식별자 |

`common_verification`은 SystemVerilog 시뮬레이션 및 검증 환경에서 사용하는 공통 클래스와 헬퍼를 제공하는 라이브러리입니다. `common_cells`의 테스트벤치(testbench)와 시뮬레이션에서 이 패키지를 활용합니다.

`commit: v0.2.0`은 특정 릴리즈 태그를 가리키며, 빌드 스크립트가 해당 저장소를 클론할 때 이 버전으로 체크아웃하도록 지시합니다.

### YAML 형식 규칙

- 최상위 키: IP 패키지 이름 (소문자, 언더스코어 구분)
- `commit`: Git 커밋 해시 또는 태그명. 재현 가능한 빌드를 위해 정확한 버전을 고정합니다.

## 의존성 및 관계

- **`common_cells.core`**: FuseSoC 코어 파일과 함께 `common_cells` 라이브러리의 빌드 설정을 구성합니다. `ips_list.yml`은 FuseSoC 외부의 PULP 전용 빌드 스크립트(`update-ips.py` 등)에서 사용됩니다.
- **`common_verification` 저장소**: `https://github.com/pulp-platform/common_verification` 에서 관리되며, `v0.2.0` 태그의 소스를 가져옵니다.
- **빌드 시스템**: PULP Platform 프로젝트에서는 `ips_list.yml`을 파싱하여 필요한 IP를 자동으로 내려받고 빌드 경로에 포함시키는 스크립트와 함께 사용됩니다.
