//
//  DependencyContainer.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/17.
//

import Foundation

class DependencyContainer {
  static let shared = DependencyContainer()

  // Service
  lazy var storageService = StorageServiceImpl()
  
  // Repository
  lazy var memoRepository = DefaultMemoRepository(storageService)
      
}
