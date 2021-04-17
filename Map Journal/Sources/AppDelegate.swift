//
//  AppDelegate.swift
//  Map Journal
//
//  Created by 원현식 on 2021/04/09.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.window = UIWindow()
    
    // TODO: 의존성
    let mapViewController = MapViewController()
    
    mapViewController.presenter = DefaultMapViewPresenter(mapViewController,
                                                          DependencyContainer.shared.memoRepository)
    
    window?.rootViewController = mapViewController
    window?.makeKeyAndVisible()
    return true
  }
}

