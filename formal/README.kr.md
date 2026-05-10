# 형식 검증(Formal Verification) 속성

이 형식 속성 파일(`*_properties.sv`)과 스크립트(`*.sby`)는 `common_cells` IP의 형식 검증에 사용되며,
`SymbiYosys`와 함께 사용하도록 설계되었습니다.

## 도구 관련 참고사항

상용 버전의 `Yosys`와 `SymbiYosys`가 설치되어 있고 PATH에 등록되어 있는지 확인하세요.
또는 `YOSYS` 및 `SBY` 변수가 해당 실행 파일을 가리키도록 설정하세요.
Symbiotic EDA Edition [20190105A] 버전에서 테스트되었습니다.
오픈 소스(FOSS) 버전은 필요한 모든 SystemVerilog 기능을 파서가 지원하지 않으므로 사용할 수 없습니다.

## 사용 방법

`make all`을 실행하면 모든 테스트가 실행됩니다.
