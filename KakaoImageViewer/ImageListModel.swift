//
//  ImageListModel.swift
//  KakaoImageViewer
//
//  Created by Doyeong Yeom on 19/12/2018.
//  Copyright © 2018 Doyeong Yeom. All rights reserved.
//

struct ImageListMeta: Codable {
    var totalCount: Int?
    var pageableCount: Int?
    var isEnd: Bool?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

struct ImageMeta: Codable {
    var collection: String?
    var thumbnailUrl: String?
    var imageUrl: String?
    var width: Int?
    var height: Int?
    var displaySiteName: String?
    var docUrl: String?
    var dateTime: String?
    
    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailUrl = "thumbnail_url"
        case imageUrl = "image_url"
        case width
        case height
        case displaySiteName = "display_sitename"
        case docUrl = "doc_url"
        case dateTime
    }
}

struct ImageListModel: Codable {
    var meta: ImageListMeta?
    var documents: [ImageMeta]?
}
