//
//  ChatView.swift
//  randomPhoto
//
//  Created by tsung-han on 2022/10/19.
//

import SwiftUI
import StreamChat
import AVFoundation

struct ChatView: View {
    
    @StateObject var listner:ChatChannelController.ObservableObject
    @State var 訊息 = ""
    var body: some View {
        
        let channel = listner.controller.channel!
        VStack{
            ScrollViewReader{reader in
                ScrollView{
                    LazyVStack{
                        ForEach(listner.messages.reversed(),id: \.self){ msg in
                            MessageRowView(訊息: msg)
                        }
                    }
                    .id("msg_view")

                }
                .onChange(of: listner.messages, perform: { value in
                    withAnimation{reader.scrollTo("msg_view", anchor:.bottom)}
                })
                .onAppear(perform: {
                    reader.scrollTo("msg_view", anchor:.bottom)
                    listner.controller.markRead()
                })
            }
            HStack{
                TextField("訊息", text: $訊息)
                Button(action: 傳送訊息, label: {Image(systemName: "paperplane.fill")})
                //空值不能送出
                .disabled(訊息=="")
            }
        }
        .navigationTitle(channel.cid.id)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action:{
                    let alertHC = UIHostingController(rootView: MyAlert().environmentObject(listner))

                    alertHC.preferredContentSize = CGSize(width: 300, height: 200)
                    alertHC.modalPresentationStyle = UIModalPresentationStyle.formSheet

                    UIApplication.shared.windows[0].rootViewController?.present(alertHC, animated: true)
                }, label:{
                    Text("Inv")
                })
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action:{
                    let alertHC = UIHostingController(rootView: MyAlert2().environmentObject(listner))

                    alertHC.preferredContentSize = CGSize(width: 300, height: 200)
                    alertHC.modalPresentationStyle = UIModalPresentationStyle.formSheet

                    UIApplication.shared.windows[0].rootViewController?.present(alertHC, animated: true)
                }, label:{
                    Text("Del")
                })
            }

        })
    }
     
    func 傳送訊息(){
        let 聊天室ID = ChannelId(type: .messaging, id: listner.channel?.cid.id ?? "")
        ChatClient.共用.channelController(for: 聊天室ID).createNewMessage(text: 訊息){result in
            switch result{
            case .success(let msgID):
                print("成功發送\(訊息)")
            
            case .failure(let err):
                print("失敗發送\(err.localizedDescription)")
        }
        }
        訊息 = ""
        
    }

}

struct MessageRowView:View{
    
    var 訊息 : ChatMessage

    var body: some View{
        HStack(){
            MessageBubble(訊息: 訊息)
                .frame(maxWidth: .infinity, alignment: (左或右()=="左") ? .leading : .trailing )
                .contextMenu(menuItems: {
                    Text(訊息.author.id)
                    if 訊息.author.isOnline{
                        Text("在線")
                    }
                    else{
                        let s = 訊息.author.lastActiveAt?.ISO8601Format() ?? Date.now.ISO8601Format()
                        let subs = s.suffix(s.count-5).prefix(11)
                        Text(subs)
                    }
                })
        }
    }
    func 左或右() -> String{
        @AppStorage("使用者名稱") var 使用者名稱 = ""
        if 訊息.author.id == 使用者名稱{
            return "右"
        }
        else{
            return "左"
        }
    }

    
}

struct MessageBubble:View{
    
    var 訊息 : ChatMessage

    var body: some View{
        VStack{
            Text("\(訊息.author.id):\(訊息.text)")
            
            let format = Date.ISO8601FormatStyle.init(dateSeparator: .dash, dateTimeSeparator: .standard, timeZone:  TimeZone(secondsFromGMT: 8*3600)!)
            //訊息時間
            let s = 訊息.updatedAt.ISO8601Format(format) ?? Date.now.ISO8601Format(format)
            let subs = s.suffix(s.count-5).prefix(11)
            Text(subs )

        }
    }
    
}


// from stack overflow 關鍵字 alert with textfield
struct MyAlert: View {
    @State private var text: String = ""
    @EnvironmentObject var listner:ChatChannelController.ObservableObject

    var body: some View {

        VStack {
            Text("輸入使用者id").font(.headline).padding()

            TextField("Type text here", text: $text).textFieldStyle(.roundedBorder).padding()
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: {})
                    listner.controller.addMembers(userIds: [UserId(text)])
                }) {

                    Text("加入")
                }
                Spacer()

                Divider()

                Spacer()
                Button(action: {
                    UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: {})
                }) {
                    Text("Cancel")
                }
                Spacer()
            }.padding(0)


            }.background(Color(white: 0.9))
    }
}

// from stack overflow 關鍵字 alert with textfield
// 2 is for del comfirm
struct MyAlert2: View {
    @State private var text: String = ""
    @EnvironmentObject var listner:ChatChannelController.ObservableObject

    var body: some View {

        VStack {
            Text("確定刪除此聊天室").font(.headline).padding()

//            TextField("Type text here", text: $text).textFieldStyle(.roundedBorder).padding()
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: {})
                    listner.controller.deleteChannel()
                }) {

                    Text("刪除")
                }
                Spacer()

                Divider()

                Spacer()
                Button(action: {
                    UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: {})
                }) {
                    Text("Cancel")
                }
                Spacer()
            }.padding(0)


            }.background(Color(white: 0.9))
    }
}
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
