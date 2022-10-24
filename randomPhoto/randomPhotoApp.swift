//
//  randomPhotoApp.swift
//  randomPhoto
//
//  Created by tsung-han on 2022/9/14.
//

import SwiftUI
import StreamChat
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
    
    @AppStorage("使用者名稱") var 使用者名稱 = ""
    @AppStorage("登入狀態") var 登入狀態 = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        print("🚀launched")
        
        let config = ChatClientConfig(apiKeyString: "a8yknuck7gf6")
        //如果已經登入過了
        
        if 登入狀態{
            ChatClient.共用 = ChatClient(config: config)
            ChatClient.共用.connectGuestUser(
                        userInfo: .init(id: 使用者名稱)
            ) { error in
              if let error = error {
                  print("Connection failed with: \(error)")
                        }
                        else {
                 // User successfully connected
                            print("登入成功\(self.使用者名稱)")
              }
                       }
        }
        else{
            ChatClient.共用 = ChatClient(config: config)
        }
        
        
        return true
    }
}

// steam API 客戶端
extension ChatClient{
    static var 共用:ChatClient!
}
