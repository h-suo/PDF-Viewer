//
//  SceneDelegate.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/09.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else {
      return
    }
    
    let PDFListViewController = DIContainer().makePDFListViewController()
    
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = UINavigationController(rootViewController: PDFListViewController)
    window?.makeKeyAndVisible()
  }
}
