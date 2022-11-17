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
    @StateObject var photoModel:PhotoPickerModel = .init()
    var body: some View {
        ZStack{
            Color.purple
                .ignoresSafeArea()
            VStack{
                Text("asyncimage的url為:")
                TextField("", text: $動態圖片url, axis: .vertical)
                    .lineLimit(5...10)
                //from 彼得潘 https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/swiftui-%E9%A1%AF%E7%A4%BA%E7%B6%B2%E8%B7%AF%E5%9C%96%E7%89%87%E7%9A%84-asyncimage-7bbc93971e27
                AsyncImage(url: URL(string: 動態圖片url)){ image in
                    image
                       .resizable()
                } placeholder: {
                    Color.gray
                }
                .scaledToFill()
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                PhotosPicker(selection: $photoModel.selectedPhoto,matching: .any(of: [.images])){
                    Text("選擇照片")
                }
                Image(uiImage: photoModel.uiImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                Button(action: {
                    let storage = Storage.storage()
                    let riversRef = storage.reference().child("temp.jpg")
                    riversRef.putData(photoModel.uiImage.jpegData(compressionQuality: 0.35)! , metadata: nil ){ (_ , err) in
                        if (err != nil){
                            print(err)
                            return
                        }
                        print("成功上傳")
                        riversRef.downloadURL { (url, error) in
                          guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                          }
                            動態圖片url = downloadURL.absoluteString
                            photoModel.uiImage=UIImage()
                        }
                    }
                }, label: {
                    Text("上傳圖片")
                })

            }
        }
    }
}
