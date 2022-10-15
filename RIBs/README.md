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

<br>

## Tutorial 3

- 목표
    - Builder를 통해 dynamic dependency를 자식 RIB에게 전달하기
    - static dependencies를 Dependency Injection tree를 이용해 전달하기
    - RIB lifecycle을 이용하여 Rx stream의 lifecycle 관리하기
    
- `LoggedOut` RIB에서 `Root` RIB으로 보낸 값을 자식인 `LoggedIn` RIB으로 보내기
    - LoggedInBuilder의 build 함수의 매개변수를 build(withListner:, player1Name:, player2Name)로 변경
    - LoggedInComponent는 player1Name과 player2Name을 property로 소유함 
    - LoggedInBuilder가 build 함수에서 LoggedInComponent를 만들고 이를 OffGameBuilder와 TicTacToeBuilder에 주입
    
- DI tree를 이용해 `LoggedIn` RIB에서 하위 RIB으로 값을 보내기
    - OffGameBuilder는 LoggedInComponent를 받아 dependency(OffGameDependecy)로서 소유함
        - LoggedInComponent는 extension에서 OffGameDependency protocol을 채택함
    - OffGameBuilder는 build 함수에서 OffGameViewController의 생성자의 매개변수에서 player1Name과 player2Name을 받아 생성한다
    
- Rx stream을 사용해 형제 RIB 사이에서 값을 추적하기
    - LoggedIn RIB에서 ScoreStream 파일을 생성
    - LoggedInComponent가 ScoreStreamIpl 객체를 sigleton으로 만드는 computed property를 소유
    - LoggedInBuilder가 LoggedInInteractor에 component.mutableScoreStream을 주입
    - OffGameDependency protocol은 read-only ScoreStream를 가짐
    - OffGameComponent는 ScoreStream을 반환하는 computed property를 소유
    - OffGameBuilder가 OffGameInteractor에 component.scoreStream을 주입
    - LoggedInComponent는 mutableScoreStream을 read-only ScoreStream의 형태로 소유하여 dependency를 제공

- stream 값을 화면에 보여주기
    - OffGameInteractor는 didBecomeActive()에서 updateScore()를 호출
    - OffGameInteractor는 updateScore()에서 scoreStream을 구독하고, 값이 변경되면  presenter(OffGameViewController)의 set(score:) 함수를 호출한다

- stream 값을 변경하는 과정
    - TicTacToeInteractor는 placeCurrentPlayerMake(atRow:,col:)함수에서 winner가 생겼을 때에 presenter(TicTacToeViewController)의 announce 함수를 실행하고, handler를 주입한다.
    - TicTacToeViewController는 announce(winner:,withCompletionHandler:) 함수에서 handler()를 호출한다
    - handler()가 호출되면 listener(LoggedInInteractor)의 gameDidEnd(withWinner:) 함수를 호출한다
    - LoggedInInteractor는 mutableScoreStream.updateScore(withWinner:) 함수를 호출하고, router?.routeToOffGame() 함수를 호출한다
