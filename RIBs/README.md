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

## Tutorial 2

- RIB 및 화면 전환의 과정 1
    - LoggedOutViewController가 listener(LoggedOutInteractor)에게 logic이 발생함을 알리며 data를 보냄
    - LoggedOutInteractor가 listener(RootInteractor)에게 business logic을 거쳐 data를 보냄
    - RootInteractor가 router(RootRouter)에게 logic이 발생함을 알리며 data를 보냄
    - RootRouter가 detachChild(_:)로 loggedOut(LoggedOutRouter)을 자식 RIB에서 떼어냄
    - RootRouter의 viewController는 loggedOut의 viewController를 dismiss 함
    - RootRouter는 loggedOut을 nil로 변경함
    - RootRouter는 loggedInBuilder(LoggedInBuilder)를 build(withListener:) 함수로 객체를 만들게 함
    - LoggedInBuilder는 LoggedInRouter를 만들어 RootRouter에게 참조값을 제공함
    - RootRouter는 attachChild(_:)로 LoggedInRouter를 자식 RIB으로 저장함

- RIB 및 화면 전환의 과정 2
    - LoggedInRouter는 didLoad()에서 offGameBuilder를 이용해 OffGameRouter를 만듦
    - LoggedInRouter는 attachChild(_:)로 OffGameRouter를 자식 RIB으로 저장함
    - LoggedInRouter는 OffGameRouter의 viewControllable을 present()함
