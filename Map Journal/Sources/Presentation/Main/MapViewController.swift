//
//  MapViewController.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/09.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  
  private var mapView = MKMapView()
  private var addJournalButton = UIButton()
  private var currentLocationButton = UIButton()
  private var buttonContainer = UIStackView()
  
  override func loadView() {
    view = mapView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAttribute()
    setupLayout()

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
    print("didTapCurrentLocationButton")
  }
  
  @objc
  private func didTapAddJournalButton() {
    print("didTapAddJournalButton")

  }
  
}
