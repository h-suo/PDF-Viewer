//
//  AppDelegate.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/09.
//

import RealmSwift
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let config = Realm.Configuration(
      schemaVersion: 2,
      migrationBlock: { migration, oldSchemaVersion in
        if oldSchemaVersion < 2 {
          migration.enumerateObjects(ofType: PDFDTO.className()) { oldObject, newObject in
            newObject!["highlight"] = List<IntStringPair>()
          }
        }
      }
    )
    
    Realm.Configuration.defaultConfiguration = config
    
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role
    )
  }
}
