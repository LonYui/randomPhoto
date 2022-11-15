//
//  PhotoPickerModel.swift
//  randomPhoto
//
//  Created by K on 2022/11/14.
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
class PhotoPickerModel: ObservableObject {
    
    @Published var uiImage:UIImage = UIImage()
    @Published var selectedPhoto:PhotosPickerItem?{
        didSet{
            if let selectedPhoto{
                processPhoto(selectedPhoto:selectedPhoto)
            }
        }
    }
    func processPhoto(selectedPhoto:PhotosPickerItem){
        selectedPhoto.loadTransferable(type: Data.self){result in
            switch result {
            case .success(let data):
                if let data,let image = UIImage(data: data){
                    self.uiImage = image
                    print("Image found")
                }
            case .failure(let err):
                print(err.localizedDescription)

            }
            
        }
    }
}
