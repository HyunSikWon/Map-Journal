//
//  AddMemoViewPresenter.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/16.
//

import Foundation
import CoreLocation

protocol AddMemoView {
  func showAlert(withErrorMessage message: String)
  func dismiss()
}

class DefaultAddMemoViewPresenter: AddMemoViewPresenter {
  var repo: MemoRepository!
  var view: AddMemoView!
  
  init(_ view: AddMemoView, _ repo: MemoRepository) {
    self.view = view
    self.repo = repo
  }
  
  func addButtonDidTap(_ location: CLLocationCoordinate2D,
                       _ viewData: MemoViewData) {
    let newMemo = Memo(viewData.title, viewData.weather, viewData.feeling, viewData.memo)
    
    repo.add(location , newMemo, { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success():
        self.view?.dismiss()
      case .failure(let error):
        self.view?.showAlert(withErrorMessage: error.localizedDescription)
        print("Add Error \(error.localizedDescription)")
      }
 
    })

  }
  
  
}
