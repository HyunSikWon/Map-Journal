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
  
  var dummyData = [
    Location(location: CLLocation(latitude: 37.51732369344599, longitude: 126.86403343414311)),
    Location(location: CLLocation(latitude: 37.5167, longitude: 126.862468))
  ]
  // repository
  // var locationRepo:
  
  // view
  var view: MapView?
  
  init(_ view: MapView) {
    self.view = view
    dummyData[0].memos.append(Memo("스타벅스1", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"))
    dummyData[0].memos.append(Memo("스타벅스2", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"))
    dummyData[0].memos.append(Memo("스타벅스3", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"))


    dummyData[1].memos.append(Memo("스타벅스1", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"))
    dummyData[1].memos.append(Memo("스타벅스2", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"))
    dummyData[1].memos.append(Memo("스타벅스3", "☂️", feelingEmoji: "☹️", simpleMemo: "기분이 별로인 날"))

  }
  
  
  // View -> Presenter
  func fetchData() {
    // TODO: Repository.fetch - 비지니스 로직
    let annotations = dummyData.map{ annotationForLocation($0)}
    view?.showAnnotations(annotations)
  }
  
  func annotationDidTap(_ annotation: MKAnnotation) {
    // TODO:  해당 어노테이션(위치)의 메모를 보여준다. - 비지니스 로직
//    let coordinate = annotation.coordinate
    
    // TODO: 의존성
    let memoListViewController = MemoListViewController()
    memoListViewController.presenter = DefaultMemoListViewPresenter(memoListViewController)
    view?.showView(memoListViewController)
  }
  
  func addButtonDidTap(_ currentLocation: CLLocationCoordinate2D) {
    
    // TODO: 의존성
    let addMemoViewController = UINavigationController(rootViewController: AddLocationViewController(currentLocation))
    view?.showView(addMemoViewController)
  }
  
  private func annotationForLocation(_ location: Location) -> MKAnnotation {
    let annotation = MKPointAnnotation()
    annotation.coordinate = location.coordinate
    return annotation
  }

}
