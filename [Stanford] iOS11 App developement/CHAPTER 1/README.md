# Chapter1 : IOS 11, Xcode 9와 Swift 4 소개

<p align = "center"> <img src = "https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%201/imageFiles/1.jpg?raw=true" width = "450"/> <img src = "https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%201/imageFiles/2.jpg?raw=true" width = "450"/> </p>

<p align = "center"> <img src = "https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%201/imageFiles/3.jpg?raw=true" width = "450"/> <img src = "https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%201/imageFiles/4.jpg?raw=true" width = "450"/></p>

- Core OS : iOS는 [BSD](https://ko.wikipedia.org/wiki/BSD) 계열 Unix이다. 그래서 C언어를 기반으로 한다
- Cocoa Touch : UI layer임(버튼, 슬라이더 등이 존재함)

<br>
 <br>

## Concentration Game
<p align = "center"> <img width="100%" src="https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%201/imageFiles/demo.gif?raw=true"> </p>

<br>
 <br>

## Today i learned
- Object Library 단축키 : CMD + SHIFT + L
- Debug 영역 단축키 : CMD + SHIFT + Y
- Storyboard와 Code는 Control 키를 이용한 Drag & Drop 으로 연결이 가능
- Option 키를 누른 채로 코드를 클릭하면 Summary, Type, Document 확인 가능
- 이름을 변경해야 할 경우 : Command + 우클릭을 이용해 Rename을 해주어야 함
- 좋은 이름을 고르는 방법 : [바로가기](https://swift.org/documentation/api-design-guidelines/#naming)
- didSet : 프로퍼티가 변경될 때마다 코드가 실행되는 구문
~~~
    var flipCount = 0 {
        didSet { flipCountLabel.text = "Flip : \(flipCount)" }
    } // flipCount 값이 변경되면 didSet 구문이 실행됨
~~~
- 아래의 Outlet Collection에는 등록한 순서대로 append됨
- 때문에 ```cardButtons.firstIndex(of: sender)``` 값이 0부터 지정됨
~~~
    @IBOutlet var cardButtons: [UIButton]!
~~~
- 색상을 지정할 때에 ```color literal```을 사용할 수 있음
<p align = "center"><img src = "https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%201/imageFiles/5.jpg?raw=true" width = "400"/></p>
<p align = "center"><img src = "https://github.com/sustainable-git/iOS-Application-Study/blob/main/%5BStanford%5D%20iOS11%20App%20developement/CHAPTER%201/imageFiles/6.jpg?raw=true" width = "400"/></p>
