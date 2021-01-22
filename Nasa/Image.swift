//
//  Image.swift
//  Nasa
//
//  Created by 王瑋 on 2021/1/17.
//

import Foundation

struct ImageResponse:Decodable {
    var hits:[Photo]
}

struct Photo:Decodable {
    var id:Int
    var webformatURL:URL
}
