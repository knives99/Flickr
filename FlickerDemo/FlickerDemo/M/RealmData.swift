//
//  RealmData.swift
//  FlickerDemo
//
//  Created by Knivesnine on 2021/9/30.
//

import Foundation
import RealmSwift

class RealmData : Object {
    
    @objc dynamic var id :String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var server: String = ""
    @objc dynamic var farm: Int = 1
    @objc dynamic var secret: String = ""
    @objc dynamic var imageUrl: String = ""
    

}
