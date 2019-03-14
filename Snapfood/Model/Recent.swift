//
//  Recent.swift
//  Snapfood
//
//  Created by Rohan Ravindran  on 2018-12-28.
//  Copyright © 2018 Rohan Ravindran. All rights reserved.
//

import Foundation
import RealmSwift

class Recent: Object {
    @objc dynamic var recentFoodName : String = ""
    @objc dynamic var recentFoodPicture : Data?
    
}
