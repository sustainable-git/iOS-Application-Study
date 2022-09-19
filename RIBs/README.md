# RIBs

- 장점
    - Dependency injection
    - Cross-platform(iOS & Android)
    - 테스트 작성의 용이성
    - RIB 마다 독립적인 설계
    - Protocol oriented programming

- 단점
    - Protocol이 너무 많이 생성됨
    - 각 RIB에 맞게 DI 작성이 필요

- 차이점
    - MVC, MVP, MVVM, VIPER는 architecture이지만, RIBs는 framework 임
    - RIB은 view를 가지고 있지 않아 app 구조가 view tree가 아닌 business logic 중심으로 설계된다.
    - view 계층과 business logic의 범위를 분리한다

<br>

## 설치

- RIBs clone
    - RIBs repository를 clone하여 다운받기
- shell script 실행하여 xcode에 설치
    - <RIBs path>/ios/tooling/install-xcode-template.sh

<br>

## Tutorial 1

- tutorial1 열기
    - <RIBs path>/ios/tutorials/tutorial1 으로 이동
- Podfile 수정
    - pod 'RxCocoa', '~> 6.0'
- Pod install
    - arch -x86_64 pod install

<br>
