//
//  randomPhotoApp.swift
//  randomPhoto
//
//  Created by tsung-han on 2022/9/14.
//

import SwiftUI
import FirebaseCore

@available(iOS 16.0, *)
@main
struct randomPhotoApp: App {
    @UIApplicationDelegateAdaptor(初始程序c.self) var 初始化程序
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class 初始程序c : NSObject ,UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        FirebaseApp.configure()
        print("🚀launched")
        return true
    }
}
