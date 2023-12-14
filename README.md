# PDF Viewer

## 📖 목차

1. [📢 소개](#1.)
2. [👤 팀원](#2.)
3. [⏱️ 타임라인](#3.)
4. [📊 UML & 파일트리](#4.)
5. [📱 실행 화면](#5.)
6. [🤔 고민한 점](#6.)
7. [🔗 참고 링크](#7.)

<br>

<a id="1."></a>

## 1. 📢 소개
URL로 PDF 파일을 추가하세요! 북마크, 하이라이트, 메모도 가능합니다!

> **핵심 개념 및 경험**
> 
> - **MVVM**
>   - 프로젝트의 가독성을 높이기 위해 `MVVM` 패턴을 이용해 프로젝트 파일 분리
> - **Combine**
>   - `ViewModel`의 데이터를 `View`에 바인딩하기 위해 `Combine` 사용
> - **PDFKit**
>   - `PDF` 파일을 활용하고 사용자에게 보여주기 위해 `PDFKit` 사용
> - **Realm**
>   - 일기의 데이터를 로컬에 저장하기 위해 `Realm`을 이용한 저장 기능 구현
> - **UISearchController**
>   - `UISearchController`를 이용한 검색 기능 구현
> - **Unit Test**
>   - `ViewModel`이 정상적으로 동작하는지 확인하기 위해 `Unit Test` 구현

<br>

<a id="2."></a>

## 2. 👤 팀원

| [Erick](https://github.com/h-suo) |
| :--------: | 
| <Img src = "https://user-images.githubusercontent.com/109963294/235300758-fe15d3c5-e312-41dd-a9dd-d61e0ab354cf.png" width="350"/>|

<br>

<a id="3."></a>
## 3. ⏱️ 타임라인

> 프로젝트 기간 :  2023.10.09 ~ 2023.10.17

|날짜|내용|
|:---:|---|
| **2023.10.09** |▫️ 사용 기술 선정 <br> ▫️ `PDFListViewController` UI 구현 <br>|
| **2023.10.10** |▫️ `PDFListCell`, `PDFDetailViewController` UI 구현 <br> ▫️ PDFData 엔티티 생성 <br>|
| **2023.10.11** |▫️ `PDFViewerUseCase` 생성 <br> ▫️ `PDFListViewModel` 생성 <br> ▫️ `PDFViewerCoordinator` 생성 <br> ▫️ `PDFDetailViewModel` 생성 <br>|
| **2023.10.16** |▫️ 북마크 기능 추가 <br> ▫️ 메모 기능 추가 <br> ▫️ `realm`을 이용한 로컬 데이터 저장 기능 구현 <br>|

> 리펙토링 기간 :  2023.11.21 ~ 2023.12.3

|날짜|내용|
|:---:|---|
| **2023.11.21** |▫️ `UISearchController`를 이용한 검색 기능 추가 <br>|
| **2023.11.27** |▫️ PDF 페이지 번호를 보여주는 기능 추가 <br>|
| **2023.11.28** |▫️ `highlight` 기능 추가 <br> ▫️ `highlight` 데이터를 저장할 수 있도록 `realm` 마이그레이션<br>|
| **2023.12.01** |▫️ `highlight` 삭제 기능 추가 <br>|
| **2023.12.03** |▫️ `ViewModel` 테스트 추가 <br>|

<br>

<a id="4."></a>
## 4. 📊 UML & 파일트리

### UML

<Img src = "https://github.com/h-suo/PDFViewer/assets/109963294/253b0edb-7cf8-4cbe-83c1-e879e53a03f0" width="800"/>

### 파일트리
```
PDFViewer
├── Application
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── DIContainer
│       └── DIContainer.swift
├── Domain
│   └── Entity
│       └── PDFData.swift
├── Presentation
│   ├── PDFList
│   │   ├── ViewModel
│   │   │   └── PDFListViewModel.swift
│   │   └── View
│   │       ├── PDFListCell.swift
│   │       └── PDFListViewController.swift
│   └── PDFDetail
│       ├── ViewModel
│       │   └── PDFDetailViewModel.swift
│       └── View
│           ├── PDFDetailViewController.swift
│           ├── PDFMemoViewController.swift
│           └── PageNumberView.swift
├── Data
│   ├── DTO
│   │   └── PDFDTO.swift
│   ├── Repositories
│   │   ├── Repository.swift
│   │   └── RealmRepository.swift
│   └── Translater
│       └── RealmTranslater.swift
├── Error
│   └── RepositoryError.swift
├── Utils
│   ├── Extensions
│   │   ├── Character+.swift
│   │   ├── String+.swift
│   │   ├── UITextView+.swift
│   │   └── UIViewController+.swift
│   ├── Manager
│   │   └── AlertManager.swift
│   └── NameSpace.swift
└── Resources
   ├── Assets.xcassets
   └── Info.plist
```

<br>

<a id="5."></a>
## 5. 📱 실행 화면
| PDF 추가 및 삭제 | PDF 검색 |
| :--------------: | :-------: |
| <Img src = "https://github.com/h-suo/PDFViewer/assets/109963294/912bb8e8-21c4-4106-933a-c33f08f7ff2a" width="300"/> | <Img src = "https://github.com/h-suo/PDFViewer/assets/109963294/04cf4b9d-3a80-4359-a8d0-b1f712164cbb" width="300"/> |
| **북마크** | **북마크 이동** |
| <Img src = "https://github.com/h-suo/PDFViewer/assets/109963294/df64f836-efb7-4dd2-a933-bd35f47be08b" width="300"/> | <Img src = "https://github.com/h-suo/PDFViewer/assets/109963294/1221a911-7c14-4653-9316-4b032a9f120c" width="300"/> |
| **하이라이트** | **메모** |
| <Img src = "https://github.com/h-suo/PDFViewer/assets/109963294/e9873bfe-ec55-47b4-99a1-96f7b7e94436" width="300"/> | <Img src = "https://github.com/h-suo/PDFViewer/assets/109963294/6ce06aa5-24d3-4a7a-854a-ca7e38a1d862" width="300"/> |

<br>

<a id="6."></a>
## 6. 🤔 고민한 점

### 1️⃣ 파일 분리

프로젝트의 가독성을 높이기 위해 파일 분리와 그룹화에 대해 고민을 했습니다. `MVVM` 패턴을 사용하여 `Model`, `ViewModel`, `View`를 나누는 것을 시작으로 그 외에 객체와 파일을 역할 별로 나누어 그룹화했습니다.

기존에 사용했던 `MVC` 패턴과 달리 `MVVM`은 `View`와 `Model`의 분리가 가능하고 `testable` 한 구현이 가능하다고 생각하여 `MVVM` 패턴을 사용했습니다.

> Application : 앱의 생명주기를 관리하는 `AppDelegate`, `SceneDelegate` <br>
> └ DIContainer : 의존성 주입을 관리하는 객체 <br>
> Domain  <br>
> └ Entity : 앱에서 사용하는 데이터 모델 <br>
> Presentation  <br>
> ├ ViewModel : `View`에 수신된 이벤트 관리 및 사용자에게 보여줄 데이터를 관리하는 객체 <br>
> └ View : `UI` 관리 및 사용자 이벤트 수신을 담당하는 객체 <br>
> Data <br>
> ├ DTO : 로컬 `DB`에서 사용하기 위한 데이터 모델 <br>
> ├ Repository : 데이터를 저장 및 수정합니다. <br>
> └ Translater : `DTO`를 `Entity`로 변환하는 객체 <br>
> Util : 프로젝트에 필요한 기능을 제공하는 `Util` 객체와 `Extension` 코드 <br>
> Resource : 프로젝트에 필요한 자원

<br>

### 2️⃣ ViewModel

`MVVM`으로 프로젝트를 설계하며 `ViewModel`을 구현하는데 많은 고민을 했습니다.

`ViewModel`의 큰 역할을 `Input`과 `Output`으로 나누어 사용자 이벤트를 받아오는 메서드와 데이터를 전달하는 프로퍼티로 나누어 구현했습니다.

**PDFListViewModel**
```swift
protocol PDFListViewModelInput {
  func storePDF(title: String, urlString: String) throws
  func deletePDF(at index: Int) throws
  func searchPDF(_ text: String)
}

protocol PDFListViewModelOutput {
  var pdfDatasPublisher: Published<[PDFData]>.Publisher { get }
  var searchPDFDatasPublisher: Published<[PDFData]>.Publisher { get }
}

typealias PDFListViewModel = PDFListViewModelInput & PDFListViewModelOutput
```

<br>

**PDFListViewController**
```swift
// MARK: - SearchResults Updating
extension PDFListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text?.lowercased() else {
      return
    }
    
    viewModel.searchPDF(text)
  }
}
```

`View`가 사용자로부터 받아온 이벤트를 `Input`의 메서드를 이용해 `ViewModel`이 알 수 있도록 했습니다.

```swift
// MARK: - Data Binding
extension PDFListViewController {
  // ...
  
  private func bindingSearchPDFData() {
    viewModel.searchPDFDatasPublisher.sink { pdfDatas in
      if !pdfDatas.isEmpty {
        self.loadCollectionView(pdfDatas)
      }
    }.store(in: &cancellables)
  }
}
```
`Output`을 이용해 데이터 바인딩 하여, `Input`으로 인해 바뀐 데이터을 `View`가 바로 업데이트할 수 있도록 했습니다.

<br>

### 3️⃣ PDFKit
`PDF`를 보여주기 위해 Apple에서 제공하는 프레임워크인 `PDFKit`을 사용했습니다.

`PDFView`로 UI를 구현하고 `PDFDocument`를 넣어 `PDF`를 볼 수 있도록 했습니다. <br>
`PDFView`의 메서드를 활용하여 페이지 이동과 북마크 기능 등을 구현했습니다.

```swift
final class PDFDetailViewController: UIViewController {
  
  // MARK: - Private Property
  private let pdfView: PDFView
    
  // MARK: - Configure UI Object
  private func configurePDFView(pdfDocument: PDFDocument?) {
    DispatchQueue.main.async {
      self.pdfView.document = pdfDocument
    }
  }
    
  // MARK: - Move PDF Page
  @objc private func tapNextButton() {
    pdfView.goToNextPage(nil)
  }
    
  // ...
}
```

<br>

### 4️⃣ Realm

사용자의 `PDF` 데이터를 저장하기 위해 `Realm`을 이용하여 `Repository`를 구현했습니다. <br>
딕셔너리 형태의 데이터를 저장하기 위해 `CoreData`가 아닌 `Realm`을 사용했습니다.

**RealmRepository**
```swift
final class RealmRepository: Repository {
  
  // MARK: - Static Property
  static let shared = RealmRepository()
  
  // MARK: - Private Property
  private var realm: Realm
    
  // ...
}
```

**DefaultPDFListViewModel**
```swift
final class DefaultPDFListViewModel: PDFListViewModel {
  
  // MARK: - Private Property
  private let repository: Repository
  
  // ...
}
```

`ViewModel`에서 `RealmRepository`를 이용해서 사용자 데이터를 로컬에 영구저장할 수 있도록 했습니다.

<br>

<a id="7."></a>
## 7. 🔗 참고 링크
- [🍎 Apple: PDFKit](https://developer.apple.com/documentation/pdfkit)
- [🍎 Apple: PDFView](https://developer.apple.com/documentation/pdfkit/pdfview)
- [🍎 Apple: UICollectionLayoutListConfiguration](https://developer.apple.com/documentation/uikit/uicollectionlayoutlistconfiguration)
- [😺 GitHub: iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)
- [😺 GitHub: PDFKitExample](https://github.com/bonjin-app/iOS/tree/main/PDFKitExample)
- [📚 블로그: Realm의 특징과 사용법](https://velog.io/@dlskawns96/Swift-Realm의-특징과-사용법)
