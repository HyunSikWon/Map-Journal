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
    let saveData = addLogic(coordinate, newMemo)
    
    storageService.save(saveData) { result in
      switch result {
      case .success():
        self.locations = saveData
        completion(.success(Void()))
      case .failure(let error):
        completion(.failure(error))
        print(error.localizedDescription)
      }
    }
    
  }
  
  private func addLogic(_ coordinate: CLLocationCoordinate2D, _ newMemo: Memo) -> [Location] {
    var temp = self.locations
    
    // 메모 추가
    for i in 0..<temp.count {
      if temp[i].latitude == coordinate.latitude || temp[i].longtitude == coordinate.longitude {
        temp[i].memos.append(newMemo)
        return temp
      }
    }
    
    // 첫 메모 추가
    let newLocation = Location(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), memo: newMemo)
    temp.append(newLocation)
    return temp
  }
  
  
  
  
  
  
  
  
}
