//
//  ContentView.swift
//  randomPhoto
//
//  Created by tsung-han on 2022/9/14.
//

import SwiftUI
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct ContentView: View {
    @State var 動態圖片url="https://res.cloudinary.com/alchemyapi/image/upload/w_250,h_250/mainnet/07783aaf80e4c4497725b2da0af33394.png"
    
    @StateObject var streamData = StreamViewModel()
    @AppStorage("登入狀態") var g登入狀態 = false
    @AppStorage("使用者名稱") var 使用者名稱g = ""
    
    var body: some View {
        NavigationView{
            VStack{
                Text("current user: \(streamData.get_currentUserId())")
                if !g登入狀態{
                    Login().navigationTitle("登入")
                }
                else {
                    ChannelView()
                        .environmentObject(streamData)
                }

            }
            
        }
        .environmentObject(streamData)
        .alert(Text(streamData.錯誤訊息), isPresented: $streamData.是否發生錯誤, actions: {})
        .overlay(content: {
            ZStack{
                if streamData.createNewChannel{
                    CreateChannel()
                        .environmentObject(streamData)
                }
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
