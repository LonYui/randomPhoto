//
//  CreateChannel.swift
//  randomPhoto
//
//  Created by tsung-han on 2022/10/19.
//

import SwiftUI

struct CreateChannel: View {
    @EnvironmentObject var streamData : StreamViewModel

    var body: some View {
        VStack{
            Text("創建")
            TextField("聊天室名稱", text:$streamData.聊天室名稱)
            Button(action: streamData.創建聊天室, label: {Text("創建")})
        }
    }
}

struct CreateChannel_Previews: PreviewProvider {
    static var previews: some View {
        CreateChannel()
    }
}
