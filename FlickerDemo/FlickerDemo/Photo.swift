//
//  Photo.swift
//  FlickerDemo
//
//  Created by Knivesnine on 2021/9/28.
//

import Foundation

struct Photo: Decodable {
   let farm: Int
   let secret: String
   let id: String
   let server: String
   let title: String
   var imageUrl: URL {
      return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
   }
}
struct PhotoData: Decodable {
   let photo: [Photo]
}
struct SearchData: Decodable {
   let photos: PhotoData
}
