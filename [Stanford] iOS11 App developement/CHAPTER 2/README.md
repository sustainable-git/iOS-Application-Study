# Chapter2 : MVC(Model-View-Controller) 패턴
<p align = "center"> <img src=https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%202/imageFiles/1.jpg?raw=true> </p>

- MVC(Model-View-Controller) 패턴
  - 시스템 내의 "객체"를 Model, View, Controller로 구분하여 설계하는 방식
  - Model : UI 독립적인 객체(화면에 나오지 않음)
    - 사용자가 편집하기 원하는 모든 데이터를 가지고 있어야 함
    - View나 Controller에 대한 어떠한 정보도 알면 안 됨
    - 변경이 일어나면, 변경 통지에 대한 처리방법을 구현해야 함
  - Controller : View를 통제함
    - Model과 View에 대해 알고 있어야 함
    - Model과 View의 변경을 모니터링 해야 함
  - View : UI 요소들 (데이터 및 객체의 입출력을 담당)
    - Model이 가지고 있는 정보를 따로 저장해서는 안 됨
    - Model이나 Controller의 구성요소를 몰라야 함
    - 변경이 일어나면, 변경 통지에 대한 처리방법을 규현해야 함

<br>
 <br>

## Concentration Game
<p align = "center"> <img width="100%" src=https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%202/imageFiles/demo.gif?raw=true> </p>

<br>
 <br>

## Today i leanred
- Struct Vs Class
  -  Struct : 상속 X, Value Type
  -  Class : 상속 O, Reference Type
  

- Property(Stored, Computed, Type)
  - Stored Property : Struct 또는 Class에서 "값"을 저장함
    - Lazy Stored Property : 값이 사용되기 전까지는 값이 계산되지 않음
~~~
    lazy var game = Concentration(numberOfPairsOfCards: cardButtons.count/2)
~~~

-  - Computed Property : "값"을 연산하고, return 함
~~~
    class Point { // 이번 강의 속에 존재하는 내용이 아님. 예시임
        var tempX : Int = 1
        var x : Int { 
                        get { return tempX }
                        set { tempX = newValue * 2 }
                    }
    } // x를 호출하면 tempX 값이 2배가 되어 저장됨
~~~

-  - Type property : 타입 자체가 가지는 속성 및 함수
~~~
    struct Card {
        static var identifierFactory = 0
        static func getUniqueIdentifier() -> Int {
            identifierFactory += 1
            return identifierFactory
        }
    }
~~~
