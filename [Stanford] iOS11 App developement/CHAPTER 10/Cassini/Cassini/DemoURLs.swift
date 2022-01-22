//
//  DemoURLs.swift
//  Cassini
//
//  Created by shin jae ung on 2022/01/17.
//

import Foundation

struct DemoURLs
{
    static let stanford = Bundle.main.url(forResource: "oval", withExtension: "jpg")
    
    static var NASA: Dictionary<String, URL> = {
        let NASAURLStrings = [
            "Cassini" : "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/cassini_saturn_illustration_grc.jpg",
            "Earth" : "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/13989104603_c57e9de5cf_o.jpg",
            "Saturn" : "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/images/284338main_Backlit_Saturn1_full.jpg"
        ]
        var urls = Dictionary<String,URL>()
        for (key, value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
