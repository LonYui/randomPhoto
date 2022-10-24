//
//  StreamViewModel.swift
//  randomPhoto
//
//  Created by tsung-han on 2022/10/17.
//

import SwiftUI
import StreamChat

class StreamViewModel: ObservableObject {
    @Published var 使用者名稱 = ""
    
    @AppStorage("使用者名稱") var 使用者名稱g = ""
    @AppStorage("登入狀態") var 登入狀態 = false
    
    @Published var 是否發生錯誤 = false
    @Published var 錯誤訊息 = ""
    
    @Published var createNewChannel = false
    @Published var 聊天室名稱 = ""
    
    
    @Published var 聊天室s:[ChatChannelController.ObservableObject]? = [ChatChannelController.ObservableObject]()
    
    func 登入(){
        let config = ChatClientConfig(apiKey: .init("a8yknuck7gf6"))
        ChatClient.共用 = ChatClient(config: config)
        ChatClient.共用.connectUser(userInfo: .init(id: 使用者名稱), token: .development(userId: 使用者名稱))
        ChatClient.共用.currentUserController().reloadUserIfNeeded(completion: {(err) in
            if let error = err{
                self.錯誤訊息=error.localizedDescription
                self.是否發生錯誤=true
            }
            self.使用者名稱g = self.使用者名稱
            self.登入狀態 = true
            print("\(self.get_currentUserId())成功登入")
        })
    }
    
    func 取得聊天室清單(){
        print("取的聊天清單")
        if 聊天室s == nil{
            
            let request = ChatClient.共用.channelListController(query: .init(
                filter: .and([.equal(.type, to: .messaging), .containMembers(userIds: [ChatClient.共用.currentUserId!])])
            ))
            request.synchronize({(err) in
                if let error = err{
                    self.錯誤訊息=error.localizedDescription
                    self.是否發生錯誤=true
                }
                self.聊天室s = request.channels.compactMap({ (channel) -> ChatChannelController.ObservableObject? in
                    return ChatClient.共用.channelController(for: channel.cid).observableObject
                    
                })
            })
        }
        else{
            
        }
    }
    
    func 創建聊天室(){
        let 新聊天室id = ChannelId(type: .messaging, id: 聊天室名稱)
        let request = try! ChatClient.共用.channelController(createChannelWithId: 新聊天室id,name:聊天室名稱,imageURL:nil)
        request.synchronize({(err) in
            if let error = err{
                self.錯誤訊息=error.localizedDescription
                self.是否發生錯誤=true
            }
            
            self.聊天室名稱 = ""
            self.createNewChannel=false
        })

    }
    
    func get_currentUserId() -> String{
        return ChatClient.共用.currentUserId ?? ""
    }
}
 
