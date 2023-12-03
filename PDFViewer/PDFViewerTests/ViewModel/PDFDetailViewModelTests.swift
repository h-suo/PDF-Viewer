//
//  PDFDetailViewModelTests.swift
//  PDFViewerTests
//
//  Created by Erick on 2023/12/03.
//

import Combine
import PDFKit
import XCTest
@testable import PDFViewer

final class PDFDetailViewModelTests: XCTestCase {
  
  // MARK: - Private Property
  private var viewModel: PDFDetailViewModel!
  private var cancellables: [AnyCancellable] = []
  
  private let dummyDatas = [
    PDFData(title: "test1", url: URL(string: "file:///Users/pyohyeonsu/Downloads/pdfViewer.pdf")!)
  ]
  
  override func setUpWithError() throws {
    viewModel = DefaultPDFDetailViewModel(
      repository: MockRepository(pdfDatas: dummyDatas),
      index: 0
    )
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
  }
  
  // MARK: - Success Case
  func test_pdfDocumentPublisher() {
    // given
    let expectation = XCTestExpectation(description: "test pdfDocumentPublisher")
    var result: PDFDocument?
    let url = URL(string: "file:///Users/pyohyeonsu/Downloads/pdfViewer.pdf")!
    let expectationDocument = PDFDocument(url: url)

    // when
    viewModel.pdfDocumentPublisher.sink { pdfDoucment in
      // then
      result = pdfDoucment
      expectation.fulfill()
    }.store(in: &cancellables)

    // then
    wait(for: [expectation], timeout: 5)
    
    if let result {
      XCTAssertEqual(result, expectationDocument)
    }
  }
  
  func test_bookmarkIndexsPublisher() {
    // given
    let expectation: [Int] = []
    
    // when
    viewModel.bookmarkIndexsPublisher.sink { bookmarkIndexs in
      // then
      XCTAssertEqual(bookmarkIndexs, expectation)
    }.store(in: &cancellables)
  }
  
  func test_updateBookmark_method_and_isBookmarkPublisher() {
    do {
      // when
      try viewModel.updateBookmark(at: 0)
      viewModel.isBookmarkPublisher.sink { isBookmark in
        // then
        XCTAssertTrue(isBookmark)
      }.store(in: &cancellables)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
  
  func test_updateHighlight_method_and_highlightsPublisher() {
    let expectation = "test highlight"
    
    do {
      // when
      try viewModel.updateHighlight(textList: [expectation], index: 0)
      viewModel.highlightsPublisher.sink { highlights in
        // then
        XCTAssertEqual(highlights, [expectation])
      }.store(in: &cancellables)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
  
  func test_memoPublisher() {
    let expectation = "test memo"
    
    do {
      // when
      try viewModel.updateMemo(text: expectation, index: 0)
      viewModel.memoPublisher.sink { memo in
        // then
        XCTAssertEqual(memo, expectation)
      }.store(in: &cancellables)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
}
