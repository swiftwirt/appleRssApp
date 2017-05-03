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
    
    func loadImageWithURL(url: URL, completionHandler: @escaping (APIResult<Any>) -> Void) -> URLSessionDownloadTask
    {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
            if error == nil, let url = url {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async() {
                        if self != nil, let image = UIImage(data: data) {
                            completionHandler(APIResult.success(image))
                        }
                    }
                } catch {
                    print("***** Error from loadImageWithURL!")
                    completionHandler(APIResult.failure(error))
                }
                
            }
        })
        downloadTask.resume()
        return downloadTask
    }
}
