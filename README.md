# 📕 LagomStyle
라곰식 소비를 위한 쇼핑 리스트 미니프로젝트

### 📚 사용기술
- UIKit, MVVM, Input-Output, CodeBasedUI, URLSession, Repository
- Kingfisher, Snapkit, IQKeyboardManagerSwift, RealmSwift

### 📚 실행화면
|시작|프로필설정|프로필이미지설정|검색|검색결과|
|-|-|-|-|-|
|![시작](https://github.com/user-attachments/assets/af382521-6fb6-44d3-9237-8eb058bd858e)|![프로필설정](https://github.com/user-attachments/assets/487fccb6-72e4-4124-a5d3-214f2d18b51a)|![프로필이미지](https://github.com/user-attachments/assets/11aebe67-d339-4dae-9703-9f7322bac890)|![검색](https://github.com/user-attachments/assets/6d5273db-c49b-4a6f-b023-abcea1db8f7d)|![검색결과](https://github.com/user-attachments/assets/949af6f2-19eb-4b0e-9495-fe1296ba15c0)|

|장바구니담기|상품상세|설정|장바구니|장바구니 추가|
|-|-|-|-|-|
|![장바구니담기](https://github.com/user-attachments/assets/db811d68-bce2-4709-bc7f-d7976f6acea6)|![상품상세](https://github.com/user-attachments/assets/198cfee3-6bfb-4b2e-8327-760406cf1064)|![설정](https://github.com/user-attachments/assets/fb16db85-543a-4ddc-bfdb-b394a546ad2a)|![장바구니](https://github.com/user-attachments/assets/a820b7d4-400d-487c-8a49-42e84b0ada61)|![장바구니추가](https://github.com/user-attachments/assets/8d07c44c-02e1-4731-94c6-c4388725ce38)|

<details>
<summary><h2>📚 구현 체크리스트</summary>
<div markdown="1">

- [x] 검색 결과 데이터 없을 때 앱 크래시 현상 해결 필요
- [x] 검색 결과 콜렉션뷰 셀 제약조건 위에서부터 다시 잡아주기!!!!
- [x] 닉네임 유효성 검사 메서드 do-try catch 구문으로 error throw 하는 방식으로 변경
- [x] 구조체 모델 CodingKey 적용
- [x] 중복 검색 데이터 기존 검색어 삭제 후 최신 데이터 추가
- [x] 다~ 하면 스켈레톤뷰 사용해보기 
- [x] View, ViewController 분리 
- [x] Alamofire => URLSession 으로 변경
- [x] Equatable -> Hashable로 변경 및 Hashable 공부
- [x] ConfigureViewProtocol 목적 명확히 하기(역할에 대한 목적이 모호) - 삭제 엔딩
- [x] Resource 파일 분리(어떤 기준으로 나눌 지 생각해보기)
- [x] 콜렉션뷰 외부로 분리해서 재사용할 수 있도록 수정
- [x] screenWidth 가져오는 코드 extension으로 따로 분리(다른 곳에서도 사용할 수 있도록)
- [x] 접근제어자를 설정해줬을 때 메서드 디스패치에서 어떤식으로 작동하며 퍼포먼스적으로 어떻게 향상이 이루어지는지 공부
- [x] 사용하지 않는 코드 혹은 주석 삭제
- [x] 스켈레톤뷰 보여주고 디스패치에서 2초뒤에 돌리는 코드 수정하기
- [x] 네트워크 코드 통합하기 
- [x] 네트워크 호출 시 상태코드에 따라 예외처리할 수 있도록 하기
- [x] 상품 검색 데이터 혹은 장바구니 데이터를 딕셔너리로 UserDefaults에 담아주는 방식으로 수정해보기
- [x] UserDefaults 전체 삭제 메서드 참고
- [x] 셀에 id값 구해주는 방식 변경(protocol, NSObject의 description())
- [x] 깃이그노어 최상단으로 올리기
- [x] 상품 눌렀을 때 네트워크 에러 발생 시 예외처리 필요
- [x] isOnboarding 빼고 나머지 UserDefaults -> realm 데이터베이스 사용 방식으로 변경
- [x] Folder에 대한 모델에서 사용되는 장바구니 데이터에 대한 리스트를 1:N 관계로 형성
- [x] 혹시 모를 Folder에 대해 메모를 작성할 수 있도록 1:1관계로 EmbeddedObject으로 Note 모델 생성
- [x] 장바구니 상품 데이터에서 해당 상품이 존재하는 Folder를 확인할 수 있도록 LinkingObjects를 통해 역관계 형성
- [x] 상품을 나열하는 콜렉션뷰에서 장바구니 버튼을 눌렀을 때 모달뷰를 띄워 폴더 선택하는 뷰를 보여주는 기능
- [x] 상품 디테일 화면에서 장바구니 버튼을 눌렀을 때 모달뷰를 띄워 폴더 선택하는 뷰를 보여주는 기능
- [ ] 대소문자 구분없이 검색하도록 변경
- [x] 닉네임 변경 시 공백제거
- [x] 더 이상 상속하지 하지 않는 클래스에 final 키워드를 사용하여 디스패치 최적화
- [x] isLike 프로퍼티명으로 되어있는 것들 isBasket으로 변경
- [x] view 혹은 cell 안에 담겨 있는 로직 ViewController로 빼기
- [x] View와 ViewModel 분리
- [ ] Realm 객체가 라이브 객체라는 것을 잘 이용할 수 있는 Realm 변경 리스너 구독해서 데이터 처리 해보기
- [ ] 스켈레톤뷰의 layer의 모양이 직각이여서 cornerRound 를 줄 필요가 있어보임
- [ ] 상품 검색 및 장바구니 뷰컨에서 세그먼트 버튼을 만들어 UI를 콜렉션뷰 or 테이블뷰로 볼 수 있도록 변경
- [ ] 검색하면 키보드 내려주기
- [ ] 조금씩 UI변경해나가기
- [ ] 로직 리팩토링
- [ ] 뷰 리팩토링

</div>
</details>

<details>
<summary><h2>📚 구현하면서 생긴 문제</summary>
<div markdown="1">



</div>
</details>

<details>
<summary><h2>📚 회고</summary>
<div markdown="1">

# 뷰와 컨트롤러 형태로 나눠져있더 형태를 뷰모델로 분리하면서 느낀 점

### 🔖 ViewModel의 필요성

- 점점 앱의 기능을 추가하게되면서 뷰컨트롤러의 뎁스가 깊어지게 되다보니 이 부분을 해결하고싶다 라는 마음이 강하게 있었지만 기능 구현에 좀 더 집중을 했고, 기능 구현을 목표만큼 한 후에도 역시나 로직 코드를 좀 분리하고싶다 라는 생각이 들었다.
- 물론 ViewModel이라는 선택지가 있다 라는 것은 알고있었지만 UIKit에서의 ViewModel과 내가 SwiftUI로 앱을 개발할 때 구현했던 ViewModel은 구조 자체가 달랐다.(내가 잘못 사용했던건가,,,)
- 어쨌든 ViewController에서 View에 대한 코드를 분리해놨다고 해도 어쨌든 뷰를 구성하는 코드와 네비게이션 푸시 등 아예 분리는 되지 않는다 라는 생각이 들어 ViewModel을 도입하게되었다.

### 🔖 Input 액션과 Output 액션으로 작동되는 로직 방식

- 처음에는 로직을 Input과 Output으로 분리를 한다는 것이 이해가 잘 되지 않았다.
- 분리를 왜 해야 하는지에 대한 이해가 아닌 분리하는 과정 자체가 좀 어려우면서 낯설었다.
- 하지만 뷰모델을 분리하면서 점차 어떤식으로 분리를 해야될 지에 대한 생각이 머릿속에서 들게되었다
- 완벽하진 않지만 모든 뷰컨트롤러를 뷰모델로 로직이 분리되면서 어떤 액션에 대한 Input이 들어가고 뷰모델에서 해당 Input을 감지한 후에 Output에 대한 액션을 뷰컨트롤러에 전달하게되면서 기능에 대한 로직 자체가 명확해지다보니 문제가 생겼을 때에 대한 테스트 자체가 확실히 수월해졌다.
- 즉, 로직에 대한 테스트를 수행할 시에 Input과 Output으로 좀 더 잘못된 점을 전보다 빠르게 캐치를 할 수 있게되었고 이러한 것도 어떻게 보면 코드의 가독성이 좋아지도록 리팩토링을 한 것이 아닌가 라는 생각과 동시에 좀 뿌듯하기도 했다.

### 🔖 구현하면서 들었던 의문점 및 마무리

##### 📚 의문점
- 어떤 버튼을 탭했을 때 네비게이션에 푸시를 하는 로직이 있다고 하면 단순히 버튼에 대한 Input 액션을 주고 뷰모델에서 감지하여  뷰컨트롤러에 Output에 대한 액션을 전달해줘 푸시를 해주는 과정 자체가 좀 어색...? 하다라는 생각이 들었지만 현 상황에서는 이게 최선이 아닐까 라는 생각으로 더 공부를 해봐야겠다

##### 📚 마무리
- 아직 완벽한 구조의 MVVM이 아니다.
- MVVM의 구조를 공부하고 분리하기 시작한 것이 아니라서 당연한 것이긴 하지만 좀 더 공부를 해서 MVVM의 구조에 더 적합한 형태의 코드를 작성할 수 있도록 리팩토링을 계속 진행해나갈 것이며 기능적으로 더 해보고싶은 것이 많다.

</div>
</details>
