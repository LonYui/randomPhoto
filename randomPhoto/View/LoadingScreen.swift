//
//  LoadingScreen.swift
//  randomPhoto
//
//  Created by tsung-han on 2022/10/18.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        ZStack{
            Color.primary.ignoresSafeArea().opacity(0.3)
            ProgressView().frame(width: 100, height: 100, alignment: .center)            
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
