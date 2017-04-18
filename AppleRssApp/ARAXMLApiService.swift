//
//  ARAXMLApiService.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/16/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class ARAXMLApiService: NSObject {
    
    enum EndPoint: String {
        case baseUrl = "http://developer.apple.com/news/rss/news.rss"
    }

    func getXML(with completionHandler: @escaping (APIResult<Any>) -> Void)
    {
        guard let url = URL(string: EndPoint.baseUrl.rawValue) else { return }
        do {
            let data = try Data(contentsOf: url)
            completionHandler(APIResult.success(data))
        } catch {
            completionHandler(APIResult.failure(error))
        }
    }    
}
