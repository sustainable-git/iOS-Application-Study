# Assignment 4 : Animated Set

[Assignment4 Pdf📎](./Programming_Project%204_Animated_Set.pdf)

<br>
<br>

<img src="./imageFiles/1.png?raw=true">

<br>
 <br>

## Animated Set + Concentration

<img width=100% src="./imageFiles/2.gif?raw=true">

<br>
 <br>

## 힘들었던 점

1. Xcode의 버전이 달라지면서 SplitView가 변경된 문제

    - 수업을 그대로 따라하더라도 SplitView가 적용이 되지 않았음
    - Xcode의 버전이 달라지면서, Storyboard에서 SplitView가 적용되는 방식이 변경됨
    - 과거 버전의 Storyboard의 XML과 현재 버전의 Storyboard XML을 비교함
    - allowDoubleColumnStyle을 지워서 문제를 해결
    - [자세한 내용](https://www.notion.so/7-1a03e9977b9249639a74c18dfadaced8)

<br>

2. 확장성이 부족한 코드

    - Set Game에서 이전에 만들어 두었던 코드는 Animation이 없음
    - 때문에, Set이 완성되어도 이전의 카드를 바로 없애지 않고, 다음 카드를 선택해야 변경되어야 했음
    - 이번 과제에 Animation을 넣으면서 이전의 카드를 바로 없애는 형식으로 변경해야 해서 소요가 많았음
    - 게다가, View를 변경하는 부분을 모두 updateViewFromModel() 메소드 안에 들어가 있고,
    - 카드를 클릭할 때마다 모든 View를 삭제하고 다시 그리는 형식이었기에, 변경의 소요가 많았음

<br>

3. Affine 변환과 Frame

    - Animation에서 Affine 변환과 Frame을 한 번에 변환하면 문제가 발생하였음
    - 때문에 Frame을 변경하지 않고, Affine 변환만을 이용해 Animation을 구현, 숫자 계산이 많았음

|Affine+frame|only Affine|
|:-:|:-:|
|<img height=400 src="./imageFiles/3.gif?raw=true">|<img height=400 src="./imageFiles/4.gif?raw=true">|

<br>

4. UISnapBehavior와 Rotation

    - Set이 완료된 Cards를 보기좋게 만들기 위해 가로로 배치하려고 하였음
    - 여기서 단순히 Snap Behavior를 적용하면 무조건 세로로 고정됨
    - Set된 Cards를 Deck으로 보내기 전에 Snap Behavior를 제거하고 보내도록 함

<br>

5. 시작할 때 grid의 layout이 정상적이지 않은 문제(ViewController LifeCycle)

    - CardCollectionView의 layoutSubviews에서 모든 CardViews에 대해 grid로 정렬하였음
    - 하지만, 이렇게 되면 View를 삭제할 때 layoutSubViews가 작동해 Animation이 없어짐
    - 따라서 이 부분을 삭제하였는데, 이제 layout이 비정상적으로 크게 만들어지는 문제가 발생함
    - 시작할 때에만 문제가 발생하고 Deal 버튼을 누르거나 Set을 맞추면 다시 문제가 사라졌음
    - 이 것을 해결하기 위해 몇 시간을 썼는데, 이유는 ViewController LifeCycle 문제였음
    - ViewDidLoad에서 CardCollectionView의 Grid의 bounds가 초기화되었던 것임!
    - 따라서 layoutSubViews를 그대로 이용하면서 Animation이 동작하는 부분에서는
    - 이 부분이 동작하지 않도록 변수 하나를 설정해 주었음

```
ViewDidLoad : 
화면이 초기할때 자주 사용됩니다.
현재의 outlet들이 셋팅되어 있기 때문에 Model을 사용하는 뷰를 업데이트 하기에 아주 좋습니다.
하지만 Bounds와 관련된 것들을 조작해서는 안됩니다.
아직 셋팅이 되기 전임으로 여러분이 원하는 결과를 기대할 수 없을지도 모릅니다.
단 한번만 호출 됩니다.
```

<br>

6. 화면 회전과 화면 크기 변경에 대한 AutoLayout

    - 화면 회전과 크기가 변경될 때에 모든 CardViews를 정렬시켜줘야 할 필요가 있음
    - 과제가 iphone과 ipad의 가로 및 세로모드에 
    - 그래서 CardCollectionView의 layoutIfNeeded()에 정렬하는 것을 넣어주었고,
    - ViewController에서 viewWillLayoutSubviews()이나 Notification을 받아서 이를 호출하려 함
    - 하지만, 해당 method가 호출될 때에 bounds가 이미 변경되어 있지 않았음
    - 때문에 화면을 회전하면 화면 모양의 반대로 bounds가 설정되는 기현상이 발생
    - 게다가 이렇게 호출하면 한 번만 호출되기 때문에 화면 회전시 생기는 Animation이 사라짐
    - 따라서 layoutSubviews에서 모든 CardViews의 위치를 변경하도록 다시 변경함
