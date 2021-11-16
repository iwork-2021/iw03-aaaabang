//
//  NewsItem.swift
//  ITSC
//
//  Created by aaaabang on 2021/11/15.
//

import UIKit

class NewsItem: NSObject {
    var title:String
    var date:String
    var link:String
    
    init(title:String,date:String,link:String) {
        self.title = title
        self.date = date
        self.link = link
    }
}
