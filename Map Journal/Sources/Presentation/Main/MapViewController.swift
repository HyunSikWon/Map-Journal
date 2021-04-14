//
//  MapViewController.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/09.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit
import Then

protocol MapView {
  func showAnnotations(_ annotaion: [MKAnnotation])
  func showMemoView(_ vc: UIViewController)
}

protocol MapViewPresenter {
  func fetchData()
  func annotationDidTap(_ annotation: MKAnnotation)
}

class MapViewController: UIViewController, MapView {
  
  static let latLongMeters: CLLocationDistance = 500
 
  var dummyData = [
    Location(location: CLLocation(latitude: 37.51732369344599, longitude: 126.86403343414311)),
    Location(location: CLLocation(latitude: 37.5167, longitude: 126.862468))
  ]
  
  private var mapView = MKMapView()
  private var addJournalButton = UIButton()
  private var currentLocationButton = UIButton()
  private var buttonContainer = UIStackView()
  private let locationManager = CLLocationManager()
  
  var presenter: MapViewPresenter!

  override func loadView() {
    view = mapView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAttribute()
    setupLayout()
    initailizeLocationManager()
    initailizeMapView()
//     presenter.fetchData()
    // 임시
    setAnnotaion()
  }
  
  private func setupLayout() {
    buttonContainer.addArrangedSubview(addJournalButton)
    buttonContainer.addArrangedSubview(currentLocationButton)
    view.addSubview(buttonContainer)
    
    buttonContainer.snp.makeConstraints { make in
      make.right.equalTo(view.snp.right).offset(-20)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-25)
      make.width.equalTo(view.snp.width).multipliedBy(0.15)
      make.height.equalTo(buttonContainer.snp.width).multipliedBy(2)
    }
  }
  
  private func setupAttribute() {
    buttonContainer.do {
      $0.distribution = .fillEqually
      $0.spacing = 10
      $0.axis = .vertical
    }

    currentLocationButton.do {
      $0.setImage(UIImage(systemName: "location.circle"), for: .normal)
      $0.contentVerticalAlignment = .fill
      $0.contentHorizontalAlignment = .fill
      $0.addTarget(self, action: #selector(didTapCurrentLocationButton), for: .touchUpInside)
    }
   
    addJournalButton.do {
      $0.setImage(UIImage(systemName: "plus.circle"), for: .normal)
      $0.contentVerticalAlignment = .fill
      $0.contentHorizontalAlignment = .fill
      $0.addTarget(self, action: #selector(didTapAddJournalButton), for: .touchUpInside)

    }

  }
  
  @objc
  private func didTapCurrentLocationButton() {
    if let location = locationManager.location {
      setRegion(MKCoordinateRegion(center: location.coordinate,
                                   latitudinalMeters: MapViewController.latLongMeters,
                                   longitudinalMeters: MapViewController.latLongMeters))
    }
  }
  
  @objc
  private func didTapAddJournalButton() {
    guard let location = locationManager.location else { return }
    let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                 longitude: location.coordinate.longitude)
    
    let navVC = UINavigationController(rootViewController: AddLocationViewController(currentLocation))
    self.present(navVC, animated: true, completion: nil)
  }
  
  private func setRegion(_ region: MKCoordinateRegion) {
    mapView.setRegion(region, animated: true)
  }
  
  // 임시
  private func setAnnotaion() {
    let annos = dummyData.map {annotationForLocation($0)}
    showAnnotations(annos)
  }
  
  // MARK: - Presenter -> View
  func showAnnotations(_ annotations: [MKAnnotation] ) {
    // Presenter -> view.fetchData(annotations)
    mapView.addAnnotations(annotations)
  }
  
  func showMemoView(_ memoViewController: UIViewController) {
    let vc = UIViewController()
    vc.view.backgroundColor = .white
    vc.modalPresentationStyle = .popover
    self.present(vc, animated: true, completion: nil)
//    self.present(memoViewController, animated: true, completion: nil)
  }
  
  // Presenter에 옮길 것
  private func annotationForLocation(_ location: Location) -> MKAnnotation {
    let annotation = MKPointAnnotation()
    annotation.coordinate = location.coordinate
    return annotation
  }

}

extension MapViewController: MKMapViewDelegate {
  private func initailizeMapView() {
    mapView.showsUserLocation = true
    mapView.delegate = self
    mapView.userTrackingMode = .follow
    if let location = locationManager.location {
      setRegion(MKCoordinateRegion(center: location.coordinate,
                                   latitudinalMeters: MapViewController.latLongMeters,
                                   longitudinalMeters: MapViewController.latLongMeters) )
    }
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    // View -> Presenter
    guard let annotation = view.annotation else {return}
    mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate,
                                         latitudinalMeters: MapViewController.latLongMeters,
                                         longitudinalMeters: MapViewController.latLongMeters), animated: true)

//    presenter.annotationDidTap(annotation)
    showMemoView(UIViewController())
  }

}

extension MapViewController: CLLocationManagerDelegate {
  private func initailizeLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    
    switch locationManager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      print("인증 성공")
      locationManager.startUpdatingLocation()
      
    case .notDetermined:
      locationManager.requestAlwaysAuthorization()
      
    case .denied, .restricted:
      print("위치 서비스 권한 필요")
    }
  }
}

