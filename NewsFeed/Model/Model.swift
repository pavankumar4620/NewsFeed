//
//  Model.swift
//  NewsFeed
//
//  Created by Gamenexa_iOS3 on 18/09/19.
//  Copyright © 2019 Gamenexa_iOS3. All rights reserved.
//

import Foundation

class News: Decodable {
    var success : Bool?
    var kstream : Kstream
}
class Kstream: Decodable {
    var current_page : Int?
    var data : [NewsFeed]
    var first_page_url : String?
    var from : Int?
    var next_page_url : String?
    var path : String?
    var per_page : Int?
    var prev_page_url : String?
    var to : Int?
}

class NewsFeed: Decodable {
    var id : Int?
    var rss_source_id : Int?
    var title : String?
    var title_image : String?
    var tag_line : String?
    var short_description : String?
    var full_description : String?
    var title_image_url : String?
    var description_image_url : String?
    var article_url : String?
    var author : String?
    var article_type : String?
    var published_date : String?
    var is_sponsored : Int?
    var is_premium : Int?
    var tags : String?
    var filtertags : String?
    var likes : Int?
    var comments : Int?
    var shares : Int?
    var meta_kstream_id : Int?
    var accepted : Int?
    var created_at : String?
    var updated_at : String?
}


