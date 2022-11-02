//
//  ChannelView.swift
//  randomPhoto
//
//  Created by tsung-han on 2022/10/19.
//

import SwiftUI
import StreamChat

struct ChannelView: View {
    @EnvironmentObject var streamData : StreamViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack{
                if let 聊天室s = streamData.聊天室s{
                    ForEach(聊天室s,id: \.channel){listner in
                        NavigationLink(destination: {
                            ChatView(listner: listner)
                        }, label: {
                            _ChannelRow(listner: listner)
                        })
                    }
                }
                else{
                    ProgressView()
                }
            }
        })
        .navigationTitle("頻道")
        .onAppear(perform: {
            streamData.聊天室s = nil
            streamData.取得聊天室清單()
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action:{
                    streamData.createNewChannel=true
                }, label:{
                    Image(systemName: "square.and.pencil")
                })
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    streamData.聊天室s = nil
                    streamData.取得聊天室清單()
                }, label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                })
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    streamData.登入狀態=false
                    streamData.使用者名稱=""
                }, label: {
                    Text("Out")
                })
            }

            
        })
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView()
    }
}

struct _ChannelRow:View {
    
    @StateObject var listner: ChatChannelController.ObservableObject
    
    var body: some View{
        HStack{
            let channel = listner.controller.channel!
            Circle()
                .overlay(content: {
                    Text(String(channel.cid.id.first!))
                })
            VStack{
                Text(String(channel.cid.id))
                Text(listner.messages.first?.text ?? "😀")
                
                let format = Date.ISO8601FormatStyle.init(dateSeparator: .dash, dateTimeSeparator: .standard, timeZone:  TimeZone(secondsFromGMT: 8*3600)!)
                //訊息時間
                let s = channel.lastMessageAt?.ISO8601Format(format) ?? Date.now.ISO8601Format(format)
                let subs = s.suffix(s.count-5).prefix(11)
                Text(subs )
                Text("未讀訊息:\(channel.unreadCount.messages)")
            }
        }
    }
    
}
