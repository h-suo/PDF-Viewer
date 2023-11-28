//
//  PDFDTO.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/16.
//

import Foundation
import RealmSwift

final class PDFDTO: Object {
  @Persisted(primaryKey: true) var id: UUID
  @Persisted var title: String
  @Persisted var url: String
  @Persisted var bookMark: List<IntBoolPair>
  @Persisted var memo: List<IntStringPair>
  
  convenience init(id: UUID = UUID(),
                   title: String, url: String,
                   bookMark: List<IntBoolPair> = List<IntBoolPair>(),
                   memo: List<IntStringPair> = List<IntStringPair>()
  ) {
    self.init()
    self.id = id
    self.title = title
    self.url = url
    self.bookMark = bookMark
    self.memo = memo
  }
}

final class IntBoolPair: Object {
  @Persisted var key: Int
  @Persisted var value: Bool
}

final class IntStringPair: Object {
  @Persisted var key: Int
  @Persisted var value: String
}
