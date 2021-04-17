//
//  LocationStorage.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/12.
//

import Foundation
import CoreLocation

protocol StorageService {
  func save(_ locations: [Location], _ completion: @escaping (Result<Void, Error>) -> Void)
  func load(_ completion: @escaping (Result<[Location], Error>) -> Void)
}

class StorageServiceImpl: StorageService {

  static let fileURL: URL = {
      let documentationDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      let fileName = "locations"
      return documentationDirectory.appendingPathComponent(fileName)
  }()

  
  func save(_ locations: [Location], _ completion: @escaping (Result<Void, Error>) -> Void) {
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(locations)
      try data.write(to: StorageServiceImpl.fileURL)
      completion(.success(()))
    } catch  {
      completion(.failure(error))
    }
  }
  
  func load(_ completion: @escaping (Result<[Location], Error>) -> Void) {
    do {
      let decoder = JSONDecoder()
      let data = try Data(contentsOf: StorageServiceImpl.fileURL)
      let locations = try decoder.decode([Location].self, from: data)
      completion(.success(locations))
    } catch {
      completion(.failure(error))
    }
  }
}
