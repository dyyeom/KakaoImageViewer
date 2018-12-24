//
//  APIService.swift
//  KakaoImageViewer
//
//  Created by Doyeong Yeom on 19/12/2018.
//  Copyright © 2018 Doyeong Yeom. All rights reserved.
//

import Alamofire

class APIService {
    static var API_HOST = "https://dapi.kakao.com"
    
    class func searchImage(searchText: String, page: Int = 1) -> Alamofire.DataRequest {
        let kakaoKey = Bundle.main.infoDictionary!["KAKAO_REST_KEY"] as! String
        return Alamofire.request(APIService.API_HOST + "/v2/search/image", method: .get, parameters: ["query" : searchText, "page" : page], headers: ["Authorization" : "KakaoAK \(kakaoKey)"])
    }
}

