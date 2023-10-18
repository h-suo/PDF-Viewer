# PDF Viewer

## 📖 목차

1. [📢 소개](#1.)
2. [👤 팀원](#2.)
3. [⏱️ 타임라인](#3.)
4. [📊 파일트리](#4.)
5. [📱 실행 화면](#5.)
6. [🤔 고민한 점](#6.)
7. [🔗 참고 링크](#7.)

<br>

<a id="1."></a>

## 1. 📢 소개
`URL`로 `PDF`를 추가하여 볼 수 있습니다! <br>
내가 원하는 곳을 북마크로 쉽게 체크할 수 있으며 페이지별로 메모를 남길 수 있습니다!

> **핵심 개념 및 경험**
> 
> - **MVVM**
>   - `MVVM`으로 아키텍쳐 설계
> - **CleanArchitecture**
>   - `CleanArchitecture` 개념을 이용한 객체 분리
> - **Combine**
>   - `Combine`을 이용한 데이터 바인딩
> - **PDFKit**
>   - `PDFKit`을 사용하여 `PDF` 파일을 볼 수 있도록 구현
> - **Realm**
>   - `Realm`을 이용한 로컬 저장 기능 구현

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
| **2023.10.13** |▫️ 코드 개선을 위한 리펙토링 <br>|
| **2023.10.16** |▫️ 북마크 기능 추가 <br> ▫️ 메모 기능 추가 <br> ▫️ `realm`을 이용한 로컬 데이터 저장 기능 구현 <br>|
| **2023.10.17** |▫️ README 작성 <br>|

<br>

<a id="4."></a>
## 4. 📊 파일트리

### 파일트리
```
├── Application
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Domain
│   ├── Entity
│   │   └── PDFData.swift
│   └── UseCase
│       └── PDFViewerUseCase.swift
├── Presentation
│   ├── Flow
│   │   └── PDFViewerCoordinator.swift
│   ├── PDFDetail
│   │   ├── View
│   │   │   ├── PDFDetailViewController.swift
│   │   │   └── PDFMemoViewController.swift
│   │   └── ViewModel
│   │       └── PDFDetailViewModel.swift
│   └── PDFList
│       ├── View
│       │   ├── PDFListCell.swift
│       │   └── PDFListViewController.swift
│       └── ViewModel
│           └── PDFListViewModel.swift
├── Data
│   ├── DTO
│   │   └── PDFDTO.swift
│   ├── Repositories
│   │   └── RealmRepository.swift
│   └── Translater
│       └── PDFDataTranslater.swift
├── Error
│   ├── RepositoryError.swift
│   └── UseCaseError.swift
├── Utils
│   └── Extensions
│       ├── UIAlertController+.swift
│       └── UITextView+.swift
└── Resources
```

<br>

<a id="5."></a>
## 5. 📱 실행 화면
| PDF 추가 | PDF 삭제 |
| :--------------: | :-------: |
| <Img src = "https://github.com/h-suo/PDF-Viewer/assets/109963294/b507e28a-78a5-44f4-a460-4531dd159c88" width="300"/> | <Img src = "https://github.com/h-suo/PDF-Viewer/assets/109963294/2da8d16c-41a4-4e83-b11a-f752627fd55d" width="300"/> |
| 북마크 추가 | 북마크 삭제 |
| <Img src = "https://github.com/h-suo/PDF-Viewer/assets/109963294/7e5dc646-75e5-4b5f-a290-5d315d11971f" width="300"/> | <Img src = "https://github.com/h-suo/PDF-Viewer/assets/109963294/2b682a99-8faa-4810-8922-eec5adcb43ba" width="300"/> |
| 북마크 이동 | 메모 |
| <Img src = "https://github.com/h-suo/PDF-Viewer/assets/109963294/8adf2cda-421c-4183-ae25-3fc084864cce" width="300"/> | <Img src = "https://github.com/h-suo/PDF-Viewer/assets/109963294/8fb83ddb-d91b-443d-845c-f2c95dab8bb0" width="300"/> |

<br>

<a id="6."></a>
## 6. 🤔 고민한 점

### 1️⃣ CleanArchitecture & MVVM

체계적인 객체의 분리를 위해 `CleanArchitecture`와 `MVVM`을 함께 적용하여 프로젝트를 구현했습니다.

**객체 분리**
- Application : `AppDelegate`와 `SceneDelegate` 등 앱의 전체적인 동작을 관여하는 파일 그룹입니다.
- Domain
  - Entity : 앱에서 사용하는 데이터 모델입니다.
  - UseCase : 앱의 큰 동작 즉 비즈니스 로직을 담당합니다.
- Presentation
  - Flow : `Coordinator`가 있으며 `View`의 흐름을 제어을 제어합니다.
  - View : `UI` 구현 및 사용자 이벤트 수신을 담당합니다.
  - ViewModel : `View`에 수신된 이벤트 관리 및 사용자에게 보여줄 데이터 관리를 합니다.
- Data
  - Repositories : 데이터를 저장 및 수정합니다.
  - Translater : `DTO`를 `Entity`로 변환합니다.
  - DTO : 로컬 DB에서 사용하기 위한 데이터 모델입니다.
- Utils : 앱에서 사용하기 위한 확장 기능의 그룹입니다.
  - Extensions

<br>

### 2️⃣ PDFKit
`PDF`를 보여주기 위해 Apple에서 제공하는 프레임워크인 `PDFKit`을 사용했습니다.

`PDFView`로 UI를 구현하고 `PDFDocument`를 넣어 `PDF`를 볼 수 있도록 했습니다.

```swift
final class PDFDetailViewController: UIViewController {
    
    // MARK: - Private Property
    private var pdfView: PDFView = {
        // ...
    }()
    
    // ...
    private func configurePDFView(pdfDocument: PDFDocument?) {
        DispatchQueue.main.async {
            self.pdfView.document = pdfDocument
        }
    }
}
```

<br>

### 3️⃣ Realm

사용자의 `PDF` 데이터를 저장하기 위해 `Realm`을 이용하여 `Repository`를 구현하였습니다.
그리고 `UseCase`에서 `RealmRepository`를 이용해서 사용자 데이터를 로컬에 영구저장할 수 있도록 했습니다.

```swift
class RealmRepository {
    
    // MARK: - Private Property
    private var realm: Realm
    
    // MARK: - CRUD Function
    // ...
}
```

<br>

### 4️⃣ List Cell

`TableView`가 아닌 `CollectionView`의 `ListConfiguration`과 `ListCell`을 사용하여 `List` UI를 구현하였습니다.
또한 스와이프 액션을 `Delegate`로 처리하는 `TableView`와 달리 `configuration`을 통해 추가하였습니다.

```swift
// MARK: - Configure UI Object
extension PDFListViewController {
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView?.register(PDFListCell.self, forCellWithReuseIdentifier: PDFListCell.identifier)
        // ...
    }
}
```

<br>

<a id="7."></a>
## 7. 🔗 참고 링크
- [🍎 Apple: PDFKit](https://developer.apple.com/documentation/pdfkit)
- [🍎 Apple: PDFView](https://developer.apple.com/documentation/pdfkit/pdfview)
- [🍎 Apple: UICollectionLayoutListConfiguration](https://developer.apple.com/documentation/uikit/uicollectionlayoutlistconfiguration)
- [😺 GitHub: iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)
- [😺 GitHub: PDFKitExample](https://github.com/bonjin-app/iOS/tree/main/PDFKitExample)
- [📚 블로그: Realm의 특징과 사용법](https://velog.io/@dlskawns96/Swift-Realm의-특징과-사용법)
