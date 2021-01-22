//
//  Api.swift
//  Nasa
//
//  Created by 王瑋 on 2021/1/17.
//

import Foundation

class APIManager: ObservableObject{
    static let shared = APIManager()
    @Published var queryString:String
    @Published var category: String
    @Published var minWidth: Int
    @Published var photos = [Photo]()
    
    init() {
        queryString = ""
        category="all"
        minWidth=0
    }
    
    func updateImage(queryString: String, category: String, minWidth: Int)
    {
        guard let queryUrl = URL(string:"https://pixabay.com/api/?key=19853961-5610843a121e5db3f4a2df753&q=\(self.queryString)&image_type=photo&category=\(self.category)&min_width=\(self.minWidth)") else{ return }
        var request = URLRequest(url: queryUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){data, response, error in
            guard let data = data else { return }
            let response = try!JSONDecoder().decode(ImageResponse.self, from: data)
            print("\(response.hits.count)")
            DispatchQueue.main.async {
                self.photos = response.hits
            }
            
        }.resume()
    }
    
//    func getImage(){
//        guard let queryUrl = URL(string:"https://pixabay.com/api/?key=19853961-5610843a121e5db3f4a2df753&q=\(self.queryString)&image_type=photo") else{ return }
//        var request = URLRequest(url: queryUrl)
//        request.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: request){data, response, error in
//            guard let data = data else { return }
//            let response = try!JSONDecoder().decode(ImageResponse.self, from: data)
//            print("\(response.hits.count)")
//            DispatchQueue.main.async {
//                self.photos = response.hits
//            }
//
//        }.resume()
//
//    }
    
}
