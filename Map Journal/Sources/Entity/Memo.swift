//
//  Memo.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/10.
//

import Foundation

struct Memo: Codable {
  var title: String
  var weatherEmogi: String
  var feelingEmogi: String
  var simpleMemo: String
  var dateString: String
  var date: Date
  
  init(_ title: String, _ weatherEmoji: String, _ feelingEmoji: String, _ simpleMemo: String) {
    self.title = title
    self.weatherEmogi = weatherEmoji
    self.feelingEmogi = feelingEmoji
    self.simpleMemo = simpleMemo
    self.date = Date()
    self.dateString = Memo.dateFormatter.string(
      from: date)
  }
  
}

extension Memo {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.autoupdatingCurrent
    formatter.locale = Locale(identifier: "ko")
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
  }()
}
