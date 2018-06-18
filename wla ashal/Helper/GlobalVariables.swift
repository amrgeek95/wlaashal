//
//  Globals.swift
//  Mazad
//
//  Created by amr sobhy on 5/7/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import Foundation
import UIKit
var my_products = 0
var my_favourites = 0
var global_category_id = ""
var isTaxi = false
var isDelivery = false
var add_product_flag = 0
var filter_category = 0
//for advanced_search
var subcategory_id = ""
var secondary_id = ""
var advanced_category_id = ""
var advanced_flag = false
var searchView = false
var staticNavigation = ""
 var image_url = "http://wla-ashl.com/panel/prod_img/"
var openChat = false
struct addressMap {
    var longtide:Double
    var latitude :Double
    var address:String
    var city:String
}
struct addressMapProduct {
    var longtide:Double
    var latitude :Double
    var address:String
    var city:String
    var productName:String
    var productID:String
}
extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

