//
//  PDFListViewModelTests.swift
//  PDFViewerTests
//
//  Created by Erick on 2023/12/03.
//

import Combine
import XCTest
@testable import PDFViewer

final class PDFListViewModelTests: XCTestCase {
  
  // MARK: - Private Property
  private var viewModel: PDFListViewModel!
  private var cancellables: [AnyCancellable] = []
  
  private let dummyDatas = [
    PDFData(title: "test1", url: URL(string: "testURL.pdf")!),
    PDFData(title: "test2", url: URL(string: "testURL.pdf")!)
  ]
  
  override func setUpWithError() throws {
    viewModel = DefaultPDFListViewModel(repository: MockRepository(pdfDatas: dummyDatas))
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
  }
  
  // MARK: - Success Case
  func test_success_storePDF_method_and_pdfDatasPublisher() {
    // given
    let url = URL(string: "testURL.pdf")!
    let expectation = (title: "storeTest", url: url)
    
    do {
      // when
      try viewModel.storePDF(title: expectation.title, urlString: expectation.url.absoluteString)
      
      viewModel.pdfDatasPublisher.sink { pdfdatas in
        let pdfData = pdfdatas.last!
        
        // then
        XCTAssertEqual(pdfData.title, expectation.title)
        XCTAssertEqual(pdfData.url, expectation.url)
      }.store(in: &cancellables)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
  
  func test_success_searchPDF_method_and_searchPDFDatasPublisher() {
    // given
    let expectation = dummyDatas.first!
    
    // when
    viewModel.searchPDF(expectation.title)
    viewModel.searchPDFDatasPublisher.sink { pdfdatas in
      let pdfData = pdfdatas.last!
      
      // then
      XCTAssertEqual(pdfData.title, expectation.title)
      XCTAssertEqual(pdfData.url, expectation.url)
    }.store(in: &cancellables)
  }
  
  func test_success_deletePDF_method() {
    do {
      // when
      for _ in 0..<dummyDatas.count {
        try viewModel.deletePDF(at: 0)
      }
      
      viewModel.searchPDFDatasPublisher.sink { pdfdatas in
        // then
        XCTAssertTrue(pdfdatas.isEmpty)
      }.store(in: &cancellables)
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
  
  // MARK: - Failure Case
  func test_failure_invalidURL() {
    // given
    let url = "failureTestURL"
    let title = "failureTest"
    let expectation = RepositoryError.invalidURL
    
    do {
      // when
      try viewModel.storePDF(title: title, urlString: url)
    } catch {
      // then
      guard let repositoryError = error as? RepositoryError else {
        XCTFail("test Fail")
        return
      }
      XCTAssertEqual(repositoryError, expectation)
    }
  }
  
  func test_failure_deletionFailed() {
    // given
    let expectation = RepositoryError.deletionFailed
    
    do {
      // when
      try viewModel.deletePDF(at: dummyDatas.count)
    } catch {
      // then
      guard let repositoryError = error as? RepositoryError else {
        XCTFail("test Fail")
        return
      }
      XCTAssertEqual(repositoryError, expectation)
    }
  }
}
