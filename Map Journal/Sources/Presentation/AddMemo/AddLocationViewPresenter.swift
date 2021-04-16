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

class DefaultAddLocationViewPresenter: AddLocationViewPresenter {

  var view: AddMemoView?
  
  init(_ view: AddMemoView) {
    self.view = view
  }
  
  func addButtonDidTap(_ location: CLLocationCoordinate2D, _ memo: MemoViewItems) {
    // TODO: Save Logic
    
    // if error
    view?.showAlert(withErrorMessage: "오류 종류")
    // succes
    view?.dismiss()
  }
    
  
}
