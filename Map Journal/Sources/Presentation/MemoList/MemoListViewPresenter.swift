//
//  MemoListViewPresenter.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/16.
//

import Foundation
import CoreLocation
protocol MemoListView {
  func setMemoListViewItems(_ viewData: [MemoViewData])
}

class DefaultMemoListViewPresenter: MemoListViewPresenter {
  
  var repo: MemoRepository?
  var view: MemoListView?
  
  init(_ view: MemoListView, _ repo: MemoRepository) {
    self.view = view
    self.repo = repo
  }
  
  // MARK: view -> presenter
  func fetchData(_ coordinate: CLLocationCoordinate2D) {
    repo?.fetch({ [weak self] result in
      guard let self = self else {return}
      switch result {
      case .success():
        self.setMemoListView(coordinate)
      case .failure(let error):
        print("fetchError \(error.localizedDescription)")
      }
    })

  }
  
  func willDeleteCell(_ indexPath: IndexPath) {
    // TODO: Delelte & Save data
  }
  
  private func setMemoListView(_ coordinate: CLLocationCoordinate2D) {
    var memoViewDatas: [MemoViewData] = []
    repo?.locations.forEach({ location in
      if location.longtitude == coordinate.longitude && location.latitude == coordinate.latitude {
        
        location.memos.forEach { (memo) in
          memoViewDatas.append(MemoViewData(title: memo.title, date: memo.dateString, feeling: memo.feelingEmogi, weather: memo.weatherEmogi, memo: memo.simpleMemo))
        }
        
      }
    })
    self.view?.setMemoListViewItems(memoViewDatas)
  }
  
}
