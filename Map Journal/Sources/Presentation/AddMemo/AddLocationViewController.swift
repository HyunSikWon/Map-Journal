//
//  AddLocationViewController.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/13.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit
import Then


class AddLocationViewController: UIViewController {
  
  let currentLocation = CLLocationCoordinate2D(latitude: 37.5167, longitude: 126.86246782116663)
  let mapView: MKMapView = MKMapView()
  let locationPin = UIImageView()
  let currentLocationButton = UIButton()
  let addButton = UIButton()
  let memoContainer = UIView()
  let memoTitle = UITextField()
  let memoTextView = UITextView()
  let feeling = UISegmentedControl(items: ["😍","😀","😙","☹️","😭","🤬"])
  let weather = UISegmentedControl(items: ["☀️","🌤","☁️","☔️","❄️"])
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupAttribute()
    initailizeMapView()
    
  }
  
  private func setupLayout() {
    view.addSubview(mapView)
    mapView.addSubview(locationPin)
    mapView.addSubview(currentLocationButton)
    memoContainer.addSubview(memoTitle)
    memoContainer.addSubview(memoTextView)
    memoContainer.addSubview(addButton)
    memoContainer.addSubview(feeling)
    memoContainer.addSubview(weather)
    view.addSubview(memoContainer)
    
    mapView.snp.makeConstraints { make in
      make.width.equalTo(view.snp.width)
      make.height.equalTo(mapView.snp.width).multipliedBy(0.8)
      make.centerX.equalTo(view)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
    }
    
    locationPin.snp.makeConstraints { make in
      make.centerX.equalTo(mapView)
      make.centerY.equalTo(mapView)
      make.width.equalTo(30)
      make.height.equalTo(30)
    }
    
    currentLocationButton.snp.makeConstraints { make in
      make.width.equalTo(mapView).multipliedBy(0.1)
      make.height.equalTo(currentLocationButton.snp.width)
      make.right.equalTo(mapView.snp.right).offset(-16)
      make.bottom.equalTo(mapView.snp.bottom).offset(-16)
      
    }
    
    memoContainer.snp.makeConstraints { make in
      make.top.equalTo(mapView.snp.bottom)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.bottom.equalTo(view.snp.bottom)
    }
    
    memoTitle.snp.makeConstraints { make in
      make.top.equalTo(memoContainer.snp.top)
        .offset(15)
      make.height.equalTo(35)
      make.left.equalTo(memoContainer.snp.left).offset(17)
      make.right.equalTo(memoContainer.snp.right).offset(-17)
    }
    
    feeling.snp.makeConstraints { make in
      make.left.equalTo(memoContainer.snp.left).offset(17)
      make.right.equalTo(memoContainer.snp.right).offset(-17)
      make.top.equalTo(memoTitle.snp.bottom).offset(10)
      make.centerX.equalTo(memoContainer)
    }
    
    weather.snp.makeConstraints { make in
      make.left.equalTo(memoContainer.snp.left).offset(17)
      make.right.equalTo(memoContainer.snp.right).offset(-17)
      make.top.equalTo(feeling.snp.bottom).offset(10)
      make.centerX.equalTo(memoContainer)
    }
    
    memoTextView.snp.makeConstraints { make in
      make.top.equalTo(weather.snp.bottom).offset(16)
      make.left.equalTo(memoContainer.snp.left).offset(15)
      make.right.equalTo(memoContainer.snp.right).offset(-15)
      make.bottom.equalTo(addButton.snp.top).offset(-16)
    }
    
    addButton.snp.makeConstraints { make in
      make.width.equalTo(view)
      make.height.equalTo(view.snp.height).multipliedBy(0.1)
      make.bottom.equalTo(memoContainer.snp.bottom)
      make.centerX.equalTo(view)
    }
    
    
  }
  
  private func setupAttribute() {
    view.do {
      $0.backgroundColor = .white
    }
    mapView.do {
      $0.showsUserLocation = true
      mapView.userTrackingMode = .follow
    }
    
    locationPin.do {
      $0.image = UIImage(systemName: "mappin")
    }
    
    currentLocationButton.do {
      $0.setImage(UIImage(systemName: "location.circle"), for: .normal)
      $0.contentVerticalAlignment = .fill
      $0.contentHorizontalAlignment = .fill
      $0.addTarget(self, action: #selector(currentLocationButtonDidTap), for: .touchUpInside)
    }
    
    memoContainer.do {
      $0.backgroundColor = .white
    }
    
    memoTitle.do {
      $0.backgroundColor = .white
      $0.borderStyle = .roundedRect
      $0.placeholder = "제목"
      $0.autocorrectionType = .no
    }
    
    feeling.do {
      $0.selectedSegmentIndex = 0
    }
    
    weather.do {
      $0.selectedSegmentIndex = 0
    }
    
    memoTextView.do {
      $0.autocorrectionType = .no
      
      $0.layer.cornerRadius = 10
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.font = UIFont.systemFont(ofSize: 16)
      $0.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    addButton.do {
      $0.backgroundColor = .systemBlue
      $0.setTitle("기록 추가", for: .normal)
      $0.setTitleColor(.white, for: .normal)
      $0.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
  }
  
  @objc
  private func addButtonDidTap() {
    // Presenter.add
    print(mapView.centerCoordinate)
  }
  
  @objc
  private func currentLocationButtonDidTap() {
    setRegion(currentLocation)
  }
  
  private func initailizeMapView() {
    let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 800)
    mapView.setCameraZoomRange(zoomRange, animated: true)
    setRegion(currentLocation)
  }
  
  private func setRegion(_ location: CLLocationCoordinate2D) {
    let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 800, longitudinalMeters: 800)
    mapView.setRegion(coordinateRegion, animated: true)
  }
}


