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

/* TODO: UI
 1. 키보드 화면 가리는 문제.
 */

protocol AddMemoViewPresenter {
  func addButtonDidTap(_ location: CLLocationCoordinate2D, _ items: MemoViewData)
}

class AddMemoViewController: UIViewController, AddMemoView {
  
  var presenter: AddMemoViewPresenter!
  
  private let currentLocation: CLLocationCoordinate2D
  private let mapView: MKMapView = MKMapView()
  private let currentLocationButton = UIButton()
  private let addButton = UIButton()
  private let memoContainer = UIView()
  private let memoTitle = UITextField()
  private let memoTextView = UITextView()
  fileprivate let feeling = UISegmentedControl(items: ["🥳","😊","😗","☹️","😭","🤬"])
  fileprivate let weather = UISegmentedControl(items: ["☀️","🌤","☁️","☔️","❄️"])
  
  init(_ currentLocation: CLLocationCoordinate2D ) {
    self.currentLocation = currentLocation
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    setupAttribute()
    initailizeMapView()
  }
  
  private func setupLayout() {
    view.addSubview(mapView)
    mapView.addSubview(currentLocationButton)
    memoContainer.addSubview(memoTitle)
    memoContainer.addSubview(memoTextView)
    memoContainer.addSubview(addButton)
    memoContainer.addSubview(feeling)
    memoContainer.addSubview(weather)
    view.addSubview(memoContainer)
    
    mapView.snp.makeConstraints { make in
      make.width.equalTo(view.snp.width)
      make.height.equalTo(mapView.snp.width).multipliedBy(0.5)
      make.centerX.equalTo(view)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
    }
    
    currentLocationButton.snp.makeConstraints { make in
      make.width.equalTo(mapView).multipliedBy(0.1)
      make.height.equalTo(currentLocationButton.snp.width)
      make.right.equalTo(mapView.snp.right).offset(-18)
      make.bottom.equalTo(mapView.snp.bottom).offset(-20)
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
      make.top.equalTo(weather.snp.bottom).offset(10)
      make.left.equalTo(memoContainer.snp.left).offset(15)
      make.right.equalTo(memoContainer.snp.right).offset(-15)
      make.height.equalTo(memoContainer).multipliedBy(0.3)
    }
    
    addButton.snp.makeConstraints { make in
      make.top.equalTo(memoTextView.snp.bottom).offset(10)
      make.left.equalTo(memoContainer.snp.left).offset(15)
      make.right.equalTo(memoContainer.snp.right).offset(-15)
      make.height.equalTo(50)
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
      $0.delegate = self
    }
    
    addButton.do {
      $0.backgroundColor = .systemBlue
      $0.setTitle("기록 추가", for: .normal)
      $0.setTitleColor(.white, for: .normal)
      $0.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
      $0.layer.cornerRadius = 10
    }
  }
  
  
  @objc
  private func addButtonDidTap() {
    // Presenter.add
    // data
    presenter.addButtonDidTap(currentLocation, MemoViewData(title: "", date: "", feeling: "", weather: "", memo: ""))
  }
  
  // MARK: - Presenter - > View
  func showAlert(withErrorMessage message: String) {
    // TODO: Show Error
  }
  
  func dismiss() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc
  private func currentLocationButtonDidTap() {
    setRegion(currentLocation)
  }
  
  private func initailizeMapView() {
    let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 500)
    mapView.setCameraZoomRange(zoomRange, animated: true)
    setRegion(currentLocation)
  }
  
  private func setRegion(_ location: CLLocationCoordinate2D) {
    let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 800, longitudinalMeters: 800)
    mapView.setRegion(coordinateRegion, animated: true)
  }
}

extension AddMemoViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let str = textView.text else { return true }
    let newLength = str.count + text.count - range.length
    return newLength <= 100
  }
}
