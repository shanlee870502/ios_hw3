//
//  ImageWallView.swift
//  Nasa
//
//  Created by 王瑋 on 2021/1/17.
//

import Foundation
import SwiftUI
import URLImage

struct ImageWallView : View{
    @ObservedObject var apiManager = APIManager.shared
    var amount: Int
    var body: some View{
        List(apiManager.photos.indices, id: \.self){index in
            Image(uiImage:UIImage(data: try! Data(contentsOf: self.apiManager.photos[index].webformatURL)) ?? UIImage())
                .resizable()
                .scaledToFit()
        }
    }
}

