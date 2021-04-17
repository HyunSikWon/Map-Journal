//
//  MapViewPresenter.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/15.
//

import Foundation
import CoreLocation
import MapKit

protocol MapView {
  func showAnnotations(_ annotaion: [MKAnnotation])
  func showView(_ vc: UIViewController)
}

class DefaultMapViewPresenter: MapViewPresenter {
  
  // MARK: - repository
  var repo: MemoRepository!
  
  //  MARK: - view
  var view: MapView!
  
  init(_ view: MapView, _ repo: MemoRepository) {
    self.view = view
    self.repo = repo
  }
  
  // View -> Presenter
  func fetchData() {
    repo.fetch({ [weak self] result in
      guard let self = self else {return}
      
      switch result {
      case .success(_):
        print("fetch success")
        self.setMapView()
        
        
      case .failure(let error):
        print("fetchError \(error.localizedDescription)")
      }
    })
  }
  
  func annotationDidTap(_ annotation: MKAnnotation) {
    let coordinate = annotation.coordinate
    // TODO: 의존성
    let memoListViewController = MemoListViewController()
    memoListViewController.coordinate = coordinate
    memoListViewController.presenter = DefaultMemoListViewPresenter(memoListViewController, DependencyContainer.shared.memoRepository)
    view.showView(memoListViewController)
  }
  
  func addButtonDidTap(_ currentLocation: CLLocationCoordinate2D) {
    // TODO: 의존성
    let addMemoViewController = AddMemoViewController(currentLocation)
    addMemoViewController.presenter = DefaultAddMemoViewPresenter(addMemoViewController, DependencyContainer.shared.memoRepository)
    view.showView(addMemoViewController)
    
  }
  
  private func setMapView() {
    let annotations = repo.locations.map { annotationForLocation($0) }
    view.showAnnotations(annotations)
  }
  
  private func annotationForLocation(_ location: Location) -> MKAnnotation {
    let annotation = MKPointAnnotation()
    annotation.coordinate = location.coordinate
    return annotation
  }
  
}
