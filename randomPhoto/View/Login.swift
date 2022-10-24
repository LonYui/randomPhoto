//
//  Login.swift
//  randomPhoto
//
//  Created by tsung-han on 2022/10/17.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var streamData : StreamViewModel
    
    var body: some View {
        VStack{
            TextField("使用者名稱", text: $streamData.使用者名稱)
            Button(action: streamData.登入, label: {
                Text("登入")
            })
                .disabled(streamData.使用者名稱=="")
        }
    }
}

struct Login_Previews: PreviewProvider {

    static var previews: some View {
        Login().environmentObject(StreamViewModel())
    }
}
