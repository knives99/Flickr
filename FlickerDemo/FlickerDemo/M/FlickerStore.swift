//
//  FlickerStore.swift
//  FlickerDemo
//
//  Created by Knivesnine on 2021/9/28.
//

import Foundation
import Alamofire
import RealmSwift

class FlickerStore{
    
   static let shared = FlickerStore()
    

    let apiKey = "5d79aba7f362c61e8becf3b54eb8af84"
    var text = ""
    var page = ""
    var photos : [Photo] = []
    let realm = try! Realm()


    func fetchData(text:String,page:String,comp :@escaping(SearchData)->Void){
        let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=5d79aba7f362c61e8becf3b54eb8af84&text=\(text)&per_page=\(page)&format=json&nojsoncallback=1"
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else{

                print(assertionFailure("data wrong"))
                return}
            do {
                let json = try JSONDecoder().decode(SearchData.self, from: data)
                comp(json)
            } catch{
                print(assertionFailure("Decode Wrong"))
            }
        }
    }
    
    func fetchImage(url:URL,comp:@escaping(Data)->Void){
        
        AF.request(url).responseData { (AFDataResponse) in
            guard let data = AFDataResponse.data else {assertionFailure(); return}
            comp(data)
        }
    }
    private init(){}
}



