//
//  MapViewController.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/09.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
  
  private var mapView = MKMapView()
  private var addJournalButton = UIButton()
  private var currentLocationButton = UIButton()
  private var buttonContainer = UIStackView()
  private let locationManager = CLLocationManager()
  
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
  
  private func setupLayout() {
    buttonContainer.translatesAutoresizingMaskIntoConstraints = false
    buttonContainer.addArrangedSubview(addJournalButton)
    buttonContainer.addArrangedSubview(currentLocationButton)
    view.addSubview(buttonContainer)
    
    NSLayoutConstraint.activate([
      buttonContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
      buttonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
      buttonContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
      buttonContainer.heightAnchor.constraint(equalTo: buttonContainer.widthAnchor, multiplier: 2)
    ])

  }
  private func setupAttribute() {
    buttonContainer.distribution = .fillEqually
    buttonContainer.spacing = 10
    buttonContainer.axis = .vertical

    currentLocationButton.setImage(UIImage(systemName: "location.circle"), for: .normal)
    currentLocationButton.contentVerticalAlignment = .fill
    currentLocationButton.contentHorizontalAlignment = .fill
    
    addJournalButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
    addJournalButton.contentVerticalAlignment = .fill
    addJournalButton.contentHorizontalAlignment = .fill

    
    currentLocationButton.addTarget(self, action: #selector(didTapCurrentLocationButton), for: .touchUpInside)
    addJournalButton.addTarget(self, action: #selector(didTapAddJournalButton), for: .touchUpInside)

  }
  
  @objc
  private func didTapCurrentLocationButton() {
    if let location = locationManager.location {
      setRegion(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500))
    }
  }
  
  @objc
  private func didTapAddJournalButton() {
  }
  
  private func setRegion(_ region: MKCoordinateRegion) {
    mapView.setRegion(region, animated: true)
  }
  
  
}

extension MapViewController: MKMapViewDelegate {
  private func initailizeMapView() {
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    if let location = locationManager.location {
      setRegion(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500) )
    }
  }
}

extension MapViewController: CLLocationManagerDelegate {
  private func initailizeLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
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
