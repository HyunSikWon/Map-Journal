//
//  MemoRepository.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/17.
//

import Foundation
import CoreLocation

protocol MemoRepository {
  var locations: [Location] { get }
  func add(_ location: CLLocationCoordinate2D, _ memo: Memo ,_ completion: @escaping (Result<Void, Error>) -> Void)
  func fetch(_ completion: @escaping (Result<Void, Error>) -> Void)
  //  func remove()
  //  func removeAll()
}

 final class DefaultMemoRepository: MemoRepository {

  private var storageService: StorageService!
  var locations: [Location] = []
  
  init(_ storageService: StorageService) {
    self.storageService = storageService
  }
  
  func fetch(_ completion: @escaping (Result<Void, Error>) -> Void) {
    storageService.load { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let locations):
        self.locations = locations
        completion(.success(Void()))
      case .failure(let error):
        completion(.failure(error))
        print(error.localizedDescription)
      }
    }
  }
  
  func add(_ coordinate: CLLocationCoordinate2D, _ newMemo: Memo, _ completion: @escaping (Result<Void, Error>) -> Void) {
    
    var flag = false
    for i in 0..<locations.count {
      if locations[i].latitude == coordinate.latitude ||
          locations[i].longtitude == coordinate.longitude {
        locations[i].memos.append(newMemo)
        flag = true
        break
      }
    }
    
    if flag == false {
      let newLocation = Location(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
      newLocation.memos.append(newMemo)
    }
    
    storageService.save(locations) { result in
      switch result {
      case .success():
        completion(.success(Void()))
      case .failure(let error):
        completion(.failure(error))
        print(error.localizedDescription)
      }

    }

  }
  
  
  
  
  
  
  
  
}
