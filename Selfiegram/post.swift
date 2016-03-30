//
//  post.swift
//  Selfiegram
//
//  Created by Kim Ellery on 2016-03-17.
//  Copyright © 2016 Kim Ellery. All rights reserved.
//

import Foundation
import UIKit

class Post {
    
    let imageURL:NSURL
    let user:User
    let comment:String
    
    init(imageURL:NSURL, user:User, comment:String){
        // You can name the property you are passing into the function the
        // same name as the class' property. To distinguish the two
        // add "self." to the beginning of the class' property.
        // So for example we are passing in an UImage called image and setting it as our
        // image property for Post.
        self.imageURL = imageURL
        self.user = user
        self.comment = comment
    }
}