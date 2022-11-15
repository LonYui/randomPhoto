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
import PhotosUI
import FirebaseStorage

@available(iOS 16.0, *)
struct ContentView: View {
    @State var 動態圖片url="https://res.cloudinary.com/alchemyapi/image/upload/w_250,h_250/mainnet/07783aaf80e4c4497725b2da0af33394.png"
    @State var photoModel:PhotoPickerModel = .init()
    var body: some View {
        ZStack{
            Color.purple
                .ignoresSafeArea()
            VStack{
                Text("url:")
                TextField("", text: $動態圖片url)
                AsyncImage(url: URL(string: 動態圖片url))
                PhotosPicker(selection: $photoModel.selectedPhoto,matching: .any(of: [.images])){
                    Text("選擇照片")
                }
                Image(uiImage: photoModel.uiImage)
                Button(action: {
                    print("image is \( photoModel.uiImage )")
                    let storage = Storage.storage()
                    storage.reference().child("temp.jpg").putData(photoModel.uiImage.jpegData(compressionQuality: 0.35)! , metadata: nil ){ (_ , err) in
                        if (err != nil){
                            print(err)
                            return
                        }
                        print("成功上傳")
                    }
                }, label: {
                    Text("上傳圖片")
                })

            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(iOS 16.0, *) {
//            ContentView()
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}
