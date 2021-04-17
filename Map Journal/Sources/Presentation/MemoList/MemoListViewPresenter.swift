//
//  MemoListViewPresenter.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/16.
//

import Foundation

protocol MemoListView {
  func setMemoListViewItems(_ viewData: [MemoViewData])
}

class DefaultMemoListViewPresenter: MemoListViewPresenter {
  
  // var memoRepo
  var view: MemoListView?
  
  init(_ view: MemoListView) {
    self.view = view
  }
  
  // MARK: view -> presenter
  func fetchData() {
    // TODO: Fetch data from repo
    view?.setMemoListViewItems(dummy.map{MemoViewData(title: $0.title, date: $0.dateString, feeling: $0.feelingEmogi, weather: $0.weatherEmogi, memo: $0.simpleMemo)})
  }
  
  func willDeleteCell(_ indexPath: IndexPath) {
    // TODO: Delelte & Save data
    view?.setMemoListViewItems(dummy.map{MemoViewData(title: $0.title, date: $0.dateString, feeling: $0.feelingEmogi, weather: $0.weatherEmogi, memo: $0.simpleMemo)})
  }
  
  var dummy = [
    Memo("스타벅스1", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날"),
    Memo("스타벅스1", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"),
    Memo("스타벅스1", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"),
    Memo("스타벅스1", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날기분이 별로인 날"),
    Memo("스타벅스1", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"),
    Memo("스타벅스1", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"),
    Memo("스타벅스1", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"),
    Memo("스타벅스1", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날")
  ]
  
}
