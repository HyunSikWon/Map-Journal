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


protocol MapViewPresenter {
  func fetchData()
  func annotationDidTap(_ annotation: MKAnnotation)
  func addButtonDidTap(_ currentLocation: CLLocationCoordinate2D)
}

class MapViewController: UIViewController, MapView {
  
  static let locationDistance: CLLocationDistance = 500
  
  // MARK: - View
  private var mapView = MKMapView()
  private var addJournalButton = UIButton()
  private var currentLocationButton = UIButton()
  private var buttonContainer = UIStackView()
  private let locationManager = CLLocationManager()
  
  // MARK: - Presenter
  var presenter: MapViewPresenter!
  
  // MARK: - Life Cycel
  override func loadView() {
    view = mapView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAttribute()
    setupLayout()
    initailizeLocationManager()
    initailizeMapView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    presenter.fetchData()
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
                                   latitudinalMeters: MapViewController.locationDistance,
                                   longitudinalMeters: MapViewController.locationDistance))
    }
  }
  
  @objc
  private func didTapAddJournalButton() {
    guard let location = locationManager.location else { return }
    let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                 longitude: location.coordinate.longitude)
    presenter.addButtonDidTap(currentLocation)
  }

  // MARK: - Presenter -> View
  func showAnnotations(_ annotations: [MKAnnotation] ) {
    mapView.addAnnotations(annotations)
  }
  
  func showView(_ vc: UIViewController) {
    // TODO: Navigtation Controller에 Full로 채우기
    let navigationController = UINavigationController(rootViewController: vc)
    navigationController.modalPresentationStyle = .fullScreen
    self.present(navigationController, animated: true, completion: nil)
  }

  // MARK: - Private
  private func setRegion(_ region: MKCoordinateRegion) {
    mapView.setRegion(region, animated: true)
  }
}

extension MapViewController: MKMapViewDelegate {
  private func initailizeMapView() {
    mapView.showsUserLocation = true
    mapView.delegate = self
    mapView.userTrackingMode = .follow
    if let location = locationManager.location {
      setRegion(MKCoordinateRegion(center: location.coordinate,
                                   latitudinalMeters: MapViewController.locationDistance,
                                   longitudinalMeters: MapViewController.locationDistance) )
    }
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let annotation = view.annotation else {return}
    mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate,
                                         latitudinalMeters: MapViewController.locationDistance,
                                         longitudinalMeters: MapViewController.locationDistance), animated: true)
    // view -> presenter
    presenter.annotationDidTap(annotation)
    mapView.deselectAnnotation(annotation, animated: true)
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

